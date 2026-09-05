import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/media_library/matching/funscript_matching_page.dart';
import 'package:syncopathy/media_library/matching/fuzzy_matcher.dart';
import 'package:syncopathy/media_library/matching/match_apply.dart';
import 'package:syncopathy/media_library/matching/match_draft.dart';
import 'package:syncopathy/media_library/matching/match_rules_store.dart';
import 'package:syncopathy/media_library/matching/match_snapshot.dart';
import 'package:syncopathy/media_library/matching/matching_session_model.dart';
import 'package:syncopathy/media_library/matching/matching_settings.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/platform/key_value_store/key_value_store.dart';

class _FakeKeyValueStore implements IKeyValueStore {
  final Map<String, Map<String, dynamic>> values = {};
  @override
  Future<Map<String, dynamic>?> get(String key) async => values[key];
  @override
  Future<void> put(String key, Map<String, dynamic> json) async {
    values[key] = json;
  }
}

/// A release name of the length this tool actually deals with. Every fact the
/// detail pane shows is deliberately longer than any pane is wide, because a
/// layout that only holds for short names does not hold.
const _long =
    'StudioName - Jane Doe And Someone Else - An Extremely Long Scene '
    'Title That Keeps Going 5400x2700 oculusrift 180 LR 60fps';

MatchingSessionModel _reviewSession() {
  final session = MatchingSessionModel(
    SettingsModel(),
    FunscriptMatchingSettings(),
    MatchRulesStore(),
  );
  final proposals = FuzzyMatcher([
    MediaSnapshot(
      fileHash: 'm1',
      basename: _long,
      directoryLabel: 'A Very Long Folder Name Indeed',
      durationSeconds: 2400,
      width: 5400,
      height: 2700,
    ),
    MediaSnapshot(
      fileHash: 'm2',
      basename: '$_long Take Two',
      directoryLabel: 'Another Rather Long Folder Name',
      durationSeconds: 60,
    ),
  ]).proposeAll([
    FunscriptSnapshot(
      funscriptHash: 's1',
      basename: '$_long.funscript',
      directoryLabel: 'A Very Long Folder Name Indeed',
      metadataTitle: 'An Extremely Long Scene Title That Keeps Going',
      performers: const ['Jane Doe', 'Someone Else', 'A Third Performer'],
      lastActionSeconds: 2350,
    ),
    FunscriptSnapshot(funscriptHash: 's2', basename: 'Nothing Matches This'),
  ]);
  session.draft.value = MatchDraft(proposals);
  session.phase.value = MatchSessionPhase.reviewing;
  session.selectedScriptHash.value = 's1';
  return session;
}

/// Every flex in the tree that lays out wider or taller than the box it was
/// given. Reported together rather than one at a time: a layout regression is
/// usually several rows at once, and fixing them one test run apart is slow.
List<String> _overflows(WidgetTester tester) {
  final found = <String>[];
  for (final ro in tester.allRenderObjects) {
    if (ro is! RenderFlex) continue;
    final horizontal = ro.direction == Axis.horizontal;
    var used = 0.0;
    for (final child in ro.getChildrenAsList()) {
      used += horizontal ? child.size.width : child.size.height;
    }
    final available = horizontal ? ro.size.width : ro.size.height;
    if (used - available <= 0.5) continue;

    final creator = ro.debugCreator.toString();
    found.add(
      '${ro.direction} needs $used, has $available: '
      '${creator.substring(0, creator.length.clamp(0, 160))}',
    );
  }
  return found;
}

/// Window sizes the tool has to hold at.
///
/// 800x600 is the minimum the desktop window can be dragged to; the smaller
/// ones are only reachable on the web build, and are kept as margin.
const _sizes = [
  Size(1920, 1080),
  Size(1440, 900),
  Size(1280, 800),
  Size(1000, 700),
  Size(900, 640),
  Size(800, 600),
  Size(700, 520),
  Size(640, 480),
];

void main() {
  setUp(() => getIt.registerSingleton<IKeyValueStore>(_FakeKeyValueStore()));
  tearDown(() => getIt.reset());

  Future<void> pump(
    WidgetTester tester,
    MatchingSessionModel session,
    Size size, {
    double textScale = 1.0,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      Provider<SettingsModel>.value(
        value: SettingsModel(),
        child: MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
            child: FunscriptMatchingPage(session: session),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  group('the toolbar reports what the session is doing', () {
    // A LayoutBuilder runs its builder during layout rather than during the
    // build around it, so a signal read inside one is never subscribed to.
    // Putting the status line in there leaves the scan running behind a
    // message frozen on whatever it said first, which reads exactly like the
    // scan itself having hung.
    testWidgets('the status line follows the scan', (tester) async {
      final session = _reviewSession();
      addTearDown(session.dispose);
      session.phase.value = MatchSessionPhase.scanning;
      session.status.value = 'Listing files';

      await pump(tester, session, const Size(1280, 800));
      expect(find.text('Listing files'), findsOneWidget);

      session.status.value = 'Hashing media (120/900)';
      await tester.pump();

      expect(find.text('Hashing media (120/900)'), findsOneWidget);
      expect(find.text('Listing files'), findsNothing);
    });

    testWidgets('the status line follows it at narrow widths too', (
      tester,
    ) async {
      // The width where the toolbar drops into its compact form is the width
      // where the LayoutBuilder matters most.
      final session = _reviewSession();
      addTearDown(session.dispose);
      session.phase.value = MatchSessionPhase.scanning;
      session.status.value = 'Listing files';

      await pump(tester, session, const Size(800, 600));
      expect(find.text('Listing files'), findsOneWidget);

      session.status.value = 'Reading funscripts (7/7)';
      await tester.pump();

      expect(find.text('Reading funscripts (7/7)'), findsOneWidget);
    });

    testWidgets('the trailing controls sit at the right edge', (tester) async {
      // A loose Flexible beside an Expanded splits the free space with it and
      // then returns whatever it does not use, which a start-aligned Row
      // discards — stranding these buttons in the middle of the bar.
      final session = _reviewSession();
      addTearDown(session.dispose);

      await pump(tester, session, const Size(1280, 800));

      final bar = tester.getRect(
        find
            .ancestor(
              of: find.byTooltip('Scan again'),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      final back = tester.getRect(find.byTooltip('Back to library'));
      final scan = tester.getRect(find.byTooltip('Scan again'));

      // Inset from its edge by the same margin the back button keeps from
      // the other one.
      expect(bar.right - scan.right, closeTo(back.left - bar.left, 0.5));
    });
  });

  group('the search fields sit on their own centre line', () {
    /// How far the text baseline block sits off the middle of its field. A
    /// dense field with default icons is 8px out, because the icons carry a
    /// 48px minimum the dense text layout knows nothing about — which reads
    /// as an input box whose text is stuck to the top.
    double offCentre(WidgetTester tester, Finder field) {
      final box = tester.getRect(field);
      final text = tester.getRect(
        find.descendant(of: field, matching: find.byType(EditableText)),
      );
      return text.center.dy - box.center.dy;
    }

    /// The residual every Material field with an underline has; the bug this
    /// guards against is four times it.
    const tolerance = 2.5;

    testWidgets('the review list filter, empty and with a clear button', (
      tester,
    ) async {
      final session = _reviewSession();
      addTearDown(session.dispose);
      await pump(tester, session, const Size(1440, 900));

      final field = find.widgetWithText(TextField, 'Filter by name');
      final empty = tester.getRect(field);
      expect(offCentre(tester, field), closeTo(0, tolerance));

      // Typing reveals the clear button, which must not resize the field or
      // shift the text off centre again.
      await tester.enterText(field, 'alpha');
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsWidgets);
      expect(tester.getRect(field).height, empty.height);
      expect(offCentre(tester, field), closeTo(0, tolerance));
    });

    testWidgets('the built-in word search', (tester) async {
      final session = _reviewSession();
      addTearDown(session.dispose);
      await pump(tester, session, const Size(1440, 900));

      await tester.tap(find.byTooltip('Matching options'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Words to ignore'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Words to ignore'));
      await tester.pumpAndSettle();

      final field = find.widgetWithText(TextField, 'Find a word');
      final empty = tester.getRect(field);
      expect(offCentre(tester, field), closeTo(0, tolerance));

      await tester.enterText(field, 'quest');
      await tester.pumpAndSettle();

      expect(tester.getRect(field).height, empty.height);
      expect(offCentre(tester, field), closeTo(0, tolerance));
    });
  });

  group('the review layout holds', () {
    for (final size in _sizes) {
      testWidgets('at ${size.width.toInt()}x${size.height.toInt()}', (
        tester,
      ) async {
        final session = _reviewSession();
        addTearDown(session.dispose);

        await pump(tester, session, size);

        expect(_overflows(tester), isEmpty, reason: '$size');
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('with a decision made and an apply to undo', (tester) async {
      final session = _reviewSession();
      addTearDown(session.dispose);
      // The widest the bars ever get: the apply bar grows a third button and
      // the detail pane grows a banner.
      session.lastApply.value = const MatchApplyOutcome(
        linkedScripts: 128,
        linkedMedia: 96,
        invalidated: [],
      );

      for (final size in _sizes) {
        await pump(tester, session, size);
        session.acceptBest(session.draft.value!.proposals.first);
        await tester.pump();

        expect(_overflows(tester), isEmpty, reason: '$size with a decision');
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('at a larger text scale', (tester) async {
      final session = _reviewSession();
      addTearDown(session.dispose);

      for (final size in _sizes) {
        await pump(tester, session, size, textScale: 1.3);

        expect(_overflows(tester), isEmpty, reason: '$size at 1.3x text');
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('with the options dialog open', (tester) async {
      final session = _reviewSession();
      addTearDown(session.dispose);

      for (final size in _sizes) {
        await pump(tester, session, size);
        await tester.tap(find.byTooltip('Matching options'));
        await tester.pumpAndSettle();

        expect(_overflows(tester), isEmpty, reason: '$size with options open');
        expect(tester.takeException(), isNull);

        await tester.tap(find.text('Done'));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('with the word list open', (tester) async {
      final session = _reviewSession();
      addTearDown(session.dispose);

      for (final size in _sizes) {
        await pump(tester, session, size);
        await tester.tap(find.byTooltip('Matching options'));
        await tester.pumpAndSettle();
        // The options dialog scrolls at these sizes, so the row has to be
        // brought into view before it can be tapped.
        await tester.ensureVisible(find.text('Words to ignore'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Words to ignore'));
        await tester.pumpAndSettle();

        expect(_overflows(tester), isEmpty, reason: '$size with words open');
        expect(tester.takeException(), isNull);
        // Both halves are on screen: the user's own list and the built-in one.
        expect(find.text('Your words'), findsOneWidget);
        expect(find.text('Built-in words'), findsOneWidget);

        // Both dialogs are stacked and both say Done; the last one in the
        // tree is the one on top.
        await tester.tap(find.text('Done').last);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Done'));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('with nothing found at all', (tester) async {
      final session = MatchingSessionModel(
        SettingsModel(),
        FunscriptMatchingSettings(),
        MatchRulesStore(),
      );
      addTearDown(session.dispose);
      session.draft.value = MatchDraft(const []);
      session.phase.value = MatchSessionPhase.reviewing;

      for (final size in _sizes) {
        await pump(tester, session, size);

        expect(_overflows(tester), isEmpty, reason: '$size empty');
        expect(tester.takeException(), isNull);
      }
    });
  });
}
