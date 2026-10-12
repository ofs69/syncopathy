/// What to do with a device state report, given the HSP stream it names.
enum HspStreamVerdict {
  /// The report describes the stream we established. Act on it.
  current,

  /// The report predates a setup that has not been echoed back yet. Ignore it.
  stale,

  /// The device is on a stream we did not establish. Set it up again.
  resync,
}

/// Tells a stale device report apart from a stream that has genuinely diverged.
///
/// Every HSP handler is keyed on the stream id: a report naming a stream we did
/// not establish describes a buffer we know nothing about, so acting on it would
/// drive the device from the wrong timeline. Ignoring it is right — but only for
/// as long as the disagreement is the echo of a setup still in flight.
///
/// The transport is ordered, so the two cases are told apart by whether our
/// setup has been echoed yet. Until it has, reports answering commands sent
/// before it still name the previous stream, and those are [stale]. Once the
/// device has reported our stream, nothing older can arrive any more: a report
/// naming another stream after that means the device left ours on its own, and
/// it gets a fresh setup at once.
///
/// It has to be at once, because the device that left is usually also falling
/// silent. An HDSP command — the Home Mode park, which auto-home fires on the
/// brief pause mpv reports while switching videos — takes the Handy out of HSP
/// and back to stream 0, and a stopped Handy reports nothing unless asked.
/// Waiting for a count of mismatching reports therefore waited forever: it saw
/// the answers to the last commands sent, then silence, while every handler
/// returned early on the mismatch, including the ones that would have set the
/// stream up again. The Handy stayed still until Home Mode was toggled.
///
/// While a setup is in flight, a mismatch is still ignored only
/// [resyncAfterMismatches] times, for a setup that never arrives.
class HspStreamGuard {
  HspStreamGuard({this.resyncAfterMismatches = 3})
    : assert(resyncAfterMismatches > 0);

  /// Consecutive mismatching reports tolerated while a setup is in flight,
  /// before it counts as lost rather than slow.
  final int resyncAfterMismatches;

  int _mismatches = 0;

  /// Whether a setup has been sent and the device has not reported it back yet.
  bool _awaitingEcho = false;

  /// Consecutive mismatching reports seen since the last agreement or [reset].
  int get mismatches => _mismatches;

  /// Judges a report naming stream [reported] against the stream [ours] we last
  /// established.
  HspStreamVerdict inspect({required int ours, required int reported}) {
    if (reported == ours) {
      _mismatches = 0;
      _awaitingEcho = false;
      return HspStreamVerdict.current;
    }
    if (!_awaitingEcho) return HspStreamVerdict.resync;
    _mismatches += 1;
    return _mismatches >= resyncAfterMismatches
        ? HspStreamVerdict.resync
        : HspStreamVerdict.stale;
  }

  /// Opens the echo window for a setup that has just been sent.
  ///
  /// Called when a setup actually reaches the transport: reports from before it
  /// are the ones to tolerate, and only until the device reports it back.
  void reset() {
    _mismatches = 0;
    _awaitingEcho = true;
  }
}
