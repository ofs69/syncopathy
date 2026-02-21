import 'package:json_annotation/json_annotation.dart';

part 'buttplug_stroker_backend_settings.g.dart';

@JsonSerializable(createJsonSchema: true)
class ButtplugStrokerBackendSettings {
  String host;
  int port;

  static const String key = "ButtplugStrokerBackendSettings";

  ButtplugStrokerBackendSettings({this.host = "localhost", this.port = 12345});

  factory ButtplugStrokerBackendSettings.fromJson(Map<String, dynamic> json) =>
      _$ButtplugStrokerBackendSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$ButtplugStrokerBackendSettingsToJson(this);

  static const jsonSchema = _$ButtplugStrokerBackendSettingsJsonSchema;
}
