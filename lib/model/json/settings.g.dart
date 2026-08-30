// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
  min: (json['min'] as num?)?.toInt() ?? 0,
  max: (json['max'] as num?)?.toInt() ?? 100,
  offsetMs: (json['offsetMs'] as num?)?.toInt() ?? 0,
  mediaPaths:
      (json['mediaPaths'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  slewMaxRateOfChange: (json['slewMaxRateOfChange'] as num?)?.toDouble() ?? 400,
  rdpEpsilon: (json['rdpEpsilon'] as num?)?.toDouble() ?? 7,
  remapFullRange: json['remapFullRange'] as bool? ?? true,
  skipToAction: json['skipToAction'] as bool? ?? true,
  embeddedVideoPlayer: json['embeddedVideoPlayer'] as bool? ?? false,
  autoSwitchToVideoPlayerTab:
      json['autoSwitchToVideoPlayerTab'] as bool? ?? false,
  invert: json['invert'] as bool? ?? false,
  playerBackendType:
      $enumDecodeNullable(
        _$PlayerBackendTypeEnumMap,
        json['playerBackendType'],
        unknownValue: PlayerBackendType.handyStrokerStreamingBluetooth,
      ) ??
      PlayerBackendType.handyStrokerStreamingBluetooth,
  autoReconnect: json['autoReconnect'] as bool? ?? false,
  funscriptGraphEnabled: json['funscriptGraphEnabled'] as bool? ?? true,
  hwdecMode:
      $enumDecodeNullable(
        _$HwdecModeEnumMap,
        json['hwdecMode'],
        unknownValue: HwdecMode.autoCopy,
      ) ??
      HwdecMode.autoCopy,
  customShortcuts:
      (json['customShortcuts'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, ShortcutBinding.fromJson(e as Map<String, dynamic>)),
      ) ??
      const {},
  hereSphereEnabled: json['hereSphereEnabled'] as bool? ?? false,
  hereSpherePort: (json['hereSpherePort'] as num?)?.toInt() ?? 9678,
  hereSphereBindAddress: json['hereSphereBindAddress'] as String? ?? '0.0.0.0',
  hereSphereDeviceOwner:
      $enumDecodeNullable(
        _$HereSphereDeviceOwnerEnumMap,
        json['hereSphereDeviceOwner'],
        unknownValue: HereSphereDeviceOwner.syncopathy,
      ) ??
      HereSphereDeviceOwner.syncopathy,
  hereSphereTimestampHost:
      json['hereSphereTimestampHost'] as String? ?? '127.0.0.1',
  hereSphereTimestampPort:
      (json['hereSphereTimestampPort'] as num?)?.toInt() ?? 23554,
  hereSphereTimestampAutoDetect:
      json['hereSphereTimestampAutoDetect'] as bool? ?? true,
  hereSphereAllowRemoteControl:
      json['hereSphereAllowRemoteControl'] as bool? ?? false,
  hereSphereDecorateThumbnails:
      json['hereSphereDecorateThumbnails'] as bool? ?? true,
  hereSphereUsername: json['hereSphereUsername'] as String? ?? 'syncopathy',
  hereSpherePasswordHash: json['hereSpherePasswordHash'] as String? ?? '',
);

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
  'min': instance.min,
  'max': instance.max,
  'offsetMs': instance.offsetMs,
  'mediaPaths': instance.mediaPaths,
  'slewMaxRateOfChange': instance.slewMaxRateOfChange,
  'rdpEpsilon': instance.rdpEpsilon,
  'remapFullRange': instance.remapFullRange,
  'skipToAction': instance.skipToAction,
  'embeddedVideoPlayer': instance.embeddedVideoPlayer,
  'autoSwitchToVideoPlayerTab': instance.autoSwitchToVideoPlayerTab,
  'invert': instance.invert,
  'playerBackendType': _$PlayerBackendTypeEnumMap[instance.playerBackendType]!,
  'autoReconnect': instance.autoReconnect,
  'funscriptGraphEnabled': instance.funscriptGraphEnabled,
  'hwdecMode': _$HwdecModeEnumMap[instance.hwdecMode]!,
  'customShortcuts': instance.customShortcuts,
  'hereSphereEnabled': instance.hereSphereEnabled,
  'hereSpherePort': instance.hereSpherePort,
  'hereSphereBindAddress': instance.hereSphereBindAddress,
  'hereSphereDeviceOwner':
      _$HereSphereDeviceOwnerEnumMap[instance.hereSphereDeviceOwner]!,
  'hereSphereTimestampAutoDetect': instance.hereSphereTimestampAutoDetect,
  'hereSphereTimestampHost': instance.hereSphereTimestampHost,
  'hereSphereTimestampPort': instance.hereSphereTimestampPort,
  'hereSphereAllowRemoteControl': instance.hereSphereAllowRemoteControl,
  'hereSphereDecorateThumbnails': instance.hereSphereDecorateThumbnails,
  'hereSphereUsername': instance.hereSphereUsername,
  'hereSpherePasswordHash': instance.hereSpherePasswordHash,
};

const _$SettingsJsonSchema = {
  r'$schema': 'https://json-schema.org/draft/2020-12/schema',
  'type': 'object',
  'properties': {
    'min': {'type': 'integer', 'default': 0},
    'max': {'type': 'integer', 'default': 100},
    'offsetMs': {'type': 'integer', 'default': 0},
    'mediaPaths': {
      'type': 'array',
      'items': {'type': 'string'},
      'default': [],
    },
    'slewMaxRateOfChange': {'type': 'number', 'default': 400.0},
    'rdpEpsilon': {'type': 'number', 'default': 7.0},
    'remapFullRange': {'type': 'boolean', 'default': true},
    'skipToAction': {'type': 'boolean', 'default': true},
    'embeddedVideoPlayer': {'type': 'boolean', 'default': false},
    'autoSwitchToVideoPlayerTab': {'type': 'boolean', 'default': false},
    'invert': {'type': 'boolean', 'default': false},
    'playerBackendType': {'type': 'object'},
    'autoReconnect': {'type': 'boolean', 'default': false},
    'funscriptGraphEnabled': {'type': 'boolean', 'default': true},
    'hwdecMode': {'type': 'object'},
    'customShortcuts': {
      'type': 'object',
      'additionalProperties': {r'$ref': r'#/$defs/ShortcutBinding'},
      'default': {},
    },
    'hereSphereEnabled': {'type': 'boolean', 'default': false},
    'hereSpherePort': {'type': 'integer', 'default': 9678},
    'hereSphereBindAddress': {'type': 'string', 'default': '0.0.0.0'},
    'hereSphereDeviceOwner': {'type': 'object'},
    'hereSphereTimestampAutoDetect': {
      'type': 'boolean',
      'description':
          "Whether to take HereSphere's address from the player that connected,\nrather than one the user typed. On by default: the address is already\nknown, because that player is the one making requests to this server.",
      'default': true,
    },
    'hereSphereTimestampHost': {
      'type': 'string',
      'description':
          'Address of the machine running HereSphere, for the timestamp channel.\nUsed only when auto-detection is off.',
      'default': '127.0.0.1',
    },
    'hereSphereTimestampPort': {'type': 'integer', 'default': 23554},
    'hereSphereAllowRemoteControl': {'type': 'boolean', 'default': false},
    'hereSphereDecorateThumbnails': {
      'type': 'boolean',
      'description':
          "Whether published thumbnails carry the library's badges and a heatmap\nstrip. On by default: the point of the badges is to tell entries apart at\na glance, and that is worth more in a headset than on a desktop.",
      'default': true,
    },
    'hereSphereUsername': {
      'type': 'string',
      'description':
          'Login HereSphere must present. The password is stored only as a salted\nPBKDF2 hash — this file is plain JSON in the application data directory\nand it travels in bug reports.',
      'default': 'syncopathy',
    },
    'hereSpherePasswordHash': {'type': 'string', 'default': ''},
  },
  r'$defs': {
    'ShortcutBinding': {
      'type': 'object',
      'properties': {
        'keyId': {'type': 'integer'},
        'control': {'type': 'boolean', 'default': false},
        'shift': {'type': 'boolean', 'default': false},
        'alt': {'type': 'boolean', 'default': false},
        'meta': {'type': 'boolean', 'default': false},
      },
      'required': ['keyId'],
    },
  },
};

const _$PlayerBackendTypeEnumMap = {
  PlayerBackendType.handyStrokerStreamingBluetooth:
      'handyStrokerStreamingBluetooth',
  PlayerBackendType.handyStrokerStreamingWeb: 'handyStrokerStreamingWeb',
  PlayerBackendType.handyStrokerCommand: 'handyStrokerCommand',
  PlayerBackendType.buttplugStrokerCommand: 'buttplugStrokerCommand',
};

const _$HwdecModeEnumMap = {
  HwdecMode.autoCopy: 'autoCopy',
  HwdecMode.autoSafe: 'autoSafe',
  HwdecMode.none: 'none',
};

const _$HereSphereDeviceOwnerEnumMap = {
  HereSphereDeviceOwner.syncopathy: 'syncopathy',
  HereSphereDeviceOwner.hereSphere: 'hereSphere',
};
