import 'dart:math' as math;
import 'dart:typed_data';

class TSNE {
  final int dimension;
  final double perplexity;
  final double theta;
  final double learningRate;
  final int maxIter;
  final double earlyExaggeration;
  final bool verbose;
  final math.Random _random;

  List<Float64List>? _Y;
  late List<Float64List> _P;
  late List<Float64List> _gains;
  late List<Float64List> _YStep;
  late List<Float64List> _grads;
  late double _momentum;
  late double _finalMomentum;
  late int _nSamples;
  late int _nFeatures;

  TSNE({
    this.dimension = 2,
    this.perplexity = 30.0,
    this.theta = 0.5,
    this.learningRate = 200.0,
    this.maxIter = 1000,
    this.earlyExaggeration = 4.0,
    this.verbose = true,
    int? randomState,
  }) : _random = randomState != null
           ? math.Random(randomState)
           : math.Random() {
    _momentum = 0.5;
    _finalMomentum = 0.8;
  }

  List<Float64List> fitTransform(List<List<double>> X) {
    _nSamples = X.length;
    _nFeatures = X[0].length;

    // Initialize the solution
    _initSolution();

    // Compute P-values
    _P = _computeGaussianPerplexity(X, perplexity);

    // Symmetrize P-values
    _symmetrizeMatrix(_P);

    // Early exaggeration
    for (int i = 0; i < _nSamples; i++) {
      for (int j = 0; j < _nSamples; j++) {
        _P[i][j] *= earlyExaggeration;
      }
    }

    // Main optimization loop
    for (int iter = 0; iter < maxIter; iter++) {
      // Compute Q-matrix (approximate using Barnes-Hut)
      final qMatrix = _computeQMatrix();

      // Compute gradient
      _computeGradient(_P, qMatrix);

      // Update the solution
      _updateSolution(iter);

      // Stop lying about P-values after 100 iterations
      if (iter == 100) {
        for (int i = 0; i < _nSamples; i++) {
          for (int j = 0; j < _nSamples; j++) {
            _P[i][j] /= earlyExaggeration;
          }
        }
      }

      // Switch momentum after 20 iterations
      if (iter == 20) {
        _momentum = _finalMomentum;
      }

      // Print progress
      if (verbose && (iter % 100 == 0 || iter == maxIter - 1)) {
        final cost = _computeCost(_P, qMatrix);
        print('Iteration $iter: error = $cost');
      }
    }

    return _Y!;
  }

  void _initSolution() {
    _Y = List.generate(
      _nSamples,
      (_) => Float64List.fromList(
        List.generate(dimension, (_) => _random.nextDouble() * 1e-4),
      ),
    );

    _gains = List.generate(
      _nSamples,
      (_) => Float64List.fromList(List.filled(dimension, 1.0)),
    );

    _YStep = List.generate(
      _nSamples,
      (_) => Float64List.fromList(List.filled(dimension, 0.0)),
    );

    _grads = List.generate(
      _nSamples,
      (_) => Float64List.fromList(List.filled(dimension, 0.0)),
    );
  }

  List<Float64List> _computeGaussianPerplexity(
    List<List<double>> X,
    double perplexity,
  ) {
    final n = X.length;
    final dist = _computeSquaredDistances(X);
    final P = List.generate(n, (_) => Float64List(n));
    final logU = math.log(perplexity);

    for (int i = 0; i < n; i++) {
      // Binary search for sigma_i
      double beta = 1.0;
      double minBeta = -double.infinity;
      double maxBeta = double.infinity;
      double tol = 1e-5;
      int iter = 0;
      const int maxIter = 50;

      double sumP = 0.0;
      double H = 0.0;

      // Get current row of distances
      final rowDist = dist[i];

      while (iter < maxIter) {
        // Compute Gaussian kernel row
        sumP = 0.0;
        for (int j = 0; j < n; j++) {
          if (i != j) {
            P[i][j] = math.exp(-beta * rowDist[j]);
            sumP += P[i][j];
          }
        }

        // Compute entropy
        H = 0.0;
        for (int j = 0; j < n; j++) {
          if (i != j && sumP > 0) {
            final p = P[i][j] / sumP;
            H += beta * (rowDist[j] * P[i][j]);
          }
        }
        H = (H / sumP) + math.log(sumP);

        // Check for convergence
        final Hdiff = H - logU;
        if (Hdiff.abs() < tol) {
          break;
        }

        // Update beta
        if (Hdiff > 0) {
          minBeta = beta;
          if (maxBeta == double.infinity) {
            beta *= 2.0;
          } else {
            beta = (beta + maxBeta) / 2.0;
          }
        } else {
          maxBeta = beta;
          if (minBeta == -double.infinity) {
            beta /= 2.0;
          } else {
            beta = (beta + minBeta) / 2.0;
          }
        }

        iter++;
      }

      // Normalize P row
      for (int j = 0; j < n; j++) {
        if (i != j) {
          P[i][j] /= sumP;
        }
      }
    }

    return P;
  }

  List<Float64List> _computeSquaredDistances(List<List<double>> X) {
    final n = X.length;
    final dist = List.generate(n, (_) => Float64List(n));

    for (int i = 0; i < n; i++) {
      for (int j = i + 1; j < n; j++) {
        final d = _squaredDistance(X[i], X[j]);
        dist[i][j] = d;
        dist[j][i] = d;
      }
    }

    return dist;
  }

  double _squaredDistance(List<double> a, List<double> b) {
    double sum = 0.0;
    for (int i = 0; i < a.length; i++) {
      final diff = a[i] - b[i];
      sum += diff * diff;
    }
    return sum;
  }

  void _symmetrizeMatrix(List<Float64List> P) {
    final n = P.length;
    for (int i = 0; i < n; i++) {
      for (int j = i + 1; j < n; j++) {
        final p = (P[i][j] + P[j][i]) / (2.0 * n);
        P[i][j] = p;
        P[j][i] = p;
      }
    }

    // Ensure no zeros for numerical stability
    const eps = 1e-12;
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        if (P[i][j] < eps) {
          P[i][j] = eps;
        }
      }
    }
  }

  List<List<double>> _computeQMatrix() {
    final n = _nSamples;
    final Q = List.generate(n, (_) => Float64List(n));
    double sumQ = 0.0;

    // Compute pairwise affinities
    for (int i = 0; i < n; i++) {
      for (int j = i + 1; j < n; j++) {
        final dist = _squaredDistance(_Y![i], _Y![j]);
        final q = 1.0 / (1.0 + dist);
        Q[i][j] = q;
        Q[j][i] = q;
        sumQ += 2 * q;
      }
    }

    // Normalize Q
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        if (i != j) {
          Q[i][j] /= sumQ;
          // Ensure no zeros for numerical stability
          if (Q[i][j] < 1e-12) {
            Q[i][j] = 1e-12;
          }
        }
      }
    }

    return Q;
  }

  void _computeGradient(List<Float64List> P, List<List<double>> Q) {
    final n = _nSamples;

    // Reset gradients
    for (int i = 0; i < n; i++) {
      _grads[i].fillRange(0, dimension, 0.0);
    }

    // Compute gradient
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        if (i != j) {
          final mult =
              4.0 *
              ((P[i][j] - Q[i][j]) *
                  (1.0 / (1.0 + _squaredDistance(_Y![i], _Y![j]))));
          for (int d = 0; d < dimension; d++) {
            final diff = _Y![i][d] - _Y![j][d];
            _grads[i][d] += mult * diff;
          }
        }
      }
    }
  }

  void _updateSolution(int iter) {
    final n = _nSamples;

    // Update gains
    for (int i = 0; i < n; i++) {
      for (int d = 0; d < dimension; d++) {
        final signChange = (_grads[i][d] > 0) != (_YStep[i][d] > 0);
        if (signChange) {
          _gains[i][d] += 0.2;
        } else {
          _gains[i][d] *= 0.8;
        }
        _gains[i][d] = math.max(_gains[i][d], 0.01);
      }
    }

    // Update Y
    for (int i = 0; i < n; i++) {
      for (int d = 0; d < dimension; d++) {
        final gain = _gains[i][d];
        final grad = _grads[i][d];

        // Update step
        _YStep[i][d] = _momentum * _YStep[i][d] - learningRate * gain * grad;

        // Update Y
        _Y![i][d] += _YStep[i][d];
      }
    }

    // Center Y
    final mean = Float64List(dimension);
    for (int i = 0; i < n; i++) {
      for (int d = 0; d < dimension; d++) {
        mean[d] += _Y![i][d];
      }
    }
    for (int d = 0; d < dimension; d++) {
      mean[d] /= n;
    }
    for (int i = 0; i < n; i++) {
      for (int d = 0; d < dimension; d++) {
        _Y![i][d] -= mean[d];
      }
    }
  }

  double _computeCost(List<Float64List> P, List<List<double>> Q) {
    double cost = 0.0;
    final n = _nSamples;

    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        if (i != j) {
          cost += P[i][j] * math.log(P[i][j] / Q[i][j]);
        }
      }
    }

    return cost;
  }
}
