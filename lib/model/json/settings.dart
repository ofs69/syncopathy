import 'package:json_annotation/json_annotation.dart';
import 'package:syncopathy/player/player_backend_type.dart';

part 'settings.g.dart';

@JsonSerializable(createJsonSchema: true)
class Settings {
  int min = 0;
  int max = 100;
  int offsetMs;
  double? slewMaxRateOfChange;
  double? rdpEpsilon;
  bool remapFullRange;
  bool skipToAction;
  bool autoSwitchToVideoPlayerTab;
  bool invert;
  PlayerBackendType playerBackendType;

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
    this.autoSwitchToVideoPlayerTab = false,
    this.invert = false,
    this.playerBackendType = PlayerBackendType.handyStrokerStreamingBluetooth,
  });

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsToJson(this);

  static const jsonSchema = _$SettingsJsonSchema;
}
