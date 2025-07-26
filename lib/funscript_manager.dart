import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/funscript_algo.dart';
import 'package:syncopathy/model/settings.dart';

class FunscriptManager {
  static String? findFunscript(String mediaPath) {
    try {
      final directoryPath = p.dirname(mediaPath);
      final baseName = p.basenameWithoutExtension(mediaPath);
      final funscriptPath = p.join(directoryPath, '$baseName.funscript');

      if (File(funscriptPath).existsSync()) {
        return funscriptPath;
      }
    } catch (e) {
      // It's possible mediaPath is not a valid path, causing an exception.
      // In that case, we can't find a funscript.
    }
    return null;
  }

  static Future<Funscript?> loadAndProcessFunscript(
      String script, Settings settings) async {
    var funscriptFile = await Funscript.fromFile(script).catchError(
      (e) => null,
      test: (e) => true,
    );
    if (funscriptFile == null) return null;

    funscriptFile.actions = FunscriptAlgorithms.processForHandy(
      funscriptFile.actions,
      rdpEpsilon: settings.rdpEpsilon,
      slewMaxRateOfChangePerSecond: settings.slewMaxRateOfChange,
      remapRange: settings.remapFullRange ? (0, 100) : null
    );
    return funscriptFile;
  }
}
