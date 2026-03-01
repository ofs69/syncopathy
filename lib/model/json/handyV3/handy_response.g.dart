// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handy_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HandyServertime _$HandyServertimeFromJson(Map<String, dynamic> json) =>
    HandyServertime(serverTime: (json['server_time'] as num).toInt());

Map<String, dynamic> _$HandyServertimeToJson(HandyServertime instance) =>
    <String, dynamic>{'server_time': instance.serverTime};

HandyError _$HandyErrorFromJson(Map<String, dynamic> json) => HandyError(
  connected: json['connected'] as bool,
  name: json['name'] as String,
  message: json['message'] as String,
  code: (json['code'] as num).toInt(),
  data: json['data'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$HandyErrorToJson(HandyError instance) =>
    <String, dynamic>{
      'connected': instance.connected,
      'name': instance.name,
      'message': instance.message,
      'code': instance.code,
      'data': instance.data,
    };

HandyResponse<T> _$HandyResponseFromJson<T extends HandyResult>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => HandyResponse<T>(
  result: _$nullableGenericFromJson(json['result'], fromJsonT),
  error: json['error'] == null
      ? null
      : HandyError.fromJson(json['error'] as Map<String, dynamic>),
);

Map<String, dynamic> _$HandyResponseToJson<T extends HandyResult>(
  HandyResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'result': _$nullableGenericToJson(instance.result, toJsonT),
  'error': instance.error,
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) => input == null ? null : toJson(input);

HandyConnected _$HandyConnectedFromJson(Map<String, dynamic> json) =>
    HandyConnected(connected: json['connected'] as bool);

Map<String, dynamic> _$HandyConnectedToJson(HandyConnected instance) =>
    <String, dynamic>{'connected': instance.connected};

HandyClock _$HandyClockFromJson(Map<String, dynamic> json) => HandyClock(
  time: (json['time'] as num).toInt(),
  clockOffset: (json['clock_offset'] as num).toInt(),
  rtd: (json['rtd'] as num).toInt(),
);

Map<String, dynamic> _$HandyClockToJson(HandyClock instance) =>
    <String, dynamic>{
      'time': instance.time,
      'clock_offset': instance.clockOffset,
      'rtd': instance.rtd,
    };

HandyInfo _$HandyInfoFromJson(Map<String, dynamic> json) => HandyInfo(
  fwStatus: (json['fw_status'] as num).toInt(),
  fwVersion: json['fw_version'] as String,
  fwFeatureFlags: json['fw_feature_flags'] as String,
  hwModelNo: (json['hw_model_no'] as num).toInt(),
  hwModelName: json['hw_model_name'] as String,
  hwModelVariant: (json['hw_model_variant'] as num).toInt(),
  sessionId: json['session_id'] as String,
);

Map<String, dynamic> _$HandyInfoToJson(HandyInfo instance) => <String, dynamic>{
  'fw_status': instance.fwStatus,
  'fw_version': instance.fwVersion,
  'fw_feature_flags': instance.fwFeatureFlags,
  'hw_model_no': instance.hwModelNo,
  'hw_model_name': instance.hwModelName,
  'hw_model_variant': instance.hwModelVariant,
  'session_id': instance.sessionId,
};

HandyHspState _$HandyHspStateFromJson(Map<String, dynamic> json) =>
    HandyHspState(
      playState: (json['play_state'] as num).toInt(),
      pauseOnStarving: json['pause_on_starving'] as bool,
      points: (json['points'] as num).toInt(),
      maxPoints: (json['max_points'] as num).toInt(),
      currentPoint: (json['current_point'] as num).toInt(),
      currentTime: (json['current_time'] as num).toInt(),
      loop: json['loop'] as bool,
      playbackRate: (json['playback_rate'] as num).toDouble(),
      firstPointTime: (json['first_point_time'] as num).toInt(),
      lastPointTime: (json['last_point_time'] as num).toInt(),
      streamId: (json['stream_id'] as num).toInt(),
      tailPointStreamIndex: (json['tail_point_stream_index'] as num).toInt(),
      tailPointStreamIndexThreshold:
          (json['tail_point_stream_index_threshold'] as num).toInt(),
    );

Map<String, dynamic> _$HandyHspStateToJson(
  HandyHspState instance,
) => <String, dynamic>{
  'play_state': instance.playState,
  'pause_on_starving': instance.pauseOnStarving,
  'points': instance.points,
  'max_points': instance.maxPoints,
  'current_point': instance.currentPoint,
  'current_time': instance.currentTime,
  'loop': instance.loop,
  'playback_rate': instance.playbackRate,
  'first_point_time': instance.firstPointTime,
  'last_point_time': instance.lastPointTime,
  'stream_id': instance.streamId,
  'tail_point_stream_index': instance.tailPointStreamIndex,
  'tail_point_stream_index_threshold': instance.tailPointStreamIndexThreshold,
};

HandyStrokeSettings _$HandyStrokeSettingsFromJson(Map<String, dynamic> json) =>
    HandyStrokeSettings(
      min: (json['min'] as num).toDouble(),
      max: (json['max'] as num).toDouble(),
      minAbsolute: (json['min_absolute'] as num).toDouble(),
      maxAbsolute: (json['max_absolute'] as num).toDouble(),
    );

Map<String, dynamic> _$HandyStrokeSettingsToJson(
  HandyStrokeSettings instance,
) => <String, dynamic>{
  'min': instance.min,
  'max': instance.max,
  'min_absolute': instance.minAbsolute,
  'max_absolute': instance.maxAbsolute,
};
