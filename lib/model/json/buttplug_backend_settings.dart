import 'package:json_annotation/json_annotation.dart';

part 'buttplug_backend_settings.g.dart';

@JsonSerializable(createJsonSchema: true)
class ButtplugBackendSettings {
  String host;
  int port;

  static const String key = "ButtplugBackendSettings";

  ButtplugBackendSettings({this.host = "localhost", this.port = 12345});

  factory ButtplugBackendSettings.fromJson(Map<String, dynamic> json) =>
      _$ButtplugBackendSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$ButtplugBackendSettingsToJson(this);

  static const jsonSchema = _$ButtplugBackendSettingsJsonSchema;
}
