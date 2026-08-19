/// Which end of the stroke Home Mode parks the device at.
///
/// The two accessors exist because the two backend families already disagree
/// about who applies inversion, and Home Mode mirrors whatever each of them
/// does for ordinary playback:
///
///  * command backends receive a raw 0-100 [position] and clamp it to the
///    configured stroke range themselves, and their script positions have
///    already been inverted upstream by `Funscript.processedActions`;
///  * the HSP backend streams normalised positions and applies [invert] at the
///    point of sending, which is what [normalized] reproduces.
enum HomeTarget {
  /// The bottom of the stroke — the long-standing Home Mode behaviour.
  low(0, 'Park at 0'),

  /// The top of the stroke.
  high(100, 'Park at 100');

  const HomeTarget(this.position, this.label);

  /// How long the device takes to travel to the parked position. Shared
  /// by both backend families so they cannot drift into parking at
  /// different speeds.
  static const int moveDurationMs = 600;

  /// Raw 0-100 position handed to command backends.
  final int position;

  /// Menu label for this target.
  final String label;

  /// Normalised 0.0-1.0 position for the HSP backend, honouring [invert].
  double normalized(bool invert) =>
      invert ? 1.0 - position / 100.0 : position / 100.0;

  /// The target a tap on the other menu entry would select.
  HomeTarget get opposite => this == HomeTarget.low ? high : low;
}
