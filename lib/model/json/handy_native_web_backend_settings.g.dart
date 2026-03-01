// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handy_native_web_backend_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HandyNativeWebBackendSettings _$HandyNativeWebBackendSettingsFromJson(
  Map<String, dynamic> json,
) => HandyNativeWebBackendSettings(
  connectionKey: json['connectionKey'] as String? ?? "",
)..applicationKeyOverride = json['applicationKeyOverride'] as String?;

Map<String, dynamic> _$HandyNativeWebBackendSettingsToJson(
  HandyNativeWebBackendSettings instance,
) => <String, dynamic>{
  'connectionKey': instance.connectionKey,
  'applicationKeyOverride': instance.applicationKeyOverride,
};

const _$HandyNativeWebBackendSettingsJsonSchema = {
  r'$schema': 'https://json-schema.org/draft/2020-12/schema',
  'type': 'object',
  'properties': {
    'connectionKey': {'type': 'string', 'default': ''},
    'applicationKeyOverride': {'type': 'string'},
  },
};
