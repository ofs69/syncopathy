import 'package:flutter/foundation.dart';

/// Hardware decoding modes offered in settings, mapped to mpv `--hwdec` values.
///
/// Deliberately a curated subset of what mpv accepts. The value is handed
/// straight to libmpv, and the embedded player renders through media_kit's
/// texture pipeline, which only tolerates a few of them. Users who need a
/// specific decoder for diagnosis can pass `--hwdec=<value>` on the command
/// line, which bypasses this enum entirely.
enum HwdecMode {
  /// Decode on the GPU and copy frames back to system memory.
  autoCopy('auto-copy'),

  /// Let mpv select a supported hardware decoder, preferring GPU interop.
  autoSafe('auto-safe'),

  /// No hardware decoding at all.
  none('no');

  /// The literal value passed to mpv's `hwdec` option/property.
  final String mpvValue;

  const HwdecMode(this.mpvValue);

  static HwdecMode get recommended =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.windows
      ? autoSafe
      : autoCopy;

  String toDisplayString() {
    final label = switch (this) {
      HwdecMode.autoCopy => 'Automatic, copy back',
      HwdecMode.autoSafe => 'Automatic, keep on GPU',
      HwdecMode.none => 'Software decoding',
    };
    return this == recommended ? '$label (Recommended)' : label;
  }

  String get description => switch (this) {
    HwdecMode.autoCopy =>
      'Decodes on the GPU and copies frames back to system memory.',
    HwdecMode.autoSafe =>
      'Leaves decoded frames on the GPU, using only decoders mpv considers '
          'safe. Lower overhead, but some drivers show a black video.',
    HwdecMode.none =>
      'Decodes on the CPU. Slower and more power-hungry, but avoids the GPU '
          'decoding path entirely.',
  };
}
