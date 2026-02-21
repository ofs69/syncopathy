// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buttplug_stroker_backend_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ButtplugStrokerBackendSettings _$ButtplugStrokerBackendSettingsFromJson(
  Map<String, dynamic> json,
) => ButtplugStrokerBackendSettings(
  host: json['host'] as String? ?? "localhost",
  port: (json['port'] as num?)?.toInt() ?? 12345,
);

Map<String, dynamic> _$ButtplugStrokerBackendSettingsToJson(
  ButtplugStrokerBackendSettings instance,
) => <String, dynamic>{'host': instance.host, 'port': instance.port};

const _$ButtplugStrokerBackendSettingsJsonSchema = {
  r'$schema': 'https://json-schema.org/draft/2020-12/schema',
  'type': 'object',
  'properties': {
    'host': {'type': 'string'},
    'port': {'type': 'integer'},
  },
  'required': ['host', 'port'],
};
