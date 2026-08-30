/// Which application drives the device while HereSphere plays the video.
///
/// Exactly one of them may: two applications commanding one stroker fight each
/// other, and the result is neither script. The choice is explicit rather than
/// inferred, because getting it wrong is not something a user can diagnose from
/// the outside — the device simply behaves strangely.
enum HereSphereDeviceOwner {
  /// Syncopathy holds the funscript and commands the device, observing
  /// HereSphere's clock over the event and timestamp channels.
  ///
  /// Syncopathy's own processing — stroke range, intensity, smoothing,
  /// inversion — applies, and HereSphere is never given a script URL. The
  /// user must leave HereSphere's synchronized peripherals turned off.
  syncopathy(
    label: 'Syncopathy drives the device',
    description:
        'Syncopathy keeps the funscript and commands the device, following '
        'HereSphere\'s playback. Your stroke range, intensity and smoothing '
        'settings apply. Needs the timestamp connection configured below, and '
        'HereSphere\'s own synchronized peripherals turned off.',
  ),

  /// HereSphere downloads the funscript and drives the device itself.
  ///
  /// Syncopathy is a media server and nothing more: it publishes script URLs
  /// alongside the video and does not command the device. The scripts are
  /// served as stored, so HereSphere's settings govern them rather than
  /// Syncopathy's processing.
  hereSphere(
    label: 'HereSphere drives the device',
    description:
        'HereSphere downloads the funscript and commands the device with its '
        'own synchronized peripherals. Syncopathy only serves the files, so '
        'its stroke range, intensity and smoothing settings do not apply. '
        'Disconnect the device from Syncopathy first.',
  );

  final String label;
  final String description;

  const HereSphereDeviceOwner({required this.label, required this.description});

  /// Whether funscript URLs are published alongside the video.
  bool get publishesScripts => this == HereSphereDeviceOwner.hereSphere;

  /// Whether Syncopathy observes HereSphere's clock to drive the device.
  bool get drivesDevice => this == HereSphereDeviceOwner.syncopathy;
}
