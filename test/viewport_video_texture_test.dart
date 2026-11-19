import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/player/media_kit_player/viewport_video_texture.dart';

void main() {
  testWidgets(
    'sizes a contained texture in physical pixels after layout settles',
    (tester) async {
      final sizes = <(int, int)>[];
      Future<void> layout(Size source, double width) => tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(devicePixelRatio: 2),
          child: Center(
            child: SizedBox(
              width: width,
              height: 240,
              child: ViewportVideoTexture(
                source: source,
                resize: (w, h) => sizes.add((w, h)),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
      );
      const settle = Duration(milliseconds: 110);
      const wide = Size(7680, 3840);
      await layout(wide, 320);
      await tester.pump(const Duration(milliseconds: 30));
      await layout(wide, 400);
      await tester.pump(settle);
      expect(sizes, [(800, 400)]);

      await layout(wide, 400);
      await tester.pump(settle);
      expect(sizes.length, 1);
      await layout(const Size(1080, 1920), 400);
      await tester.pump(settle);
      expect(sizes.last, (270, 480));
      await layout(const Size(128, 72), 400);
      await tester.pump(settle);
      expect(sizes.last, (128, 72));

      await layout(wide, 300);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(settle);
      expect(sizes.length, 3);
    },
  );
}
