import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/media_library/matching/funscript_matching_page.dart';
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

/// Smoke tests for the tool's page.
///
/// There is no ObjectBox store in a widget test, so the scan fails on the first
/// thing it touches — which is exactly the case worth covering: a tool that
/// cannot scan has to say so and stay usable, not throw during build.
void main() {
  setUp(() {
    getIt.registerSingleton<IKeyValueStore>(_FakeKeyValueStore());
  });

  tearDown(() => getIt.reset());

  Future<void> pumpPage(WidgetTester tester) async {
    await tester.pumpWidget(
      Provider<SettingsModel>.value(
        value: SettingsModel(),
        child: const MaterialApp(home: FunscriptMatchingPage()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('builds and offers its controls', (tester) async {
    await pumpPage(tester);

    expect(find.text('Match funscripts'), findsOneWidget);
    expect(find.byTooltip('Scan again'), findsOneWidget);
    expect(find.byTooltip('Matching options'), findsOneWidget);
    expect(find.byTooltip('Back to library'), findsOneWidget);
  });

  testWidgets('a failed scan reports itself instead of throwing', (
    tester,
  ) async {
    await pumpPage(tester);
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    expect(tester.takeException(), isNull);
    // Nothing was found, so the page falls back to its empty state rather than
    // rendering a review list with nothing in it.
    expect(find.byType(ListView), findsNothing);
  });

  testWidgets('offers nothing to bulk-accept when there is nothing', (
    tester,
  ) async {
    await pumpPage(tester);

    expect(find.textContaining('obvious'), findsNothing);
  });
}
