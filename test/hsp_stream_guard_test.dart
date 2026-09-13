import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/player/hsp_stream_guard.dart';

void main() {
  test('a report naming our stream is acted on', () {
    final guard = HspStreamGuard();
    expect(
      guard.inspect(ours: 3, reported: 3),
      HspStreamVerdict.current,
    );
  });

  test('a mismatch is ignored while a setup could still be in flight', () {
    final guard = HspStreamGuard(resyncAfterMismatches: 3);
    expect(guard.inspect(ours: 4, reported: 3), HspStreamVerdict.stale);
    expect(guard.inspect(ours: 4, reported: 3), HspStreamVerdict.stale);
  });

  test('the echo resolving clears the mismatches', () {
    final guard = HspStreamGuard(resyncAfterMismatches: 3);
    guard.inspect(ours: 4, reported: 3);
    guard.inspect(ours: 4, reported: 3);
    expect(guard.inspect(ours: 4, reported: 4), HspStreamVerdict.current);
    expect(guard.mismatches, 0);
    // The budget is spent per disagreement, not per session.
    expect(guard.inspect(ours: 5, reported: 4), HspStreamVerdict.stale);
  });

  test('a mismatch that will not resolve asks for a fresh setup', () {
    final guard = HspStreamGuard(resyncAfterMismatches: 3);
    expect(guard.inspect(ours: 1, reported: 9), HspStreamVerdict.stale);
    expect(guard.inspect(ours: 1, reported: 9), HspStreamVerdict.stale);
    expect(guard.inspect(ours: 1, reported: 9), HspStreamVerdict.resync);
  });

  // The regression this guard exists for: a device left on a stream from an
  // earlier run used to wedge the backend. Every handler returned early on the
  // mismatch, including the one that would have called hspSetup, so the Handy
  // stayed still until the user toggled Home Mode off and back on — the only
  // other path that re-established the stream.
  test('a device on a stream from an earlier run recovers on its own', () {
    final guard = HspStreamGuard(resyncAfterMismatches: 3);
    // Our counter restarted at zero with the backend; the device kept 7.
    var ours = 0;
    var verdict = guard.inspect(ours: ours, reported: 7);
    var reports = 1;
    while (verdict != HspStreamVerdict.resync) {
      verdict = guard.inspect(ours: ours, reported: 7);
      reports += 1;
      expect(reports, lessThan(10), reason: 'never asked for a resync');
    }

    // hspSetup: the stream id advances and the echo window restarts.
    ours += 1;
    guard.reset();

    // The device is still echoing the old stream for a report or two.
    expect(guard.inspect(ours: ours, reported: 7), HspStreamVerdict.stale);
    // Then it adopts ours, and playback proceeds without anyone touching a
    // setting.
    expect(guard.inspect(ours: ours, reported: ours), HspStreamVerdict.current);
  });

  test('a setup that never reached the device leaves the id alone', () {
    // What hspSetup now does when hspCommandTarget is null: no advance, so the
    // guard keeps judging against the stream the device actually has.
    final guard = HspStreamGuard(resyncAfterMismatches: 2);
    const ours = 2;
    expect(guard.inspect(ours: ours, reported: ours), HspStreamVerdict.current);
    expect(guard.mismatches, 0);
  });

  test('resyncAfterMismatches must leave room for one echo', () {
    expect(() => HspStreamGuard(resyncAfterMismatches: 0), throwsA(anything));
  });
}
