// This is a generated file - do not edit.
//
// Generated from constants.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

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
    ..e<HampPlayState>(
        1, _omitFieldNames ? '' : 'playState', $pb.PbFieldType.OE,
        defaultOrMaker: HampPlayState.HAMP_STATE_STOPPED,
        valueOf: HampPlayState.valueOf,
        enumValues: HampPlayState.values)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'velocity', $pb.PbFieldType.OF)
    ..aOB(3, _omitFieldNames ? '' : 'direction')
    ..a<$core.double>(4, _omitFieldNames ? '' : 'min', $pb.PbFieldType.OF)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'max', $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HampState clone() => HampState()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HampState copyWith(void Function(HampState) updates) =>
      super.copyWith((message) => updates(message as HampState)) as HampState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HampState create() => HampState._();
  @$core.override
  HampState createEmptyInstance() => create();
  static $pb.PbList<HampState> createRepeated() => $pb.PbList<HampState>();
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
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU3)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'version', $pb.PbFieldType.OU3)
    ..aOB(4, _omitFieldNames ? '' : 'customPattern')
    ..a<$core.int>(5, _omitFieldNames ? '' : 'slot', $pb.PbFieldType.OU3)
    ..e<HrppPatternType>(6, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE,
        defaultOrMaker: HrppPatternType.HRPP_NOT_SET,
        valueOf: HrppPatternType.valueOf,
        enumValues: HrppPatternType.values)
    ..a<$core.int>(
        7, _omitFieldNames ? '' : 'pauseRandomMin', $pb.PbFieldType.OU3)
    ..a<$core.int>(
        8, _omitFieldNames ? '' : 'pauseRandomMax', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HrppPattern clone() => HrppPattern()..mergeFromMessage(this);
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
  static $pb.PbList<HrppPattern> createRepeated() => $pb.PbList<HrppPattern>();
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
}

class HrppState extends $pb.GeneratedMessage {
  factory HrppState({
    $core.int? currentPatternNr,
    HrppPattern? currentPattern,
    $core.int? nrOfPatterns,
    $core.bool? enabled,
    $core.double? amplitude,
    $core.double? playbackSpeed,
  }) {
    final result = create();
    if (currentPatternNr != null) result.currentPatternNr = currentPatternNr;
    if (currentPattern != null) result.currentPattern = currentPattern;
    if (nrOfPatterns != null) result.nrOfPatterns = nrOfPatterns;
    if (enabled != null) result.enabled = enabled;
    if (amplitude != null) result.amplitude = amplitude;
    if (playbackSpeed != null) result.playbackSpeed = playbackSpeed;
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
    ..a<$core.int>(
        1, _omitFieldNames ? '' : 'currentPatternNr', $pb.PbFieldType.OU3)
    ..aOM<HrppPattern>(2, _omitFieldNames ? '' : 'currentPattern',
        subBuilder: HrppPattern.create)
    ..a<$core.int>(
        3, _omitFieldNames ? '' : 'nrOfPatterns', $pb.PbFieldType.OU3)
    ..aOB(4, _omitFieldNames ? '' : 'enabled')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'amplitude', $pb.PbFieldType.OF)
    ..a<$core.double>(
        6, _omitFieldNames ? '' : 'playbackSpeed', $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HrppState clone() => HrppState()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HrppState copyWith(void Function(HrppState) updates) =>
      super.copyWith((message) => updates(message as HrppState)) as HrppState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HrppState create() => HrppState._();
  @$core.override
  HrppState createEmptyInstance() => create();
  static $pb.PbList<HrppState> createRepeated() => $pb.PbList<HrppState>();
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

  @$pb.TagNumber(4)
  $core.bool get enabled => $_getBF(3);
  @$pb.TagNumber(4)
  set enabled($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEnabled() => $_has(3);
  @$pb.TagNumber(4)
  void clearEnabled() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get amplitude => $_getN(4);
  @$pb.TagNumber(5)
  set amplitude($core.double value) => $_setFloat(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAmplitude() => $_has(4);
  @$pb.TagNumber(5)
  void clearAmplitude() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get playbackSpeed => $_getN(5);
  @$pb.TagNumber(6)
  set playbackSpeed($core.double value) => $_setFloat(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPlaybackSpeed() => $_has(5);
  @$pb.TagNumber(6)
  void clearPlaybackSpeed() => $_clearField(6);
}

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
    ..e<HspPlayState>(1, _omitFieldNames ? '' : 'playState', $pb.PbFieldType.OE,
        defaultOrMaker: HspPlayState.HSP_STATE_NOT_INITIALIZED,
        valueOf: HspPlayState.valueOf,
        enumValues: HspPlayState.values)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'points', $pb.PbFieldType.OU3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'maxPoints', $pb.PbFieldType.OU3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'currentPoint', $pb.PbFieldType.O3)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'currentTime', $pb.PbFieldType.O3)
    ..aOB(6, _omitFieldNames ? '' : 'loop')
    ..a<$core.double>(
        7, _omitFieldNames ? '' : 'playbackRate', $pb.PbFieldType.OF)
    ..a<$core.int>(
        8, _omitFieldNames ? '' : 'firstPointTime', $pb.PbFieldType.OU3)
    ..a<$core.int>(
        9, _omitFieldNames ? '' : 'lastPointTime', $pb.PbFieldType.OU3)
    ..a<$core.int>(10, _omitFieldNames ? '' : 'streamId', $pb.PbFieldType.OU3)
    ..a<$core.int>(
        11, _omitFieldNames ? '' : 'tailPointStreamIndex', $pb.PbFieldType.O3)
    ..a<$core.int>(12, _omitFieldNames ? '' : 'tailPointStreamIndexThreshold',
        $pb.PbFieldType.OU3)
    ..aOB(13, _omitFieldNames ? '' : 'pauseOnStarving')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HspState clone() => HspState()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HspState copyWith(void Function(HspState) updates) =>
      super.copyWith((message) => updates(message as HspState)) as HspState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HspState create() => HspState._();
  @$core.override
  HspState createEmptyInstance() => create();
  static $pb.PbList<HspState> createRepeated() => $pb.PbList<HspState>();
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
    ..a<$core.double>(2, _omitFieldNames ? '' : 'amplitude', $pb.PbFieldType.OF)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'frequency', $pb.PbFieldType.OU3)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'position', $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HvpState clone() => HvpState()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HvpState copyWith(void Function(HvpState) updates) =>
      super.copyWith((message) => updates(message as HvpState)) as HvpState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HvpState create() => HvpState._();
  @$core.override
  HvpState createEmptyInstance() => create();
  static $pb.PbList<HvpState> createRepeated() => $pb.PbList<HvpState>();
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
    ..a<$core.int>(1, _omitFieldNames ? '' : 't', $pb.PbFieldType.OU3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'x', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Point clone() => Point()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Point copyWith(void Function(Point) updates) =>
      super.copyWith((message) => updates(message as Point)) as Point;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Point create() => Point._();
  @$core.override
  Point createEmptyInstance() => create();
  static $pb.PbList<Point> createRepeated() => $pb.PbList<Point>();
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
    ..a<$core.int>(3, _omitFieldNames ? '' : 'channel', $pb.PbFieldType.OU3)
    ..e<AuthModes>(4, _omitFieldNames ? '' : 'authmode', $pb.PbFieldType.OE,
        defaultOrMaker: AuthModes.AUTH_OPEN,
        valueOf: AuthModes.valueOf,
        enumValues: AuthModes.values)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'rssi', $pb.PbFieldType.O3)
    ..aOS(6, _omitFieldNames ? '' : 'ip')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApInfo clone() => ApInfo()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApInfo copyWith(void Function(ApInfo) updates) =>
      super.copyWith((message) => updates(message as ApInfo)) as ApInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApInfo create() => ApInfo._();
  @$core.override
  ApInfo createEmptyInstance() => create();
  static $pb.PbList<ApInfo> createRepeated() => $pb.PbList<ApInfo>();
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
    ..a<$core.int>(1, _omitFieldNames ? '' : 'level', $pb.PbFieldType.OU3)
    ..aOB(2, _omitFieldNames ? '' : 'chargerConnected')
    ..aOB(3, _omitFieldNames ? '' : 'chargingComplete')
    ..a<$core.double>(
        4, _omitFieldNames ? '' : 'usbVoltage', $pb.PbFieldType.OF)
    ..a<$core.double>(
        5, _omitFieldNames ? '' : 'batteryVoltage', $pb.PbFieldType.OF)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'usbAdcValue', $pb.PbFieldType.OU3)
    ..a<$core.int>(
        7, _omitFieldNames ? '' : 'batteryAdcValue', $pb.PbFieldType.OU3)
    ..a<$core.double>(
        8, _omitFieldNames ? '' : 'batteryTemperature', $pb.PbFieldType.OF)
    ..a<$core.int>(9, _omitFieldNames ? '' : 'batteryTemperatureAdcValue',
        $pb.PbFieldType.OU3)
    ..aOB(10, _omitFieldNames ? '' : 'notSupportedCharger')
    ..aOB(11, _omitFieldNames ? '' : 'shutDownVoltageDetected')
    ..aOB(12, _omitFieldNames ? '' : 'chargerFaultDetected')
    ..a<$core.double>(13, _omitFieldNames ? '' : 'lastFullyChargedVoltage',
        $pb.PbFieldType.OF)
    ..aOB(14, _omitFieldNames ? '' : 'chgr')
    ..aOB(15, _omitFieldNames ? '' : 'icDone')
    ..aOB(16, _omitFieldNames ? '' : 'pg')
    ..aOB(17, _omitFieldNames ? '' : 'chargerDisabled')
    ..aOB(18, _omitFieldNames ? '' : 'charging')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatteryState clone() => BatteryState()..mergeFromMessage(this);
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
  static $pb.PbList<BatteryState> createRepeated() =>
      $pb.PbList<BatteryState>();
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
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
