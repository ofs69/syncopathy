import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:syncopathy/model/json/funscript_metadata.dart';

part 'funscript_json.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class FunscriptAction implements Comparable<FunscriptAction> {
  /// The time in milliseconds at which the action should occur.
  final int at;

  /// The position (0-100) for the action.
  final int pos;

  FunscriptAction({required this.at, required this.pos});

  factory FunscriptAction.fromJson(Map<String, dynamic> json) =>
      _$FunscriptActionFromJson(json);
  Map<String, dynamic> toJson() => _$FunscriptActionToJson(this);

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

  @override
  String toString() => "{at: $at, pos: $pos}";
}

class VersionConverter implements JsonConverter<String, dynamic> {
  const VersionConverter();

  @override
  String fromJson(dynamic json) {
    // Check if the incoming JSON value is actually a String
    if (json is String) {
      return json;
    }
    // Fallback value if it's a double, int, null, etc.
    return "1.0";
  }

  @override
  dynamic toJson(String object) => object;
}

@JsonSerializable(fieldRename: FieldRename.none)
class FunscriptJson {
  /// The version of the Funscript. Defaults to "1.0".
  @VersionConverter()
  final String version;

  /// Whether the y-axis is inverted. Defaults to false.
  final bool inverted;

  /// The range of motion (0-100). Defaults to 90.
  final int range;

  /// The list of actions.
  final List<FunscriptAction> actions;
  //late final Signal<List<FunscriptAction>> processedActions;
  //late final List<FunscriptAction> originalActions;

  /// Optional metadata.
  final FunscriptMetadata? metadata;

  /// The file path.
  // final String filePath;
  // String get fileName => p.basename(filePath);

  /// If it's a script token.
  // late final bool likelyScriptToken;

  FunscriptJson({
    this.version = "1.0",
    this.inverted = false,
    this.range = 100,
    required this.actions,
    this.metadata,
  });

  factory FunscriptJson.fromJson(Map<String, dynamic> json) =>
      _$FunscriptJsonFromJson(json);
  Map<String, dynamic> toJson() => _$FunscriptJsonToJson(this);

  // a hash based on the actions
  // it changes when an action changes is added or removed
  String computeFunscriptHash() {
    final buffer = StringBuffer();
    for (final action in actions) {
      buffer.write('${action.at}${action.pos}');
    }
    final content = buffer.toString();
    final bytes = utf8.encode(content);
    return sha256.convert(bytes).toString();
  }
}
