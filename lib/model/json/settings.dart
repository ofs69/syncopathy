import 'package:json_annotation/json_annotation.dart';
import 'package:syncopathy/heresphere/heresphere_mode.dart';
import 'package:syncopathy/model/home_target.dart';
import 'package:syncopathy/player/hwdec_mode.dart';
import 'package:syncopathy/player/player_backend_type.dart';
import 'package:syncopathy/model/shortcut_settings.dart';

part 'settings.g.dart';

@JsonSerializable(createJsonSchema: true)
class Settings {
  int min = 0;
  int max = 100;
  int offsetMs;
  List<String> mediaPaths = [];
  double slewMaxRateOfChange;
  double rdpEpsilon;
  bool remapFullRange;
  bool skipToAction;
  bool embeddedVideoPlayer;
  bool autoSwitchToVideoPlayerTab;
  bool invert;
  @JsonKey(unknownEnumValue: PlayerBackendType.handyStrokerStreamingBluetooth)
  PlayerBackendType playerBackendType;
  bool autoReconnect;
  bool autoHomeOnPause;
  int homeMoveDurationMs;
  bool funscriptGraphEnabled;
  @JsonKey(unknownEnumValue: HwdecMode.autoCopy)
  HwdecMode hwdecMode;
  Map<String, ShortcutBinding> customShortcuts = {};
  bool hereSphereEnabled;
  int hereSpherePort;
  String hereSphereBindAddress;
  @JsonKey(unknownEnumValue: HereSphereDeviceOwner.syncopathy)
  HereSphereDeviceOwner hereSphereDeviceOwner;

  /// Whether to take HereSphere's address from the player that connected,
  /// rather than one the user typed. On by default: the address is already
  /// known, because that player is the one making requests to this server.
  bool hereSphereTimestampAutoDetect;

  /// Address of the machine running HereSphere, for the timestamp channel.
  /// Used only when auto-detection is off.
  String hereSphereTimestampHost;
  int hereSphereTimestampPort;
  bool hereSphereAllowRemoteControl;

  /// Whether published thumbnails carry the library's badges and a heatmap
  /// strip. On by default: the point of the badges is to tell entries apart at
  /// a glance, and that is worth more in a headset than on a desktop.
  bool hereSphereDecorateThumbnails;

  /// Login HereSphere must present. The password is stored only as a salted
  /// PBKDF2 hash — this file is plain JSON in the application data directory
  /// and it travels in bug reports.
  String hereSphereUsername;
  String hereSpherePasswordHash;

  static const String key = "MainAppSettings";

  Settings({
    this.min = 0,
    this.max = 100,
    this.offsetMs = 0,
    List<String> mediaPaths = const [],
    this.slewMaxRateOfChange = 400,
    this.rdpEpsilon = 7,
    this.remapFullRange = true,
    this.skipToAction = true,
    this.embeddedVideoPlayer = false,
    this.autoSwitchToVideoPlayerTab = false,
    this.invert = false,
    this.playerBackendType = PlayerBackendType.handyStrokerStreamingBluetooth,
    this.autoReconnect = false,
    this.autoHomeOnPause = false,
    this.homeMoveDurationMs = HomeTarget.defaultMoveDurationMs,
    this.funscriptGraphEnabled = true,
    this.hwdecMode = HwdecMode.autoCopy,
    Map<String, ShortcutBinding> customShortcuts = const {},
    this.hereSphereEnabled = false,
    this.hereSpherePort = 9678,
    this.hereSphereBindAddress = '0.0.0.0',
    this.hereSphereDeviceOwner = HereSphereDeviceOwner.syncopathy,
    this.hereSphereTimestampHost = '127.0.0.1',
    this.hereSphereTimestampPort = 23554,
    this.hereSphereTimestampAutoDetect = true,
    this.hereSphereAllowRemoteControl = false,
    this.hereSphereDecorateThumbnails = true,
    this.hereSphereUsername = 'syncopathy',
    this.hereSpherePasswordHash = '',
  }) : mediaPaths = List.of(mediaPaths),
       customShortcuts = Map.of(customShortcuts);

  factory Settings.fromJson(Map<String, dynamic> json) {
    try {
      return _$SettingsFromJson(json);
    } catch (_) {
      // Corrupted or incompatible persisted data (e.g. removed enum value,
      // type mismatch). Fall back to defaults rather than crashing.
      return Settings();
    }
  }

  Map<String, dynamic> toJson() => _$SettingsToJson(this);

  static const jsonSchema = _$SettingsJsonSchema;
}
