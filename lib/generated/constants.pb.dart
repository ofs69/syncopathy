// This is a generated file - do not edit.
//
// Generated from constants.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'constants.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'constants.pbenum.dart';

class HampState extends $pb.GeneratedMessage {
  factory HampState({
    HampPlayState? playState,
    $core.double? velocity,
    $core.bool? direction,
    $core.double? min,
    $core.double? max,
  }) {
    final result = create();
    if (playState != null) result.playState = playState;
    if (velocity != null) result.velocity = velocity;
    if (direction != null) result.direction = direction;
    if (min != null) result.min = min;
    if (max != null) result.max = max;
    return result;
  }

  HampState._();

  factory HampState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HampState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HampState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aE<HampPlayState>(1, _omitFieldNames ? '' : 'playState',
        enumValues: HampPlayState.values)
    ..aD(2, _omitFieldNames ? '' : 'velocity', fieldType: $pb.PbFieldType.OF)
    ..aOB(3, _omitFieldNames ? '' : 'direction')
    ..aD(4, _omitFieldNames ? '' : 'min', fieldType: $pb.PbFieldType.OF)
    ..aD(5, _omitFieldNames ? '' : 'max', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HampState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HampState copyWith(void Function(HampState) updates) =>
      super.copyWith((message) => updates(message as HampState)) as HampState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HampState create() => HampState._();
  @$core.override
  HampState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HampState getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HampState>(create);
  static HampState? _defaultInstance;

  @$pb.TagNumber(1)
  HampPlayState get playState => $_getN(0);
  @$pb.TagNumber(1)
  set playState(HampPlayState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlayState() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlayState() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get velocity => $_getN(1);
  @$pb.TagNumber(2)
  set velocity($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVelocity() => $_has(1);
  @$pb.TagNumber(2)
  void clearVelocity() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get direction => $_getBF(2);
  @$pb.TagNumber(3)
  set direction($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDirection() => $_has(2);
  @$pb.TagNumber(3)
  void clearDirection() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get min => $_getN(3);
  @$pb.TagNumber(4)
  set min($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMin() => $_has(3);
  @$pb.TagNumber(4)
  void clearMin() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get max => $_getN(4);
  @$pb.TagNumber(5)
  set max($core.double value) => $_setFloat(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMax() => $_has(4);
  @$pb.TagNumber(5)
  void clearMax() => $_clearField(5);
}

class HrppPattern extends $pb.GeneratedMessage {
  factory HrppPattern({
    $core.int? id,
    $core.String? name,
    $core.int? version,
    $core.bool? customPattern,
    $core.int? slot,
    HrppPatternType? type,
    $core.int? pauseRandomMin,
    $core.int? pauseRandomMax,
    HrppPatternAccess? access,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (version != null) result.version = version;
    if (customPattern != null) result.customPattern = customPattern;
    if (slot != null) result.slot = slot;
    if (type != null) result.type = type;
    if (pauseRandomMin != null) result.pauseRandomMin = pauseRandomMin;
    if (pauseRandomMax != null) result.pauseRandomMax = pauseRandomMax;
    if (access != null) result.access = access;
    return result;
  }

  HrppPattern._();

  factory HrppPattern.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HrppPattern.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HrppPattern',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'id', fieldType: $pb.PbFieldType.OU3)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aI(3, _omitFieldNames ? '' : 'version', fieldType: $pb.PbFieldType.OU3)
    ..aOB(4, _omitFieldNames ? '' : 'customPattern')
    ..aI(5, _omitFieldNames ? '' : 'slot', fieldType: $pb.PbFieldType.OU3)
    ..aE<HrppPatternType>(6, _omitFieldNames ? '' : 'type',
        enumValues: HrppPatternType.values)
    ..aI(7, _omitFieldNames ? '' : 'pauseRandomMin',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(8, _omitFieldNames ? '' : 'pauseRandomMax',
        fieldType: $pb.PbFieldType.OU3)
    ..aE<HrppPatternAccess>(9, _omitFieldNames ? '' : 'access',
        enumValues: HrppPatternAccess.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HrppPattern clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HrppPattern copyWith(void Function(HrppPattern) updates) =>
      super.copyWith((message) => updates(message as HrppPattern))
          as HrppPattern;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HrppPattern create() => HrppPattern._();
  @$core.override
  HrppPattern createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HrppPattern getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HrppPattern>(create);
  static HrppPattern? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get version => $_getIZ(2);
  @$pb.TagNumber(3)
  set version($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get customPattern => $_getBF(3);
  @$pb.TagNumber(4)
  set customPattern($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCustomPattern() => $_has(3);
  @$pb.TagNumber(4)
  void clearCustomPattern() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get slot => $_getIZ(4);
  @$pb.TagNumber(5)
  set slot($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSlot() => $_has(4);
  @$pb.TagNumber(5)
  void clearSlot() => $_clearField(5);

  @$pb.TagNumber(6)
  HrppPatternType get type => $_getN(5);
  @$pb.TagNumber(6)
  set type(HrppPatternType value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasType() => $_has(5);
  @$pb.TagNumber(6)
  void clearType() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get pauseRandomMin => $_getIZ(6);
  @$pb.TagNumber(7)
  set pauseRandomMin($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPauseRandomMin() => $_has(6);
  @$pb.TagNumber(7)
  void clearPauseRandomMin() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get pauseRandomMax => $_getIZ(7);
  @$pb.TagNumber(8)
  set pauseRandomMax($core.int value) => $_setUnsignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPauseRandomMax() => $_has(7);
  @$pb.TagNumber(8)
  void clearPauseRandomMax() => $_clearField(8);

  @$pb.TagNumber(9)
  HrppPatternAccess get access => $_getN(8);
  @$pb.TagNumber(9)
  set access(HrppPatternAccess value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasAccess() => $_has(8);
  @$pb.TagNumber(9)
  void clearAccess() => $_clearField(9);
}

class HrppState extends $pb.GeneratedMessage {
  factory HrppState({
    $core.int? currentPatternNr,
    HrppPattern? currentPattern,
    $core.int? nrOfPatterns,
    $core.double? amplitude,
    $core.double? playbackRate,
    HrppPlayState? playState,
  }) {
    final result = create();
    if (currentPatternNr != null) result.currentPatternNr = currentPatternNr;
    if (currentPattern != null) result.currentPattern = currentPattern;
    if (nrOfPatterns != null) result.nrOfPatterns = nrOfPatterns;
    if (amplitude != null) result.amplitude = amplitude;
    if (playbackRate != null) result.playbackRate = playbackRate;
    if (playState != null) result.playState = playState;
    return result;
  }

  HrppState._();

  factory HrppState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HrppState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HrppState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'currentPatternNr',
        fieldType: $pb.PbFieldType.OU3)
    ..aOM<HrppPattern>(2, _omitFieldNames ? '' : 'currentPattern',
        subBuilder: HrppPattern.create)
    ..aI(3, _omitFieldNames ? '' : 'nrOfPatterns',
        fieldType: $pb.PbFieldType.OU3)
    ..aD(5, _omitFieldNames ? '' : 'amplitude', fieldType: $pb.PbFieldType.OF)
    ..aD(7, _omitFieldNames ? '' : 'playbackRate',
        fieldType: $pb.PbFieldType.OF)
    ..aE<HrppPlayState>(8, _omitFieldNames ? '' : 'playState',
        enumValues: HrppPlayState.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HrppState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HrppState copyWith(void Function(HrppState) updates) =>
      super.copyWith((message) => updates(message as HrppState)) as HrppState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HrppState create() => HrppState._();
  @$core.override
  HrppState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HrppState getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HrppState>(create);
  static HrppState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get currentPatternNr => $_getIZ(0);
  @$pb.TagNumber(1)
  set currentPatternNr($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCurrentPatternNr() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrentPatternNr() => $_clearField(1);

  @$pb.TagNumber(2)
  HrppPattern get currentPattern => $_getN(1);
  @$pb.TagNumber(2)
  set currentPattern(HrppPattern value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCurrentPattern() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrentPattern() => $_clearField(2);
  @$pb.TagNumber(2)
  HrppPattern ensureCurrentPattern() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get nrOfPatterns => $_getIZ(2);
  @$pb.TagNumber(3)
  set nrOfPatterns($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNrOfPatterns() => $_has(2);
  @$pb.TagNumber(3)
  void clearNrOfPatterns() => $_clearField(3);

  /// bool enabled = 4; //DEPRECATED in FW4.2 - Use play_state instead
  @$pb.TagNumber(5)
  $core.double get amplitude => $_getN(3);
  @$pb.TagNumber(5)
  set amplitude($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(5)
  $core.bool hasAmplitude() => $_has(3);
  @$pb.TagNumber(5)
  void clearAmplitude() => $_clearField(5);

  /// float playback_speed = 6; //DEPRECATED in 4.2 use playback_rate
  @$pb.TagNumber(7)
  $core.double get playbackRate => $_getN(4);
  @$pb.TagNumber(7)
  set playbackRate($core.double value) => $_setFloat(4, value);
  @$pb.TagNumber(7)
  $core.bool hasPlaybackRate() => $_has(4);
  @$pb.TagNumber(7)
  void clearPlaybackRate() => $_clearField(7);

  @$pb.TagNumber(8)
  HrppPlayState get playState => $_getN(5);
  @$pb.TagNumber(8)
  set playState(HrppPlayState value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPlayState() => $_has(5);
  @$pb.TagNumber(8)
  void clearPlayState() => $_clearField(8);
}

///
/// HSP state snapshot semantics (read carefully — these fields are NOT all sampled at the
/// same instant, and some are internal bookkeeping rather than exact playback facts):
/// current_time   — the live playback clock at the moment this message was generated.
/// It advances continuously while playing.
/// current_point  — an internal index into the point buffer that tracks roughly where
/// playback is. It is updated as playback progresses, but it does NOT
/// move in lockstep with current_time and is NOT guaranteed to be
/// monotonic: it can jump forward when catching up, and step backward
/// when playback is re-synced to the server clock or resumed. Treat it
/// as an approximate position marker, not as an exact or ever-increasing
/// count of points reached.
/// Consequence: current_time and current_point are sampled/updated at different moments and
/// by different mechanisms, so they will frequently disagree. Do NOT assume current_point
/// corresponds to current_time. If you need the point the clock is currently between,
/// compute it yourself from current_time and the point list; do not infer it from
/// current_point.
/// current_point also reflects internal scheduling, not necessarily the device's physical
/// position — the actuator can lag (gentle start, speed limits, post-resync catch-up), so
/// the real position may trail what current_point suggests.
/// While paused, current_time may continue to drift rather than freeze at the pause instant;
/// treat current_time as meaningful only while play_state indicates active playback.
/// first_point_time / last_point_time / points describe the buffer contents, not the live
/// playback position, and update only when points are added or cleared.
/// Finally, this snapshot is assembled field-by-field while playback continues in the
/// background, so individual fields may be from slightly different instants. Use it as an
/// approximate status indicator, not as a source for exact-frame synchronization.
class HspState extends $pb.GeneratedMessage {
  factory HspState({
    HspPlayState? playState,
    $core.int? points,
    $core.int? maxPoints,
    $core.int? currentPoint,
    $core.int? currentTime,
    $core.bool? loop,
    $core.double? playbackRate,
    $core.int? firstPointTime,
    $core.int? lastPointTime,
    $core.int? streamId,
    $core.int? tailPointStreamIndex,
    $core.int? tailPointStreamIndexThreshold,
    $core.bool? pauseOnStarving,
    $core.bool? jitterFilter,
    $core.double? jitterFilterThresholdMm,
    $core.bool? scriptSpeed,
  }) {
    final result = create();
    if (playState != null) result.playState = playState;
    if (points != null) result.points = points;
    if (maxPoints != null) result.maxPoints = maxPoints;
    if (currentPoint != null) result.currentPoint = currentPoint;
    if (currentTime != null) result.currentTime = currentTime;
    if (loop != null) result.loop = loop;
    if (playbackRate != null) result.playbackRate = playbackRate;
    if (firstPointTime != null) result.firstPointTime = firstPointTime;
    if (lastPointTime != null) result.lastPointTime = lastPointTime;
    if (streamId != null) result.streamId = streamId;
    if (tailPointStreamIndex != null)
      result.tailPointStreamIndex = tailPointStreamIndex;
    if (tailPointStreamIndexThreshold != null)
      result.tailPointStreamIndexThreshold = tailPointStreamIndexThreshold;
    if (pauseOnStarving != null) result.pauseOnStarving = pauseOnStarving;
    if (jitterFilter != null) result.jitterFilter = jitterFilter;
    if (jitterFilterThresholdMm != null)
      result.jitterFilterThresholdMm = jitterFilterThresholdMm;
    if (scriptSpeed != null) result.scriptSpeed = scriptSpeed;
    return result;
  }

  HspState._();

  factory HspState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HspState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HspState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aE<HspPlayState>(1, _omitFieldNames ? '' : 'playState',
        enumValues: HspPlayState.values)
    ..aI(2, _omitFieldNames ? '' : 'points', fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'maxPoints', fieldType: $pb.PbFieldType.OU3)
    ..aI(4, _omitFieldNames ? '' : 'currentPoint')
    ..aI(5, _omitFieldNames ? '' : 'currentTime')
    ..aOB(6, _omitFieldNames ? '' : 'loop')
    ..aD(7, _omitFieldNames ? '' : 'playbackRate',
        fieldType: $pb.PbFieldType.OF)
    ..aI(8, _omitFieldNames ? '' : 'firstPointTime',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(9, _omitFieldNames ? '' : 'lastPointTime',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(10, _omitFieldNames ? '' : 'streamId', fieldType: $pb.PbFieldType.OU3)
    ..aI(11, _omitFieldNames ? '' : 'tailPointStreamIndex')
    ..aI(12, _omitFieldNames ? '' : 'tailPointStreamIndexThreshold',
        fieldType: $pb.PbFieldType.OU3)
    ..aOB(13, _omitFieldNames ? '' : 'pauseOnStarving')
    ..aOB(14, _omitFieldNames ? '' : 'jitterFilter')
    ..aD(15, _omitFieldNames ? '' : 'jitterFilterThresholdMm',
        fieldType: $pb.PbFieldType.OF)
    ..aOB(16, _omitFieldNames ? '' : 'scriptSpeed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HspState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HspState copyWith(void Function(HspState) updates) =>
      super.copyWith((message) => updates(message as HspState)) as HspState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HspState create() => HspState._();
  @$core.override
  HspState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HspState getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HspState>(create);
  static HspState? _defaultInstance;

  @$pb.TagNumber(1)
  HspPlayState get playState => $_getN(0);
  @$pb.TagNumber(1)
  set playState(HspPlayState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlayState() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlayState() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get points => $_getIZ(1);
  @$pb.TagNumber(2)
  set points($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPoints() => $_has(1);
  @$pb.TagNumber(2)
  void clearPoints() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get maxPoints => $_getIZ(2);
  @$pb.TagNumber(3)
  set maxPoints($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMaxPoints() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxPoints() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get currentPoint => $_getIZ(3);
  @$pb.TagNumber(4)
  set currentPoint($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCurrentPoint() => $_has(3);
  @$pb.TagNumber(4)
  void clearCurrentPoint() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get currentTime => $_getIZ(4);
  @$pb.TagNumber(5)
  set currentTime($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCurrentTime() => $_has(4);
  @$pb.TagNumber(5)
  void clearCurrentTime() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get loop => $_getBF(5);
  @$pb.TagNumber(6)
  set loop($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLoop() => $_has(5);
  @$pb.TagNumber(6)
  void clearLoop() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get playbackRate => $_getN(6);
  @$pb.TagNumber(7)
  set playbackRate($core.double value) => $_setFloat(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPlaybackRate() => $_has(6);
  @$pb.TagNumber(7)
  void clearPlaybackRate() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get firstPointTime => $_getIZ(7);
  @$pb.TagNumber(8)
  set firstPointTime($core.int value) => $_setUnsignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFirstPointTime() => $_has(7);
  @$pb.TagNumber(8)
  void clearFirstPointTime() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get lastPointTime => $_getIZ(8);
  @$pb.TagNumber(9)
  set lastPointTime($core.int value) => $_setUnsignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLastPointTime() => $_has(8);
  @$pb.TagNumber(9)
  void clearLastPointTime() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get streamId => $_getIZ(9);
  @$pb.TagNumber(10)
  set streamId($core.int value) => $_setUnsignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasStreamId() => $_has(9);
  @$pb.TagNumber(10)
  void clearStreamId() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get tailPointStreamIndex => $_getIZ(10);
  @$pb.TagNumber(11)
  set tailPointStreamIndex($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasTailPointStreamIndex() => $_has(10);
  @$pb.TagNumber(11)
  void clearTailPointStreamIndex() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get tailPointStreamIndexThreshold => $_getIZ(11);
  @$pb.TagNumber(12)
  set tailPointStreamIndexThreshold($core.int value) =>
      $_setUnsignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasTailPointStreamIndexThreshold() => $_has(11);
  @$pb.TagNumber(12)
  void clearTailPointStreamIndexThreshold() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.bool get pauseOnStarving => $_getBF(12);
  @$pb.TagNumber(13)
  set pauseOnStarving($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasPauseOnStarving() => $_has(12);
  @$pb.TagNumber(13)
  void clearPauseOnStarving() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.bool get jitterFilter => $_getBF(13);
  @$pb.TagNumber(14)
  set jitterFilter($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasJitterFilter() => $_has(13);
  @$pb.TagNumber(14)
  void clearJitterFilter() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.double get jitterFilterThresholdMm => $_getN(14);
  @$pb.TagNumber(15)
  set jitterFilterThresholdMm($core.double value) => $_setFloat(14, value);
  @$pb.TagNumber(15)
  $core.bool hasJitterFilterThresholdMm() => $_has(14);
  @$pb.TagNumber(15)
  void clearJitterFilterThresholdMm() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.bool get scriptSpeed => $_getBF(15);
  @$pb.TagNumber(16)
  set scriptSpeed($core.bool value) => $_setBool(15, value);
  @$pb.TagNumber(16)
  $core.bool hasScriptSpeed() => $_has(15);
  @$pb.TagNumber(16)
  void clearScriptSpeed() => $_clearField(16);
}

class HvpState extends $pb.GeneratedMessage {
  factory HvpState({
    $core.bool? enabled,
    $core.double? amplitude,
    $core.int? frequency,
    $core.double? position,
  }) {
    final result = create();
    if (enabled != null) result.enabled = enabled;
    if (amplitude != null) result.amplitude = amplitude;
    if (frequency != null) result.frequency = frequency;
    if (position != null) result.position = position;
    return result;
  }

  HvpState._();

  factory HvpState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HvpState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HvpState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'enabled')
    ..aD(2, _omitFieldNames ? '' : 'amplitude', fieldType: $pb.PbFieldType.OF)
    ..aI(3, _omitFieldNames ? '' : 'frequency', fieldType: $pb.PbFieldType.OU3)
    ..aD(4, _omitFieldNames ? '' : 'position', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HvpState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HvpState copyWith(void Function(HvpState) updates) =>
      super.copyWith((message) => updates(message as HvpState)) as HvpState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HvpState create() => HvpState._();
  @$core.override
  HvpState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HvpState getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HvpState>(create);
  static HvpState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enabled => $_getBF(0);
  @$pb.TagNumber(1)
  set enabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get amplitude => $_getN(1);
  @$pb.TagNumber(2)
  set amplitude($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAmplitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmplitude() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get frequency => $_getIZ(2);
  @$pb.TagNumber(3)
  set frequency($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFrequency() => $_has(2);
  @$pb.TagNumber(3)
  void clearFrequency() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get position => $_getN(3);
  @$pb.TagNumber(4)
  set position($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPosition() => $_has(3);
  @$pb.TagNumber(4)
  void clearPosition() => $_clearField(4);
}

class Point extends $pb.GeneratedMessage {
  factory Point({
    $core.int? t,
    $core.int? x,
  }) {
    final result = create();
    if (t != null) result.t = t;
    if (x != null) result.x = x;
    return result;
  }

  Point._();

  factory Point.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Point.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Point',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 't', fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'x', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Point clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Point copyWith(void Function(Point) updates) =>
      super.copyWith((message) => updates(message as Point)) as Point;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Point create() => Point._();
  @$core.override
  Point createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Point getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Point>(create);
  static Point? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get t => $_getIZ(0);
  @$pb.TagNumber(1)
  set t($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasT() => $_has(0);
  @$pb.TagNumber(1)
  void clearT() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get x => $_getIZ(1);
  @$pb.TagNumber(2)
  set x($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasX() => $_has(1);
  @$pb.TagNumber(2)
  void clearX() => $_clearField(2);
}

///
/// Windowed speed/tuning telemetry, split per drive direction (the two
/// directions have separate feedforward/tuning). Averages cover regulator
/// ticks (~1 kHz) while DRIVING; samples == 0 = the slide did not drive that
/// way during the window. Shared by ResponseSpeedStatsGet and
/// NotificationSpeedStats. Added in FW4.4.
class SpeedStatsBucket extends $pb.GeneratedMessage {
  factory SpeedStatsBucket({
    $core.int? samples,
    $core.double? avgSpeed,
    $core.double? avgTargetSpeed,
    $core.double? avgMotor,
    $core.double? avgTrim,
    $core.double? avgAbsSpeedError,
  }) {
    final result = create();
    if (samples != null) result.samples = samples;
    if (avgSpeed != null) result.avgSpeed = avgSpeed;
    if (avgTargetSpeed != null) result.avgTargetSpeed = avgTargetSpeed;
    if (avgMotor != null) result.avgMotor = avgMotor;
    if (avgTrim != null) result.avgTrim = avgTrim;
    if (avgAbsSpeedError != null) result.avgAbsSpeedError = avgAbsSpeedError;
    return result;
  }

  SpeedStatsBucket._();

  factory SpeedStatsBucket.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SpeedStatsBucket.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SpeedStatsBucket',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'samples', fieldType: $pb.PbFieldType.OU3)
    ..aD(2, _omitFieldNames ? '' : 'avgSpeed', fieldType: $pb.PbFieldType.OF)
    ..aD(3, _omitFieldNames ? '' : 'avgTargetSpeed',
        fieldType: $pb.PbFieldType.OF)
    ..aD(4, _omitFieldNames ? '' : 'avgMotor', fieldType: $pb.PbFieldType.OF)
    ..aD(5, _omitFieldNames ? '' : 'avgTrim', fieldType: $pb.PbFieldType.OF)
    ..aD(6, _omitFieldNames ? '' : 'avgAbsSpeedError',
        fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SpeedStatsBucket clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SpeedStatsBucket copyWith(void Function(SpeedStatsBucket) updates) =>
      super.copyWith((message) => updates(message as SpeedStatsBucket))
          as SpeedStatsBucket;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SpeedStatsBucket create() => SpeedStatsBucket._();
  @$core.override
  SpeedStatsBucket createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SpeedStatsBucket getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SpeedStatsBucket>(create);
  static SpeedStatsBucket? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get samples => $_getIZ(0);
  @$pb.TagNumber(1)
  set samples($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSamples() => $_has(0);
  @$pb.TagNumber(1)
  void clearSamples() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get avgSpeed => $_getN(1);
  @$pb.TagNumber(2)
  set avgSpeed($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAvgSpeed() => $_has(1);
  @$pb.TagNumber(2)
  void clearAvgSpeed() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get avgTargetSpeed => $_getN(2);
  @$pb.TagNumber(3)
  set avgTargetSpeed($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAvgTargetSpeed() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvgTargetSpeed() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get avgMotor => $_getN(3);
  @$pb.TagNumber(4)
  set avgMotor($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAvgMotor() => $_has(3);
  @$pb.TagNumber(4)
  void clearAvgMotor() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get avgTrim => $_getN(4);
  @$pb.TagNumber(5)
  set avgTrim($core.double value) => $_setFloat(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAvgTrim() => $_has(4);
  @$pb.TagNumber(5)
  void clearAvgTrim() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get avgAbsSpeedError => $_getN(5);
  @$pb.TagNumber(6)
  set avgAbsSpeedError($core.double value) => $_setFloat(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAvgAbsSpeedError() => $_has(5);
  @$pb.TagNumber(6)
  void clearAvgAbsSpeedError() => $_clearField(6);
}

class SpeedStats extends $pb.GeneratedMessage {
  factory SpeedStats({
    $core.int? seq,
    $core.int? windowMs,
    $fixnum.Int64? endTimeUs,
    SpeedStatsBucket? backward,
    SpeedStatsBucket? forward,
    SpeedStatsBucket? combined,
  }) {
    final result = create();
    if (seq != null) result.seq = seq;
    if (windowMs != null) result.windowMs = windowMs;
    if (endTimeUs != null) result.endTimeUs = endTimeUs;
    if (backward != null) result.backward = backward;
    if (forward != null) result.forward = forward;
    if (combined != null) result.combined = combined;
    return result;
  }

  SpeedStats._();

  factory SpeedStats.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SpeedStats.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SpeedStats',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'seq', fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'windowMs', fieldType: $pb.PbFieldType.OU3)
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'endTimeUs', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<SpeedStatsBucket>(4, _omitFieldNames ? '' : 'backward',
        subBuilder: SpeedStatsBucket.create)
    ..aOM<SpeedStatsBucket>(5, _omitFieldNames ? '' : 'forward',
        subBuilder: SpeedStatsBucket.create)
    ..aOM<SpeedStatsBucket>(6, _omitFieldNames ? '' : 'combined',
        subBuilder: SpeedStatsBucket.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SpeedStats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SpeedStats copyWith(void Function(SpeedStats) updates) =>
      super.copyWith((message) => updates(message as SpeedStats)) as SpeedStats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SpeedStats create() => SpeedStats._();
  @$core.override
  SpeedStats createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SpeedStats getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SpeedStats>(create);
  static SpeedStats? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get seq => $_getIZ(0);
  @$pb.TagNumber(1)
  set seq($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeq() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeq() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get windowMs => $_getIZ(1);
  @$pb.TagNumber(2)
  set windowMs($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWindowMs() => $_has(1);
  @$pb.TagNumber(2)
  void clearWindowMs() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get endTimeUs => $_getI64(2);
  @$pb.TagNumber(3)
  set endTimeUs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEndTimeUs() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndTimeUs() => $_clearField(3);

  @$pb.TagNumber(4)
  SpeedStatsBucket get backward => $_getN(3);
  @$pb.TagNumber(4)
  set backward(SpeedStatsBucket value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasBackward() => $_has(3);
  @$pb.TagNumber(4)
  void clearBackward() => $_clearField(4);
  @$pb.TagNumber(4)
  SpeedStatsBucket ensureBackward() => $_ensure(3);

  @$pb.TagNumber(5)
  SpeedStatsBucket get forward => $_getN(4);
  @$pb.TagNumber(5)
  set forward(SpeedStatsBucket value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasForward() => $_has(4);
  @$pb.TagNumber(5)
  void clearForward() => $_clearField(5);
  @$pb.TagNumber(5)
  SpeedStatsBucket ensureForward() => $_ensure(4);

  @$pb.TagNumber(6)
  SpeedStatsBucket get combined => $_getN(5);
  @$pb.TagNumber(6)
  set combined(SpeedStatsBucket value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCombined() => $_has(5);
  @$pb.TagNumber(6)
  void clearCombined() => $_clearField(6);
  @$pb.TagNumber(6)
  SpeedStatsBucket ensureCombined() => $_ensure(5);
}

///
/// Can be extended with more info from wifi_ap_record_t if need:
/// typedef struct {
/// uint8_t bssid[6];                     //< MAC address of AP
/// uint8_t ssid[33];                     //< SSID of AP
/// uint8_t primary;                      //< channel of AP
/// wifi_second_chan_t second;            //< secondary channel of AP
/// int8_t  rssi;                         //< signal strength of AP
/// wifi_auth_mode_t authmode;            //< authmode of AP
/// wifi_cipher_type_t pairwise_cipher;   //< pairwise cipher of AP
/// wifi_cipher_type_t group_cipher;      //< group cipher of AP
/// wifi_ant_t ant;                       //< antenna used to receive beacon from AP
/// uint32_t phy_11b:1;                   //< bit: 0 flag to identify if 11b mode is enabled or not
/// uint32_t phy_11g:1;                   //< bit: 1 flag to identify if 11g mode is enabled or not
/// uint32_t phy_11n:1;                   //< bit: 2 flag to identify if 11n mode is enabled or not
/// uint32_t phy_lr:1;                    //< bit: 3 flag to identify if low rate is enabled or not
/// uint32_t phy_11ax:1;                  //< bit: 4 flag to identify if 11ax mode is enabled or not
/// uint32_t wps:1;                       //< bit: 5 flag to identify if WPS is supported or not
/// uint32_t ftm_responder:1;             //< bit: 6 flag to identify if FTM is supported in responder mode
/// uint32_t ftm_initiator:1;             //< bit: 7 flag to identify if FTM is supported in initiator mode
/// uint32_t reserved:24;                 //< bit: 8..31 reserved
/// wifi_country_t country;               //< country information of AP
/// wifi_he_ap_info_t he_ap;              //< HE AP info
/// } wifi_ap_record_t;
class ApInfo extends $pb.GeneratedMessage {
  factory ApInfo({
    $core.String? ssid,
    $core.String? bssid,
    $core.int? channel,
    AuthModes? authmode,
    $core.int? rssi,
    $core.String? ip,
  }) {
    final result = create();
    if (ssid != null) result.ssid = ssid;
    if (bssid != null) result.bssid = bssid;
    if (channel != null) result.channel = channel;
    if (authmode != null) result.authmode = authmode;
    if (rssi != null) result.rssi = rssi;
    if (ip != null) result.ip = ip;
    return result;
  }

  ApInfo._();

  factory ApInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ssid')
    ..aOS(2, _omitFieldNames ? '' : 'bssid')
    ..aI(3, _omitFieldNames ? '' : 'channel', fieldType: $pb.PbFieldType.OU3)
    ..aE<AuthModes>(4, _omitFieldNames ? '' : 'authmode',
        enumValues: AuthModes.values)
    ..aI(5, _omitFieldNames ? '' : 'rssi')
    ..aOS(6, _omitFieldNames ? '' : 'ip')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApInfo copyWith(void Function(ApInfo) updates) =>
      super.copyWith((message) => updates(message as ApInfo)) as ApInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApInfo create() => ApInfo._();
  @$core.override
  ApInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApInfo>(create);
  static ApInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ssid => $_getSZ(0);
  @$pb.TagNumber(1)
  set ssid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSsid() => $_has(0);
  @$pb.TagNumber(1)
  void clearSsid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get bssid => $_getSZ(1);
  @$pb.TagNumber(2)
  set bssid($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBssid() => $_has(1);
  @$pb.TagNumber(2)
  void clearBssid() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get channel => $_getIZ(2);
  @$pb.TagNumber(3)
  set channel($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChannel() => $_has(2);
  @$pb.TagNumber(3)
  void clearChannel() => $_clearField(3);

  @$pb.TagNumber(4)
  AuthModes get authmode => $_getN(3);
  @$pb.TagNumber(4)
  set authmode(AuthModes value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAuthmode() => $_has(3);
  @$pb.TagNumber(4)
  void clearAuthmode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get rssi => $_getIZ(4);
  @$pb.TagNumber(5)
  set rssi($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRssi() => $_has(4);
  @$pb.TagNumber(5)
  void clearRssi() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get ip => $_getSZ(5);
  @$pb.TagNumber(6)
  set ip($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIp() => $_has(5);
  @$pb.TagNumber(6)
  void clearIp() => $_clearField(6);
}

class BatteryState extends $pb.GeneratedMessage {
  factory BatteryState({
    $core.int? level,
    $core.bool? chargerConnected,
    $core.bool? chargingComplete,
    $core.double? usbVoltage,
    $core.double? batteryVoltage,
    $core.int? usbAdcValue,
    $core.int? batteryAdcValue,
    $core.double? batteryTemperature,
    $core.int? batteryTemperatureAdcValue,
    $core.bool? notSupportedCharger,
    $core.bool? shutDownVoltageDetected,
    $core.bool? chargerFaultDetected,
    $core.double? lastFullyChargedVoltage,
    $core.bool? chgr,
    $core.bool? icDone,
    $core.bool? pg,
    $core.bool? chargerDisabled,
    $core.bool? charging,
    $core.bool? lowVoltageDetected,
  }) {
    final result = create();
    if (level != null) result.level = level;
    if (chargerConnected != null) result.chargerConnected = chargerConnected;
    if (chargingComplete != null) result.chargingComplete = chargingComplete;
    if (usbVoltage != null) result.usbVoltage = usbVoltage;
    if (batteryVoltage != null) result.batteryVoltage = batteryVoltage;
    if (usbAdcValue != null) result.usbAdcValue = usbAdcValue;
    if (batteryAdcValue != null) result.batteryAdcValue = batteryAdcValue;
    if (batteryTemperature != null)
      result.batteryTemperature = batteryTemperature;
    if (batteryTemperatureAdcValue != null)
      result.batteryTemperatureAdcValue = batteryTemperatureAdcValue;
    if (notSupportedCharger != null)
      result.notSupportedCharger = notSupportedCharger;
    if (shutDownVoltageDetected != null)
      result.shutDownVoltageDetected = shutDownVoltageDetected;
    if (chargerFaultDetected != null)
      result.chargerFaultDetected = chargerFaultDetected;
    if (lastFullyChargedVoltage != null)
      result.lastFullyChargedVoltage = lastFullyChargedVoltage;
    if (chgr != null) result.chgr = chgr;
    if (icDone != null) result.icDone = icDone;
    if (pg != null) result.pg = pg;
    if (chargerDisabled != null) result.chargerDisabled = chargerDisabled;
    if (charging != null) result.charging = charging;
    if (lowVoltageDetected != null)
      result.lowVoltageDetected = lowVoltageDetected;
    return result;
  }

  BatteryState._();

  factory BatteryState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BatteryState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BatteryState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'level', fieldType: $pb.PbFieldType.OU3)
    ..aOB(2, _omitFieldNames ? '' : 'chargerConnected')
    ..aOB(3, _omitFieldNames ? '' : 'chargingComplete')
    ..aD(4, _omitFieldNames ? '' : 'usbVoltage', fieldType: $pb.PbFieldType.OF)
    ..aD(5, _omitFieldNames ? '' : 'batteryVoltage',
        fieldType: $pb.PbFieldType.OF)
    ..aI(6, _omitFieldNames ? '' : 'usbAdcValue',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(7, _omitFieldNames ? '' : 'batteryAdcValue',
        fieldType: $pb.PbFieldType.OU3)
    ..aD(8, _omitFieldNames ? '' : 'batteryTemperature',
        fieldType: $pb.PbFieldType.OF)
    ..aI(9, _omitFieldNames ? '' : 'batteryTemperatureAdcValue',
        fieldType: $pb.PbFieldType.OU3)
    ..aOB(10, _omitFieldNames ? '' : 'notSupportedCharger')
    ..aOB(11, _omitFieldNames ? '' : 'shutDownVoltageDetected')
    ..aOB(12, _omitFieldNames ? '' : 'chargerFaultDetected')
    ..aD(13, _omitFieldNames ? '' : 'lastFullyChargedVoltage',
        fieldType: $pb.PbFieldType.OF)
    ..aOB(14, _omitFieldNames ? '' : 'chgr')
    ..aOB(15, _omitFieldNames ? '' : 'icDone')
    ..aOB(16, _omitFieldNames ? '' : 'pg')
    ..aOB(17, _omitFieldNames ? '' : 'chargerDisabled')
    ..aOB(18, _omitFieldNames ? '' : 'charging')
    ..aOB(19, _omitFieldNames ? '' : 'lowVoltageDetected')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatteryState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatteryState copyWith(void Function(BatteryState) updates) =>
      super.copyWith((message) => updates(message as BatteryState))
          as BatteryState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BatteryState create() => BatteryState._();
  @$core.override
  BatteryState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BatteryState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BatteryState>(create);
  static BatteryState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get level => $_getIZ(0);
  @$pb.TagNumber(1)
  set level($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLevel() => $_has(0);
  @$pb.TagNumber(1)
  void clearLevel() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get chargerConnected => $_getBF(1);
  @$pb.TagNumber(2)
  set chargerConnected($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChargerConnected() => $_has(1);
  @$pb.TagNumber(2)
  void clearChargerConnected() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get chargingComplete => $_getBF(2);
  @$pb.TagNumber(3)
  set chargingComplete($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChargingComplete() => $_has(2);
  @$pb.TagNumber(3)
  void clearChargingComplete() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get usbVoltage => $_getN(3);
  @$pb.TagNumber(4)
  set usbVoltage($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUsbVoltage() => $_has(3);
  @$pb.TagNumber(4)
  void clearUsbVoltage() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get batteryVoltage => $_getN(4);
  @$pb.TagNumber(5)
  set batteryVoltage($core.double value) => $_setFloat(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBatteryVoltage() => $_has(4);
  @$pb.TagNumber(5)
  void clearBatteryVoltage() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get usbAdcValue => $_getIZ(5);
  @$pb.TagNumber(6)
  set usbAdcValue($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUsbAdcValue() => $_has(5);
  @$pb.TagNumber(6)
  void clearUsbAdcValue() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get batteryAdcValue => $_getIZ(6);
  @$pb.TagNumber(7)
  set batteryAdcValue($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBatteryAdcValue() => $_has(6);
  @$pb.TagNumber(7)
  void clearBatteryAdcValue() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get batteryTemperature => $_getN(7);
  @$pb.TagNumber(8)
  set batteryTemperature($core.double value) => $_setFloat(7, value);
  @$pb.TagNumber(8)
  $core.bool hasBatteryTemperature() => $_has(7);
  @$pb.TagNumber(8)
  void clearBatteryTemperature() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get batteryTemperatureAdcValue => $_getIZ(8);
  @$pb.TagNumber(9)
  set batteryTemperatureAdcValue($core.int value) =>
      $_setUnsignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasBatteryTemperatureAdcValue() => $_has(8);
  @$pb.TagNumber(9)
  void clearBatteryTemperatureAdcValue() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get notSupportedCharger => $_getBF(9);
  @$pb.TagNumber(10)
  set notSupportedCharger($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasNotSupportedCharger() => $_has(9);
  @$pb.TagNumber(10)
  void clearNotSupportedCharger() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get shutDownVoltageDetected => $_getBF(10);
  @$pb.TagNumber(11)
  set shutDownVoltageDetected($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasShutDownVoltageDetected() => $_has(10);
  @$pb.TagNumber(11)
  void clearShutDownVoltageDetected() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get chargerFaultDetected => $_getBF(11);
  @$pb.TagNumber(12)
  set chargerFaultDetected($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasChargerFaultDetected() => $_has(11);
  @$pb.TagNumber(12)
  void clearChargerFaultDetected() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.double get lastFullyChargedVoltage => $_getN(12);
  @$pb.TagNumber(13)
  set lastFullyChargedVoltage($core.double value) => $_setFloat(12, value);
  @$pb.TagNumber(13)
  $core.bool hasLastFullyChargedVoltage() => $_has(12);
  @$pb.TagNumber(13)
  void clearLastFullyChargedVoltage() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.bool get chgr => $_getBF(13);
  @$pb.TagNumber(14)
  set chgr($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasChgr() => $_has(13);
  @$pb.TagNumber(14)
  void clearChgr() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.bool get icDone => $_getBF(14);
  @$pb.TagNumber(15)
  set icDone($core.bool value) => $_setBool(14, value);
  @$pb.TagNumber(15)
  $core.bool hasIcDone() => $_has(14);
  @$pb.TagNumber(15)
  void clearIcDone() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.bool get pg => $_getBF(15);
  @$pb.TagNumber(16)
  set pg($core.bool value) => $_setBool(15, value);
  @$pb.TagNumber(16)
  $core.bool hasPg() => $_has(15);
  @$pb.TagNumber(16)
  void clearPg() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.bool get chargerDisabled => $_getBF(16);
  @$pb.TagNumber(17)
  set chargerDisabled($core.bool value) => $_setBool(16, value);
  @$pb.TagNumber(17)
  $core.bool hasChargerDisabled() => $_has(16);
  @$pb.TagNumber(17)
  void clearChargerDisabled() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.bool get charging => $_getBF(17);
  @$pb.TagNumber(18)
  set charging($core.bool value) => $_setBool(17, value);
  @$pb.TagNumber(18)
  $core.bool hasCharging() => $_has(17);
  @$pb.TagNumber(18)
  void clearCharging() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.bool get lowVoltageDetected => $_getBF(18);
  @$pb.TagNumber(19)
  set lowVoltageDetected($core.bool value) => $_setBool(18, value);
  @$pb.TagNumber(19)
  $core.bool hasLowVoltageDetected() => $_has(18);
  @$pb.TagNumber(19)
  void clearLowVoltageDetected() => $_clearField(19);
}

/// Sensor data parts for NotificationSensorUpdate. Each part is only present in
/// the notification if subscribed to via RequestSensorNotificationSet.
/// The sensor strip is one bendable array folded over the top of the holder:
/// side A rises from position 0 to the top, side B falls from the top back to 0.
/// Added in FW4.3
class SensorRawData extends $pb.GeneratedMessage {
  factory SensorRawData({
    $core.List<$core.int>? ports,
  }) {
    final result = create();
    if (ports != null) result.ports = ports;
    return result;
  }

  SensorRawData._();

  factory SensorRawData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SensorRawData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SensorRawData',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'ports', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SensorRawData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SensorRawData copyWith(void Function(SensorRawData) updates) =>
      super.copyWith((message) => updates(message as SensorRawData))
          as SensorRawData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SensorRawData create() => SensorRawData._();
  @$core.override
  SensorRawData createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SensorRawData getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SensorRawData>(create);
  static SensorRawData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get ports => $_getN(0);
  @$pb.TagNumber(1)
  set ports($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPorts() => $_has(0);
  @$pb.TagNumber(1)
  void clearPorts() => $_clearField(1);
}

/// Absolute positions [mm] above position 0 (the strip ends); 0 when no contact
/// Added in FW4.3
class SensorPositionAbs extends $pb.GeneratedMessage {
  factory SensorPositionAbs({
    $core.double? master,
    $core.double? sideA,
    $core.double? sideB,
  }) {
    final result = create();
    if (master != null) result.master = master;
    if (sideA != null) result.sideA = sideA;
    if (sideB != null) result.sideB = sideB;
    return result;
  }

  SensorPositionAbs._();

  factory SensorPositionAbs.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SensorPositionAbs.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SensorPositionAbs',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'master', fieldType: $pb.PbFieldType.OF)
    ..aD(2, _omitFieldNames ? '' : 'sideA', fieldType: $pb.PbFieldType.OF)
    ..aD(3, _omitFieldNames ? '' : 'sideB', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SensorPositionAbs clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SensorPositionAbs copyWith(void Function(SensorPositionAbs) updates) =>
      super.copyWith((message) => updates(message as SensorPositionAbs))
          as SensorPositionAbs;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SensorPositionAbs create() => SensorPositionAbs._();
  @$core.override
  SensorPositionAbs createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SensorPositionAbs getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SensorPositionAbs>(create);
  static SensorPositionAbs? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get master => $_getN(0);
  @$pb.TagNumber(1)
  set master($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMaster() => $_has(0);
  @$pb.TagNumber(1)
  void clearMaster() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get sideA => $_getN(1);
  @$pb.TagNumber(2)
  set sideA($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSideA() => $_has(1);
  @$pb.TagNumber(2)
  void clearSideA() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get sideB => $_getN(2);
  @$pb.TagNumber(3)
  set sideB($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSideB() => $_has(2);
  @$pb.TagNumber(3)
  void clearSideB() => $_clearField(3);
}

/// Relative positions 0..1 of the side span (0 = bottom, 1 = top/fold); 0 when no contact
/// Added in FW4.3
class SensorPositionRel extends $pb.GeneratedMessage {
  factory SensorPositionRel({
    $core.double? master,
    $core.double? sideA,
    $core.double? sideB,
  }) {
    final result = create();
    if (master != null) result.master = master;
    if (sideA != null) result.sideA = sideA;
    if (sideB != null) result.sideB = sideB;
    return result;
  }

  SensorPositionRel._();

  factory SensorPositionRel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SensorPositionRel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SensorPositionRel',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'master', fieldType: $pb.PbFieldType.OF)
    ..aD(2, _omitFieldNames ? '' : 'sideA', fieldType: $pb.PbFieldType.OF)
    ..aD(3, _omitFieldNames ? '' : 'sideB', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SensorPositionRel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SensorPositionRel copyWith(void Function(SensorPositionRel) updates) =>
      super.copyWith((message) => updates(message as SensorPositionRel))
          as SensorPositionRel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SensorPositionRel create() => SensorPositionRel._();
  @$core.override
  SensorPositionRel createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SensorPositionRel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SensorPositionRel>(create);
  static SensorPositionRel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get master => $_getN(0);
  @$pb.TagNumber(1)
  set master($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMaster() => $_has(0);
  @$pb.TagNumber(1)
  void clearMaster() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get sideA => $_getN(1);
  @$pb.TagNumber(2)
  set sideA($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSideA() => $_has(1);
  @$pb.TagNumber(2)
  void clearSideA() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get sideB => $_getN(2);
  @$pb.TagNumber(3)
  set sideB($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSideB() => $_has(2);
  @$pb.TagNumber(3)
  void clearSideB() => $_clearField(3);
}

/// The full sensor state - one shared shape for both the notification stream
/// (NotificationSensorUpdate carries only the subscribed parts) and the
/// on-demand pull (ResponseSensorStateGet carries all parts). An absent part
/// is omitted from the wire message entirely (bits, a scalar, reads 0 when
/// not subscribed).
/// Added in FW4.3
class SensorState extends $pb.GeneratedMessage {
  factory SensorState({
    SensorRawData? raw,
    $fixnum.Int64? bits,
    SensorPositionAbs? positionAbs,
    SensorPositionRel? positionRel,
    $core.bool? contactSideA,
    $core.bool? contactSideB,
    $core.int? timestampMs,
    $core.bool? sleeping,
  }) {
    final result = create();
    if (raw != null) result.raw = raw;
    if (bits != null) result.bits = bits;
    if (positionAbs != null) result.positionAbs = positionAbs;
    if (positionRel != null) result.positionRel = positionRel;
    if (contactSideA != null) result.contactSideA = contactSideA;
    if (contactSideB != null) result.contactSideB = contactSideB;
    if (timestampMs != null) result.timestampMs = timestampMs;
    if (sleeping != null) result.sleeping = sleeping;
    return result;
  }

  SensorState._();

  factory SensorState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SensorState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SensorState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<SensorRawData>(1, _omitFieldNames ? '' : 'raw',
        subBuilder: SensorRawData.create)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'bits', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<SensorPositionAbs>(3, _omitFieldNames ? '' : 'positionAbs',
        subBuilder: SensorPositionAbs.create)
    ..aOM<SensorPositionRel>(4, _omitFieldNames ? '' : 'positionRel',
        subBuilder: SensorPositionRel.create)
    ..aOB(5, _omitFieldNames ? '' : 'contactSideA')
    ..aOB(6, _omitFieldNames ? '' : 'contactSideB')
    ..aI(7, _omitFieldNames ? '' : 'timestampMs',
        fieldType: $pb.PbFieldType.OU3)
    ..aOB(8, _omitFieldNames ? '' : 'sleeping')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SensorState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SensorState copyWith(void Function(SensorState) updates) =>
      super.copyWith((message) => updates(message as SensorState))
          as SensorState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SensorState create() => SensorState._();
  @$core.override
  SensorState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SensorState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SensorState>(create);
  static SensorState? _defaultInstance;

  @$pb.TagNumber(1)
  SensorRawData get raw => $_getN(0);
  @$pb.TagNumber(1)
  set raw(SensorRawData value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRaw() => $_has(0);
  @$pb.TagNumber(1)
  void clearRaw() => $_clearField(1);
  @$pb.TagNumber(1)
  SensorRawData ensureRaw() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get bits => $_getI64(1);
  @$pb.TagNumber(2)
  set bits($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBits() => $_has(1);
  @$pb.TagNumber(2)
  void clearBits() => $_clearField(2);

  @$pb.TagNumber(3)
  SensorPositionAbs get positionAbs => $_getN(2);
  @$pb.TagNumber(3)
  set positionAbs(SensorPositionAbs value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPositionAbs() => $_has(2);
  @$pb.TagNumber(3)
  void clearPositionAbs() => $_clearField(3);
  @$pb.TagNumber(3)
  SensorPositionAbs ensurePositionAbs() => $_ensure(2);

  @$pb.TagNumber(4)
  SensorPositionRel get positionRel => $_getN(3);
  @$pb.TagNumber(4)
  set positionRel(SensorPositionRel value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPositionRel() => $_has(3);
  @$pb.TagNumber(4)
  void clearPositionRel() => $_clearField(4);
  @$pb.TagNumber(4)
  SensorPositionRel ensurePositionRel() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.bool get contactSideA => $_getBF(4);
  @$pb.TagNumber(5)
  set contactSideA($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasContactSideA() => $_has(4);
  @$pb.TagNumber(5)
  void clearContactSideA() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get contactSideB => $_getBF(5);
  @$pb.TagNumber(6)
  set contactSideB($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasContactSideB() => $_has(5);
  @$pb.TagNumber(6)
  void clearContactSideB() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get timestampMs => $_getIZ(6);
  @$pb.TagNumber(7)
  set timestampMs($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTimestampMs() => $_has(6);
  @$pb.TagNumber(7)
  void clearTimestampMs() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get sleeping => $_getBF(7);
  @$pb.TagNumber(8)
  set sleeping($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSleeping() => $_has(7);
  @$pb.TagNumber(8)
  void clearSleeping() => $_clearField(8);
}

/// A device currently connected to the server. NB! Server only - never built or
/// parsed by the FW. Shared by ResponseDeviceListGet (302) and
/// NotificationDeviceListChanged (301).
class ConnectedDevice extends $pb.GeneratedMessage {
  factory ConnectedDevice({
    $core.String? key,
    $core.int? serial,
    $core.int? hwModelNumber,
  }) {
    final result = create();
    if (key != null) result.key = key;
    if (serial != null) result.serial = serial;
    if (hwModelNumber != null) result.hwModelNumber = hwModelNumber;
    return result;
  }

  ConnectedDevice._();

  factory ConnectedDevice.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConnectedDevice.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConnectedDevice',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aI(2, _omitFieldNames ? '' : 'serial', fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'hwModelNumber',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectedDevice clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectedDevice copyWith(void Function(ConnectedDevice) updates) =>
      super.copyWith((message) => updates(message as ConnectedDevice))
          as ConnectedDevice;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConnectedDevice create() => ConnectedDevice._();
  @$core.override
  ConnectedDevice createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConnectedDevice getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConnectedDevice>(create);
  static ConnectedDevice? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get serial => $_getIZ(1);
  @$pb.TagNumber(2)
  set serial($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSerial() => $_has(1);
  @$pb.TagNumber(2)
  void clearSerial() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get hwModelNumber => $_getIZ(2);
  @$pb.TagNumber(3)
  set hwModelNumber($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHwModelNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearHwModelNumber() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
