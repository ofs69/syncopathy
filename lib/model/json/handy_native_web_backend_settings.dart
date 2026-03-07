import 'package:json_annotation/json_annotation.dart';

part 'handy_native_web_backend_settings.g.dart';

@JsonSerializable(createJsonSchema: true)
class HandyNativeWebBackendSettings {
  String connectionKey;
  String? applicationKeyOverride;

  static const String key = "HandyNativeWebBackendSettings";

  HandyNativeWebBackendSettings({this.connectionKey = ""});

  factory HandyNativeWebBackendSettings.fromJson(Map<String, dynamic> json) =>
      _$HandyNativeWebBackendSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$HandyNativeWebBackendSettingsToJson(this);

  static const jsonSchema = _$HandyNativeWebBackendSettingsJsonSchema;
}
