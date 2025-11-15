import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/pca.dart';

void main() {
  group('PCA', () {
    test('fitTransform returns correct shape', () {
      final pca = PCA(components: 1);
      final data = [
        [1.0, 2.0],
        [2.0, 3.0],
        [3.0, 4.0],
      ];
      final result = pca.fitTransform(data);
      final projected = result['projected']!;
      expect(projected.length, 3);
      expect(projected[0].length, 1);
    });

    test('fitTransform with more components', () {
      final pca = PCA(components: 2);
      final data = [
        [1.0, 2.0, 3.0],
        [2.0, 3.0, 4.0],
        [3.0, 4.0, 5.0],
        [4.0, 5.0, 6.0],
      ];
      final result = pca.fitTransform(data);
      final projected = result['projected']!;
      expect(projected.length, 4);
      expect(projected[0].length, 2);
    });

    test('fitTransform with empty data', () {
      final pca = PCA(components: 1);
      final data = <List<double>>[];
      final result = pca.fitTransform(data);
      final projected = result['projected']!;
      expect(projected.isEmpty, true);
    });

    test('fitTransform with single data point', () {
      final pca = PCA(components: 1);
      final data = [
        [1.0, 2.0, 3.0],
      ];
      // This should not throw an error, but the result is not well-defined.
      // The covariance matrix will be all zeros.
      final result = pca.fitTransform(data);
      final projected = result['projected']!;
      expect(projected.length, 1);
      expect(projected[0].length, 1);
    });
  });
}
