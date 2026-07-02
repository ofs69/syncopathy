import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/player/hsp_clock_sync.dart';

void main() {
  test('aggregateClockSync averages and rounds offset and rtd', () async {
    final samples = <({int rtd, double offset})>[
      (rtd: 10, offset: 2.0),
      (rtd: 20, offset: 4.0),
      (rtd: 30, offset: 6.0),
      (rtd: 41, offset: 9.0),
    ];
    var i = 0;

    final result = await aggregateClockSync(
      tries: samples.length,
      delay: Duration.zero,
      sample: () async => samples[i++],
    );

    // offset: (2 + 4 + 6 + 9) / 4 = 5.25 -> 5
    // rtd:    (10 + 20 + 30 + 41) / 4 = 25.25 -> 25
    expect(result.averageOffset, 5);
    expect(result.averageRtd, 25);
  });

  test('aggregateClockSync calls sample exactly tries times', () async {
    var calls = 0;
    await aggregateClockSync(
      tries: 7,
      delay: Duration.zero,
      sample: () async {
        calls += 1;
        return (rtd: 1, offset: 1.0);
      },
    );
    expect(calls, 7);
  });
}
