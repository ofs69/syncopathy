/// Hardware decoding modes offered in settings, mapped to mpv `--hwdec` values.
///
/// Deliberately a curated subset of what mpv accepts. The value is handed
/// straight to libmpv, and the embedded player renders through media_kit's
/// texture pipeline, which only tolerates a few of them. Users who need a
/// specific decoder for diagnosis can pass `--hwdec=<value>` on the command
/// line, which bypasses this enum entirely.
enum HwdecMode {
  /// Decode on the GPU, copy frames back to system memory. The long-standing
  /// default, and the most compatible with the texture pipeline.
  autoCopy('auto-copy'),

  /// Keep decoded frames in GPU memory, restricted to the decoders mpv
  /// whitelists as safe. Preferred over plain `auto`, which will also try
  /// methods known to misbehave.
  autoSafe('auto-safe'),

  /// No hardware decoding at all.
  none('no');

  /// The literal value passed to mpv's `hwdec` option/property.
  final String mpvValue;

  const HwdecMode(this.mpvValue);

  String toDisplayString() => switch (this) {
    HwdecMode.autoCopy => 'Automatic, copy back (Recommended)',
    HwdecMode.autoSafe => 'Automatic, keep on GPU',
    HwdecMode.none => 'Software decoding',
  };

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
