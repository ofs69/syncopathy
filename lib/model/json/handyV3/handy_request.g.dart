// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handy_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HspSetup _$HspSetupFromJson(Map<String, dynamic> json) =>
    HspSetup(streamId: (json['stream_id'] as num?)?.toInt());

Map<String, dynamic> _$HspSetupToJson(HspSetup instance) => <String, dynamic>{
  'stream_id': ?instance.streamId,
};

HspAddPoint _$HspAddPointFromJson(Map<String, dynamic> json) =>
    HspAddPoint(x: (json['x'] as num).toInt(), t: (json['t'] as num).toInt());

Map<String, dynamic> _$HspAddPointToJson(HspAddPoint instance) =>
    <String, dynamic>{'x': instance.x, 't': instance.t};

HspAdd _$HspAddFromJson(Map<String, dynamic> json) => HspAdd(
  points: (json['points'] as List<dynamic>)
      .map((e) => HspAddPoint.fromJson(e as Map<String, dynamic>))
      .toList(),
  flush: json['flush'] as bool,
  tailPointStreamIndex: (json['tail_point_stream_index'] as num?)?.toInt(),
  tailPointThreshold: (json['tail_point_threshold'] as num?)?.toInt(),
);

Map<String, dynamic> _$HspAddToJson(HspAdd instance) => <String, dynamic>{
  'points': instance.points,
  'flush': instance.flush,
  'tail_point_stream_index': ?instance.tailPointStreamIndex,
  'tail_point_threshold': ?instance.tailPointThreshold,
};

HspSynctime _$HspSynctimeFromJson(Map<String, dynamic> json) => HspSynctime(
  currentTime: (json['current_time'] as num).toInt(),
  serverTime: (json['server_time'] as num).toInt(),
  filter: (json['filter'] as num).toDouble(),
);

Map<String, dynamic> _$HspSynctimeToJson(HspSynctime instance) =>
    <String, dynamic>{
      'current_time': instance.currentTime,
      'server_time': instance.serverTime,
      'filter': instance.filter,
    };

HspResume _$HspResumeFromJson(Map<String, dynamic> json) =>
    HspResume(pickUp: json['pick_up'] as bool);

Map<String, dynamic> _$HspResumeToJson(HspResume instance) => <String, dynamic>{
  'pick_up': instance.pickUp,
};

HspPlay _$HspPlayFromJson(Map<String, dynamic> json) => HspPlay(
  startTime: (json['start_time'] as num).toInt(),
  serverTime: (json['server_time'] as num).toInt(),
  playbackRate: (json['playback_rate'] as num).toDouble(),
  pauseOnStarving: json['pause_on_starving'] as bool,
  loop: json['loop'] as bool,
);

Map<String, dynamic> _$HspPlayToJson(HspPlay instance) => <String, dynamic>{
  'start_time': instance.startTime,
  'server_time': instance.serverTime,
  'playback_rate': instance.playbackRate,
  'pause_on_starving': instance.pauseOnStarving,
  'loop': instance.loop,
};

HdspXpt _$HdspXptFromJson(Map<String, dynamic> json) => HdspXpt(
  xp: (json['xp'] as num).toDouble(),
  t: (json['t'] as num).toInt(),
  stopOnTarget: json['stop_on_target'] as bool?,
  immediateRsp: json['immediate_rsp'] as bool?,
);

Map<String, dynamic> _$HdspXptToJson(HdspXpt instance) => <String, dynamic>{
  'xp': instance.xp,
  't': instance.t,
  'stop_on_target': ?instance.stopOnTarget,
  'immediate_rsp': ?instance.immediateRsp,
};

HandyStrokeSet _$HandyStrokeSetFromJson(Map<String, dynamic> json) =>
    HandyStrokeSet(
      min: (json['min'] as num).toDouble(),
      max: (json['max'] as num).toDouble(),
    );

Map<String, dynamic> _$HandyStrokeSetToJson(HandyStrokeSet instance) =>
    <String, dynamic>{'min': instance.min, 'max': instance.max};

HspThreshold _$HspThresholdFromJson(Map<String, dynamic> json) => HspThreshold(
  tailPointThreshold: (json['tail_point_threshold'] as num).toInt(),
);

Map<String, dynamic> _$HspThresholdToJson(HspThreshold instance) =>
    <String, dynamic>{'tail_point_threshold': instance.tailPointThreshold};

HspLoop _$HspLoopFromJson(Map<String, dynamic> json) =>
    HspLoop(loop: json['loop'] as bool);

Map<String, dynamic> _$HspLoopToJson(HspLoop instance) => <String, dynamic>{
  'loop': instance.loop,
};

HspPauseOnStarving _$HspPauseOnStarvingFromJson(Map<String, dynamic> json) =>
    HspPauseOnStarving(pauseOnStarving: json['pause_on_starving'] as bool);

Map<String, dynamic> _$HspPauseOnStarvingToJson(HspPauseOnStarving instance) =>
    <String, dynamic>{'pause_on_starving': instance.pauseOnStarving};
