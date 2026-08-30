import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signals/signals.dart';
import 'package:syncopathy/heatmap.dart';
import 'package:syncopathy/model/json/funscript_json.dart';

/// The seek bar under a session that cannot be steered.
///
/// The player tab aims its controls at whichever session owns playback, and an
/// external player Syncopathy only observes accepts no seeks. A null [onClick]
/// is how the bar says so, and it has to actually refuse — a bar that takes the
/// click and drops it looks identical to one that seeked to the wrong place.
void main() {
  const width = 400.0;
  const durationSeconds = 100.0;

  final actions = [
    FunscriptAction(at: 0, pos: 0),
    FunscriptAction(at: 50000, pos: 100),
    FunscriptAction(at: 100000, pos: 0),
  ];

  Widget host({required void Function(Duration)? onClick}) => MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: width,
          height: 24,
          child: Heatmap(
            actions: actions,
            totalDuration: signal(durationSeconds),
            videoPositionFixedStep: signal(0),
            playbackSpeed: signal(1.0),
            strokeRange: signal(const RangeValues(0, 100)),
            onClick: onClick,
          ),
        ),
      ),
    ),
  );

  testWidgets('a seekable bar reports where the click landed', (tester) async {
    final seeks = <Duration>[];
    await tester.pumpWidget(host(onClick: seeks.add));

    // A quarter of the way across a 100 s script.
    final bar = tester.getRect(find.byType(Heatmap));
    await tester.tapAt(Offset(bar.left + width * 0.25, bar.center.dy));
    await tester.pump();

    expect(seeks, isNotEmpty);
    expect(seeks.last.inSeconds, 25);
  });

  testWidgets('a bar with no seek swallows nothing and does not throw', (
    tester,
  ) async {
    await tester.pumpWidget(host(onClick: null));

    final bar = tester.getRect(find.byType(Heatmap));
    await tester.tapAt(Offset(bar.left + width * 0.25, bar.center.dy));
    await tester.pump();

    expect(tester.takeException(), isNull);
  });

  testWidgets('only a seekable bar offers the keyboard/screen-reader seek', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(host(onClick: (_) {}));
    final seekable = tester
        .getSemantics(find.bySemanticsLabel('Seek position'))
        .getSemanticsData();
    expect(seekable.hasAction(SemanticsAction.increase), isTrue);
    expect(seekable.hasAction(SemanticsAction.decrease), isTrue);

    await tester.pumpWidget(host(onClick: null));
    final readOnly = tester
        .getSemantics(find.bySemanticsLabel('Playback position'))
        .getSemanticsData();
    expect(readOnly.hasAction(SemanticsAction.increase), isFalse);
    expect(readOnly.hasAction(SemanticsAction.decrease), isFalse);

    handle.dispose();
  });
}
