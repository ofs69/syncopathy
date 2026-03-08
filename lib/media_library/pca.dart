import 'dart:math';

class PCA {
  final int components;

  PCA({required this.components});

  Map<String, dynamic> fitTransform(List<List<double>> data) {
    if (data.isEmpty) {
      return {'projected': []};
    }

    final centeredData = _center(data);
    final covMatrix = _covariance(centeredData);
    final eigenResult = _jacobiEigen(covMatrix);
    final eigenvalues = eigenResult['eigenvalues']! as List<double>;
    final eigenvectors = eigenResult['eigenvectors']! as List<List<double>>;

    final sortedIndices = List.generate(eigenvalues.length, (i) => i)
      ..sort((a, b) => eigenvalues[b].compareTo(eigenvalues[a]));

    final topEigenvectors = sortedIndices
        .sublist(0, components)
        .map((i) => eigenvectors[i])
        .toList();

    final projectedData = _project(centeredData, _transpose(topEigenvectors));

    return {'projected': projectedData};
  }

  List<List<double>> _center(List<List<double>> data) {
    final numFeatures = data[0].length;
    final means = List.filled(numFeatures, 0.0);

    for (var i = 0; i < data.length; i++) {
      for (var j = 0; j < numFeatures; j++) {
        means[j] += data[i][j];
      }
    }

    for (var j = 0; j < numFeatures; j++) {
      means[j] /= data.length;
    }

    final centered = List.generate(
      data.length,
      (i) => List.filled(numFeatures, 0.0),
    );
    for (var i = 0; i < data.length; i++) {
      for (var j = 0; j < numFeatures; j++) {
        centered[i][j] = data[i][j] - means[j];
      }
    }
    return centered;
  }

  List<List<double>> _covariance(List<List<double>> data) {
    final numSamples = data.length;
    final numFeatures = data[0].length;
    final cov = List.generate(
      numFeatures,
      (_) => List.filled(numFeatures, 0.0),
    );

    for (var i = 0; i < numFeatures; i++) {
      for (var j = i; j < numFeatures; j++) {
        double sum = 0;
        for (var k = 0; k < numSamples; k++) {
          sum += data[k][i] * data[k][j];
        }
        cov[i][j] = sum / (numSamples - 1);
        cov[j][i] = cov[i][j];
      }
    }
    return cov;
  }

  Map<String, dynamic> _jacobiEigen(List<List<double>> matrix) {
    final n = matrix.length;
    var A = List<List<double>>.generate(n, (i) => List<double>.from(matrix[i]));
    var V = List<List<double>>.generate(
      n,
      (i) => List<double>.generate(n, (j) => i == j ? 1.0 : 0.0),
    );
    const maxIterations = 100;
    const tolerance = 1e-10;

    for (var iter = 0; iter < maxIterations; iter++) {
      double maxVal = 0;
      int p = 0, q = 1;
      for (var i = 0; i < n; i++) {
        for (var j = i + 1; j < n; j++) {
          if (A[i][j].abs() > maxVal) {
            maxVal = A[i][j].abs();
            p = i;
            q = j;
          }
        }
      }

      if (maxVal < tolerance) {
        break;
      }

      double theta;
      if (A[p][p] == A[q][q]) {
        theta = pi / 4 * (A[p][q] > 0 ? 1 : -1);
      } else {
        final tau = (A[q][q] - A[p][p]) / (2 * A[p][q]);
        final t = (tau >= 0 ? 1 : -1) / (tau.abs() + sqrt(1 + tau * tau));
        theta = atan(t);
      }

      final c = cos(theta);
      final s = sin(theta);

      final app = A[p][p];
      final aqq = A[q][q];
      final apq = A[p][q];

      A[p][p] = c * c * app - 2 * s * c * apq + s * s * aqq;
      A[q][q] = s * s * app + 2 * s * c * apq + c * c * aqq;
      A[p][q] = A[q][p] = 0.0;

      for (var i = 0; i < n; i++) {
        if (i != p && i != q) {
          final aip = A[i][p];
          final aiq = A[i][q];
          A[i][p] = A[p][i] = c * aip - s * aiq;
          A[i][q] = A[q][i] = s * aip + c * aiq;
        }
      }

      for (var i = 0; i < n; i++) {
        final vip = V[i][p];
        final viq = V[i][q];
        V[i][p] = c * vip - s * viq;
        V[i][q] = s * vip + c * viq;
      }
    }

    final eigenvalues = List.generate(n, (i) => A[i][i]);
    final eigenvectors = _transpose(V);

    return {'eigenvalues': eigenvalues, 'eigenvectors': eigenvectors};
  }

  List<List<double>> _transpose(List<List<double>> matrix) {
    if (matrix.isEmpty) return [];
    final rows = matrix.length;
    final cols = matrix[0].length;
    final transposed = List.generate(cols, (_) => List.filled(rows, 0.0));
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        transposed[j][i] = matrix[i][j];
      }
    }
    return transposed;
  }

  List<List<double>> _project(
    List<List<double>> data,
    List<List<double>> components,
  ) {
    final projected = List.generate(
      data.length,
      (i) => List.filled(components[0].length, 0.0),
    );
    for (var i = 0; i < data.length; i++) {
      for (var j = 0; j < components[0].length; j++) {
        double sum = 0;
        for (var k = 0; k < data[0].length; k++) {
          sum += data[i][k] * components[k][j];
        }
        projected[i][j] = sum;
      }
    }
    return projected;
  }
}
