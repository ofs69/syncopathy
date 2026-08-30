import 'package:signals/signals.dart';

/// Decides what Home Mode should do as playback pauses and resumes, for the
/// "Home on pause" setting.
///
/// Home Mode is a single flag that the home button, the keyboard shortcut and
/// this controller all write, so the rule is ownership: the controller only
/// turns Home Mode off again when it was the one that turned it on, and it
/// gives that ownership up the moment the user touches the flag themselves.
/// Whatever the user last chose therefore stands — a park they switched on
/// survives playback resuming, and one they switched off is not re-taken until
/// playback pauses afresh.
///
/// Parking happens on the *transition* into a pause (or on the setting being
/// switched on while already paused), never merely because playback is paused.
/// That is what keeps a manual override from being undone on the spot, and it
/// also means starting the app with nothing playing does not seize the device.
class AutoHomeController {
  final Signal<bool> _engaged = signal(false);

  /// Whether the device is currently parked because this controller parked it,
  /// as opposed to the user having switched Home Mode on by hand. Drives the
  /// home button's "automatic" look.
  ReadonlySignal<bool> get engaged => _engaged;

  // The state as of the previous evaluation; null until the first one, which
  // only establishes the baseline. [_lastHome] is what Home Mode was left at,
  // so a value that differs on the next evaluation can only be the user's.
  bool? _lastPaused;
  bool? _lastAutoHomeOnPause;
  bool _lastHome = false;

  /// The value Home Mode should take now, or null to leave it alone.
  ///
  /// [autoHomeOnPause] is the setting, [paused] the playback state and
  /// [homeEnabled] Home Mode as it stands.
  bool? nextHomeState({
    required bool autoHomeOnPause,
    required bool paused,
    required bool homeEnabled,
  }) {
    // Home Mode moved without us moving it: the user took it over.
    if (homeEnabled != _lastHome) _engaged.value = false;

    final firstEvaluation = _lastPaused == null;
    final pauseChanged = paused != _lastPaused;
    final settingChanged = autoHomeOnPause != _lastAutoHomeOnPause;
    _lastPaused = paused;
    _lastAutoHomeOnPause = autoHomeOnPause;

    bool? next;
    if (firstEvaluation) {
      // Baseline only — see the class comment.
    } else if (autoHomeOnPause && paused) {
      if (!homeEnabled && (pauseChanged || settingChanged)) {
        _engaged.value = true;
        next = true;
      }
    } else if (_engaged.value) {
      // Playback resumed, or the setting was switched off, and the park is
      // ours to release.
      _engaged.value = false;
      if (homeEnabled) next = false;
    }

    _lastHome = next ?? homeEnabled;
    return next;
  }
}
