import 'package:syncopathy/logging.dart';

/// Repeatedly samples the round-trip delay (RTD) and clock offset to the device,
/// aggregates them over [tries] iterations paced by [delay], and returns the
/// rounded averages in milliseconds.
///
/// [sample] performs one measurement round-trip and returns its `(rtd, offset)`.
/// The loop, per-iteration logging, pacing, and averaging are shared between the
/// Bluetooth and Web HSP backends, which differ only in how a single sample is
/// taken (a servertime GET vs. a clock-offset RPC) and how the resulting
/// averages are applied to the device clock afterwards.
Future<({int averageOffset, int averageRtd})> aggregateClockSync({
  required int tries,
  required Duration delay,
  required Future<({int rtd, double offset})> Function() sample,
}) async {
  var offsetAggregated = 0.0;
  var rtdAggregated = 0.0;
  for (var index = 0; index < tries; index += 1) {
    final s = await sample();
    Logger.debug('RTD: ${s.rtd}\tOffset: ${s.offset}');
    offsetAggregated += s.offset;
    rtdAggregated += s.rtd;
    await Future.delayed(delay);
  }
  return (
    averageOffset: (offsetAggregated / tries).round(),
    averageRtd: (rtdAggregated / tries).round(),
  );
}
