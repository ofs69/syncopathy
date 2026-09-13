/// What to do with a device state report, given the HSP stream it names.
enum HspStreamVerdict {
  /// The report describes the stream we established. Act on it.
  current,

  /// The report predates a setup that has not been echoed back yet. Ignore it.
  stale,

  /// The device has settled on a stream we never established. Set it up again.
  resync,
}

/// Tells a stale device report apart from a stream that has genuinely diverged.
///
/// Every HSP handler is keyed on the stream id: a report naming a stream we did
/// not establish describes a buffer we know nothing about, so acting on it would
/// drive the device from the wrong timeline. Ignoring it is right — but only for
/// as long as the disagreement is the echo of a setup still in flight.
///
/// The two cases look identical in a single report and are told apart by how
/// long they last. A setup in flight is resolved by the next report or two; a
/// device left on a stream from an earlier run never resolves at all. Left
/// unbounded, that second case wedges the backend: every handler returns early,
/// including the ones that would have issued the setup that fixes it, so the
/// only way out is an unrelated code path that happens to call `hspSetup` —
/// switching Home Mode off, in practice.
///
/// So a mismatch is ignored [resyncAfterMismatches] times and then treated as
/// divergence. The cost of waiting is a fraction of a second of device reports;
/// the cost of not waiting is re-establishing the stream on every setup, which
/// would never let one settle.
class HspStreamGuard {
  HspStreamGuard({this.resyncAfterMismatches = 3})
    : assert(resyncAfterMismatches > 0);

  /// Consecutive mismatching reports tolerated before the stream counts as
  /// diverged rather than as an echo of a setup in flight.
  final int resyncAfterMismatches;

  int _mismatches = 0;

  /// Consecutive mismatching reports seen since the last agreement or [reset].
  int get mismatches => _mismatches;

  /// Judges a report naming stream [reported] against the stream [ours] we last
  /// established.
  HspStreamVerdict inspect({required int ours, required int reported}) {
    if (reported == ours) {
      _mismatches = 0;
      return HspStreamVerdict.current;
    }
    _mismatches += 1;
    return _mismatches >= resyncAfterMismatches
        ? HspStreamVerdict.resync
        : HspStreamVerdict.stale;
  }

  /// Forgets the mismatches so far.
  ///
  /// Called when a setup actually reaches the device: that is the point the
  /// echo window starts, and counting reports from before it would spend the
  /// budget on a disagreement that has already been addressed.
  void reset() => _mismatches = 0;
}
