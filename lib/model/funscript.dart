// A wrapper around the FunscriptJson class
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/funscript_algo.dart';
import 'package:syncopathy/model/json/funscript_json.dart';
import 'package:syncopathy/model/json/funscript_metadata.dart';

class Funscript {
  final FunscriptJson json;

  UnmodifiableListView<FunscriptAction> get originalActions =>
      UnmodifiableListView(json.actions);
  FunscriptMetadata? get metadata => json.metadata;

  final Signal<List<FunscriptAction>> processedActions = signal([]);

  late final ReadonlySignal<double> averageSpeed = computed(
    () => FunscriptAlgorithms.averageSpeed(processedActions.value),
  );
  late final ReadonlySignal<double> averageMin = computed(
    () => FunscriptAlgorithms.averageMin(processedActions.value),
  );
  late final ReadonlySignal<double> averageMax = computed(
    () => FunscriptAlgorithms.averageMax(processedActions.value),
  );

  late final bool likelyScriptToken;

  final String filePath;
  String get fileName => p.basename(filePath);

  Funscript({required this.json, required this.filePath}) {
    likelyScriptToken = isScriptToken(originalActions);
    // remove duplicate timestamps
    final uniqueActions = <FunscriptAction>[];
    final seenTimestamps = <int>{};
    for (final action in originalActions) {
      if (seenTimestamps.add(action.at)) {
        uniqueActions.add(action);
      }
    }
  }

  // This determines if something is likely a script token
  // If this is true it is highly unlikely that it isn't
  // False positives are also unlikely
  static bool isScriptToken(List<FunscriptAction> actions) {
    // 'magic' number for script token
    const magic = 136740671;
    // Script tokens can not be empty or have more than 100 actions.
    if (actions.isEmpty || actions.length > 100) {
      return false;
    }
    // Check if the script contains the token signal marker.
    for (final a in actions) {
      if (a.pos == 0 && a.at == magic % actions.length) {
        return true;
      }
    }
    return false;
  }

  static int getActionBefore(int timeMs, List<FunscriptAction> actions) {
    final index = lowerBound(actions, FunscriptAction(at: timeMs, pos: 0));
    return index == actions.length ? index - 1 : index;
  }

  static Funscript fromJson(Map<String, dynamic> funscriptMap, String path) {
    final json = FunscriptJson.fromJson(funscriptMap);
    return Funscript(json: json, filePath: path);
  }

  static Future<Funscript?> fromFile(String path) async {
    final jsonString = await File(path).readAsString();
    final json = jsonDecode(jsonString);
    return fromJson(json, path);
  }
}
