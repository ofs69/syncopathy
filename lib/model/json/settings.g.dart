// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
  min: (json['min'] as num?)?.toInt() ?? 0,
  max: (json['max'] as num?)?.toInt() ?? 100,
  offsetMs: (json['offsetMs'] as num?)?.toInt() ?? 0,
  slewMaxRateOfChange: (json['slewMaxRateOfChange'] as num?)?.toDouble() ?? 400,
  rdpEpsilon: (json['rdpEpsilon'] as num?)?.toDouble() ?? 7,
  remapFullRange: json['remapFullRange'] as bool? ?? true,
  skipToAction: json['skipToAction'] as bool? ?? true,
  autoSwitchToVideoPlayerTab:
      json['autoSwitchToVideoPlayerTab'] as bool? ?? false,
  invert: json['invert'] as bool? ?? false,
  playerBackendType:
      $enumDecodeNullable(
        _$PlayerBackendTypeEnumMap,
        json['playerBackendType'],
      ) ??
      PlayerBackendType.handyStrokerStreamingBluetooth,
);

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
  'min': instance.min,
  'max': instance.max,
  'offsetMs': instance.offsetMs,
  'slewMaxRateOfChange': instance.slewMaxRateOfChange,
  'rdpEpsilon': instance.rdpEpsilon,
  'remapFullRange': instance.remapFullRange,
  'skipToAction': instance.skipToAction,
  'autoSwitchToVideoPlayerTab': instance.autoSwitchToVideoPlayerTab,
  'invert': instance.invert,
  'playerBackendType': _$PlayerBackendTypeEnumMap[instance.playerBackendType]!,
};

const _$SettingsJsonSchema = {
  r'$schema': 'https://json-schema.org/draft/2020-12/schema',
  'type': 'object',
  'properties': {
    'min': {'type': 'integer'},
    'max': {'type': 'integer'},
    'offsetMs': {'type': 'integer'},
    'slewMaxRateOfChange': {'type': 'number'},
    'rdpEpsilon': {'type': 'number'},
    'remapFullRange': {'type': 'boolean'},
    'skipToAction': {'type': 'boolean'},
    'autoSwitchToVideoPlayerTab': {'type': 'boolean'},
    'invert': {'type': 'boolean'},
    'playerBackendType': {'type': 'object'},
  },
  'required': [
    'min',
    'max',
    'offsetMs',
    'remapFullRange',
    'skipToAction',
    'autoSwitchToVideoPlayerTab',
    'invert',
    'playerBackendType',
  ],
};

const _$PlayerBackendTypeEnumMap = {
  PlayerBackendType.handyStrokerStreamingBluetooth:
      'handyStrokerStreamingBluetooth',
  PlayerBackendType.handyStrokerCommand: 'handyStrokerCommand',
  PlayerBackendType.buttplugStrokerCommand: 'buttplugStrokerCommand',
};
