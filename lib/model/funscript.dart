import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/sqlite/models/funscript_metadata.dart';

/// Represents a single action in a Funscript file.
class FunscriptAction implements Comparable<FunscriptAction> {
  /// The time in milliseconds at which the action should occur.
  final int at;

  /// The position (0-100) for the action.
  final int pos;

  FunscriptAction({required this.at, required this.pos});

  /// Creates a [FunscriptAction] from a JSON map.
  factory FunscriptAction.fromJson(Map<String, dynamic> json) {
    final at = json['at'];
    final pos = json['pos'];
    if (at is! int || pos is! int) {
      throw FormatException(
        "Invalid Funscript action format: 'at' and 'pos' must be integers.",
        json,
      );
    }
    return FunscriptAction(at: at, pos: pos.clamp(0, 100));
  }

  @override
  int compareTo(FunscriptAction other) {
    return at.compareTo(other.at);
  }

  @override
  bool operator ==(Object other) {
    return other is FunscriptAction && other.at == at && other.pos == pos;
  }

  @override
  int get hashCode => at.hashCode;
}

/// Represents a Funscript file.
///
/// Contains metadata and a list of actions for controlling haptic devices.
class Funscript {
  /// The version of the Funscript. Defaults to "1.0".
  final String version;

  /// Whether the y-axis is inverted. Defaults to false.
  final bool inverted;

  /// The range of motion (0-100). Defaults to 90.
  final int range;

  /// The list of actions.
  List<FunscriptAction> actions;

  /// A backup copy of the original actions if actions was modified
  List<FunscriptAction> originalActions = [];

  /// Optional metadata.
  final FunscriptMetadata? metadata;

  final String filePath;
  String get fileName => p.basename(filePath);

  Funscript({
    this.version = "1.0",
    this.inverted = false,
    this.range = 90,
    required this.actions,
    this.metadata,
    required this.filePath,
  });

  int getIndexBefore(int time) {
    var test = FunscriptAction(at: time, pos: 0);
    var index = actions.lowerBound(test);
    return max(index - 1, 0);
  }

  /// Creates a [Funscript] object from a JSON map.
  factory Funscript.fromJson(Map<String, dynamic> json, String filePath) {
    final actionsRaw = json['actions'];
    if (actionsRaw == null) {
      throw const FormatException("Funscript missing 'actions' key.");
    }
    if (actionsRaw is! List) {
      throw const FormatException("'actions' key must be a list.");
    }

    List<FunscriptAction> actions = actionsRaw
        .map((i) => FunscriptAction.fromJson(i as Map<String, dynamic>))
        .toList();
    actions.sort();
    actions.removeWhere((action) => action.at < 0);

    // remove duplicate timestamps
    final uniqueActions = <FunscriptAction>[];
    final seenTimestamps = <int>{};
    for (final action in actions) {
      if (seenTimestamps.add(action.at)) {
        uniqueActions.add(action);
      }
    }

    final metadataMap = json['metadata'] as Map<String, dynamic>?;
    FunscriptMetadata? metadata;
    if (metadataMap != null) {
      try {
        metadata = FunscriptMetadata.fromJson(metadataMap);
      } catch (e) {
        Logger.debug("Failed to parse Funscript metadata for '$filePath': $e");
      }
    }

    return Funscript(
      version: json['version'] as String? ?? "1.0",
      inverted: json['inverted'] as bool? ?? false,
      range: json['range'] as int? ?? 90,
      actions: uniqueActions,
      metadata: metadata,
      filePath: filePath,
    );
  }

  /// Parses a Funscript file from the given [path].
  ///
  /// Throws a [FileSystemException] if the file is not found.
  /// Throws a [FormatException] if the JSON is invalid or doesn't match the Funscript format.
  static Future<Funscript?> fromFile(String path) async {
    final file = File(path);
    if (!await file.exists()) {
      throw FileSystemException("File not found", path);
    }

    try {
      final contents = await file.readAsString();
      final json = jsonDecode(contents);
      if (json is! Map<String, dynamic>) {
        throw const FormatException("Root of Funscript must be a JSON object.");
      }
      return Funscript.fromJson(json, path);
    } on FormatException catch (e) {
      throw FormatException(
        "Invalid Funscript format in file '$path': ${e.message}",
        e.source,
      );
    } catch (e) {
      throw FormatException("Failed to parse Funscript file '$path': $e");
    }
  }
}
