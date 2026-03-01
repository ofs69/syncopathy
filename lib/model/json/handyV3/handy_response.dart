import 'package:json_annotation/json_annotation.dart';

part 'handy_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class HandyServertime {
  final int serverTime;

  HandyServertime({required this.serverTime});

  factory HandyServertime.fromJson(Map<String, dynamic> json) =>
      _$HandyServertimeFromJson(json);

  Map<String, dynamic> toJson() => _$HandyServertimeToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class HandyError {
  final bool connected;
  final String name;
  final String message;
  final int code;
  final Map<String, dynamic>? data;

  HandyError({
    required this.connected,
    required this.name,
    required this.message,
    required this.code,
    this.data,
  });

  factory HandyError.fromJson(Map<String, dynamic> json) =>
      _$HandyErrorFromJson(json);

  Map<String, dynamic> toJson() => _$HandyErrorToJson(this);
}

abstract class HandyResult {}

@JsonSerializable(
  genericArgumentFactories: true,
  fieldRename: FieldRename.snake,
)
class HandyResponse<T extends HandyResult> {
  final T? result;
  final HandyError? error;

  HandyResponse({required this.result, required this.error});

  factory HandyResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$HandyResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$HandyResponseToJson(this, toJsonT);

  bool get isError => error != null;
  bool get isResult => result != null;
  bool get isEmpty => error == null && result == null;
  factory HandyResponse.empty() => HandyResponse(result: null, error: null);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class HandyConnected extends HandyResult {
  final bool connected;

  HandyConnected({required this.connected});

  factory HandyConnected.fromJson(Map<String, dynamic> json) =>
      _$HandyConnectedFromJson(json);

  Map<String, dynamic> toJson() => _$HandyConnectedToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class HandyClock extends HandyResult {
  final int time;
  final int clockOffset;
  final int rtd;

  HandyClock({
    required this.time,
    required this.clockOffset,
    required this.rtd,
  });

  factory HandyClock.fromJson(Map<String, dynamic> json) =>
      _$HandyClockFromJson(json);

  Map<String, dynamic> toJson() => _$HandyClockToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class HandyInfo extends HandyResult {
  final int fwStatus;
  final String fwVersion;
  final String fwFeatureFlags;
  final int hwModelNo;
  final String hwModelName;
  final int hwModelVariant;
  final String sessionId;

  HandyInfo({
    required this.fwStatus,
    required this.fwVersion,
    required this.fwFeatureFlags,
    required this.hwModelNo,
    required this.hwModelName,
    required this.hwModelVariant,
    required this.sessionId,
  });

  factory HandyInfo.fromJson(Map<String, dynamic> json) =>
      _$HandyInfoFromJson(json);

  Map<String, dynamic> toJson() => _$HandyInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class HandyHspState extends HandyResult {
  final int playState;
  final bool pauseOnStarving;
  final int points;
  final int maxPoints;
  final int currentPoint;
  final int currentTime;
  final bool loop;
  final double playbackRate;
  final int firstPointTime;
  final int lastPointTime;
  final int streamId;
  final int tailPointStreamIndex;
  final int tailPointStreamIndexThreshold;

  HandyHspState({
    required this.playState,
    required this.pauseOnStarving,
    required this.points,
    required this.maxPoints,
    required this.currentPoint,
    required this.currentTime,
    required this.loop,
    required this.playbackRate,
    required this.firstPointTime,
    required this.lastPointTime,
    required this.streamId,
    required this.tailPointStreamIndex,
    required this.tailPointStreamIndexThreshold,
  });

  factory HandyHspState.fromJson(Map<String, dynamic> json) =>
      _$HandyHspStateFromJson(json);

  Map<String, dynamic> toJson() => _$HandyHspStateToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class HandyStrokeSettings extends HandyResult {
  final double min;
  final double max;
  final double minAbsolute;
  final double maxAbsolute;

  HandyStrokeSettings({
    required this.min,
    required this.max,
    required this.minAbsolute,
    required this.maxAbsolute,
  });

  factory HandyStrokeSettings.fromJson(Map<String, dynamic> json) =>
      _$HandyStrokeSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$HandyStrokeSettingsToJson(this);
}
