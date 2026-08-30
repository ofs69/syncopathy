import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/heresphere/heresphere_projection.dart';

void main() {
  group('detectHereSphereProjection', () {
    test('a file with no markers declares nothing', () {
      // Nothing declared means HereSphere keeps deciding for itself, which is
      // the right answer when the file does not say.
      final result = detectHereSphereProjection('holiday clip.mp4');
      expect(result.isEmpty, isTrue);
      expect(result.projection, isNull);
      expect(result.stereo, isNull);
    });

    test('reads 180 side-by-side', () {
      final result = detectHereSphereProjection('scene_180_sbs.mp4');
      expect(result.projection, 'equirectangular');
      expect(result.stereo, 'sbs');
      expect(result.fov, 180);
    });

    test('reads 360 top-bottom', () {
      final result = detectHereSphereProjection('scene_360_tb.mp4');
      expect(result.projection, 'equirectangular360');
      expect(result.stereo, 'tb');
      expect(result.fov, 360);
    });

    test('accepts the alternate stereo spellings', () {
      expect(detectHereSphereProjection('a_180_lr.mp4').stereo, 'sbs');
      expect(detectHereSphereProjection('a_360_ou.mp4').stereo, 'tb');
    });

    test('a flat 2D marker is perspective mono', () {
      final result = detectHereSphereProjection('clip_2d.mp4');
      expect(result.projection, 'perspective');
      expect(result.stereo, 'mono');
    });

    group('fisheye lenses', () {
      test('MKX200', () {
        final result = detectHereSphereProjection('scene_mkx200_alpha.mp4');
        expect(result.projection, 'fisheye');
        expect(result.lens, 'MKX200');
        expect(result.fov, 200);
      });

      test('MKX220 is not swallowed by MKX200', () {
        final result = detectHereSphereProjection('scene_mkx220.mp4');
        expect(result.lens, 'MKX220');
        expect(result.fov, 220);
      });

      test('VRCA220', () {
        expect(detectHereSphereProjection('s_vrca220.mp4').lens, 'VRCA220');
      });

      test('RF52', () {
        final result = detectHereSphereProjection('s_rf52.mp4');
        expect(result.lens, 'RF52');
        expect(result.projection, 'fisheye');
      });

      test('fisheye190 beats a bare fisheye', () {
        final result = detectHereSphereProjection('s_fisheye190_sbs.mp4');
        expect(result.fov, 190);
        expect(result.stereo, 'sbs');
      });

      test('a lens wins over an angle marker', () {
        // `mkx200_180` names a fisheye lens, not an equirectangular 180.
        final result = detectHereSphereProjection('s_mkx200_180.mp4');
        expect(result.projection, 'fisheye');
        expect(result.fov, 200);
      });
    });

    group('markers must stand alone', () {
      test('a number inside another number is not a marker', () {
        expect(detectHereSphereProjection('best of 1800s.mp4').isEmpty, isTrue);
        expect(detectHereSphereProjection('clip3600.mp4').isEmpty, isTrue);
      });

      test('letters inside a word are not markers', () {
        // "lr" inside a word, and "ou" inside "outdoor", must not be read as
        // stereo layouts.
        expect(detectHereSphereProjection('outdoors walk.mp4').stereo, isNull);
        expect(detectHereSphereProjection('colour test.mp4').stereo, isNull);
      });

      test('a marker at the very start or end still counts', () {
        expect(detectHereSphereProjection('180_scene.mp4').fov, 180);
        expect(detectHereSphereProjection('scene sbs.mp4').stereo, 'sbs');
      });

      test('any separator works', () {
        for (final name in [
          'a_180_sbs.mp4',
          'a-180-sbs.mp4',
          'a.180.sbs.mp4',
          'a 180 sbs.mp4',
        ]) {
          final result = detectHereSphereProjection(name);
          expect(result.projection, 'equirectangular', reason: name);
          expect(result.stereo, 'sbs', reason: name);
        }
      });
    });

    test('detection is case-insensitive', () {
      final result = detectHereSphereProjection('SCENE_180_SBS.MP4');
      expect(result.projection, 'equirectangular');
      expect(result.stereo, 'sbs');
    });

    test('a projection with no stereo marker leaves stereo unsaid', () {
      // Side-by-side is the convention, but a convention is an assumption and
      // this only reports what the file states.
      final result = detectHereSphereProjection('scene_180.mp4');
      expect(result.projection, 'equirectangular');
      expect(result.stereo, isNull);
    });
  });
}
