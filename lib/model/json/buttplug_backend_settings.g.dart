// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buttplug_backend_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ButtplugBackendSettings _$ButtplugBackendSettingsFromJson(
  Map<String, dynamic> json,
) => ButtplugBackendSettings(
  host: json['host'] as String? ?? "localhost",
  port: (json['port'] as num?)?.toInt() ?? 12345,
);

Map<String, dynamic> _$ButtplugBackendSettingsToJson(
  ButtplugBackendSettings instance,
) => <String, dynamic>{'host': instance.host, 'port': instance.port};

const _$ButtplugBackendSettingsJsonSchema = {
  r'$schema': 'https://json-schema.org/draft/2020-12/schema',
  'type': 'object',
  'properties': {
    'host': {'type': 'string', 'default': 'localhost'},
    'port': {'type': 'integer', 'default': 12345},
  },
};
