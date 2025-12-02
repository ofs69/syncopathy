import 'dart:math';

import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/isar/video_model.dart';
import 'package:syncopathy/pca.dart';
import 'package:syncopathy/media_manager.dart';

/// Helper class to hold stroke data
class Stroke {
  final double startPos;
  final double endPos;
  final int startTime;
  final int endTime;

  Stroke({
    required this.startPos,
    required this.endPos,
    required this.startTime,
    required this.endTime,
  });

  double get length => (endPos - startPos).abs();
  int get duration => endTime - startTime;
  double get speed => duration > 0 ? length / duration : 0;
}

class PcaCalculator {
  final MediaManager mediaManager;

  PcaCalculator(this.mediaManager);

  Future<Map<String, List<double>>> performPcaCalculation({
    required void Function(String) onProgress,
  }) async {
    final allVideos = mediaManager.allVideos;
    final Map<String, List<double>> pcaScoresByPath = {};

    onProgress('Loading funscripts for PCA sorting...');
    int loadedCount = 0;
    final videosWithFunscript = <Video>[];
    for (var video in allVideos) {
      await video.loadFunscript();
      if (video.funscript != null) {
        videosWithFunscript.add(video);
      }
      loadedCount++;
      onProgress(
          'Loaded $loadedCount of ${allVideos.length} funscripts...');
    }
    onProgress(
      'Finished loading funscripts. Total: $loadedCount. Now calculating PCA...',
    );

    if (videosWithFunscript.length >= 2) {
      final features = videosWithFunscript.map((v) {
        final funscript = v.funscript!;
        final positions =
            funscript.actions.map((a) => a.pos.toDouble()).toList();
        final speeds = <double>[];
        for (var i = 0; i < funscript.actions.length - 1; i++) {
          final a1 = funscript.actions[i];
          final a2 = funscript.actions[i + 1];
          final timeDiff = a2.at - a1.at;
          if (timeDiff > 0) {
            speeds.add(
              (a2.pos.toDouble() - a1.pos.toDouble()).abs() / timeDiff,
            );
          }
        }

        final accelerations = <double>[];
        for (var i = 0; i < speeds.length - 1; i++) {
          final timeDiff =
              funscript.actions[i + 1].at - funscript.actions[i].at;
          if (timeDiff > 0) {
            accelerations.add((speeds[i + 1] - speeds[i]) / timeDiff);
          }
        }

        final strokes = _extractStrokes(funscript);
        final strokeLengths = strokes.map((s) => s.length).toList();
        final strokeDurations =
            strokes.map((s) => s.duration.toDouble()).toList();

        if (positions.isEmpty) {
          positions.add(0);
        }

        if (speeds.isEmpty) {
          speeds.add(0);
        }

        if (accelerations.isEmpty) {
          accelerations.add(0);
        }

        if (strokeLengths.isEmpty) {
          strokeLengths.add(0);
        }

        if (strokeDurations.isEmpty) {
          strokeDurations.add(0);
        }

        final positionQuantiles = _calculateQuantiles(positions, 16);
        final speedQuantiles = _calculateQuantiles(speeds, 16);
        final accelerationQuantiles =
            _calculateQuantiles(accelerations, 16);
        final positionSkewness = _calculateSkewness(positions);
        final speedSkewness = _calculateSkewness(speeds);
        final accelerationSkewness = _calculateSkewness(accelerations);
        final positionKurtosis = _calculateKurtosis(positions);
        final speedKurtosis = _calculateKurtosis(speeds);
        final accelerationKurtosis = _calculateKurtosis(accelerations);
        final strokeLengthVariance = _calculateVariance(strokeLengths);
        final strokeDurationVariance = _calculateVariance(strokeDurations);
        final averageStrokeLength = strokeLengths.isEmpty
            ? 0.0
            : strokeLengths.reduce((a, b) => a + b) / strokeLengths.length;
        final averageStrokeDuration = strokeDurations.isEmpty
            ? 0.0
            : strokeDurations.reduce((a, b) => a + b) /
                strokeDurations.length;

        return [
          positionSkewness,
          speedSkewness,
          accelerationSkewness,
          positionKurtosis,
          speedKurtosis,
          accelerationKurtosis,
          strokeLengthVariance,
          strokeDurationVariance,
          averageStrokeLength,
          averageStrokeDuration,
          ...speedQuantiles,
          ...positionQuantiles,
          ...accelerationQuantiles,
        ];
      }).toList();

      final standardizedFeatures = _standardizeFeatures(features);
      final pca = PCA(components: 2);
      final pcaResult = pca.fitTransform(standardizedFeatures);
      final principalComponents =
          pcaResult['projected'] as List<List<double>>;

      for (var i = 0; i < videosWithFunscript.length; i++) {
        pcaScoresByPath[videosWithFunscript[i].videoPath] =
            principalComponents[i];
      }
    }
    return pcaScoresByPath;
  }

  List<List<double>> _standardizeFeatures(List<List<double>> features) {
    if (features.isEmpty) {
      return [];
    }

    final numFeatures = features[0].length;
    final means = List.filled(numFeatures, 0.0);
    final stdDevs = List.filled(numFeatures, 0.0);

    // Calculate means
    for (var i = 0; i < features.length; i++) {
      for (var j = 0; j < numFeatures; j++) {
        means[j] += features[i][j];
      }
    }
    for (var j = 0; j < numFeatures; j++) {
      means[j] /= features.length;
    }

    // Calculate standard deviations
    for (var i = 0; i < features.length; i++) {
      for (var j = 0; j < numFeatures; j++) {
        stdDevs[j] += pow(features[i][j] - means[j], 2);
      }
    }
    for (var j = 0; j < numFeatures; j++) {
      stdDevs[j] = sqrt(stdDevs[j] / features.length);
    }

    // Standardize features
    final standardizedFeatures =
        List.generate(features.length, (i) => List.filled(numFeatures, 0.0));
    for (var i = 0; i < features.length; i++) {
      for (var j = 0; j < numFeatures; j++) {
        if (stdDevs[j] > 0) {
          standardizedFeatures[i][j] =
              (features[i][j] - means[j]) / stdDevs[j];
        } else {
          standardizedFeatures[i][j] = 0.0;
        }
      }
    }

    return standardizedFeatures;
  }

  List<double> _calculateQuantiles(List<double> data, int numQuantiles) {
    if (data.isEmpty) {
      return List.filled(numQuantiles, 0.0);
    }
    data.sort();
    final quantiles = <double>[];
    for (var i = 1; i <= numQuantiles; i++) {
      final index = (data.length * i / numQuantiles) - 1;
      quantiles.add(data[index.round().clamp(0, data.length - 1)]);
    }
    return quantiles;
  }

  double _calculateVariance(List<double> data) {
    if (data.length < 2) {
      return 0.0;
    }
    final mean = data.reduce((a, b) => a + b) / data.length;
    return data.map((x) => (x - mean) * (x - mean)).reduce((a, b) => a + b) /
        data.length;
  }

  double _calculateSkewness(List<double> data) {
    if (data.length < 3) {
      return 0.0;
    }
    final n = data.length.toDouble();
    final mean = data.reduce((a, b) => a + b) / n;
    final variance =
        data.map((x) => pow(x - mean, 2)).reduce((a, b) => a + b) / n;
    if (variance == 0) {
      return 0.0;
    }
    final stdDev = sqrt(variance);
    final m3 = data.map((x) => pow(x - mean, 3)).reduce((a, b) => a + b) / n;
    return m3 / pow(stdDev, 3);
  }

  double _calculateKurtosis(List<double> data) {
    if (data.length < 4) {
      return 0.0;
    }
    final n = data.length.toDouble();
    final mean = data.reduce((a, b) => a + b) / n;
    final variance =
        data.map((x) => pow(x - mean, 2)).reduce((a, b) => a + b) / n;
    if (variance == 0) {
      return 0.0;
    }
    final stdDev = sqrt(variance);
    final m4 = data.map((x) => pow(x - mean, 4)).reduce((a, b) => a + b) / n;
    return m4 / pow(stdDev, 4);
  }

  // Function to extract strokes
  List<Stroke> _extractStrokes(Funscript funscript) {
    final strokes = <Stroke>[];
    if (funscript.actions.length < 2) {
      return strokes;
    }

    int direction = 0; // 0 = unknown, 1 = up, -1 = down
    int strokeStartIndex = 0;

    for (int i = 0; i < funscript.actions.length - 1; i++) {
      final p1 = funscript.actions[i].pos;
      final p2 = funscript.actions[i + 1].pos;

      int currentDirection = (p2 > p1) ? 1 : ((p2 < p1) ? -1 : 0);

      if (direction == 0 && currentDirection != 0) {
        direction = currentDirection;
      }

      if (currentDirection != 0 && currentDirection != direction) {
        // Direction changed, end of a stroke
        final startAction = funscript.actions[strokeStartIndex];
        final endAction = funscript.actions[i];
        strokes.add(Stroke(
          startPos: startAction.pos.toDouble(),
          endPos: endAction.pos.toDouble(),
          startTime: startAction.at,
          endTime: endAction.at,
        ));
        strokeStartIndex = i;
        direction = currentDirection;
      }
    }

    // Add the last stroke
    final startAction = funscript.actions[strokeStartIndex];
    final endAction = funscript.actions.last;
    strokes.add(Stroke(
      startPos: startAction.pos.toDouble(),
      endPos: endAction.pos.toDouble(),
      startTime: startAction.at,
      endTime: endAction.at,
    ));

    return strokes;
  }
}
