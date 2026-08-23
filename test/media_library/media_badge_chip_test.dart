import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/media_library/media_badge.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

final _spec = BadgeSpec(
  id: 'test',
  label: 'Test',
  icon: Icons.timer,
  build: (_) => null,
  preview: const BadgeValue(text: '12:34', tooltip: 'Test'),
);

Widget _host(Widget child, {double width = 400}) => MaterialApp(
  home: Scaffold(
    body: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(width: width, child: child),
    ),
  ),
);

Widget _chip(BadgeValue value) =>
    MediaBadgeChip(spec: _spec, value: value, foreground: Colors.white);

List<Size> _chipSizes(WidgetTester tester) => find
    .byType(MediaBadgeChip)
    .evaluate()
    .map((e) => tester.getSize(find.byWidget(e.widget)))
    .toList();

/// A badge that always shows [text] for any media, so overlay layout can be
/// exercised without building real funscript relations.
BadgeSpec _fixedSpec(String id, String? text) => BadgeSpec(
  id: id,
  label: id,
  icon: Icons.timer,
  build: (_) => BadgeValue(text: text, tooltip: id),
  preview: BadgeValue(text: text, tooltip: id),
);

MediaFile _media() => MediaFile(
  name: 'clip',
  mediaPath: r'C:\media\clip.mp4',
  fileHash: 'media-hash',
  playCount: 0,
  fileNotFound: false,
);

void main() {
  group('MediaBadgeChip', () {
    testWidgets('icon-only and text badges render at the same height', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _chip(const BadgeValue(text: '12:34', tooltip: 'Duration')),
              _chip(const BadgeValue(tooltip: 'AI-generated script')),
            ],
          ),
        ),
      );

      final sizes = _chipSizes(tester);
      expect(sizes, hasLength(2));
      expect(
        sizes.first.height,
        sizes.last.height,
        reason: 'an icon-only badge must not sit shorter than its neighbours',
      );
    });

    testWidgets('an icon-only badge is still narrower than a text one', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _chip(const BadgeValue(text: '12:34', tooltip: 'Duration')),
              _chip(const BadgeValue(tooltip: 'AI-generated script')),
            ],
          ),
        ),
      );

      final sizes = _chipSizes(tester);
      // Guards the empty-string sizer: it must set the height without also
      // padding out the width of an icon-only badge.
      expect(sizes.first.width, greaterThan(sizes.last.width));
    });
  });

  group('MediaBadgeOverlay', () {
    testWidgets('renders nothing when no badge applies', (tester) async {
      await tester.pumpWidget(
        _host(
          MediaBadgeOverlay(
            badges: [_spec], // build() returns null for every media
            media: _media(),
            foreground: Colors.white,
          ),
        ),
      );
      expect(find.byType(MediaBadgeChip), findsNothing);
    });

    testWidgets('keeps badges on one row when they fit', (tester) async {
      await tester.pumpWidget(
        _host(
          MediaBadgeOverlay(
            badges: [
              _fixedSpec('a', '12:34'),
              _fixedSpec('b', '999+'),
              _fixedSpec('c', '10-90'),
            ],
            media: _media(),
            foreground: Colors.white,
          ),
          width: 400,
        ),
      );

      final tops = find
          .byType(MediaBadgeChip)
          .evaluate()
          .map((e) => tester.getTopLeft(find.byWidget(e.widget)).dy)
          .toSet();
      expect(tops, hasLength(1), reason: 'all three should share one row');
    });

    testWidgets('wraps onto further rows when the card is too narrow', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          MediaBadgeOverlay(
            badges: [
              _fixedSpec('a', '12:34'),
              _fixedSpec('b', '999+'),
              _fixedSpec('c', '10-90'),
            ],
            media: _media(),
            foreground: Colors.white,
          ),
          // Wide enough for a badge, too narrow for all three side by side.
          width: 150,
        ),
      );

      expect(find.byType(MediaBadgeChip), findsNWidgets(3));
      final tops = find
          .byType(MediaBadgeChip)
          .evaluate()
          .map((e) => tester.getTopLeft(find.byWidget(e.widget)).dy)
          .toSet();
      expect(
        tops.length,
        greaterThan(1),
        reason: 'a narrow card must wrap badges instead of overflowing',
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('a badge too wide for the card ellipsizes, not overflows', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          MediaBadgeOverlay(
            badges: [_fixedSpec('a', 'a-very-long-badge-value')],
            media: _media(),
            foreground: Colors.white,
          ),
          width: 60,
        ),
      );

      expect(find.byType(MediaBadgeChip), findsOneWidget);
      expect(
        tester.takeException(),
        isNull,
        reason: 'the value should be clipped to fit, not overflow the pill',
      );
    });

    testWidgets('badges stay right-aligned', (tester) async {
      const width = 400.0;
      await tester.pumpWidget(
        _host(
          MediaBadgeOverlay(
            badges: [_fixedSpec('a', '12:34')],
            media: _media(),
            foreground: Colors.white,
          ),
          width: width,
        ),
      );

      final chip = find.byType(MediaBadgeChip);
      // 4px of overlay padding sits between the badge and the card edge.
      expect(tester.getTopRight(chip).dx, closeTo(width - 4.0, 0.01));
    });
  });
}
