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
    'min': {'type': 'integer', 'default': 0},
    'max': {'type': 'integer', 'default': 100},
    'offsetMs': {'type': 'integer', 'default': 0},
    'slewMaxRateOfChange': {'type': 'number', 'default': 400.0},
    'rdpEpsilon': {'type': 'number', 'default': 7.0},
    'remapFullRange': {'type': 'boolean', 'default': true},
    'skipToAction': {'type': 'boolean', 'default': true},
    'autoSwitchToVideoPlayerTab': {'type': 'boolean', 'default': false},
    'invert': {'type': 'boolean', 'default': false},
    'playerBackendType': {'type': 'object'},
  },
};

const _$PlayerBackendTypeEnumMap = {
  PlayerBackendType.handyStrokerStreamingBluetooth:
      'handyStrokerStreamingBluetooth',
  PlayerBackendType.handyStrokerCommand: 'handyStrokerCommand',
  PlayerBackendType.buttplugStrokerCommand: 'buttplugStrokerCommand',
};
