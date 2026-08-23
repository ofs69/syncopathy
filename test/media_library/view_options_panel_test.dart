import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/media_library/filter/media_filter_logic.dart';
import 'package:syncopathy/media_library/media_badge.dart';
import 'package:syncopathy/media_library/view_options_panel.dart';
import 'package:syncopathy/model/media_library_settings_model.dart';

Widget _host(MediaLibrarySettingsModel settings) => MaterialApp(
  home: Scaffold(
    body: Provider<MediaLibrarySettingsModel>.value(
      value: settings,
      child: const SingleChildScrollView(child: ViewOptionsPanel()),
    ),
  ),
);

/// Taps the badge chip for [id]. The picker renders each badge as itself, so
/// the chips are found by their preview text rather than by a label.
Future<void> _tapBadge(WidgetTester tester, String id) async {
  final spec = badgesById[id]!;
  final chip = find.byWidgetPredicate(
    (w) => w is MediaBadgeChip && w.spec.id == id,
    description: 'badge chip "$id"',
  );
  expect(chip, findsOneWidget, reason: 'no chip for ${spec.label}');
  await tester.tap(chip);
  await tester.pump();
}

void main() {
  group('ViewOptionsPanel', () {
    late MediaLibrarySettingsModel settings;

    setUp(() => settings = MediaLibrarySettingsModel());

    testWidgets('shows one chip per registered badge, not one row each', (
      tester,
    ) async {
      await tester.pumpWidget(_host(settings));
      expect(
        find.byType(MediaBadgeChip),
        findsNWidgets(availableBadges.length),
      );
      // The old menu had a "Show <label>" row per badge; nothing should.
      for (final spec in availableBadges) {
        expect(find.text('Show ${spec.label}'), findsNothing);
      }
    });

    testWidgets('tapping a badge chip toggles it off and back on', (
      tester,
    ) async {
      await tester.pumpWidget(_host(settings));
      expect(settings.enabledBadges.value, contains('duration'));

      await _tapBadge(tester, 'duration');
      expect(settings.enabledBadges.value, isNot(contains('duration')));

      await _tapBadge(tester, 'duration');
      expect(settings.enabledBadges.value, contains('duration'));
    });

    testWidgets('the density stepper clamps at both ends', (tester) async {
      settings.videosPerRow.value = 2;
      await tester.pumpWidget(_host(settings));

      final fewer = find.widgetWithIcon(IconButton, Icons.remove);
      final more = find.widgetWithIcon(IconButton, Icons.add);
      expect(tester.widget<IconButton>(fewer).onPressed, isNull);

      await tester.tap(more);
      await tester.pump();
      expect(settings.videosPerRow.value, 3);
      expect(tester.widget<IconButton>(fewer).onPressed, isNotNull);

      settings.videosPerRow.value = 10;
      await tester.pump();
      expect(tester.widget<IconButton>(more).onPressed, isNull);
    });

    testWidgets('rating visibility and grouping stay in the panel', (
      tester,
    ) async {
      await tester.pumpWidget(_host(settings));
      for (final filter in VideoFilter.values) {
        expect(find.text(filter.label), findsOneWidget);
      }
      expect(find.text('Separate favorites/dislikes'), findsOneWidget);
    });

    testWidgets('reset is disabled until something differs from default', (
      tester,
    ) async {
      await tester.pumpWidget(_host(settings));
      final reset = find.widgetWithText(TextButton, 'Reset');
      expect(tester.widget<TextButton>(reset).onPressed, isNull);

      settings.videosPerRow.value = 7;
      await tester.pump();
      expect(tester.widget<TextButton>(reset).onPressed, isNotNull);
    });

    testWidgets('reset restores every view option at once', (tester) async {
      await tester.pumpWidget(_host(settings));
      settings.videosPerRow.value = 9;
      settings.showVideoTitles.value = true;
      settings.separateFavorites.value = false;
      settings.visibilityFilters.value = {VideoFilter.hideDisliked};
      settings.enabledBadges.value = ['duration'];
      await tester.pump();

      await tester.tap(find.widgetWithText(TextButton, 'Reset'));
      await tester.pump();

      expect(settings.videosPerRow.value, 4);
      expect(settings.showVideoTitles.value, isFalse);
      expect(settings.separateFavorites.value, isTrue);
      expect(settings.visibilityFilters.value, isEmpty);
      expect(settings.enabledBadges.value, defaultBadgeIds);
      expect(settings.isViewCustomized.value, isFalse);
    });

    testWidgets('isViewCustomized ignores sort order', (tester) async {
      await tester.pumpWidget(_host(settings));
      settings.sortOption.value = SortOption.random;
      settings.isSortAscending.value = false;
      await tester.pump();
      // Sort has its own always-visible control, so it must not light up the
      // view-options button.
      expect(settings.isViewCustomized.value, isFalse);
    });
  });
}
