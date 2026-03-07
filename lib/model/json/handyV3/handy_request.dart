import 'package:json_annotation/json_annotation.dart';

part 'handy_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class HspSetup {
  @JsonKey(includeIfNull: false)
  final int? streamId;

  HspSetup({required this.streamId});

  factory HspSetup.fromJson(Map<String, dynamic> json) =>
      _$HspSetupFromJson(json);
  Map<String, dynamic> toJson() => _$HspSetupToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class HspAddPoint {
  final int x;
  final int t;
  HspAddPoint({required this.x, required this.t});

  factory HspAddPoint.fromJson(Map<String, dynamic> json) =>
      _$HspAddPointFromJson(json);
  Map<String, dynamic> toJson() => _$HspAddPointToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class HspAdd {
  final List<HspAddPoint> points;
  final bool flush;
  @JsonKey(includeIfNull: false)
  final int? tailPointStreamIndex;
  @JsonKey(includeIfNull: false)
  final int? tailPointThreshold;

  HspAdd({
    required this.points,
    required this.flush,
    this.tailPointStreamIndex,
    this.tailPointThreshold,
  });

  factory HspAdd.fromJson(Map<String, dynamic> json) => _$HspAddFromJson(json);
  Map<String, dynamic> toJson() => _$HspAddToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class HspSynctime {
  final int currentTime;
  final int serverTime;
  final double filter;

  HspSynctime({
    required this.currentTime,
    required this.serverTime,
    required this.filter,
  });

  factory HspSynctime.fromJson(Map<String, dynamic> json) =>
      _$HspSynctimeFromJson(json);
  Map<String, dynamic> toJson() => _$HspSynctimeToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class HspResume {
  final bool pickUp;

  HspResume({required this.pickUp});

  factory HspResume.fromJson(Map<String, dynamic> json) =>
      _$HspResumeFromJson(json);
  Map<String, dynamic> toJson() => _$HspResumeToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class HspPlay {
  final int startTime;
  final int serverTime;
  final double playbackRate;
  final bool pauseOnStarving;
  final bool loop;

  // The bundled add command is ommited for now
  // {
  //   "add": {
  //     "points": [
  //       {
  //         "t": 100,
  //         "x": 100
  //       }
  //     ],
  //     "flush": true,
  //     "tail_point_stream_index": 100,
  //     "tail_point_threshold": 100
  //   }
  // }

  HspPlay({
    required this.startTime,
    required this.serverTime,
    required this.playbackRate,
    required this.pauseOnStarving,
    required this.loop,
  });

  factory HspPlay.fromJson(Map<String, dynamic> json) =>
      _$HspPlayFromJson(json);
  Map<String, dynamic> toJson() => _$HspPlayToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class HdspXpt {
  final double xp;
  final int t;
  @JsonKey(includeIfNull: false)
  final bool? stopOnTarget;
  @JsonKey(includeIfNull: false)
  final bool? immediateRsp;

  HdspXpt({
    required this.xp,
    required this.t,
    required this.stopOnTarget,
    required this.immediateRsp,
  });
  factory HdspXpt.fromJson(Map<String, dynamic> json) =>
      _$HdspXptFromJson(json);
  Map<String, dynamic> toJson() => _$HdspXptToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class HandyStrokeSet {
  final double min;
  final double max;
  HandyStrokeSet({required this.min, required this.max});

  factory HandyStrokeSet.fromJson(Map<String, dynamic> json) =>
      _$HandyStrokeSetFromJson(json);
  Map<String, dynamic> toJson() => _$HandyStrokeSetToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class HspThreshold {
  final int tailPointThreshold;
  HspThreshold({required this.tailPointThreshold});

  factory HspThreshold.fromJson(Map<String, dynamic> json) =>
      _$HspThresholdFromJson(json);
  Map<String, dynamic> toJson() => _$HspThresholdToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class HspLoop {
  final bool loop;

  HspLoop({required this.loop});

  factory HspLoop.fromJson(Map<String, dynamic> json) =>
      _$HspLoopFromJson(json);
  Map<String, dynamic> toJson() => _$HspLoopToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class HspPauseOnStarving {
  final bool pauseOnStarving;

  HspPauseOnStarving({required this.pauseOnStarving});

  factory HspPauseOnStarving.fromJson(Map<String, dynamic> json) =>
      _$HspPauseOnStarvingFromJson(json);
  Map<String, dynamic> toJson() => _$HspPauseOnStarvingToJson(this);
}
