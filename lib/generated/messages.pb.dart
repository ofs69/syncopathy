// This is a generated file - do not edit.
//
// Generated from messages.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'constants.pb.dart' as $0;
import 'messages.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'messages.pbenum.dart';

/// NB! Server messages, never touched by the FW
/// 300
class RequestServerTimeGet extends $pb.GeneratedMessage {
  factory RequestServerTimeGet() => create();

  RequestServerTimeGet._();

  factory RequestServerTimeGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestServerTimeGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestServerTimeGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestServerTimeGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestServerTimeGet copyWith(void Function(RequestServerTimeGet) updates) =>
      super.copyWith((message) => updates(message as RequestServerTimeGet))
          as RequestServerTimeGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestServerTimeGet create() => RequestServerTimeGet._();
  @$core.override
  RequestServerTimeGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestServerTimeGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestServerTimeGet>(create);
  static RequestServerTimeGet? _defaultInstance;
}

class ResponseServerTimeGet extends $pb.GeneratedMessage {
  factory ResponseServerTimeGet({
    $fixnum.Int64? time,
  }) {
    final result = create();
    if (time != null) result.time = time;
    return result;
  }

  ResponseServerTimeGet._();

  factory ResponseServerTimeGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseServerTimeGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseServerTimeGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'time', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseServerTimeGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseServerTimeGet copyWith(
          void Function(ResponseServerTimeGet) updates) =>
      super.copyWith((message) => updates(message as ResponseServerTimeGet))
          as ResponseServerTimeGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseServerTimeGet create() => ResponseServerTimeGet._();
  @$core.override
  ResponseServerTimeGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseServerTimeGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseServerTimeGet>(create);
  static ResponseServerTimeGet? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get time => $_getI64(0);
  @$pb.TagNumber(1)
  set time($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearTime() => $_clearField(1);
}

/// 301
class RequestConnectedGet extends $pb.GeneratedMessage {
  factory RequestConnectedGet() => create();

  RequestConnectedGet._();

  factory RequestConnectedGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestConnectedGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestConnectedGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestConnectedGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestConnectedGet copyWith(void Function(RequestConnectedGet) updates) =>
      super.copyWith((message) => updates(message as RequestConnectedGet))
          as RequestConnectedGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestConnectedGet create() => RequestConnectedGet._();
  @$core.override
  RequestConnectedGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestConnectedGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestConnectedGet>(create);
  static RequestConnectedGet? _defaultInstance;
}

/// The PULL counterpart of NotificationConnectedChanged (300): the same presence
/// STATE, on demand. A client that missed the push - or that wants to re-verify
/// after a suspend, a heartbeat miss or a reconnect - asks for it here instead of
/// tearing the socket down and rebuilding it to be told again.
/// NB! State only. The transition detail on 300 (disconnect, timestamp) is
/// deliberately NOT mirrored here: those describe an EVENT that happened, and a
/// client asking "is a device attached right now" cannot tell a current fact from
/// a historical one. Why the last device left is 300's to say, not this one's.
class ResponseConnectedGet extends $pb.GeneratedMessage {
  factory ResponseConnectedGet({
    $core.bool? connected,
    $core.String? sessionId,
    $0.ConnectedDeviceInfo? info,
  }) {
    final result = create();
    if (connected != null) result.connected = connected;
    if (sessionId != null) result.sessionId = sessionId;
    if (info != null) result.info = info;
    return result;
  }

  ResponseConnectedGet._();

  factory ResponseConnectedGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseConnectedGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseConnectedGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'connected')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aOM<$0.ConnectedDeviceInfo>(3, _omitFieldNames ? '' : 'info',
        subBuilder: $0.ConnectedDeviceInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseConnectedGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseConnectedGet copyWith(void Function(ResponseConnectedGet) updates) =>
      super.copyWith((message) => updates(message as ResponseConnectedGet))
          as ResponseConnectedGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseConnectedGet create() => ResponseConnectedGet._();
  @$core.override
  ResponseConnectedGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseConnectedGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseConnectedGet>(create);
  static ResponseConnectedGet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get connected => $_getBF(0);
  @$pb.TagNumber(1)
  set connected($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConnected() => $_has(0);
  @$pb.TagNumber(1)
  void clearConnected() => $_clearField(1);

  /// Both SERVER-filled, and carrying exactly what 300 puts in the fields of the
  /// same name. Added in FW4.4
  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  /// carries and the online API serves as DeviceInfo.session_id. Empty
  /// while no device is attached
  @$pb.TagNumber(3)
  $0.ConnectedDeviceInfo get info => $_getN(2);
  @$pb.TagNumber(3)
  set info($0.ConnectedDeviceInfo value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasInfo() => $_has(2);
  @$pb.TagNumber(3)
  void clearInfo() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.ConnectedDeviceInfo ensureInfo() => $_ensure(2);
}

/// 304 - Added in FW4.4 - The server's firmware verdict for the connected device.
/// SERVER-answered: only the server knows which release is current. This is the
/// same fact the online API serves as fw_status on getDeviceInfo, so a socket
/// session no longer needs a REST call to learn it.
class RequestFwStatusGet extends $pb.GeneratedMessage {
  factory RequestFwStatusGet() => create();

  RequestFwStatusGet._();

  factory RequestFwStatusGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestFwStatusGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestFwStatusGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestFwStatusGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestFwStatusGet copyWith(void Function(RequestFwStatusGet) updates) =>
      super.copyWith((message) => updates(message as RequestFwStatusGet))
          as RequestFwStatusGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestFwStatusGet create() => RequestFwStatusGet._();
  @$core.override
  RequestFwStatusGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestFwStatusGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestFwStatusGet>(create);
  static RequestFwStatusGet? _defaultInstance;
}

class ResponseFwStatusGet extends $pb.GeneratedMessage {
  factory ResponseFwStatusGet({
    $0.FirmwareStatus? status,
    $core.String? latestVersion,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (latestVersion != null) result.latestVersion = latestVersion;
    return result;
  }

  ResponseFwStatusGet._();

  factory ResponseFwStatusGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseFwStatusGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseFwStatusGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aE<$0.FirmwareStatus>(1, _omitFieldNames ? '' : 'status',
        enumValues: $0.FirmwareStatus.values)
    ..aOS(2, _omitFieldNames ? '' : 'latestVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseFwStatusGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseFwStatusGet copyWith(void Function(ResponseFwStatusGet) updates) =>
      super.copyWith((message) => updates(message as ResponseFwStatusGet))
          as ResponseFwStatusGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseFwStatusGet create() => ResponseFwStatusGet._();
  @$core.override
  ResponseFwStatusGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseFwStatusGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseFwStatusGet>(create);
  static ResponseFwStatusGet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.FirmwareStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status($0.FirmwareStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get latestVersion => $_getSZ(1);
  @$pb.TagNumber(2)
  set latestVersion($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLatestVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearLatestVersion() => $_clearField(2);
}

/// 582 - Mechanical UNIFORMITY test (FW4.4). Async: blank response, then
/// NotificationTestComplete{msg_id, result}; read the detailed result with
/// RequestSlideMaintResultGet (856). OPEN LOOP, independent of the regulator and
/// its tuning (like the hall calibration): a constant-duty pass from each end in
/// each direction, the measured speed binned along the stroke. A uniform
/// mechanism rises monotonically to a plateau; a local bind (dry rail, damaged
/// screw flank, debris) is a DIP at that position, a one-way load is a
/// forward/backward plateau asymmetry. Verdict OK / CHECK (probably wants
/// lubrication) / FAIL. Also for the user: an app can offer it as a device check.
/// result: 0 ok; -1 motion failure; -4 already running; -5 not calibrated (run
/// the endpoint calibration first). Moves the slider for ~10 s. Requires a
/// calibrated slider; the device must be idle.
class RequestTestUniformity extends $pb.GeneratedMessage {
  factory RequestTestUniformity({
    $core.double? duty,
  }) {
    final result = create();
    if (duty != null) result.duty = duty;
    return result;
  }

  RequestTestUniformity._();

  factory RequestTestUniformity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestTestUniformity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestTestUniformity',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'duty', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestTestUniformity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestTestUniformity copyWith(
          void Function(RequestTestUniformity) updates) =>
      super.copyWith((message) => updates(message as RequestTestUniformity))
          as RequestTestUniformity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestTestUniformity create() => RequestTestUniformity._();
  @$core.override
  RequestTestUniformity createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestTestUniformity getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestTestUniformity>(create);
  static RequestTestUniformity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get duty => $_getN(0);
  @$pb.TagNumber(1)
  set duty($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDuty() => $_has(0);
  @$pb.TagNumber(1)
  void clearDuty() => $_clearField(1);
}

/// 583 - MAX SPEED test (FW4.4). Async like 582. The absolute speed the device
/// reaches inside its own stroke at full motor power WITHOUT reaching the ends:
/// the braking distance is measured first (stop from a moderate speed), then
/// each full-power pass brakes when the remaining travel equals 1.5 x the
/// predicted stopping distance plus a margin. result: 0 ok; -1 motion failure;
/// -4 already running; -5 not calibrated; -6 braking constant could not be
/// measured. Moves the slider hard for ~10 s.
class RequestTestMaxSpeed extends $pb.GeneratedMessage {
  factory RequestTestMaxSpeed() => create();

  RequestTestMaxSpeed._();

  factory RequestTestMaxSpeed.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestTestMaxSpeed.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestTestMaxSpeed',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestTestMaxSpeed clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestTestMaxSpeed copyWith(void Function(RequestTestMaxSpeed) updates) =>
      super.copyWith((message) => updates(message as RequestTestMaxSpeed))
          as RequestTestMaxSpeed;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestTestMaxSpeed create() => RequestTestMaxSpeed._();
  @$core.override
  RequestTestMaxSpeed createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestTestMaxSpeed getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestTestMaxSpeed>(create);
  static RequestTestMaxSpeed? _defaultInstance;
}

/// 606
class RequestConnectionKeyGet extends $pb.GeneratedMessage {
  factory RequestConnectionKeyGet() => create();

  RequestConnectionKeyGet._();

  factory RequestConnectionKeyGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestConnectionKeyGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestConnectionKeyGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestConnectionKeyGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestConnectionKeyGet copyWith(
          void Function(RequestConnectionKeyGet) updates) =>
      super.copyWith((message) => updates(message as RequestConnectionKeyGet))
          as RequestConnectionKeyGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestConnectionKeyGet create() => RequestConnectionKeyGet._();
  @$core.override
  RequestConnectionKeyGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestConnectionKeyGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestConnectionKeyGet>(create);
  static RequestConnectionKeyGet? _defaultInstance;
}

class ResponseConnectionKeyGet extends $pb.GeneratedMessage {
  factory ResponseConnectionKeyGet({
    $core.String? key,
  }) {
    final result = create();
    if (key != null) result.key = key;
    return result;
  }

  ResponseConnectionKeyGet._();

  factory ResponseConnectionKeyGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseConnectionKeyGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseConnectionKeyGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseConnectionKeyGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseConnectionKeyGet copyWith(
          void Function(ResponseConnectionKeyGet) updates) =>
      super.copyWith((message) => updates(message as ResponseConnectionKeyGet))
          as ResponseConnectionKeyGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseConnectionKeyGet create() => ResponseConnectionKeyGet._();
  @$core.override
  ResponseConnectionKeyGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseConnectionKeyGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseConnectionKeyGet>(create);
  static ResponseConnectionKeyGet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);
}

/// /////////////////////// WIFI configuration 620-639 /////////////////////////
/// 620 Port for wifi_prov_config_get_data_t - Get the current state of the wifi connection
class RequestWifiStatusGet extends $pb.GeneratedMessage {
  factory RequestWifiStatusGet() => create();

  RequestWifiStatusGet._();

  factory RequestWifiStatusGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestWifiStatusGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestWifiStatusGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWifiStatusGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWifiStatusGet copyWith(void Function(RequestWifiStatusGet) updates) =>
      super.copyWith((message) => updates(message as RequestWifiStatusGet))
          as RequestWifiStatusGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestWifiStatusGet create() => RequestWifiStatusGet._();
  @$core.override
  RequestWifiStatusGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestWifiStatusGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestWifiStatusGet>(create);
  static RequestWifiStatusGet? _defaultInstance;
}

class ResponseWifiStatusGet extends $pb.GeneratedMessage {
  factory ResponseWifiStatusGet({
    $0.ApInfo? apInfo,
    $0.WifiState? state,
    $0.WifiFailedReason? failedReason,
    $core.bool? socketConnected,
    $core.String? ssid,
  }) {
    final result = create();
    if (apInfo != null) result.apInfo = apInfo;
    if (state != null) result.state = state;
    if (failedReason != null) result.failedReason = failedReason;
    if (socketConnected != null) result.socketConnected = socketConnected;
    if (ssid != null) result.ssid = ssid;
    return result;
  }

  ResponseWifiStatusGet._();

  factory ResponseWifiStatusGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseWifiStatusGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseWifiStatusGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.ApInfo>(1, _omitFieldNames ? '' : 'apInfo',
        subBuilder: $0.ApInfo.create)
    ..aE<$0.WifiState>(2, _omitFieldNames ? '' : 'state',
        enumValues: $0.WifiState.values)
    ..aE<$0.WifiFailedReason>(3, _omitFieldNames ? '' : 'failedReason',
        enumValues: $0.WifiFailedReason.values)
    ..aOB(4, _omitFieldNames ? '' : 'socketConnected')
    ..aOS(5, _omitFieldNames ? '' : 'ssid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseWifiStatusGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseWifiStatusGet copyWith(
          void Function(ResponseWifiStatusGet) updates) =>
      super.copyWith((message) => updates(message as ResponseWifiStatusGet))
          as ResponseWifiStatusGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseWifiStatusGet create() => ResponseWifiStatusGet._();
  @$core.override
  ResponseWifiStatusGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseWifiStatusGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseWifiStatusGet>(create);
  static ResponseWifiStatusGet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.ApInfo get apInfo => $_getN(0);
  @$pb.TagNumber(1)
  set apInfo($0.ApInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasApInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearApInfo() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.ApInfo ensureApInfo() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.WifiState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state($0.WifiState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.WifiFailedReason get failedReason => $_getN(2);
  @$pb.TagNumber(3)
  set failedReason($0.WifiFailedReason value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFailedReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearFailedReason() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get socketConnected => $_getBF(3);
  @$pb.TagNumber(4)
  set socketConnected($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSocketConnected() => $_has(3);
  @$pb.TagNumber(4)
  void clearSocketConnected() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get ssid => $_getSZ(4);
  @$pb.TagNumber(5)
  set ssid($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSsid() => $_has(4);
  @$pb.TagNumber(5)
  void clearSsid() => $_clearField(5);
}

/// 621
/// Port for wifi_prov_config_set_data_t - Set the wifi configuration
/// If connected to WiFi, this call will disconnect the device from the current AP. It will not connect to the new AP.
class RequestWifiSet extends $pb.GeneratedMessage {
  factory RequestWifiSet({
    $core.String? ssid,
    $core.String? password,
    $core.bool? save,
  }) {
    final result = create();
    if (ssid != null) result.ssid = ssid;
    if (password != null) result.password = password;
    if (save != null) result.save = save;
    return result;
  }

  RequestWifiSet._();

  factory RequestWifiSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestWifiSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestWifiSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ssid')
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..aOB(3, _omitFieldNames ? '' : 'save')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWifiSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWifiSet copyWith(void Function(RequestWifiSet) updates) =>
      super.copyWith((message) => updates(message as RequestWifiSet))
          as RequestWifiSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestWifiSet create() => RequestWifiSet._();
  @$core.override
  RequestWifiSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestWifiSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestWifiSet>(create);
  static RequestWifiSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ssid => $_getSZ(0);
  @$pb.TagNumber(1)
  set ssid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSsid() => $_has(0);
  @$pb.TagNumber(1)
  void clearSsid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get save => $_getBF(2);
  @$pb.TagNumber(3)
  set save($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSave() => $_has(2);
  @$pb.TagNumber(3)
  void clearSave() => $_clearField(3);
}

/// port for _hdy_pc_prov_config_config_apply is not needed since we can set the WiFi by OnlineModeSet
/// 623 Port for _hdy_pc_prov_scan_start+result - Start wifi scan. Rembember to stop the scan when done! Returns OK if scan has started ok. Returns a scan complete notification when the scan is done.
class RequestWifiScanStart extends $pb.GeneratedMessage {
  factory RequestWifiScanStart({
    $core.bool? blocking,
    $core.bool? passive,
    $core.int? channel,
    $core.bool? showHidden,
    $core.int? passiveScanTime,
    $core.int? activeScanTimeMin,
    $core.int? activeScanTimeMax,
  }) {
    final result = create();
    if (blocking != null) result.blocking = blocking;
    if (passive != null) result.passive = passive;
    if (channel != null) result.channel = channel;
    if (showHidden != null) result.showHidden = showHidden;
    if (passiveScanTime != null) result.passiveScanTime = passiveScanTime;
    if (activeScanTimeMin != null) result.activeScanTimeMin = activeScanTimeMin;
    if (activeScanTimeMax != null) result.activeScanTimeMax = activeScanTimeMax;
    return result;
  }

  RequestWifiScanStart._();

  factory RequestWifiScanStart.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestWifiScanStart.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestWifiScanStart',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'blocking')
    ..aOB(2, _omitFieldNames ? '' : 'passive')
    ..aI(3, _omitFieldNames ? '' : 'channel', fieldType: $pb.PbFieldType.OU3)
    ..aOB(4, _omitFieldNames ? '' : 'showHidden')
    ..aI(5, _omitFieldNames ? '' : 'passiveScanTime',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(6, _omitFieldNames ? '' : 'activeScanTimeMin',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(7, _omitFieldNames ? '' : 'activeScanTimeMax',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWifiScanStart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWifiScanStart copyWith(void Function(RequestWifiScanStart) updates) =>
      super.copyWith((message) => updates(message as RequestWifiScanStart))
          as RequestWifiScanStart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestWifiScanStart create() => RequestWifiScanStart._();
  @$core.override
  RequestWifiScanStart createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestWifiScanStart getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestWifiScanStart>(create);
  static RequestWifiScanStart? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get blocking => $_getBF(0);
  @$pb.TagNumber(1)
  set blocking($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBlocking() => $_has(0);
  @$pb.TagNumber(1)
  void clearBlocking() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get passive => $_getBF(1);
  @$pb.TagNumber(2)
  set passive($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassive() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassive() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get channel => $_getIZ(2);
  @$pb.TagNumber(3)
  set channel($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChannel() => $_has(2);
  @$pb.TagNumber(3)
  void clearChannel() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get showHidden => $_getBF(3);
  @$pb.TagNumber(4)
  set showHidden($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasShowHidden() => $_has(3);
  @$pb.TagNumber(4)
  void clearShowHidden() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get passiveScanTime => $_getIZ(4);
  @$pb.TagNumber(5)
  set passiveScanTime($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPassiveScanTime() => $_has(4);
  @$pb.TagNumber(5)
  void clearPassiveScanTime() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get activeScanTimeMin => $_getIZ(5);
  @$pb.TagNumber(6)
  set activeScanTimeMin($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasActiveScanTimeMin() => $_has(5);
  @$pb.TagNumber(6)
  void clearActiveScanTimeMin() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get activeScanTimeMax => $_getIZ(6);
  @$pb.TagNumber(7)
  set activeScanTimeMax($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasActiveScanTimeMax() => $_has(6);
  @$pb.TagNumber(7)
  void clearActiveScanTimeMax() => $_clearField(7);
}

/// 624
/// Due to BLE limitations, the results are sent in chunks
class RequestWifiScanResultsGet extends $pb.GeneratedMessage {
  factory RequestWifiScanResultsGet({
    $core.int? maxResults,
    $core.int? offsetIndex,
  }) {
    final result = create();
    if (maxResults != null) result.maxResults = maxResults;
    if (offsetIndex != null) result.offsetIndex = offsetIndex;
    return result;
  }

  RequestWifiScanResultsGet._();

  factory RequestWifiScanResultsGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestWifiScanResultsGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestWifiScanResultsGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'maxResults', fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'offsetIndex',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWifiScanResultsGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWifiScanResultsGet copyWith(
          void Function(RequestWifiScanResultsGet) updates) =>
      super.copyWith((message) => updates(message as RequestWifiScanResultsGet))
          as RequestWifiScanResultsGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestWifiScanResultsGet create() => RequestWifiScanResultsGet._();
  @$core.override
  RequestWifiScanResultsGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestWifiScanResultsGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestWifiScanResultsGet>(create);
  static RequestWifiScanResultsGet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get maxResults => $_getIZ(0);
  @$pb.TagNumber(1)
  set maxResults($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMaxResults() => $_has(0);
  @$pb.TagNumber(1)
  void clearMaxResults() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get offsetIndex => $_getIZ(1);
  @$pb.TagNumber(2)
  set offsetIndex($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOffsetIndex() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffsetIndex() => $_clearField(2);
}

class ResponseWifiScanResultsGet extends $pb.GeneratedMessage {
  factory ResponseWifiScanResultsGet({
    $core.Iterable<$0.ApInfo>? apInfo,
    $core.int? totalResults,
  }) {
    final result = create();
    if (apInfo != null) result.apInfo.addAll(apInfo);
    if (totalResults != null) result.totalResults = totalResults;
    return result;
  }

  ResponseWifiScanResultsGet._();

  factory ResponseWifiScanResultsGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseWifiScanResultsGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseWifiScanResultsGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..pPM<$0.ApInfo>(1, _omitFieldNames ? '' : 'apInfo',
        subBuilder: $0.ApInfo.create)
    ..aI(2, _omitFieldNames ? '' : 'totalResults',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseWifiScanResultsGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseWifiScanResultsGet copyWith(
          void Function(ResponseWifiScanResultsGet) updates) =>
      super.copyWith(
              (message) => updates(message as ResponseWifiScanResultsGet))
          as ResponseWifiScanResultsGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseWifiScanResultsGet create() => ResponseWifiScanResultsGet._();
  @$core.override
  ResponseWifiScanResultsGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseWifiScanResultsGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseWifiScanResultsGet>(create);
  static ResponseWifiScanResultsGet? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$0.ApInfo> get apInfo => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get totalResults => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalResults($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalResults() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalResults() => $_clearField(2);
}

/// 625
/// Clean up the scan results and free memory on the device
class RequestWifiScanStop extends $pb.GeneratedMessage {
  factory RequestWifiScanStop() => create();

  RequestWifiScanStop._();

  factory RequestWifiScanStop.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestWifiScanStop.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestWifiScanStop',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWifiScanStop clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWifiScanStop copyWith(void Function(RequestWifiScanStop) updates) =>
      super.copyWith((message) => updates(message as RequestWifiScanStop))
          as RequestWifiScanStop;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestWifiScanStop create() => RequestWifiScanStop._();
  @$core.override
  RequestWifiScanStop createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestWifiScanStop getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestWifiScanStop>(create);
  static RequestWifiScanStop? _defaultInstance;
}

/// 700
class RequestModeGet extends $pb.GeneratedMessage {
  factory RequestModeGet() => create();

  RequestModeGet._();

  factory RequestModeGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestModeGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestModeGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestModeGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestModeGet copyWith(void Function(RequestModeGet) updates) =>
      super.copyWith((message) => updates(message as RequestModeGet))
          as RequestModeGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestModeGet create() => RequestModeGet._();
  @$core.override
  RequestModeGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestModeGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestModeGet>(create);
  static RequestModeGet? _defaultInstance;
}

class ResponseModeGet extends $pb.GeneratedMessage {
  factory ResponseModeGet({
    $0.Mode? mode,
    $core.int? modeSessionId,
  }) {
    final result = create();
    if (mode != null) result.mode = mode;
    if (modeSessionId != null) result.modeSessionId = modeSessionId;
    return result;
  }

  ResponseModeGet._();

  factory ResponseModeGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseModeGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseModeGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aE<$0.Mode>(1, _omitFieldNames ? '' : 'mode', enumValues: $0.Mode.values)
    ..aI(2, _omitFieldNames ? '' : 'modeSessionId',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseModeGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseModeGet copyWith(void Function(ResponseModeGet) updates) =>
      super.copyWith((message) => updates(message as ResponseModeGet))
          as ResponseModeGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseModeGet create() => ResponseModeGet._();
  @$core.override
  ResponseModeGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseModeGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseModeGet>(create);
  static ResponseModeGet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Mode get mode => $_getN(0);
  @$pb.TagNumber(1)
  set mode($0.Mode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearMode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get modeSessionId => $_getIZ(1);
  @$pb.TagNumber(2)
  set modeSessionId($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasModeSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearModeSessionId() => $_clearField(2);
}

/// 701
class RequestModeSet extends $pb.GeneratedMessage {
  factory RequestModeSet({
    $0.Mode? mode,
  }) {
    final result = create();
    if (mode != null) result.mode = mode;
    return result;
  }

  RequestModeSet._();

  factory RequestModeSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestModeSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestModeSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aE<$0.Mode>(1, _omitFieldNames ? '' : 'mode', enumValues: $0.Mode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestModeSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestModeSet copyWith(void Function(RequestModeSet) updates) =>
      super.copyWith((message) => updates(message as RequestModeSet))
          as RequestModeSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestModeSet create() => RequestModeSet._();
  @$core.override
  RequestModeSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestModeSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestModeSet>(create);
  static RequestModeSet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Mode get mode => $_getN(0);
  @$pb.TagNumber(1)
  set mode($0.Mode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearMode() => $_clearField(1);
}

class ResponseModeSet extends $pb.GeneratedMessage {
  factory ResponseModeSet({
    $0.Mode? mode,
    $core.int? modeSessionId,
  }) {
    final result = create();
    if (mode != null) result.mode = mode;
    if (modeSessionId != null) result.modeSessionId = modeSessionId;
    return result;
  }

  ResponseModeSet._();

  factory ResponseModeSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseModeSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseModeSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aE<$0.Mode>(1, _omitFieldNames ? '' : 'mode', enumValues: $0.Mode.values)
    ..aI(2, _omitFieldNames ? '' : 'modeSessionId',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseModeSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseModeSet copyWith(void Function(ResponseModeSet) updates) =>
      super.copyWith((message) => updates(message as ResponseModeSet))
          as ResponseModeSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseModeSet create() => ResponseModeSet._();
  @$core.override
  ResponseModeSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseModeSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseModeSet>(create);
  static ResponseModeSet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Mode get mode => $_getN(0);
  @$pb.TagNumber(1)
  set mode($0.Mode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearMode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get modeSessionId => $_getIZ(1);
  @$pb.TagNumber(2)
  set modeSessionId($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasModeSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearModeSessionId() => $_clearField(2);
}

///
/// Reboots the device.
/// The connection mode at start can be overriden by the connection_mode parameter.
/// NB! This override will only be used once. After the first boot, the connection mode will be set to the value in settings.
class RequestReboot extends $pb.GeneratedMessage {
  factory RequestReboot({
    $0.ConnectionMode? connectionMode,
  }) {
    final result = create();
    if (connectionMode != null) result.connectionMode = connectionMode;
    return result;
  }

  RequestReboot._();

  factory RequestReboot.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestReboot.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestReboot',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aE<$0.ConnectionMode>(3, _omitFieldNames ? '' : 'connectionMode',
        enumValues: $0.ConnectionMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestReboot clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestReboot copyWith(void Function(RequestReboot) updates) =>
      super.copyWith((message) => updates(message as RequestReboot))
          as RequestReboot;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestReboot create() => RequestReboot._();
  @$core.override
  RequestReboot createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestReboot getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestReboot>(create);
  static RequestReboot? _defaultInstance;

  @$pb.TagNumber(3)
  $0.ConnectionMode get connectionMode => $_getN(0);
  @$pb.TagNumber(3)
  set connectionMode($0.ConnectionMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasConnectionMode() => $_has(0);
  @$pb.TagNumber(3)
  void clearConnectionMode() => $_clearField(3);
}

/// 708
class RequestButtonPress extends $pb.GeneratedMessage {
  factory RequestButtonPress({
    $core.int? button,
    $0.ButtonEvent? event,
  }) {
    final result = create();
    if (button != null) result.button = button;
    if (event != null) result.event = event;
    return result;
  }

  RequestButtonPress._();

  factory RequestButtonPress.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestButtonPress.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestButtonPress',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'button', fieldType: $pb.PbFieldType.OU3)
    ..aE<$0.ButtonEvent>(2, _omitFieldNames ? '' : 'event',
        enumValues: $0.ButtonEvent.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestButtonPress clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestButtonPress copyWith(void Function(RequestButtonPress) updates) =>
      super.copyWith((message) => updates(message as RequestButtonPress))
          as RequestButtonPress;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestButtonPress create() => RequestButtonPress._();
  @$core.override
  RequestButtonPress createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestButtonPress getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestButtonPress>(create);
  static RequestButtonPress? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get button => $_getIZ(0);
  @$pb.TagNumber(1)
  set button($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasButton() => $_has(0);
  @$pb.TagNumber(1)
  void clearButton() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.ButtonEvent get event => $_getN(1);
  @$pb.TagNumber(2)
  set event($0.ButtonEvent value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEvent() => $_has(1);
  @$pb.TagNumber(2)
  void clearEvent() => $_clearField(2);
}

/// 709
class RequestClockOffsetSet extends $pb.GeneratedMessage {
  factory RequestClockOffsetSet({
    $fixnum.Int64? clockOffset,
    $core.int? rtd,
  }) {
    final result = create();
    if (clockOffset != null) result.clockOffset = clockOffset;
    if (rtd != null) result.rtd = rtd;
    return result;
  }

  RequestClockOffsetSet._();

  factory RequestClockOffsetSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestClockOffsetSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestClockOffsetSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'clockOffset', $pb.PbFieldType.OS6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(2, _omitFieldNames ? '' : 'rtd')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestClockOffsetSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestClockOffsetSet copyWith(
          void Function(RequestClockOffsetSet) updates) =>
      super.copyWith((message) => updates(message as RequestClockOffsetSet))
          as RequestClockOffsetSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestClockOffsetSet create() => RequestClockOffsetSet._();
  @$core.override
  RequestClockOffsetSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestClockOffsetSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestClockOffsetSet>(create);
  static RequestClockOffsetSet? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get clockOffset => $_getI64(0);
  @$pb.TagNumber(1)
  set clockOffset($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClockOffset() => $_has(0);
  @$pb.TagNumber(1)
  void clearClockOffset() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get rtd => $_getIZ(1);
  @$pb.TagNumber(2)
  set rtd($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRtd() => $_has(1);
  @$pb.TagNumber(2)
  void clearRtd() => $_clearField(2);
}

class ResponseClockOffsetSet extends $pb.GeneratedMessage {
  factory ResponseClockOffsetSet({
    $core.int? time,
    $fixnum.Int64? clockOffset,
    $core.int? rtd,
  }) {
    final result = create();
    if (time != null) result.time = time;
    if (clockOffset != null) result.clockOffset = clockOffset;
    if (rtd != null) result.rtd = rtd;
    return result;
  }

  ResponseClockOffsetSet._();

  factory ResponseClockOffsetSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseClockOffsetSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseClockOffsetSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'time', fieldType: $pb.PbFieldType.OU3)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'clockOffset', $pb.PbFieldType.OS6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(3, _omitFieldNames ? '' : 'rtd')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseClockOffsetSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseClockOffsetSet copyWith(
          void Function(ResponseClockOffsetSet) updates) =>
      super.copyWith((message) => updates(message as ResponseClockOffsetSet))
          as ResponseClockOffsetSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseClockOffsetSet create() => ResponseClockOffsetSet._();
  @$core.override
  ResponseClockOffsetSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseClockOffsetSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseClockOffsetSet>(create);
  static ResponseClockOffsetSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get time => $_getIZ(0);
  @$pb.TagNumber(1)
  set time($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearTime() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get clockOffset => $_getI64(1);
  @$pb.TagNumber(2)
  set clockOffset($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClockOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearClockOffset() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get rtd => $_getIZ(2);
  @$pb.TagNumber(3)
  set rtd($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRtd() => $_has(2);
  @$pb.TagNumber(3)
  void clearRtd() => $_clearField(3);
}

/// 710
class RequestBatteryGet extends $pb.GeneratedMessage {
  factory RequestBatteryGet({
    $core.bool? flush,
  }) {
    final result = create();
    if (flush != null) result.flush = flush;
    return result;
  }

  RequestBatteryGet._();

  factory RequestBatteryGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestBatteryGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestBatteryGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'flush')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestBatteryGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestBatteryGet copyWith(void Function(RequestBatteryGet) updates) =>
      super.copyWith((message) => updates(message as RequestBatteryGet))
          as RequestBatteryGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestBatteryGet create() => RequestBatteryGet._();
  @$core.override
  RequestBatteryGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestBatteryGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestBatteryGet>(create);
  static RequestBatteryGet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get flush => $_getBF(0);
  @$pb.TagNumber(1)
  set flush($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFlush() => $_has(0);
  @$pb.TagNumber(1)
  void clearFlush() => $_clearField(1);
}

class ResponseBatteryGet extends $pb.GeneratedMessage {
  factory ResponseBatteryGet({
    $0.BatteryState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseBatteryGet._();

  factory ResponseBatteryGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseBatteryGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseBatteryGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.BatteryState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.BatteryState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseBatteryGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseBatteryGet copyWith(void Function(ResponseBatteryGet) updates) =>
      super.copyWith((message) => updates(message as ResponseBatteryGet))
          as ResponseBatteryGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseBatteryGet create() => ResponseBatteryGet._();
  @$core.override
  ResponseBatteryGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseBatteryGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseBatteryGet>(create);
  static ResponseBatteryGet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.BatteryState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.BatteryState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.BatteryState ensureState() => $_ensure(0);
}

/// 712
class RequestClockOffsetGet extends $pb.GeneratedMessage {
  factory RequestClockOffsetGet() => create();

  RequestClockOffsetGet._();

  factory RequestClockOffsetGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestClockOffsetGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestClockOffsetGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestClockOffsetGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestClockOffsetGet copyWith(
          void Function(RequestClockOffsetGet) updates) =>
      super.copyWith((message) => updates(message as RequestClockOffsetGet))
          as RequestClockOffsetGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestClockOffsetGet create() => RequestClockOffsetGet._();
  @$core.override
  RequestClockOffsetGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestClockOffsetGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestClockOffsetGet>(create);
  static RequestClockOffsetGet? _defaultInstance;
}

class ResponseClockOffsetGet extends $pb.GeneratedMessage {
  factory ResponseClockOffsetGet({
    $core.int? time,
    $fixnum.Int64? clockOffset,
    $core.int? rtd,
  }) {
    final result = create();
    if (time != null) result.time = time;
    if (clockOffset != null) result.clockOffset = clockOffset;
    if (rtd != null) result.rtd = rtd;
    return result;
  }

  ResponseClockOffsetGet._();

  factory ResponseClockOffsetGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseClockOffsetGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseClockOffsetGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'time', fieldType: $pb.PbFieldType.OU3)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'clockOffset', $pb.PbFieldType.OS6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(3, _omitFieldNames ? '' : 'rtd')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseClockOffsetGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseClockOffsetGet copyWith(
          void Function(ResponseClockOffsetGet) updates) =>
      super.copyWith((message) => updates(message as ResponseClockOffsetGet))
          as ResponseClockOffsetGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseClockOffsetGet create() => ResponseClockOffsetGet._();
  @$core.override
  ResponseClockOffsetGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseClockOffsetGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseClockOffsetGet>(create);
  static ResponseClockOffsetGet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get time => $_getIZ(0);
  @$pb.TagNumber(1)
  set time($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearTime() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get clockOffset => $_getI64(1);
  @$pb.TagNumber(2)
  set clockOffset($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClockOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearClockOffset() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get rtd => $_getIZ(2);
  @$pb.TagNumber(3)
  set rtd($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRtd() => $_has(2);
  @$pb.TagNumber(3)
  void clearRtd() => $_clearField(3);
}

/// 713
/// Get the system capabilities
class RequestCapabilitiesGet extends $pb.GeneratedMessage {
  factory RequestCapabilitiesGet() => create();

  RequestCapabilitiesGet._();

  factory RequestCapabilitiesGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestCapabilitiesGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestCapabilitiesGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestCapabilitiesGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestCapabilitiesGet copyWith(
          void Function(RequestCapabilitiesGet) updates) =>
      super.copyWith((message) => updates(message as RequestCapabilitiesGet))
          as RequestCapabilitiesGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestCapabilitiesGet create() => RequestCapabilitiesGet._();
  @$core.override
  RequestCapabilitiesGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestCapabilitiesGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestCapabilitiesGet>(create);
  static RequestCapabilitiesGet? _defaultInstance;
}

class ResponseCapabilitiesGet extends $pb.GeneratedMessage {
  factory ResponseCapabilitiesGet({
    $core.bool? vulvaOriented,
    $core.bool? battery,
    $core.int? slider,
    $core.int? lra,
    $core.int? erm,
    $core.bool? externalMemory,
    $core.bool? rgbLedIndicator,
    $core.bool? ledMatrix,
    $core.int? ledMatrixLedsX,
    $core.int? ledMatrixLedsY,
    $core.bool? rgbRing,
    $core.int? rgbRingLeds,
    $core.int? batteryCapacity,
    $0.BatteryDriver? batteryDriver,
    $core.int? bleMtu,
    $core.int? wsBufferSize,
    $core.int? sensors,
    $core.bool? usbVoltageMeasure,
    $core.bool? batteryTemperatureMeasure,
    $core.bool? sensorForce,
    $core.int? sensorSides,
  }) {
    final result = create();
    if (vulvaOriented != null) result.vulvaOriented = vulvaOriented;
    if (battery != null) result.battery = battery;
    if (slider != null) result.slider = slider;
    if (lra != null) result.lra = lra;
    if (erm != null) result.erm = erm;
    if (externalMemory != null) result.externalMemory = externalMemory;
    if (rgbLedIndicator != null) result.rgbLedIndicator = rgbLedIndicator;
    if (ledMatrix != null) result.ledMatrix = ledMatrix;
    if (ledMatrixLedsX != null) result.ledMatrixLedsX = ledMatrixLedsX;
    if (ledMatrixLedsY != null) result.ledMatrixLedsY = ledMatrixLedsY;
    if (rgbRing != null) result.rgbRing = rgbRing;
    if (rgbRingLeds != null) result.rgbRingLeds = rgbRingLeds;
    if (batteryCapacity != null) result.batteryCapacity = batteryCapacity;
    if (batteryDriver != null) result.batteryDriver = batteryDriver;
    if (bleMtu != null) result.bleMtu = bleMtu;
    if (wsBufferSize != null) result.wsBufferSize = wsBufferSize;
    if (sensors != null) result.sensors = sensors;
    if (usbVoltageMeasure != null) result.usbVoltageMeasure = usbVoltageMeasure;
    if (batteryTemperatureMeasure != null)
      result.batteryTemperatureMeasure = batteryTemperatureMeasure;
    if (sensorForce != null) result.sensorForce = sensorForce;
    if (sensorSides != null) result.sensorSides = sensorSides;
    return result;
  }

  ResponseCapabilitiesGet._();

  factory ResponseCapabilitiesGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseCapabilitiesGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseCapabilitiesGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'vulvaOriented')
    ..aOB(2, _omitFieldNames ? '' : 'battery')
    ..aI(3, _omitFieldNames ? '' : 'slider', fieldType: $pb.PbFieldType.OU3)
    ..aI(4, _omitFieldNames ? '' : 'lra', fieldType: $pb.PbFieldType.OU3)
    ..aI(5, _omitFieldNames ? '' : 'erm', fieldType: $pb.PbFieldType.OU3)
    ..aOB(6, _omitFieldNames ? '' : 'externalMemory')
    ..aOB(7, _omitFieldNames ? '' : 'rgbLedIndicator')
    ..aOB(8, _omitFieldNames ? '' : 'ledMatrix')
    ..aI(9, _omitFieldNames ? '' : 'ledMatrixLedsX',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(10, _omitFieldNames ? '' : 'ledMatrixLedsY',
        fieldType: $pb.PbFieldType.OU3)
    ..aOB(11, _omitFieldNames ? '' : 'rgbRing')
    ..aI(12, _omitFieldNames ? '' : 'rgbRingLeds',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(13, _omitFieldNames ? '' : 'batteryCapacity',
        fieldType: $pb.PbFieldType.OU3)
    ..aE<$0.BatteryDriver>(14, _omitFieldNames ? '' : 'batteryDriver',
        enumValues: $0.BatteryDriver.values)
    ..aI(15, _omitFieldNames ? '' : 'bleMtu', fieldType: $pb.PbFieldType.OU3)
    ..aI(16, _omitFieldNames ? '' : 'wsBufferSize',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(17, _omitFieldNames ? '' : 'sensors', fieldType: $pb.PbFieldType.OU3)
    ..aOB(18, _omitFieldNames ? '' : 'usbVoltageMeasure')
    ..aOB(19, _omitFieldNames ? '' : 'batteryTemperatureMeasure')
    ..aOB(20, _omitFieldNames ? '' : 'sensorForce')
    ..aI(21, _omitFieldNames ? '' : 'sensorSides',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseCapabilitiesGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseCapabilitiesGet copyWith(
          void Function(ResponseCapabilitiesGet) updates) =>
      super.copyWith((message) => updates(message as ResponseCapabilitiesGet))
          as ResponseCapabilitiesGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseCapabilitiesGet create() => ResponseCapabilitiesGet._();
  @$core.override
  ResponseCapabilitiesGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseCapabilitiesGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseCapabilitiesGet>(create);
  static ResponseCapabilitiesGet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get vulvaOriented => $_getBF(0);
  @$pb.TagNumber(1)
  set vulvaOriented($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVulvaOriented() => $_has(0);
  @$pb.TagNumber(1)
  void clearVulvaOriented() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get battery => $_getBF(1);
  @$pb.TagNumber(2)
  set battery($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBattery() => $_has(1);
  @$pb.TagNumber(2)
  void clearBattery() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get slider => $_getIZ(2);
  @$pb.TagNumber(3)
  set slider($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSlider() => $_has(2);
  @$pb.TagNumber(3)
  void clearSlider() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get lra => $_getIZ(3);
  @$pb.TagNumber(4)
  set lra($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLra() => $_has(3);
  @$pb.TagNumber(4)
  void clearLra() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get erm => $_getIZ(4);
  @$pb.TagNumber(5)
  set erm($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasErm() => $_has(4);
  @$pb.TagNumber(5)
  void clearErm() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get externalMemory => $_getBF(5);
  @$pb.TagNumber(6)
  set externalMemory($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExternalMemory() => $_has(5);
  @$pb.TagNumber(6)
  void clearExternalMemory() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get rgbLedIndicator => $_getBF(6);
  @$pb.TagNumber(7)
  set rgbLedIndicator($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRgbLedIndicator() => $_has(6);
  @$pb.TagNumber(7)
  void clearRgbLedIndicator() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get ledMatrix => $_getBF(7);
  @$pb.TagNumber(8)
  set ledMatrix($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLedMatrix() => $_has(7);
  @$pb.TagNumber(8)
  void clearLedMatrix() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get ledMatrixLedsX => $_getIZ(8);
  @$pb.TagNumber(9)
  set ledMatrixLedsX($core.int value) => $_setUnsignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLedMatrixLedsX() => $_has(8);
  @$pb.TagNumber(9)
  void clearLedMatrixLedsX() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get ledMatrixLedsY => $_getIZ(9);
  @$pb.TagNumber(10)
  set ledMatrixLedsY($core.int value) => $_setUnsignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasLedMatrixLedsY() => $_has(9);
  @$pb.TagNumber(10)
  void clearLedMatrixLedsY() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get rgbRing => $_getBF(10);
  @$pb.TagNumber(11)
  set rgbRing($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRgbRing() => $_has(10);
  @$pb.TagNumber(11)
  void clearRgbRing() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get rgbRingLeds => $_getIZ(11);
  @$pb.TagNumber(12)
  set rgbRingLeds($core.int value) => $_setUnsignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasRgbRingLeds() => $_has(11);
  @$pb.TagNumber(12)
  void clearRgbRingLeds() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get batteryCapacity => $_getIZ(12);
  @$pb.TagNumber(13)
  set batteryCapacity($core.int value) => $_setUnsignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasBatteryCapacity() => $_has(12);
  @$pb.TagNumber(13)
  void clearBatteryCapacity() => $_clearField(13);

  @$pb.TagNumber(14)
  $0.BatteryDriver get batteryDriver => $_getN(13);
  @$pb.TagNumber(14)
  set batteryDriver($0.BatteryDriver value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasBatteryDriver() => $_has(13);
  @$pb.TagNumber(14)
  void clearBatteryDriver() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get bleMtu => $_getIZ(14);
  @$pb.TagNumber(15)
  set bleMtu($core.int value) => $_setUnsignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasBleMtu() => $_has(14);
  @$pb.TagNumber(15)
  void clearBleMtu() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.int get wsBufferSize => $_getIZ(15);
  @$pb.TagNumber(16)
  set wsBufferSize($core.int value) => $_setUnsignedInt32(15, value);
  @$pb.TagNumber(16)
  $core.bool hasWsBufferSize() => $_has(15);
  @$pb.TagNumber(16)
  void clearWsBufferSize() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.int get sensors => $_getIZ(16);
  @$pb.TagNumber(17)
  set sensors($core.int value) => $_setUnsignedInt32(16, value);
  @$pb.TagNumber(17)
  $core.bool hasSensors() => $_has(16);
  @$pb.TagNumber(17)
  void clearSensors() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.bool get usbVoltageMeasure => $_getBF(17);
  @$pb.TagNumber(18)
  set usbVoltageMeasure($core.bool value) => $_setBool(17, value);
  @$pb.TagNumber(18)
  $core.bool hasUsbVoltageMeasure() => $_has(17);
  @$pb.TagNumber(18)
  void clearUsbVoltageMeasure() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.bool get batteryTemperatureMeasure => $_getBF(18);
  @$pb.TagNumber(19)
  set batteryTemperatureMeasure($core.bool value) => $_setBool(18, value);
  @$pb.TagNumber(19)
  $core.bool hasBatteryTemperatureMeasure() => $_has(18);
  @$pb.TagNumber(19)
  void clearBatteryTemperatureMeasure() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.bool get sensorForce => $_getBF(19);
  @$pb.TagNumber(20)
  set sensorForce($core.bool value) => $_setBool(19, value);
  @$pb.TagNumber(20)
  $core.bool hasSensorForce() => $_has(19);
  @$pb.TagNumber(20)
  void clearSensorForce() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.int get sensorSides => $_getIZ(20);
  @$pb.TagNumber(21)
  set sensorSides($core.int value) => $_setUnsignedInt32(20, value);
  @$pb.TagNumber(21)
  $core.bool hasSensorSides() => $_has(20);
  @$pb.TagNumber(21)
  void clearSensorSides() => $_clearField(21);
}

///
/// Get the session ids (Random Int) (mode, socket and boot)
/// - Added in FW4.0.11
class RequestSessionIdsGet extends $pb.GeneratedMessage {
  factory RequestSessionIdsGet() => create();

  RequestSessionIdsGet._();

  factory RequestSessionIdsGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestSessionIdsGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestSessionIdsGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSessionIdsGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSessionIdsGet copyWith(void Function(RequestSessionIdsGet) updates) =>
      super.copyWith((message) => updates(message as RequestSessionIdsGet))
          as RequestSessionIdsGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestSessionIdsGet create() => RequestSessionIdsGet._();
  @$core.override
  RequestSessionIdsGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestSessionIdsGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestSessionIdsGet>(create);
  static RequestSessionIdsGet? _defaultInstance;
}

class ResponseSessionIdsGet extends $pb.GeneratedMessage {
  factory ResponseSessionIdsGet({
    $core.int? bootSessionId,
    $core.int? socketSessionId,
    $core.int? modeSessionId,
  }) {
    final result = create();
    if (bootSessionId != null) result.bootSessionId = bootSessionId;
    if (socketSessionId != null) result.socketSessionId = socketSessionId;
    if (modeSessionId != null) result.modeSessionId = modeSessionId;
    return result;
  }

  ResponseSessionIdsGet._();

  factory ResponseSessionIdsGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseSessionIdsGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseSessionIdsGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'bootSessionId',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'socketSessionId',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'modeSessionId',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSessionIdsGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSessionIdsGet copyWith(
          void Function(ResponseSessionIdsGet) updates) =>
      super.copyWith((message) => updates(message as ResponseSessionIdsGet))
          as ResponseSessionIdsGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseSessionIdsGet create() => ResponseSessionIdsGet._();
  @$core.override
  ResponseSessionIdsGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseSessionIdsGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseSessionIdsGet>(create);
  static ResponseSessionIdsGet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get bootSessionId => $_getIZ(0);
  @$pb.TagNumber(1)
  set bootSessionId($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBootSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBootSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get socketSessionId => $_getIZ(1);
  @$pb.TagNumber(2)
  set socketSessionId($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSocketSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSocketSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get modeSessionId => $_getIZ(2);
  @$pb.TagNumber(3)
  set modeSessionId($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasModeSessionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearModeSessionId() => $_clearField(3);
}

/// 715 - Added in FW4.0.13
///  Stop the device no matter the mode.
class RequestStopCurrentMode extends $pb.GeneratedMessage {
  factory RequestStopCurrentMode() => create();

  RequestStopCurrentMode._();

  factory RequestStopCurrentMode.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestStopCurrentMode.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestStopCurrentMode',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestStopCurrentMode clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestStopCurrentMode copyWith(
          void Function(RequestStopCurrentMode) updates) =>
      super.copyWith((message) => updates(message as RequestStopCurrentMode))
          as RequestStopCurrentMode;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestStopCurrentMode create() => RequestStopCurrentMode._();
  @$core.override
  RequestStopCurrentMode createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestStopCurrentMode getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestStopCurrentMode>(create);
  static RequestStopCurrentMode? _defaultInstance;
}

/// 716 - Added in FW4.0.13
class RequestConnectionModeSet extends $pb.GeneratedMessage {
  factory RequestConnectionModeSet({
    $0.ConnectionMode? mode,
  }) {
    final result = create();
    if (mode != null) result.mode = mode;
    return result;
  }

  RequestConnectionModeSet._();

  factory RequestConnectionModeSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestConnectionModeSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestConnectionModeSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aE<$0.ConnectionMode>(1, _omitFieldNames ? '' : 'mode',
        enumValues: $0.ConnectionMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestConnectionModeSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestConnectionModeSet copyWith(
          void Function(RequestConnectionModeSet) updates) =>
      super.copyWith((message) => updates(message as RequestConnectionModeSet))
          as RequestConnectionModeSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestConnectionModeSet create() => RequestConnectionModeSet._();
  @$core.override
  RequestConnectionModeSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestConnectionModeSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestConnectionModeSet>(create);
  static RequestConnectionModeSet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.ConnectionMode get mode => $_getN(0);
  @$pb.TagNumber(1)
  set mode($0.ConnectionMode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearMode() => $_clearField(1);
}

/// 717 - Added in FW4.0.13
class RequestConnectionModeGet extends $pb.GeneratedMessage {
  factory RequestConnectionModeGet() => create();

  RequestConnectionModeGet._();

  factory RequestConnectionModeGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestConnectionModeGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestConnectionModeGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestConnectionModeGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestConnectionModeGet copyWith(
          void Function(RequestConnectionModeGet) updates) =>
      super.copyWith((message) => updates(message as RequestConnectionModeGet))
          as RequestConnectionModeGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestConnectionModeGet create() => RequestConnectionModeGet._();
  @$core.override
  RequestConnectionModeGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestConnectionModeGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestConnectionModeGet>(create);
  static RequestConnectionModeGet? _defaultInstance;
}

class ResponseConnectionModeGet extends $pb.GeneratedMessage {
  factory ResponseConnectionModeGet({
    $0.ConnectionMode? mode,
  }) {
    final result = create();
    if (mode != null) result.mode = mode;
    return result;
  }

  ResponseConnectionModeGet._();

  factory ResponseConnectionModeGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseConnectionModeGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseConnectionModeGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aE<$0.ConnectionMode>(1, _omitFieldNames ? '' : 'mode',
        enumValues: $0.ConnectionMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseConnectionModeGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseConnectionModeGet copyWith(
          void Function(ResponseConnectionModeGet) updates) =>
      super.copyWith((message) => updates(message as ResponseConnectionModeGet))
          as ResponseConnectionModeGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseConnectionModeGet create() => ResponseConnectionModeGet._();
  @$core.override
  ResponseConnectionModeGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseConnectionModeGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseConnectionModeGet>(create);
  static ResponseConnectionModeGet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.ConnectionMode get mode => $_getN(0);
  @$pb.TagNumber(1)
  set mode($0.ConnectionMode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearMode() => $_clearField(1);
}

/// 718 - Added in FW4.4 - The PUBLIC subset of RequestPrivateInfoGet: what the device IS (product
/// identity + firmware), never WHICH UNIT it is. Deliberately carries no serial,
/// uid, mac, pcba_version or production_date - those stay private so a client
/// holding only a connection key cannot fingerprint a single device. Every field
/// here is shared by every unit of the same model, and every one of them is
/// already served to third parties by the online API's getDeviceInfo.
class RequestPublicInfoGet extends $pb.GeneratedMessage {
  factory RequestPublicInfoGet() => create();

  RequestPublicInfoGet._();

  factory RequestPublicInfoGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestPublicInfoGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestPublicInfoGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestPublicInfoGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestPublicInfoGet copyWith(void Function(RequestPublicInfoGet) updates) =>
      super.copyWith((message) => updates(message as RequestPublicInfoGet))
          as RequestPublicInfoGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestPublicInfoGet create() => RequestPublicInfoGet._();
  @$core.override
  RequestPublicInfoGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestPublicInfoGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestPublicInfoGet>(create);
  static RequestPublicInfoGet? _defaultInstance;
}

class ResponsePublicInfoGet extends $pb.GeneratedMessage {
  factory ResponsePublicInfoGet({
    $core.int? hwModelNumber,
    $core.int? hwModelVariantNumber,
    $core.String? fwVersion,
    $core.String? fwFeatureFlags,
  }) {
    final result = create();
    if (hwModelNumber != null) result.hwModelNumber = hwModelNumber;
    if (hwModelVariantNumber != null)
      result.hwModelVariantNumber = hwModelVariantNumber;
    if (fwVersion != null) result.fwVersion = fwVersion;
    if (fwFeatureFlags != null) result.fwFeatureFlags = fwFeatureFlags;
    return result;
  }

  ResponsePublicInfoGet._();

  factory ResponsePublicInfoGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponsePublicInfoGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponsePublicInfoGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'hwModelNumber',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'hwModelVariantNumber',
        fieldType: $pb.PbFieldType.OU3)
    ..aOS(3, _omitFieldNames ? '' : 'fwVersion')
    ..aOS(4, _omitFieldNames ? '' : 'fwFeatureFlags')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponsePublicInfoGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponsePublicInfoGet copyWith(
          void Function(ResponsePublicInfoGet) updates) =>
      super.copyWith((message) => updates(message as ResponsePublicInfoGet))
          as ResponsePublicInfoGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponsePublicInfoGet create() => ResponsePublicInfoGet._();
  @$core.override
  ResponsePublicInfoGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponsePublicInfoGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponsePublicInfoGet>(create);
  static ResponsePublicInfoGet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get hwModelNumber => $_getIZ(0);
  @$pb.TagNumber(1)
  set hwModelNumber($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHwModelNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearHwModelNumber() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get hwModelVariantNumber => $_getIZ(1);
  @$pb.TagNumber(2)
  set hwModelVariantNumber($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHwModelVariantNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearHwModelVariantNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get fwVersion => $_getSZ(2);
  @$pb.TagNumber(3)
  set fwVersion($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFwVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearFwVersion() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get fwFeatureFlags => $_getSZ(3);
  @$pb.TagNumber(4)
  set fwFeatureFlags($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFwFeatureFlags() => $_has(3);
  @$pb.TagNumber(4)
  void clearFwFeatureFlags() => $_clearField(4);
}

/// /////////////////////// HAMP /////////////////////////
/// 720
class RequestHampStart extends $pb.GeneratedMessage {
  factory RequestHampStart() => create();

  RequestHampStart._();

  factory RequestHampStart.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHampStart.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHampStart',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHampStart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHampStart copyWith(void Function(RequestHampStart) updates) =>
      super.copyWith((message) => updates(message as RequestHampStart))
          as RequestHampStart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHampStart create() => RequestHampStart._();
  @$core.override
  RequestHampStart createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHampStart getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHampStart>(create);
  static RequestHampStart? _defaultInstance;
}

class ResponseHampStart extends $pb.GeneratedMessage {
  factory ResponseHampStart({
    $0.HampState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHampStart._();

  factory ResponseHampStart.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHampStart.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHampStart',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HampState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HampState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHampStart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHampStart copyWith(void Function(ResponseHampStart) updates) =>
      super.copyWith((message) => updates(message as ResponseHampStart))
          as ResponseHampStart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHampStart create() => ResponseHampStart._();
  @$core.override
  ResponseHampStart createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHampStart getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHampStart>(create);
  static ResponseHampStart? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HampState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HampState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HampState ensureState() => $_ensure(0);
}

/// 721
class RequestHampStop extends $pb.GeneratedMessage {
  factory RequestHampStop() => create();

  RequestHampStop._();

  factory RequestHampStop.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHampStop.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHampStop',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHampStop clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHampStop copyWith(void Function(RequestHampStop) updates) =>
      super.copyWith((message) => updates(message as RequestHampStop))
          as RequestHampStop;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHampStop create() => RequestHampStop._();
  @$core.override
  RequestHampStop createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHampStop getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHampStop>(create);
  static RequestHampStop? _defaultInstance;
}

class ResponseHampStop extends $pb.GeneratedMessage {
  factory ResponseHampStop({
    $0.HampState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHampStop._();

  factory ResponseHampStop.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHampStop.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHampStop',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HampState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HampState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHampStop clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHampStop copyWith(void Function(ResponseHampStop) updates) =>
      super.copyWith((message) => updates(message as ResponseHampStop))
          as ResponseHampStop;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHampStop create() => ResponseHampStop._();
  @$core.override
  ResponseHampStop createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHampStop getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHampStop>(create);
  static ResponseHampStop? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HampState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HampState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HampState ensureState() => $_ensure(0);
}

/// 723
class RequestHampVelocitySet extends $pb.GeneratedMessage {
  factory RequestHampVelocitySet({
    $core.double? velocity,
  }) {
    final result = create();
    if (velocity != null) result.velocity = velocity;
    return result;
  }

  RequestHampVelocitySet._();

  factory RequestHampVelocitySet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHampVelocitySet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHampVelocitySet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'velocity', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHampVelocitySet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHampVelocitySet copyWith(
          void Function(RequestHampVelocitySet) updates) =>
      super.copyWith((message) => updates(message as RequestHampVelocitySet))
          as RequestHampVelocitySet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHampVelocitySet create() => RequestHampVelocitySet._();
  @$core.override
  RequestHampVelocitySet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHampVelocitySet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHampVelocitySet>(create);
  static RequestHampVelocitySet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get velocity => $_getN(0);
  @$pb.TagNumber(1)
  set velocity($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVelocity() => $_has(0);
  @$pb.TagNumber(1)
  void clearVelocity() => $_clearField(1);
}

class ResponseHampVelocitySet extends $pb.GeneratedMessage {
  factory ResponseHampVelocitySet({
    $0.HampState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHampVelocitySet._();

  factory ResponseHampVelocitySet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHampVelocitySet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHampVelocitySet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HampState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HampState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHampVelocitySet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHampVelocitySet copyWith(
          void Function(ResponseHampVelocitySet) updates) =>
      super.copyWith((message) => updates(message as ResponseHampVelocitySet))
          as ResponseHampVelocitySet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHampVelocitySet create() => ResponseHampVelocitySet._();
  @$core.override
  ResponseHampVelocitySet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHampVelocitySet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHampVelocitySet>(create);
  static ResponseHampVelocitySet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HampState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HampState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HampState ensureState() => $_ensure(0);
}

/// 724
class RequestHampStateGet extends $pb.GeneratedMessage {
  factory RequestHampStateGet() => create();

  RequestHampStateGet._();

  factory RequestHampStateGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHampStateGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHampStateGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHampStateGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHampStateGet copyWith(void Function(RequestHampStateGet) updates) =>
      super.copyWith((message) => updates(message as RequestHampStateGet))
          as RequestHampStateGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHampStateGet create() => RequestHampStateGet._();
  @$core.override
  RequestHampStateGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHampStateGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHampStateGet>(create);
  static RequestHampStateGet? _defaultInstance;
}

class ResponseHampStateGet extends $pb.GeneratedMessage {
  factory ResponseHampStateGet({
    $0.HampState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHampStateGet._();

  factory ResponseHampStateGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHampStateGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHampStateGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HampState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HampState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHampStateGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHampStateGet copyWith(void Function(ResponseHampStateGet) updates) =>
      super.copyWith((message) => updates(message as ResponseHampStateGet))
          as ResponseHampStateGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHampStateGet create() => ResponseHampStateGet._();
  @$core.override
  ResponseHampStateGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHampStateGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHampStateGet>(create);
  static ResponseHampStateGet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HampState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HampState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HampState ensureState() => $_ensure(0);
}

/// 725 - Added in FW4.0.15
class RequestHampZoneSet extends $pb.GeneratedMessage {
  factory RequestHampZoneSet({
    $core.double? min,
    $core.double? max,
  }) {
    final result = create();
    if (min != null) result.min = min;
    if (max != null) result.max = max;
    return result;
  }

  RequestHampZoneSet._();

  factory RequestHampZoneSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHampZoneSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHampZoneSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'min', fieldType: $pb.PbFieldType.OF)
    ..aD(2, _omitFieldNames ? '' : 'max', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHampZoneSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHampZoneSet copyWith(void Function(RequestHampZoneSet) updates) =>
      super.copyWith((message) => updates(message as RequestHampZoneSet))
          as RequestHampZoneSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHampZoneSet create() => RequestHampZoneSet._();
  @$core.override
  RequestHampZoneSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHampZoneSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHampZoneSet>(create);
  static RequestHampZoneSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get min => $_getN(0);
  @$pb.TagNumber(1)
  set min($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMin() => $_has(0);
  @$pb.TagNumber(1)
  void clearMin() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get max => $_getN(1);
  @$pb.TagNumber(2)
  set max($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMax() => $_has(1);
  @$pb.TagNumber(2)
  void clearMax() => $_clearField(2);
}

class ResponseHampZoneSet extends $pb.GeneratedMessage {
  factory ResponseHampZoneSet({
    $0.HampState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHampZoneSet._();

  factory ResponseHampZoneSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHampZoneSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHampZoneSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HampState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HampState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHampZoneSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHampZoneSet copyWith(void Function(ResponseHampZoneSet) updates) =>
      super.copyWith((message) => updates(message as ResponseHampZoneSet))
          as ResponseHampZoneSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHampZoneSet create() => ResponseHampZoneSet._();
  @$core.override
  ResponseHampZoneSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHampZoneSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHampZoneSet>(create);
  static ResponseHampZoneSet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HampState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HampState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HampState ensureState() => $_ensure(0);
}

/// /////////////////////// HDSP /////////////////////////
/// NB! Absolute values are capped within limits.
/// 740
class RequestHdspXaVaSet extends $pb.GeneratedMessage {
  factory RequestHdspXaVaSet({
    $core.double? xa,
    $core.double? va,
    $core.bool? stopOnTarget,
  }) {
    final result = create();
    if (xa != null) result.xa = xa;
    if (va != null) result.va = va;
    if (stopOnTarget != null) result.stopOnTarget = stopOnTarget;
    return result;
  }

  RequestHdspXaVaSet._();

  factory RequestHdspXaVaSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHdspXaVaSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHdspXaVaSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'xa', fieldType: $pb.PbFieldType.OF)
    ..aD(2, _omitFieldNames ? '' : 'va', fieldType: $pb.PbFieldType.OF)
    ..aOB(3, _omitFieldNames ? '' : 'stopOnTarget')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHdspXaVaSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHdspXaVaSet copyWith(void Function(RequestHdspXaVaSet) updates) =>
      super.copyWith((message) => updates(message as RequestHdspXaVaSet))
          as RequestHdspXaVaSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHdspXaVaSet create() => RequestHdspXaVaSet._();
  @$core.override
  RequestHdspXaVaSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHdspXaVaSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHdspXaVaSet>(create);
  static RequestHdspXaVaSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get xa => $_getN(0);
  @$pb.TagNumber(1)
  set xa($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasXa() => $_has(0);
  @$pb.TagNumber(1)
  void clearXa() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get va => $_getN(1);
  @$pb.TagNumber(2)
  set va($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVa() => $_has(1);
  @$pb.TagNumber(2)
  void clearVa() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get stopOnTarget => $_getBF(2);
  @$pb.TagNumber(3)
  set stopOnTarget($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStopOnTarget() => $_has(2);
  @$pb.TagNumber(3)
  void clearStopOnTarget() => $_clearField(3);
}

/// 741
class RequestHdspXpVaSet extends $pb.GeneratedMessage {
  factory RequestHdspXpVaSet({
    $core.double? xp,
    $core.double? va,
    $core.bool? stopOnTarget,
  }) {
    final result = create();
    if (xp != null) result.xp = xp;
    if (va != null) result.va = va;
    if (stopOnTarget != null) result.stopOnTarget = stopOnTarget;
    return result;
  }

  RequestHdspXpVaSet._();

  factory RequestHdspXpVaSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHdspXpVaSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHdspXpVaSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'xp', fieldType: $pb.PbFieldType.OF)
    ..aD(2, _omitFieldNames ? '' : 'va', fieldType: $pb.PbFieldType.OF)
    ..aOB(3, _omitFieldNames ? '' : 'stopOnTarget')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHdspXpVaSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHdspXpVaSet copyWith(void Function(RequestHdspXpVaSet) updates) =>
      super.copyWith((message) => updates(message as RequestHdspXpVaSet))
          as RequestHdspXpVaSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHdspXpVaSet create() => RequestHdspXpVaSet._();
  @$core.override
  RequestHdspXpVaSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHdspXpVaSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHdspXpVaSet>(create);
  static RequestHdspXpVaSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get xp => $_getN(0);
  @$pb.TagNumber(1)
  set xp($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasXp() => $_has(0);
  @$pb.TagNumber(1)
  void clearXp() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get va => $_getN(1);
  @$pb.TagNumber(2)
  set va($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVa() => $_has(1);
  @$pb.TagNumber(2)
  void clearVa() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get stopOnTarget => $_getBF(2);
  @$pb.TagNumber(3)
  set stopOnTarget($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStopOnTarget() => $_has(2);
  @$pb.TagNumber(3)
  void clearStopOnTarget() => $_clearField(3);
}

/// 742
class RequestHdspXpVpSet extends $pb.GeneratedMessage {
  factory RequestHdspXpVpSet({
    $core.double? xp,
    $core.double? vp,
    $core.bool? stopOnTarget,
  }) {
    final result = create();
    if (xp != null) result.xp = xp;
    if (vp != null) result.vp = vp;
    if (stopOnTarget != null) result.stopOnTarget = stopOnTarget;
    return result;
  }

  RequestHdspXpVpSet._();

  factory RequestHdspXpVpSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHdspXpVpSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHdspXpVpSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'xp', fieldType: $pb.PbFieldType.OF)
    ..aD(2, _omitFieldNames ? '' : 'vp', fieldType: $pb.PbFieldType.OF)
    ..aOB(3, _omitFieldNames ? '' : 'stopOnTarget')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHdspXpVpSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHdspXpVpSet copyWith(void Function(RequestHdspXpVpSet) updates) =>
      super.copyWith((message) => updates(message as RequestHdspXpVpSet))
          as RequestHdspXpVpSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHdspXpVpSet create() => RequestHdspXpVpSet._();
  @$core.override
  RequestHdspXpVpSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHdspXpVpSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHdspXpVpSet>(create);
  static RequestHdspXpVpSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get xp => $_getN(0);
  @$pb.TagNumber(1)
  set xp($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasXp() => $_has(0);
  @$pb.TagNumber(1)
  void clearXp() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get vp => $_getN(1);
  @$pb.TagNumber(2)
  set vp($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVp() => $_has(1);
  @$pb.TagNumber(2)
  void clearVp() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get stopOnTarget => $_getBF(2);
  @$pb.TagNumber(3)
  set stopOnTarget($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStopOnTarget() => $_has(2);
  @$pb.TagNumber(3)
  void clearStopOnTarget() => $_clearField(3);
}

/// 743
class RequestHdspXaTSet extends $pb.GeneratedMessage {
  factory RequestHdspXaTSet({
    $core.double? xa,
    $core.int? t,
    $core.bool? stopOnTarget,
  }) {
    final result = create();
    if (xa != null) result.xa = xa;
    if (t != null) result.t = t;
    if (stopOnTarget != null) result.stopOnTarget = stopOnTarget;
    return result;
  }

  RequestHdspXaTSet._();

  factory RequestHdspXaTSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHdspXaTSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHdspXaTSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'xa', fieldType: $pb.PbFieldType.OF)
    ..aI(2, _omitFieldNames ? '' : 't', fieldType: $pb.PbFieldType.OU3)
    ..aOB(3, _omitFieldNames ? '' : 'stopOnTarget')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHdspXaTSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHdspXaTSet copyWith(void Function(RequestHdspXaTSet) updates) =>
      super.copyWith((message) => updates(message as RequestHdspXaTSet))
          as RequestHdspXaTSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHdspXaTSet create() => RequestHdspXaTSet._();
  @$core.override
  RequestHdspXaTSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHdspXaTSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHdspXaTSet>(create);
  static RequestHdspXaTSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get xa => $_getN(0);
  @$pb.TagNumber(1)
  set xa($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasXa() => $_has(0);
  @$pb.TagNumber(1)
  void clearXa() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get t => $_getIZ(1);
  @$pb.TagNumber(2)
  set t($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasT() => $_has(1);
  @$pb.TagNumber(2)
  void clearT() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get stopOnTarget => $_getBF(2);
  @$pb.TagNumber(3)
  set stopOnTarget($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStopOnTarget() => $_has(2);
  @$pb.TagNumber(3)
  void clearStopOnTarget() => $_clearField(3);
}

/// 744
class RequestHdspXpTSet extends $pb.GeneratedMessage {
  factory RequestHdspXpTSet({
    $core.double? xp,
    $core.int? t,
    $core.bool? stopOnTarget,
  }) {
    final result = create();
    if (xp != null) result.xp = xp;
    if (t != null) result.t = t;
    if (stopOnTarget != null) result.stopOnTarget = stopOnTarget;
    return result;
  }

  RequestHdspXpTSet._();

  factory RequestHdspXpTSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHdspXpTSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHdspXpTSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'xp', fieldType: $pb.PbFieldType.OF)
    ..aI(2, _omitFieldNames ? '' : 't', fieldType: $pb.PbFieldType.OU3)
    ..aOB(3, _omitFieldNames ? '' : 'stopOnTarget')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHdspXpTSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHdspXpTSet copyWith(void Function(RequestHdspXpTSet) updates) =>
      super.copyWith((message) => updates(message as RequestHdspXpTSet))
          as RequestHdspXpTSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHdspXpTSet create() => RequestHdspXpTSet._();
  @$core.override
  RequestHdspXpTSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHdspXpTSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHdspXpTSet>(create);
  static RequestHdspXpTSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get xp => $_getN(0);
  @$pb.TagNumber(1)
  set xp($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasXp() => $_has(0);
  @$pb.TagNumber(1)
  void clearXp() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get t => $_getIZ(1);
  @$pb.TagNumber(2)
  set t($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasT() => $_has(1);
  @$pb.TagNumber(2)
  void clearT() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get stopOnTarget => $_getBF(2);
  @$pb.TagNumber(3)
  set stopOnTarget($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStopOnTarget() => $_has(2);
  @$pb.TagNumber(3)
  void clearStopOnTarget() => $_clearField(3);
}

/// 745
class RequestHdspXaVpSet extends $pb.GeneratedMessage {
  factory RequestHdspXaVpSet({
    $core.double? xa,
    $core.double? vp,
    $core.bool? stopOnTarget,
  }) {
    final result = create();
    if (xa != null) result.xa = xa;
    if (vp != null) result.vp = vp;
    if (stopOnTarget != null) result.stopOnTarget = stopOnTarget;
    return result;
  }

  RequestHdspXaVpSet._();

  factory RequestHdspXaVpSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHdspXaVpSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHdspXaVpSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'xa', fieldType: $pb.PbFieldType.OF)
    ..aD(2, _omitFieldNames ? '' : 'vp', fieldType: $pb.PbFieldType.OF)
    ..aOB(3, _omitFieldNames ? '' : 'stopOnTarget')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHdspXaVpSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHdspXaVpSet copyWith(void Function(RequestHdspXaVpSet) updates) =>
      super.copyWith((message) => updates(message as RequestHdspXaVpSet))
          as RequestHdspXaVpSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHdspXaVpSet create() => RequestHdspXaVpSet._();
  @$core.override
  RequestHdspXaVpSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHdspXaVpSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHdspXaVpSet>(create);
  static RequestHdspXaVpSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get xa => $_getN(0);
  @$pb.TagNumber(1)
  set xa($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasXa() => $_has(0);
  @$pb.TagNumber(1)
  void clearXa() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get vp => $_getN(1);
  @$pb.TagNumber(2)
  set vp($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVp() => $_has(1);
  @$pb.TagNumber(2)
  void clearVp() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get stopOnTarget => $_getBF(2);
  @$pb.TagNumber(3)
  set stopOnTarget($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStopOnTarget() => $_has(2);
  @$pb.TagNumber(3)
  void clearStopOnTarget() => $_clearField(3);
}

/// 746
class RequestHdspStop extends $pb.GeneratedMessage {
  factory RequestHdspStop() => create();

  RequestHdspStop._();

  factory RequestHdspStop.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHdspStop.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHdspStop',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHdspStop clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHdspStop copyWith(void Function(RequestHdspStop) updates) =>
      super.copyWith((message) => updates(message as RequestHdspStop))
          as RequestHdspStop;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHdspStop create() => RequestHdspStop._();
  @$core.override
  RequestHdspStop createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHdspStop getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHdspStop>(create);
  static RequestHdspStop? _defaultInstance;
}

/// /////////////////////// Sensor /////////////////////////
/// Sensor (position/pressure sensing, e.g. the S02 IR array) - 800
/// 800
/// Subscribe to sensor update notifications (NotificationSensorUpdate).
/// Select exactly which parts each notification carries - unselected parts are
/// omitted from the message entirely, so subscribe only to what you need and
/// the notifications stay small. enabled=false stops the stream.
/// Added in FW4.3
class RequestSensorNotificationSet extends $pb.GeneratedMessage {
  factory RequestSensorNotificationSet({
    $core.bool? enabled,
    $core.bool? raw,
    $core.bool? bits,
    $core.bool? positionAbs,
    $core.bool? positionRel,
    $core.int? minIntervalMs,
    $0.SensorNotificationMode? mode,
    $core.bool? force,
  }) {
    final result = create();
    if (enabled != null) result.enabled = enabled;
    if (raw != null) result.raw = raw;
    if (bits != null) result.bits = bits;
    if (positionAbs != null) result.positionAbs = positionAbs;
    if (positionRel != null) result.positionRel = positionRel;
    if (minIntervalMs != null) result.minIntervalMs = minIntervalMs;
    if (mode != null) result.mode = mode;
    if (force != null) result.force = force;
    return result;
  }

  RequestSensorNotificationSet._();

  factory RequestSensorNotificationSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestSensorNotificationSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestSensorNotificationSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'enabled')
    ..aOB(2, _omitFieldNames ? '' : 'raw')
    ..aOB(3, _omitFieldNames ? '' : 'bits')
    ..aOB(4, _omitFieldNames ? '' : 'positionAbs')
    ..aOB(5, _omitFieldNames ? '' : 'positionRel')
    ..aI(6, _omitFieldNames ? '' : 'minIntervalMs',
        fieldType: $pb.PbFieldType.OU3)
    ..aE<$0.SensorNotificationMode>(7, _omitFieldNames ? '' : 'mode',
        enumValues: $0.SensorNotificationMode.values)
    ..aOB(8, _omitFieldNames ? '' : 'force')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSensorNotificationSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSensorNotificationSet copyWith(
          void Function(RequestSensorNotificationSet) updates) =>
      super.copyWith(
              (message) => updates(message as RequestSensorNotificationSet))
          as RequestSensorNotificationSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestSensorNotificationSet create() =>
      RequestSensorNotificationSet._();
  @$core.override
  RequestSensorNotificationSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestSensorNotificationSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestSensorNotificationSet>(create);
  static RequestSensorNotificationSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enabled => $_getBF(0);
  @$pb.TagNumber(1)
  set enabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get raw => $_getBF(1);
  @$pb.TagNumber(2)
  set raw($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRaw() => $_has(1);
  @$pb.TagNumber(2)
  void clearRaw() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get bits => $_getBF(2);
  @$pb.TagNumber(3)
  set bits($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBits() => $_has(2);
  @$pb.TagNumber(3)
  void clearBits() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get positionAbs => $_getBF(3);
  @$pb.TagNumber(4)
  set positionAbs($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPositionAbs() => $_has(3);
  @$pb.TagNumber(4)
  void clearPositionAbs() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get positionRel => $_getBF(4);
  @$pb.TagNumber(5)
  set positionRel($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPositionRel() => $_has(4);
  @$pb.TagNumber(5)
  void clearPositionRel() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get minIntervalMs => $_getIZ(5);
  @$pb.TagNumber(6)
  set minIntervalMs($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMinIntervalMs() => $_has(5);
  @$pb.TagNumber(6)
  void clearMinIntervalMs() => $_clearField(6);

  /// 0 = every change. Contact changes always send immediately, and the
  /// latest reading is delivered once the interval expires (trailing
  /// edge) - the client is never left on stale data.
  /// ON_INTERVAL mode: the sending period; 0 = as fast as free system
  /// resources allow.
  @$pb.TagNumber(7)
  $0.SensorNotificationMode get mode => $_getN(6);
  @$pb.TagNumber(7)
  set mode($0.SensorNotificationMode value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasMode() => $_has(6);
  @$pb.TagNumber(7)
  void clearMode() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get force => $_getBF(7);
  @$pb.TagNumber(8)
  set force($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasForce() => $_has(7);
  @$pb.TagNumber(8)
  void clearForce() => $_clearField(8);
}

/// Echoes the configuration that is now active
/// Added in FW4.3
class ResponseSensorNotificationSet extends $pb.GeneratedMessage {
  factory ResponseSensorNotificationSet({
    $core.bool? enabled,
    $core.bool? raw,
    $core.bool? bits,
    $core.bool? positionAbs,
    $core.bool? positionRel,
    $core.int? minIntervalMs,
    $0.SensorNotificationMode? mode,
    $core.bool? force,
  }) {
    final result = create();
    if (enabled != null) result.enabled = enabled;
    if (raw != null) result.raw = raw;
    if (bits != null) result.bits = bits;
    if (positionAbs != null) result.positionAbs = positionAbs;
    if (positionRel != null) result.positionRel = positionRel;
    if (minIntervalMs != null) result.minIntervalMs = minIntervalMs;
    if (mode != null) result.mode = mode;
    if (force != null) result.force = force;
    return result;
  }

  ResponseSensorNotificationSet._();

  factory ResponseSensorNotificationSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseSensorNotificationSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseSensorNotificationSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'enabled')
    ..aOB(2, _omitFieldNames ? '' : 'raw')
    ..aOB(3, _omitFieldNames ? '' : 'bits')
    ..aOB(4, _omitFieldNames ? '' : 'positionAbs')
    ..aOB(5, _omitFieldNames ? '' : 'positionRel')
    ..aI(6, _omitFieldNames ? '' : 'minIntervalMs',
        fieldType: $pb.PbFieldType.OU3)
    ..aE<$0.SensorNotificationMode>(7, _omitFieldNames ? '' : 'mode',
        enumValues: $0.SensorNotificationMode.values)
    ..aOB(8, _omitFieldNames ? '' : 'force')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSensorNotificationSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSensorNotificationSet copyWith(
          void Function(ResponseSensorNotificationSet) updates) =>
      super.copyWith(
              (message) => updates(message as ResponseSensorNotificationSet))
          as ResponseSensorNotificationSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseSensorNotificationSet create() =>
      ResponseSensorNotificationSet._();
  @$core.override
  ResponseSensorNotificationSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseSensorNotificationSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseSensorNotificationSet>(create);
  static ResponseSensorNotificationSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enabled => $_getBF(0);
  @$pb.TagNumber(1)
  set enabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get raw => $_getBF(1);
  @$pb.TagNumber(2)
  set raw($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRaw() => $_has(1);
  @$pb.TagNumber(2)
  void clearRaw() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get bits => $_getBF(2);
  @$pb.TagNumber(3)
  set bits($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBits() => $_has(2);
  @$pb.TagNumber(3)
  void clearBits() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get positionAbs => $_getBF(3);
  @$pb.TagNumber(4)
  set positionAbs($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPositionAbs() => $_has(3);
  @$pb.TagNumber(4)
  void clearPositionAbs() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get positionRel => $_getBF(4);
  @$pb.TagNumber(5)
  set positionRel($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPositionRel() => $_has(4);
  @$pb.TagNumber(5)
  void clearPositionRel() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get minIntervalMs => $_getIZ(5);
  @$pb.TagNumber(6)
  set minIntervalMs($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMinIntervalMs() => $_has(5);
  @$pb.TagNumber(6)
  void clearMinIntervalMs() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.SensorNotificationMode get mode => $_getN(6);
  @$pb.TagNumber(7)
  set mode($0.SensorNotificationMode value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasMode() => $_has(6);
  @$pb.TagNumber(7)
  void clearMode() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get force => $_getBF(7);
  @$pb.TagNumber(8)
  set force($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasForce() => $_has(7);
  @$pb.TagNumber(8)
  void clearForce() => $_clearField(8);
}

/// 801
/// Pull the current sensor state on demand - a fresh hardware read, same data
/// as NotificationSensorUpdate but with ALL parts always included.
/// Added in FW4.3
class RequestSensorStateGet extends $pb.GeneratedMessage {
  factory RequestSensorStateGet() => create();

  RequestSensorStateGet._();

  factory RequestSensorStateGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestSensorStateGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestSensorStateGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSensorStateGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSensorStateGet copyWith(
          void Function(RequestSensorStateGet) updates) =>
      super.copyWith((message) => updates(message as RequestSensorStateGet))
          as RequestSensorStateGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestSensorStateGet create() => RequestSensorStateGet._();
  @$core.override
  RequestSensorStateGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestSensorStateGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestSensorStateGet>(create);
  static RequestSensorStateGet? _defaultInstance;
}

/// Added in FW4.3
class ResponseSensorStateGet extends $pb.GeneratedMessage {
  factory ResponseSensorStateGet({
    $0.SensorState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseSensorStateGet._();

  factory ResponseSensorStateGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseSensorStateGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseSensorStateGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.SensorState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.SensorState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSensorStateGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSensorStateGet copyWith(
          void Function(ResponseSensorStateGet) updates) =>
      super.copyWith((message) => updates(message as ResponseSensorStateGet))
          as ResponseSensorStateGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseSensorStateGet create() => ResponseSensorStateGet._();
  @$core.override
  ResponseSensorStateGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseSensorStateGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseSensorStateGet>(create);
  static ResponseSensorStateGet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.SensorState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.SensorState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.SensorState ensureState() => $_ensure(0);
}

/// 802
/// Read back the active notification subscription without changing it. Meant
/// for clients that lost track of what they set: the device auto-disables the
/// stream when it sees no client connected, so after a reconnect the client's
/// last-known configuration is unreliable.
/// Added in FW4.3
class RequestSensorNotificationGet extends $pb.GeneratedMessage {
  factory RequestSensorNotificationGet() => create();

  RequestSensorNotificationGet._();

  factory RequestSensorNotificationGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestSensorNotificationGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestSensorNotificationGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSensorNotificationGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSensorNotificationGet copyWith(
          void Function(RequestSensorNotificationGet) updates) =>
      super.copyWith(
              (message) => updates(message as RequestSensorNotificationGet))
          as RequestSensorNotificationGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestSensorNotificationGet create() =>
      RequestSensorNotificationGet._();
  @$core.override
  RequestSensorNotificationGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestSensorNotificationGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestSensorNotificationGet>(create);
  static RequestSensorNotificationGet? _defaultInstance;
}

/// Same shape as ResponseSensorNotificationSet
/// Added in FW4.3
class ResponseSensorNotificationGet extends $pb.GeneratedMessage {
  factory ResponseSensorNotificationGet({
    $core.bool? enabled,
    $core.bool? raw,
    $core.bool? bits,
    $core.bool? positionAbs,
    $core.bool? positionRel,
    $core.int? minIntervalMs,
    $0.SensorNotificationMode? mode,
    $core.bool? force,
  }) {
    final result = create();
    if (enabled != null) result.enabled = enabled;
    if (raw != null) result.raw = raw;
    if (bits != null) result.bits = bits;
    if (positionAbs != null) result.positionAbs = positionAbs;
    if (positionRel != null) result.positionRel = positionRel;
    if (minIntervalMs != null) result.minIntervalMs = minIntervalMs;
    if (mode != null) result.mode = mode;
    if (force != null) result.force = force;
    return result;
  }

  ResponseSensorNotificationGet._();

  factory ResponseSensorNotificationGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseSensorNotificationGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseSensorNotificationGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'enabled')
    ..aOB(2, _omitFieldNames ? '' : 'raw')
    ..aOB(3, _omitFieldNames ? '' : 'bits')
    ..aOB(4, _omitFieldNames ? '' : 'positionAbs')
    ..aOB(5, _omitFieldNames ? '' : 'positionRel')
    ..aI(6, _omitFieldNames ? '' : 'minIntervalMs',
        fieldType: $pb.PbFieldType.OU3)
    ..aE<$0.SensorNotificationMode>(7, _omitFieldNames ? '' : 'mode',
        enumValues: $0.SensorNotificationMode.values)
    ..aOB(8, _omitFieldNames ? '' : 'force')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSensorNotificationGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSensorNotificationGet copyWith(
          void Function(ResponseSensorNotificationGet) updates) =>
      super.copyWith(
              (message) => updates(message as ResponseSensorNotificationGet))
          as ResponseSensorNotificationGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseSensorNotificationGet create() =>
      ResponseSensorNotificationGet._();
  @$core.override
  ResponseSensorNotificationGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseSensorNotificationGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseSensorNotificationGet>(create);
  static ResponseSensorNotificationGet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enabled => $_getBF(0);
  @$pb.TagNumber(1)
  set enabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get raw => $_getBF(1);
  @$pb.TagNumber(2)
  set raw($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRaw() => $_has(1);
  @$pb.TagNumber(2)
  void clearRaw() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get bits => $_getBF(2);
  @$pb.TagNumber(3)
  set bits($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBits() => $_has(2);
  @$pb.TagNumber(3)
  void clearBits() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get positionAbs => $_getBF(3);
  @$pb.TagNumber(4)
  set positionAbs($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPositionAbs() => $_has(3);
  @$pb.TagNumber(4)
  void clearPositionAbs() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get positionRel => $_getBF(4);
  @$pb.TagNumber(5)
  set positionRel($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPositionRel() => $_has(4);
  @$pb.TagNumber(5)
  void clearPositionRel() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get minIntervalMs => $_getIZ(5);
  @$pb.TagNumber(6)
  set minIntervalMs($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMinIntervalMs() => $_has(5);
  @$pb.TagNumber(6)
  void clearMinIntervalMs() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.SensorNotificationMode get mode => $_getN(6);
  @$pb.TagNumber(7)
  set mode($0.SensorNotificationMode value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasMode() => $_has(6);
  @$pb.TagNumber(7)
  void clearMode() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get force => $_getBF(7);
  @$pb.TagNumber(8)
  set force($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasForce() => $_has(7);
  @$pb.TagNumber(8)
  void clearForce() => $_clearField(8);
}

/// ///////////////////////////////////////////////////////////////////////////
/// 810-818 MEMS force strip (ZSFS1001, S01 ribcage) - WORK IN PROGRESS.
/// NOT FINALIZED: ids, fields and behaviour may still change or be removed.
/// Nothing here is a committed API yet (public since 2026-10-08). Types live
/// in constants.proto.
///
/// - Builds without the MEMS backend answer ERROR_FUNCTION_NOT_SUPPORTED.
/// - Sensor indexes are PHYSICAL: 0 = the sensor at the I2C base address (the
///   connector end). SensorForce in the sensor stream is LOGICAL order instead.
/// - sensor_mask: bit i = physical sensor i; 0 = every present sensor. Absent
///   sensors in a mask are skipped (reset is the exception: it re-probes them).
/// - While a test runs (817), every request here except 810 and 818 is rejected
///   with ESP_ERR_INVALID_STATE (259).
/// Added in FW4.4
/// ///////////////////////////////////////////////////////////////////////////
/// 810 - Strip and per-sensor status (no I2C traffic). Allowed during a test.
class RequestMemsStatusGet extends $pb.GeneratedMessage {
  factory RequestMemsStatusGet() => create();

  RequestMemsStatusGet._();

  factory RequestMemsStatusGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestMemsStatusGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestMemsStatusGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestMemsStatusGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestMemsStatusGet copyWith(void Function(RequestMemsStatusGet) updates) =>
      super.copyWith((message) => updates(message as RequestMemsStatusGet))
          as RequestMemsStatusGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestMemsStatusGet create() => RequestMemsStatusGet._();
  @$core.override
  RequestMemsStatusGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestMemsStatusGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestMemsStatusGet>(create);
  static RequestMemsStatusGet? _defaultInstance;
}

class ResponseMemsStatusGet extends $pb.GeneratedMessage {
  factory ResponseMemsStatusGet({
    $core.int? count,
    $core.int? presentMask,
    $core.int? baseAddress,
    $core.bool? reversed,
    $core.int? threshold,
    $core.int? pollMs,
    $core.int? readFailures,
    $core.bool? testRunning,
    $core.Iterable<$0.MemsSensorInfo>? sensors,
    $core.bool? inverted,
  }) {
    final result = create();
    if (count != null) result.count = count;
    if (presentMask != null) result.presentMask = presentMask;
    if (baseAddress != null) result.baseAddress = baseAddress;
    if (reversed != null) result.reversed = reversed;
    if (threshold != null) result.threshold = threshold;
    if (pollMs != null) result.pollMs = pollMs;
    if (readFailures != null) result.readFailures = readFailures;
    if (testRunning != null) result.testRunning = testRunning;
    if (sensors != null) result.sensors.addAll(sensors);
    if (inverted != null) result.inverted = inverted;
    return result;
  }

  ResponseMemsStatusGet._();

  factory ResponseMemsStatusGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseMemsStatusGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseMemsStatusGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'count', fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'presentMask',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'baseAddress',
        fieldType: $pb.PbFieldType.OU3)
    ..aOB(4, _omitFieldNames ? '' : 'reversed')
    ..aI(5, _omitFieldNames ? '' : 'threshold', fieldType: $pb.PbFieldType.OU3)
    ..aI(6, _omitFieldNames ? '' : 'pollMs', fieldType: $pb.PbFieldType.OU3)
    ..aI(7, _omitFieldNames ? '' : 'readFailures',
        fieldType: $pb.PbFieldType.OU3)
    ..aOB(8, _omitFieldNames ? '' : 'testRunning')
    ..pPM<$0.MemsSensorInfo>(9, _omitFieldNames ? '' : 'sensors',
        subBuilder: $0.MemsSensorInfo.create)
    ..aOB(10, _omitFieldNames ? '' : 'inverted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseMemsStatusGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseMemsStatusGet copyWith(
          void Function(ResponseMemsStatusGet) updates) =>
      super.copyWith((message) => updates(message as ResponseMemsStatusGet))
          as ResponseMemsStatusGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseMemsStatusGet create() => ResponseMemsStatusGet._();
  @$core.override
  ResponseMemsStatusGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseMemsStatusGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseMemsStatusGet>(create);
  static ResponseMemsStatusGet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get count => $_getIZ(0);
  @$pb.TagNumber(1)
  set count($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get presentMask => $_getIZ(1);
  @$pb.TagNumber(2)
  set presentMask($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPresentMask() => $_has(1);
  @$pb.TagNumber(2)
  void clearPresentMask() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get baseAddress => $_getIZ(2);
  @$pb.TagNumber(3)
  set baseAddress($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBaseAddress() => $_has(2);
  @$pb.TagNumber(3)
  void clearBaseAddress() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get reversed => $_getBF(3);
  @$pb.TagNumber(4)
  set reversed($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReversed() => $_has(3);
  @$pb.TagNumber(4)
  void clearReversed() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get threshold => $_getIZ(4);
  @$pb.TagNumber(5)
  set threshold($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasThreshold() => $_has(4);
  @$pb.TagNumber(5)
  void clearThreshold() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get pollMs => $_getIZ(5);
  @$pb.TagNumber(6)
  set pollMs($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPollMs() => $_has(5);
  @$pb.TagNumber(6)
  void clearPollMs() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get readFailures => $_getIZ(6);
  @$pb.TagNumber(7)
  set readFailures($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasReadFailures() => $_has(6);
  @$pb.TagNumber(7)
  void clearReadFailures() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get testRunning => $_getBF(7);
  @$pb.TagNumber(8)
  set testRunning($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTestRunning() => $_has(7);
  @$pb.TagNumber(8)
  void clearTestRunning() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<$0.MemsSensorInfo> get sensors => $_getList(8);

  @$pb.TagNumber(10)
  $core.bool get inverted => $_getBF(9);
  @$pb.TagNumber(10)
  set inverted($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasInverted() => $_has(9);
  @$pb.TagNumber(10)
  void clearInverted() => $_clearField(10);
}

/// 811 - Fresh read of the selected sensors (raw + force)
class RequestMemsRead extends $pb.GeneratedMessage {
  factory RequestMemsRead({
    $core.int? sensorMask,
  }) {
    final result = create();
    if (sensorMask != null) result.sensorMask = sensorMask;
    return result;
  }

  RequestMemsRead._();

  factory RequestMemsRead.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestMemsRead.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestMemsRead',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'sensorMask', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestMemsRead clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestMemsRead copyWith(void Function(RequestMemsRead) updates) =>
      super.copyWith((message) => updates(message as RequestMemsRead))
          as RequestMemsRead;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestMemsRead create() => RequestMemsRead._();
  @$core.override
  RequestMemsRead createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestMemsRead getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestMemsRead>(create);
  static RequestMemsRead? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get sensorMask => $_getIZ(0);
  @$pb.TagNumber(1)
  set sensorMask($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSensorMask() => $_has(0);
  @$pb.TagNumber(1)
  void clearSensorMask() => $_clearField(1);
}

class ResponseMemsRead extends $pb.GeneratedMessage {
  factory ResponseMemsRead({
    $core.int? timestampMs,
    $core.Iterable<$0.MemsReading>? readings,
  }) {
    final result = create();
    if (timestampMs != null) result.timestampMs = timestampMs;
    if (readings != null) result.readings.addAll(readings);
    return result;
  }

  ResponseMemsRead._();

  factory ResponseMemsRead.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseMemsRead.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseMemsRead',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'timestampMs',
        fieldType: $pb.PbFieldType.OU3)
    ..pPM<$0.MemsReading>(2, _omitFieldNames ? '' : 'readings',
        subBuilder: $0.MemsReading.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseMemsRead clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseMemsRead copyWith(void Function(ResponseMemsRead) updates) =>
      super.copyWith((message) => updates(message as ResponseMemsRead))
          as ResponseMemsRead;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseMemsRead create() => ResponseMemsRead._();
  @$core.override
  ResponseMemsRead createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseMemsRead getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseMemsRead>(create);
  static ResponseMemsRead? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get timestampMs => $_getIZ(0);
  @$pb.TagNumber(1)
  set timestampMs($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTimestampMs() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestampMs() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$0.MemsReading> get readings => $_getList(1);
}

/// 812 - Re-zero the selected sensors. Press nothing while it runs.
class RequestMemsTare extends $pb.GeneratedMessage {
  factory RequestMemsTare({
    $core.int? sensorMask,
  }) {
    final result = create();
    if (sensorMask != null) result.sensorMask = sensorMask;
    return result;
  }

  RequestMemsTare._();

  factory RequestMemsTare.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestMemsTare.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestMemsTare',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'sensorMask', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestMemsTare clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestMemsTare copyWith(void Function(RequestMemsTare) updates) =>
      super.copyWith((message) => updates(message as RequestMemsTare))
          as RequestMemsTare;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestMemsTare create() => RequestMemsTare._();
  @$core.override
  RequestMemsTare createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestMemsTare getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestMemsTare>(create);
  static RequestMemsTare? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get sensorMask => $_getIZ(0);
  @$pb.TagNumber(1)
  set sensorMask($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSensorMask() => $_has(0);
  @$pb.TagNumber(1)
  void clearSensorMask() => $_clearField(1);
}

class ResponseMemsTare extends $pb.GeneratedMessage {
  factory ResponseMemsTare({
    $core.Iterable<$0.MemsSensorResult>? results,
  }) {
    final result = create();
    if (results != null) result.results.addAll(results);
    return result;
  }

  ResponseMemsTare._();

  factory ResponseMemsTare.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseMemsTare.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseMemsTare',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..pPM<$0.MemsSensorResult>(1, _omitFieldNames ? '' : 'results',
        subBuilder: $0.MemsSensorResult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseMemsTare clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseMemsTare copyWith(void Function(ResponseMemsTare) updates) =>
      super.copyWith((message) => updates(message as ResponseMemsTare))
          as ResponseMemsTare;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseMemsTare create() => ResponseMemsTare._();
  @$core.override
  ResponseMemsTare createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseMemsTare getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseMemsTare>(create);
  static ResponseMemsTare? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$0.MemsSensorResult> get results => $_getList(0);
}

/// 813 - Die temperature of the selected sensors (~60 ms)
class RequestMemsTempGet extends $pb.GeneratedMessage {
  factory RequestMemsTempGet({
    $core.int? sensorMask,
  }) {
    final result = create();
    if (sensorMask != null) result.sensorMask = sensorMask;
    return result;
  }

  RequestMemsTempGet._();

  factory RequestMemsTempGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestMemsTempGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestMemsTempGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'sensorMask', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestMemsTempGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestMemsTempGet copyWith(void Function(RequestMemsTempGet) updates) =>
      super.copyWith((message) => updates(message as RequestMemsTempGet))
          as RequestMemsTempGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestMemsTempGet create() => RequestMemsTempGet._();
  @$core.override
  RequestMemsTempGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestMemsTempGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestMemsTempGet>(create);
  static RequestMemsTempGet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get sensorMask => $_getIZ(0);
  @$pb.TagNumber(1)
  set sensorMask($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSensorMask() => $_has(0);
  @$pb.TagNumber(1)
  void clearSensorMask() => $_clearField(1);
}

class ResponseMemsTempGet extends $pb.GeneratedMessage {
  factory ResponseMemsTempGet({
    $core.Iterable<$0.MemsTemperature>? temperatures,
  }) {
    final result = create();
    if (temperatures != null) result.temperatures.addAll(temperatures);
    return result;
  }

  ResponseMemsTempGet._();

  factory ResponseMemsTempGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseMemsTempGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseMemsTempGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..pPM<$0.MemsTemperature>(1, _omitFieldNames ? '' : 'temperatures',
        subBuilder: $0.MemsTemperature.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseMemsTempGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseMemsTempGet copyWith(void Function(ResponseMemsTempGet) updates) =>
      super.copyWith((message) => updates(message as ResponseMemsTempGet))
          as ResponseMemsTempGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseMemsTempGet create() => ResponseMemsTempGet._();
  @$core.override
  ResponseMemsTempGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseMemsTempGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseMemsTempGet>(create);
  static ResponseMemsTempGet? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$0.MemsTemperature> get temperatures => $_getList(0);
}

/// 814 - Soft reset + re-init (default config) + tare. Absent sensors in the
/// mask are re-probed, so a re-seated strip can come back without a reboot.
/// Press nothing while it runs.
class RequestMemsReset extends $pb.GeneratedMessage {
  factory RequestMemsReset({
    $core.int? sensorMask,
  }) {
    final result = create();
    if (sensorMask != null) result.sensorMask = sensorMask;
    return result;
  }

  RequestMemsReset._();

  factory RequestMemsReset.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestMemsReset.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestMemsReset',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'sensorMask', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestMemsReset clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestMemsReset copyWith(void Function(RequestMemsReset) updates) =>
      super.copyWith((message) => updates(message as RequestMemsReset))
          as RequestMemsReset;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestMemsReset create() => RequestMemsReset._();
  @$core.override
  RequestMemsReset createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestMemsReset getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestMemsReset>(create);
  static RequestMemsReset? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get sensorMask => $_getIZ(0);
  @$pb.TagNumber(1)
  set sensorMask($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSensorMask() => $_has(0);
  @$pb.TagNumber(1)
  void clearSensorMask() => $_clearField(1);
}

class ResponseMemsReset extends $pb.GeneratedMessage {
  factory ResponseMemsReset({
    $core.int? presentMask,
    $core.Iterable<$0.MemsSensorResult>? results,
  }) {
    final result = create();
    if (presentMask != null) result.presentMask = presentMask;
    if (results != null) result.results.addAll(results);
    return result;
  }

  ResponseMemsReset._();

  factory ResponseMemsReset.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseMemsReset.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseMemsReset',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'presentMask',
        fieldType: $pb.PbFieldType.OU3)
    ..pPM<$0.MemsSensorResult>(2, _omitFieldNames ? '' : 'results',
        subBuilder: $0.MemsSensorResult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseMemsReset clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseMemsReset copyWith(void Function(ResponseMemsReset) updates) =>
      super.copyWith((message) => updates(message as ResponseMemsReset))
          as ResponseMemsReset;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseMemsReset create() => ResponseMemsReset._();
  @$core.override
  ResponseMemsReset createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseMemsReset getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseMemsReset>(create);
  static ResponseMemsReset? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get presentMask => $_getIZ(0);
  @$pb.TagNumber(1)
  set presentMask($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPresentMask() => $_has(0);
  @$pb.TagNumber(1)
  void clearPresentMask() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$0.MemsSensorResult> get results => $_getList(1);
}

/// 815 - Raw register access: read, or write then read back. Bench/debug use -
/// a bad write can stop a sensor until a reset (814).
class RequestMemsRegister extends $pb.GeneratedMessage {
  factory RequestMemsRegister({
    $core.int? index,
    $core.int? reg,
    $core.bool? write,
    $core.int? value,
  }) {
    final result = create();
    if (index != null) result.index = index;
    if (reg != null) result.reg = reg;
    if (write != null) result.write = write;
    if (value != null) result.value = value;
    return result;
  }

  RequestMemsRegister._();

  factory RequestMemsRegister.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestMemsRegister.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestMemsRegister',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'index', fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'reg', fieldType: $pb.PbFieldType.OU3)
    ..aOB(3, _omitFieldNames ? '' : 'write')
    ..aI(4, _omitFieldNames ? '' : 'value', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestMemsRegister clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestMemsRegister copyWith(void Function(RequestMemsRegister) updates) =>
      super.copyWith((message) => updates(message as RequestMemsRegister))
          as RequestMemsRegister;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestMemsRegister create() => RequestMemsRegister._();
  @$core.override
  RequestMemsRegister createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestMemsRegister getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestMemsRegister>(create);
  static RequestMemsRegister? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get index => $_getIZ(0);
  @$pb.TagNumber(1)
  set index($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIndex() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndex() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get reg => $_getIZ(1);
  @$pb.TagNumber(2)
  set reg($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReg() => $_has(1);
  @$pb.TagNumber(2)
  void clearReg() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get write => $_getBF(2);
  @$pb.TagNumber(3)
  set write($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWrite() => $_has(2);
  @$pb.TagNumber(3)
  void clearWrite() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get value => $_getIZ(3);
  @$pb.TagNumber(4)
  set value($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearValue() => $_clearField(4);
}

class ResponseMemsRegister extends $pb.GeneratedMessage {
  factory ResponseMemsRegister({
    $core.int? index,
    $core.int? reg,
    $core.int? value,
  }) {
    final result = create();
    if (index != null) result.index = index;
    if (reg != null) result.reg = reg;
    if (value != null) result.value = value;
    return result;
  }

  ResponseMemsRegister._();

  factory ResponseMemsRegister.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseMemsRegister.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseMemsRegister',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'index', fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'reg', fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'value', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseMemsRegister clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseMemsRegister copyWith(void Function(ResponseMemsRegister) updates) =>
      super.copyWith((message) => updates(message as ResponseMemsRegister))
          as ResponseMemsRegister;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseMemsRegister create() => ResponseMemsRegister._();
  @$core.override
  ResponseMemsRegister createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseMemsRegister getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseMemsRegister>(create);
  static ResponseMemsRegister? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get index => $_getIZ(0);
  @$pb.TagNumber(1)
  set index($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIndex() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndex() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get reg => $_getIZ(1);
  @$pb.TagNumber(2)
  set reg($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReg() => $_has(1);
  @$pb.TagNumber(2)
  void clearReg() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get value => $_getIZ(2);
  @$pb.TagNumber(3)
  set value($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearValue() => $_clearField(3);
}

/// 816 - Change the sampling configuration of the selected sensors (partial
/// update via has_ flags), then tare them (press nothing). RAM only: a reboot or
/// a reset (814) returns to the default (1000 sps, LPF on, cutoff code 2 = 21 Hz).
/// Read the applied config back with 810.
class RequestMemsConfigSet extends $pb.GeneratedMessage {
  factory RequestMemsConfigSet({
    $core.int? sensorMask,
    $core.bool? hasRateSps,
    $core.int? rateSps_3,
    $core.bool? hasLpfEnabled,
    $core.bool? lpfEnabled_5,
    $core.bool? hasLpfCutoff,
    $core.int? lpfCutoff_7,
  }) {
    final result = create();
    if (sensorMask != null) result.sensorMask = sensorMask;
    if (hasRateSps != null) result.hasRateSps = hasRateSps;
    if (rateSps_3 != null) result.rateSps_3 = rateSps_3;
    if (hasLpfEnabled != null) result.hasLpfEnabled = hasLpfEnabled;
    if (lpfEnabled_5 != null) result.lpfEnabled_5 = lpfEnabled_5;
    if (hasLpfCutoff != null) result.hasLpfCutoff = hasLpfCutoff;
    if (lpfCutoff_7 != null) result.lpfCutoff_7 = lpfCutoff_7;
    return result;
  }

  RequestMemsConfigSet._();

  factory RequestMemsConfigSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestMemsConfigSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestMemsConfigSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'sensorMask', fieldType: $pb.PbFieldType.OU3)
    ..aOB(2, _omitFieldNames ? '' : 'hasRateSps')
    ..aI(3, _omitFieldNames ? '' : 'rateSps', fieldType: $pb.PbFieldType.OU3)
    ..aOB(4, _omitFieldNames ? '' : 'hasLpfEnabled')
    ..aOB(5, _omitFieldNames ? '' : 'lpfEnabled')
    ..aOB(6, _omitFieldNames ? '' : 'hasLpfCutoff')
    ..aI(7, _omitFieldNames ? '' : 'lpfCutoff', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestMemsConfigSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestMemsConfigSet copyWith(void Function(RequestMemsConfigSet) updates) =>
      super.copyWith((message) => updates(message as RequestMemsConfigSet))
          as RequestMemsConfigSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestMemsConfigSet create() => RequestMemsConfigSet._();
  @$core.override
  RequestMemsConfigSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestMemsConfigSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestMemsConfigSet>(create);
  static RequestMemsConfigSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get sensorMask => $_getIZ(0);
  @$pb.TagNumber(1)
  set sensorMask($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSensorMask() => $_has(0);
  @$pb.TagNumber(1)
  void clearSensorMask() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get hasRateSps => $_getBF(1);
  @$pb.TagNumber(2)
  set hasRateSps($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHasRateSps() => $_has(1);
  @$pb.TagNumber(2)
  void clearHasRateSps() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get rateSps_3 => $_getIZ(2);
  @$pb.TagNumber(3)
  set rateSps_3($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRateSps_3() => $_has(2);
  @$pb.TagNumber(3)
  void clearRateSps_3() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get hasLpfEnabled => $_getBF(3);
  @$pb.TagNumber(4)
  set hasLpfEnabled($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHasLpfEnabled() => $_has(3);
  @$pb.TagNumber(4)
  void clearHasLpfEnabled() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get lpfEnabled_5 => $_getBF(4);
  @$pb.TagNumber(5)
  set lpfEnabled_5($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLpfEnabled_5() => $_has(4);
  @$pb.TagNumber(5)
  void clearLpfEnabled_5() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get hasLpfCutoff => $_getBF(5);
  @$pb.TagNumber(6)
  set hasLpfCutoff($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasHasLpfCutoff() => $_has(5);
  @$pb.TagNumber(6)
  void clearHasLpfCutoff() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get lpfCutoff_7 => $_getIZ(6);
  @$pb.TagNumber(7)
  set lpfCutoff_7($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLpfCutoff_7() => $_has(6);
  @$pb.TagNumber(7)
  void clearLpfCutoff_7() => $_clearField(7);
}

class ResponseMemsConfigSet extends $pb.GeneratedMessage {
  factory ResponseMemsConfigSet({
    $core.Iterable<$0.MemsSensorResult>? results,
  }) {
    final result = create();
    if (results != null) result.results.addAll(results);
    return result;
  }

  ResponseMemsConfigSet._();

  factory ResponseMemsConfigSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseMemsConfigSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseMemsConfigSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..pPM<$0.MemsSensorResult>(1, _omitFieldNames ? '' : 'results',
        subBuilder: $0.MemsSensorResult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseMemsConfigSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseMemsConfigSet copyWith(
          void Function(ResponseMemsConfigSet) updates) =>
      super.copyWith((message) => updates(message as ResponseMemsConfigSet))
          as ResponseMemsConfigSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseMemsConfigSet create() => ResponseMemsConfigSet._();
  @$core.override
  ResponseMemsConfigSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseMemsConfigSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseMemsConfigSet>(create);
  static ResponseMemsConfigSet? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$0.MemsSensorResult> get results => $_getList(0);
}

/// 817 - Start a test in the background. Sensing (positions, force, contact)
/// pauses until it ends; poll 818 for the result. One test at a time.
class RequestMemsTestStart extends $pb.GeneratedMessage {
  factory RequestMemsTestStart({
    $0.MemsTestType? type,
    $core.int? sensorMask,
    $core.int? sweeps,
    $core.int? durationMs,
    $core.int? rateSps,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (sensorMask != null) result.sensorMask = sensorMask;
    if (sweeps != null) result.sweeps = sweeps;
    if (durationMs != null) result.durationMs = durationMs;
    if (rateSps != null) result.rateSps = rateSps;
    return result;
  }

  RequestMemsTestStart._();

  factory RequestMemsTestStart.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestMemsTestStart.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestMemsTestStart',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aE<$0.MemsTestType>(1, _omitFieldNames ? '' : 'type',
        enumValues: $0.MemsTestType.values)
    ..aI(2, _omitFieldNames ? '' : 'sensorMask', fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'sweeps', fieldType: $pb.PbFieldType.OU3)
    ..aI(4, _omitFieldNames ? '' : 'durationMs', fieldType: $pb.PbFieldType.OU3)
    ..aI(5, _omitFieldNames ? '' : 'rateSps', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestMemsTestStart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestMemsTestStart copyWith(void Function(RequestMemsTestStart) updates) =>
      super.copyWith((message) => updates(message as RequestMemsTestStart))
          as RequestMemsTestStart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestMemsTestStart create() => RequestMemsTestStart._();
  @$core.override
  RequestMemsTestStart createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestMemsTestStart getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestMemsTestStart>(create);
  static RequestMemsTestStart? _defaultInstance;

  @$pb.TagNumber(1)
  $0.MemsTestType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type($0.MemsTestType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get sensorMask => $_getIZ(1);
  @$pb.TagNumber(2)
  set sensorMask($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSensorMask() => $_has(1);
  @$pb.TagNumber(2)
  void clearSensorMask() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get sweeps => $_getIZ(2);
  @$pb.TagNumber(3)
  set sweeps($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSweeps() => $_has(2);
  @$pb.TagNumber(3)
  void clearSweeps() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get durationMs => $_getIZ(3);
  @$pb.TagNumber(4)
  set durationMs($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDurationMs() => $_has(3);
  @$pb.TagNumber(4)
  void clearDurationMs() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get rateSps => $_getIZ(4);
  @$pb.TagNumber(5)
  set rateSps($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRateSps() => $_has(4);
  @$pb.TagNumber(5)
  void clearRateSps() => $_clearField(5);
}

class ResponseMemsTestStart extends $pb.GeneratedMessage {
  factory ResponseMemsTestStart({
    $0.MemsTestResult? result,
  }) {
    final result$ = create();
    if (result != null) result$.result = result;
    return result$;
  }

  ResponseMemsTestStart._();

  factory ResponseMemsTestStart.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseMemsTestStart.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseMemsTestStart',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.MemsTestResult>(1, _omitFieldNames ? '' : 'result',
        subBuilder: $0.MemsTestResult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseMemsTestStart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseMemsTestStart copyWith(
          void Function(ResponseMemsTestStart) updates) =>
      super.copyWith((message) => updates(message as ResponseMemsTestStart))
          as ResponseMemsTestStart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseMemsTestStart create() => ResponseMemsTestStart._();
  @$core.override
  ResponseMemsTestStart createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseMemsTestStart getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseMemsTestStart>(create);
  static ResponseMemsTestStart? _defaultInstance;

  @$pb.TagNumber(1)
  $0.MemsTestResult get result => $_getN(0);
  @$pb.TagNumber(1)
  set result($0.MemsTestResult value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.MemsTestResult ensureResult() => $_ensure(0);
}

/// 818 - Result of the running or last test. Allowed during a test.
class RequestMemsTestResultGet extends $pb.GeneratedMessage {
  factory RequestMemsTestResultGet() => create();

  RequestMemsTestResultGet._();

  factory RequestMemsTestResultGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestMemsTestResultGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestMemsTestResultGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestMemsTestResultGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestMemsTestResultGet copyWith(
          void Function(RequestMemsTestResultGet) updates) =>
      super.copyWith((message) => updates(message as RequestMemsTestResultGet))
          as RequestMemsTestResultGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestMemsTestResultGet create() => RequestMemsTestResultGet._();
  @$core.override
  RequestMemsTestResultGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestMemsTestResultGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestMemsTestResultGet>(create);
  static RequestMemsTestResultGet? _defaultInstance;
}

class ResponseMemsTestResultGet extends $pb.GeneratedMessage {
  factory ResponseMemsTestResultGet({
    $0.MemsTestResult? result,
  }) {
    final result$ = create();
    if (result != null) result$.result = result;
    return result$;
  }

  ResponseMemsTestResultGet._();

  factory ResponseMemsTestResultGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseMemsTestResultGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseMemsTestResultGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.MemsTestResult>(1, _omitFieldNames ? '' : 'result',
        subBuilder: $0.MemsTestResult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseMemsTestResultGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseMemsTestResultGet copyWith(
          void Function(ResponseMemsTestResultGet) updates) =>
      super.copyWith((message) => updates(message as ResponseMemsTestResultGet))
          as ResponseMemsTestResultGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseMemsTestResultGet create() => ResponseMemsTestResultGet._();
  @$core.override
  ResponseMemsTestResultGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseMemsTestResultGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseMemsTestResultGet>(create);
  static ResponseMemsTestResultGet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.MemsTestResult get result => $_getN(0);
  @$pb.TagNumber(1)
  set result($0.MemsTestResult value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.MemsTestResult ensureResult() => $_ensure(0);
}

/// End of 810-818 (WORK IN PROGRESS)
/// /////////////////////// Slider /////////////////////////
/// 840
class RequestSliderStrokeGet extends $pb.GeneratedMessage {
  factory RequestSliderStrokeGet() => create();

  RequestSliderStrokeGet._();

  factory RequestSliderStrokeGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestSliderStrokeGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestSliderStrokeGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSliderStrokeGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSliderStrokeGet copyWith(
          void Function(RequestSliderStrokeGet) updates) =>
      super.copyWith((message) => updates(message as RequestSliderStrokeGet))
          as RequestSliderStrokeGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestSliderStrokeGet create() => RequestSliderStrokeGet._();
  @$core.override
  RequestSliderStrokeGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestSliderStrokeGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestSliderStrokeGet>(create);
  static RequestSliderStrokeGet? _defaultInstance;
}

class ResponseSliderStrokeGet extends $pb.GeneratedMessage {
  factory ResponseSliderStrokeGet({
    $core.double? min,
    $core.double? max,
    $core.double? minAbsolute,
    $core.double? maxAbsolute,
  }) {
    final result = create();
    if (min != null) result.min = min;
    if (max != null) result.max = max;
    if (minAbsolute != null) result.minAbsolute = minAbsolute;
    if (maxAbsolute != null) result.maxAbsolute = maxAbsolute;
    return result;
  }

  ResponseSliderStrokeGet._();

  factory ResponseSliderStrokeGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseSliderStrokeGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseSliderStrokeGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'min', fieldType: $pb.PbFieldType.OF)
    ..aD(2, _omitFieldNames ? '' : 'max', fieldType: $pb.PbFieldType.OF)
    ..aD(3, _omitFieldNames ? '' : 'minAbsolute', fieldType: $pb.PbFieldType.OF)
    ..aD(4, _omitFieldNames ? '' : 'maxAbsolute', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSliderStrokeGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSliderStrokeGet copyWith(
          void Function(ResponseSliderStrokeGet) updates) =>
      super.copyWith((message) => updates(message as ResponseSliderStrokeGet))
          as ResponseSliderStrokeGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseSliderStrokeGet create() => ResponseSliderStrokeGet._();
  @$core.override
  ResponseSliderStrokeGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseSliderStrokeGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseSliderStrokeGet>(create);
  static ResponseSliderStrokeGet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get min => $_getN(0);
  @$pb.TagNumber(1)
  set min($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMin() => $_has(0);
  @$pb.TagNumber(1)
  void clearMin() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get max => $_getN(1);
  @$pb.TagNumber(2)
  set max($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMax() => $_has(1);
  @$pb.TagNumber(2)
  void clearMax() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get minAbsolute => $_getN(2);
  @$pb.TagNumber(3)
  set minAbsolute($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMinAbsolute() => $_has(2);
  @$pb.TagNumber(3)
  void clearMinAbsolute() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get maxAbsolute => $_getN(3);
  @$pb.TagNumber(4)
  set maxAbsolute($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMaxAbsolute() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxAbsolute() => $_clearField(4);
}

/// 841
class RequestSliderStrokeSet extends $pb.GeneratedMessage {
  factory RequestSliderStrokeSet({
    $core.double? min,
    $core.double? max,
  }) {
    final result = create();
    if (min != null) result.min = min;
    if (max != null) result.max = max;
    return result;
  }

  RequestSliderStrokeSet._();

  factory RequestSliderStrokeSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestSliderStrokeSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestSliderStrokeSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'min', fieldType: $pb.PbFieldType.OF)
    ..aD(2, _omitFieldNames ? '' : 'max', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSliderStrokeSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSliderStrokeSet copyWith(
          void Function(RequestSliderStrokeSet) updates) =>
      super.copyWith((message) => updates(message as RequestSliderStrokeSet))
          as RequestSliderStrokeSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestSliderStrokeSet create() => RequestSliderStrokeSet._();
  @$core.override
  RequestSliderStrokeSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestSliderStrokeSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestSliderStrokeSet>(create);
  static RequestSliderStrokeSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get min => $_getN(0);
  @$pb.TagNumber(1)
  set min($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMin() => $_has(0);
  @$pb.TagNumber(1)
  void clearMin() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get max => $_getN(1);
  @$pb.TagNumber(2)
  set max($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMax() => $_has(1);
  @$pb.TagNumber(2)
  void clearMax() => $_clearField(2);
}

/// Return to match the notification. If not the caller does not know the state of the absolute values
class ResponseSliderStrokeSet extends $pb.GeneratedMessage {
  factory ResponseSliderStrokeSet({
    $core.double? min,
    $core.double? max,
    $core.double? minAbsolute,
    $core.double? maxAbsolute,
  }) {
    final result = create();
    if (min != null) result.min = min;
    if (max != null) result.max = max;
    if (minAbsolute != null) result.minAbsolute = minAbsolute;
    if (maxAbsolute != null) result.maxAbsolute = maxAbsolute;
    return result;
  }

  ResponseSliderStrokeSet._();

  factory ResponseSliderStrokeSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseSliderStrokeSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseSliderStrokeSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'min', fieldType: $pb.PbFieldType.OF)
    ..aD(2, _omitFieldNames ? '' : 'max', fieldType: $pb.PbFieldType.OF)
    ..aD(3, _omitFieldNames ? '' : 'minAbsolute', fieldType: $pb.PbFieldType.OF)
    ..aD(4, _omitFieldNames ? '' : 'maxAbsolute', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSliderStrokeSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSliderStrokeSet copyWith(
          void Function(ResponseSliderStrokeSet) updates) =>
      super.copyWith((message) => updates(message as ResponseSliderStrokeSet))
          as ResponseSliderStrokeSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseSliderStrokeSet create() => ResponseSliderStrokeSet._();
  @$core.override
  ResponseSliderStrokeSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseSliderStrokeSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseSliderStrokeSet>(create);
  static ResponseSliderStrokeSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get min => $_getN(0);
  @$pb.TagNumber(1)
  set min($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMin() => $_has(0);
  @$pb.TagNumber(1)
  void clearMin() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get max => $_getN(1);
  @$pb.TagNumber(2)
  set max($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMax() => $_has(1);
  @$pb.TagNumber(2)
  void clearMax() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get minAbsolute => $_getN(2);
  @$pb.TagNumber(3)
  set minAbsolute($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMinAbsolute() => $_has(2);
  @$pb.TagNumber(3)
  void clearMinAbsolute() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get maxAbsolute => $_getN(3);
  @$pb.TagNumber(4)
  set maxAbsolute($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMaxAbsolute() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxAbsolute() => $_clearField(4);
}

/// 842
class RequestSliderStateGet extends $pb.GeneratedMessage {
  factory RequestSliderStateGet() => create();

  RequestSliderStateGet._();

  factory RequestSliderStateGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestSliderStateGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestSliderStateGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSliderStateGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSliderStateGet copyWith(
          void Function(RequestSliderStateGet) updates) =>
      super.copyWith((message) => updates(message as RequestSliderStateGet))
          as RequestSliderStateGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestSliderStateGet create() => RequestSliderStateGet._();
  @$core.override
  RequestSliderStateGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestSliderStateGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestSliderStateGet>(create);
  static RequestSliderStateGet? _defaultInstance;
}

class ResponseSliderStateGet extends $pb.GeneratedMessage {
  factory ResponseSliderStateGet({
    $core.double? position,
    $core.double? positionAbsolute,
    $core.double? motorTemp,
    $core.double? speedAbsolute,
    $core.bool? dir,
    $core.int? motorPosition,
    $core.int? motorTempAdcValue,
  }) {
    final result = create();
    if (position != null) result.position = position;
    if (positionAbsolute != null) result.positionAbsolute = positionAbsolute;
    if (motorTemp != null) result.motorTemp = motorTemp;
    if (speedAbsolute != null) result.speedAbsolute = speedAbsolute;
    if (dir != null) result.dir = dir;
    if (motorPosition != null) result.motorPosition = motorPosition;
    if (motorTempAdcValue != null) result.motorTempAdcValue = motorTempAdcValue;
    return result;
  }

  ResponseSliderStateGet._();

  factory ResponseSliderStateGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseSliderStateGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseSliderStateGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'position', fieldType: $pb.PbFieldType.OF)
    ..aD(2, _omitFieldNames ? '' : 'positionAbsolute',
        fieldType: $pb.PbFieldType.OF)
    ..aD(3, _omitFieldNames ? '' : 'motorTemp', fieldType: $pb.PbFieldType.OF)
    ..aD(4, _omitFieldNames ? '' : 'speedAbsolute',
        fieldType: $pb.PbFieldType.OF)
    ..aOB(5, _omitFieldNames ? '' : 'dir')
    ..aI(6, _omitFieldNames ? '' : 'motorPosition',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(7, _omitFieldNames ? '' : 'motorTempAdcValue',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSliderStateGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSliderStateGet copyWith(
          void Function(ResponseSliderStateGet) updates) =>
      super.copyWith((message) => updates(message as ResponseSliderStateGet))
          as ResponseSliderStateGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseSliderStateGet create() => ResponseSliderStateGet._();
  @$core.override
  ResponseSliderStateGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseSliderStateGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseSliderStateGet>(create);
  static ResponseSliderStateGet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get position => $_getN(0);
  @$pb.TagNumber(1)
  set position($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPosition() => $_has(0);
  @$pb.TagNumber(1)
  void clearPosition() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get positionAbsolute => $_getN(1);
  @$pb.TagNumber(2)
  set positionAbsolute($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPositionAbsolute() => $_has(1);
  @$pb.TagNumber(2)
  void clearPositionAbsolute() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get motorTemp => $_getN(2);
  @$pb.TagNumber(3)
  set motorTemp($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMotorTemp() => $_has(2);
  @$pb.TagNumber(3)
  void clearMotorTemp() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get speedAbsolute => $_getN(3);
  @$pb.TagNumber(4)
  set speedAbsolute($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSpeedAbsolute() => $_has(3);
  @$pb.TagNumber(4)
  void clearSpeedAbsolute() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get dir => $_getBF(4);
  @$pb.TagNumber(5)
  set dir($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDir() => $_has(4);
  @$pb.TagNumber(5)
  void clearDir() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get motorPosition => $_getIZ(5);
  @$pb.TagNumber(6)
  set motorPosition($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMotorPosition() => $_has(5);
  @$pb.TagNumber(6)
  void clearMotorPosition() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get motorTempAdcValue => $_getIZ(6);
  @$pb.TagNumber(7)
  set motorTempAdcValue($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMotorTempAdcValue() => $_has(6);
  @$pb.TagNumber(7)
  void clearMotorTempAdcValue() => $_clearField(7);
}

/// 843 - Moves the slider to the absolute position and reset encoder
/// Added in FW4.0.15
class RequestSliderCalibrate extends $pb.GeneratedMessage {
  factory RequestSliderCalibrate({
    $core.bool? goToStart,
  }) {
    final result = create();
    if (goToStart != null) result.goToStart = goToStart;
    return result;
  }

  RequestSliderCalibrate._();

  factory RequestSliderCalibrate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestSliderCalibrate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestSliderCalibrate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'goToStart')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSliderCalibrate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSliderCalibrate copyWith(
          void Function(RequestSliderCalibrate) updates) =>
      super.copyWith((message) => updates(message as RequestSliderCalibrate))
          as RequestSliderCalibrate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestSliderCalibrate create() => RequestSliderCalibrate._();
  @$core.override
  RequestSliderCalibrate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestSliderCalibrate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestSliderCalibrate>(create);
  static RequestSliderCalibrate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get goToStart => $_getBF(0);
  @$pb.TagNumber(1)
  set goToStart($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGoToStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearGoToStart() => $_clearField(1);
}

class ResponseSliderCalibrate extends $pb.GeneratedMessage {
  factory ResponseSliderCalibrate({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  ResponseSliderCalibrate._();

  factory ResponseSliderCalibrate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseSliderCalibrate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseSliderCalibrate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSliderCalibrate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSliderCalibrate copyWith(
          void Function(ResponseSliderCalibrate) updates) =>
      super.copyWith((message) => updates(message as ResponseSliderCalibrate))
          as ResponseSliderCalibrate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseSliderCalibrate create() => ResponseSliderCalibrate._();
  @$core.override
  ResponseSliderCalibrate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseSliderCalibrate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseSliderCalibrate>(create);
  static ResponseSliderCalibrate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

/// /////////////////////// Slide diagnostics (FW4.4) /////////////////////////
/// 844 - Arm a diagnostics capture (any channel: hall, regulator or hsp).
/// Buffers are PSRAM-only: non-PSRAM variants answer ERROR_FUNCTION_NOT_SUPPORTED
/// (capability hint: ResponseCapabilitiesGet.external_memory).
/// wrap=true keeps the newest records (rolling ring); wrap=false freezes the
/// capture when it is full. Restarting an armed capture resets it and bumps seq.
/// Added in FW4.4
class RequestSlideDiagStart extends $pb.GeneratedMessage {
  factory RequestSlideDiagStart({
    $0.SlideDiagChannel? channel,
    $core.int? maxRecords,
    $core.bool? wrap,
    $core.int? fieldMask,
    $core.int? minIntervalMs,
  }) {
    final result = create();
    if (channel != null) result.channel = channel;
    if (maxRecords != null) result.maxRecords = maxRecords;
    if (wrap != null) result.wrap = wrap;
    if (fieldMask != null) result.fieldMask = fieldMask;
    if (minIntervalMs != null) result.minIntervalMs = minIntervalMs;
    return result;
  }

  RequestSlideDiagStart._();

  factory RequestSlideDiagStart.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestSlideDiagStart.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestSlideDiagStart',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aE<$0.SlideDiagChannel>(1, _omitFieldNames ? '' : 'channel',
        enumValues: $0.SlideDiagChannel.values)
    ..aI(2, _omitFieldNames ? '' : 'maxRecords', fieldType: $pb.PbFieldType.OU3)
    ..aOB(3, _omitFieldNames ? '' : 'wrap')
    ..aI(4, _omitFieldNames ? '' : 'fieldMask', fieldType: $pb.PbFieldType.OU3)
    ..aI(5, _omitFieldNames ? '' : 'minIntervalMs',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSlideDiagStart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSlideDiagStart copyWith(
          void Function(RequestSlideDiagStart) updates) =>
      super.copyWith((message) => updates(message as RequestSlideDiagStart))
          as RequestSlideDiagStart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestSlideDiagStart create() => RequestSlideDiagStart._();
  @$core.override
  RequestSlideDiagStart createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestSlideDiagStart getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestSlideDiagStart>(create);
  static RequestSlideDiagStart? _defaultInstance;

  @$pb.TagNumber(1)
  $0.SlideDiagChannel get channel => $_getN(0);
  @$pb.TagNumber(1)
  set channel($0.SlideDiagChannel value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChannel() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannel() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get maxRecords => $_getIZ(1);
  @$pb.TagNumber(2)
  set maxRecords($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxRecords() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxRecords() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get wrap => $_getBF(2);
  @$pb.TagNumber(3)
  set wrap($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWrap() => $_has(2);
  @$pb.TagNumber(3)
  void clearWrap() => $_clearField(3);

  /// REGULATOR channel only: bitmask of record fields to capture, bit N =
  /// field N of the record in struct order (time is always kept). 0 = all
  /// fields. Fewer fields = smaller records = more records in the budget.
  /// Replaces any existing capture on that channel. Added in FW4.4.
  @$pb.TagNumber(4)
  $core.int get fieldMask => $_getIZ(3);
  @$pb.TagNumber(4)
  set fieldMask($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFieldMask() => $_has(3);
  @$pb.TagNumber(4)
  void clearFieldMask() => $_clearField(4);

  /// Rate reduction (2026-09-11). 0 = store every record (default). N > 0 = store the
  /// "plain" records at most once per N ms: on the REGULATOR channel a plain record is a
  /// run-phase tick that follows another run-phase tick; on the HALL channel a plain
  /// edge in the same direction as the previous one. Everything else is ALWAYS stored
  /// regardless of N: every turn-phase regulator record (coast brake, reverse brake,
  /// backlash creep, launch, turn done, overspeed stop), the FIRST run record after a
  /// turn (the launch tick), every hall record that is not a plain edge, and every hall
  /// direction flip. What dropped regulator ticks did is not lost: their trim_adjust
  /// values are summed into and their flags OR-ed into the next stored record. The
  /// hall sequence number exposes dropped edges. Ignored on the HSP channel. Status
  /// reports the interval and the dropped count. Use it to make a capture (and its
  /// download) cover N-10x more time at the cost of run-phase resolution.
  @$pb.TagNumber(5)
  $core.int get minIntervalMs => $_getIZ(4);
  @$pb.TagNumber(5)
  set minIntervalMs($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMinIntervalMs() => $_has(4);
  @$pb.TagNumber(5)
  void clearMinIntervalMs() => $_clearField(5);
}

class ResponseSlideDiagStart extends $pb.GeneratedMessage {
  factory ResponseSlideDiagStart({
    $core.int? capacityRecords,
    $core.int? entrySize,
    $core.int? formatVersion,
    $core.int? seq,
    $core.int? fieldMask,
    $core.int? minIntervalMs,
  }) {
    final result = create();
    if (capacityRecords != null) result.capacityRecords = capacityRecords;
    if (entrySize != null) result.entrySize = entrySize;
    if (formatVersion != null) result.formatVersion = formatVersion;
    if (seq != null) result.seq = seq;
    if (fieldMask != null) result.fieldMask = fieldMask;
    if (minIntervalMs != null) result.minIntervalMs = minIntervalMs;
    return result;
  }

  ResponseSlideDiagStart._();

  factory ResponseSlideDiagStart.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseSlideDiagStart.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseSlideDiagStart',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'capacityRecords',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'entrySize', fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'formatVersion',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(4, _omitFieldNames ? '' : 'seq', fieldType: $pb.PbFieldType.OU3)
    ..aI(5, _omitFieldNames ? '' : 'fieldMask', fieldType: $pb.PbFieldType.OU3)
    ..aI(6, _omitFieldNames ? '' : 'minIntervalMs',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSlideDiagStart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSlideDiagStart copyWith(
          void Function(ResponseSlideDiagStart) updates) =>
      super.copyWith((message) => updates(message as ResponseSlideDiagStart))
          as ResponseSlideDiagStart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseSlideDiagStart create() => ResponseSlideDiagStart._();
  @$core.override
  ResponseSlideDiagStart createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseSlideDiagStart getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseSlideDiagStart>(create);
  static ResponseSlideDiagStart? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get capacityRecords => $_getIZ(0);
  @$pb.TagNumber(1)
  set capacityRecords($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCapacityRecords() => $_has(0);
  @$pb.TagNumber(1)
  void clearCapacityRecords() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get entrySize => $_getIZ(1);
  @$pb.TagNumber(2)
  set entrySize($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEntrySize() => $_has(1);
  @$pb.TagNumber(2)
  void clearEntrySize() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get formatVersion => $_getIZ(2);
  @$pb.TagNumber(3)
  set formatVersion($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFormatVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearFormatVersion() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get seq => $_getIZ(3);
  @$pb.TagNumber(4)
  set seq($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSeq() => $_has(3);
  @$pb.TagNumber(4)
  void clearSeq() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get fieldMask => $_getIZ(4);
  @$pb.TagNumber(5)
  set fieldMask($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFieldMask() => $_has(4);
  @$pb.TagNumber(5)
  void clearFieldMask() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get minIntervalMs => $_getIZ(5);
  @$pb.TagNumber(6)
  set minIntervalMs($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMinIntervalMs() => $_has(5);
  @$pb.TagNumber(6)
  void clearMinIntervalMs() => $_clearField(6);
}

/// 845
/// Added in FW4.4
class RequestSlideDiagStatus extends $pb.GeneratedMessage {
  factory RequestSlideDiagStatus({
    $0.SlideDiagChannel? channel,
  }) {
    final result = create();
    if (channel != null) result.channel = channel;
    return result;
  }

  RequestSlideDiagStatus._();

  factory RequestSlideDiagStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestSlideDiagStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestSlideDiagStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aE<$0.SlideDiagChannel>(1, _omitFieldNames ? '' : 'channel',
        enumValues: $0.SlideDiagChannel.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSlideDiagStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSlideDiagStatus copyWith(
          void Function(RequestSlideDiagStatus) updates) =>
      super.copyWith((message) => updates(message as RequestSlideDiagStatus))
          as RequestSlideDiagStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestSlideDiagStatus create() => RequestSlideDiagStatus._();
  @$core.override
  RequestSlideDiagStatus createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestSlideDiagStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestSlideDiagStatus>(create);
  static RequestSlideDiagStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $0.SlideDiagChannel get channel => $_getN(0);
  @$pb.TagNumber(1)
  set channel($0.SlideDiagChannel value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChannel() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannel() => $_clearField(1);
}

class ResponseSlideDiagStatus extends $pb.GeneratedMessage {
  factory ResponseSlideDiagStatus({
    $0.SlideDiagState? state,
    $core.bool? wrap,
    $core.bool? wrapped,
    $core.bool? full,
    $core.int? entrySize,
    $core.int? formatVersion,
    $core.int? capacityRecords,
    $core.int? usedRecords,
    $core.int? totalRecords,
    $core.int? seq,
    $core.int? fieldMask,
    $core.int? minIntervalMs,
    $core.int? droppedRecords,
  }) {
    final result = create();
    if (state != null) result.state = state;
    if (wrap != null) result.wrap = wrap;
    if (wrapped != null) result.wrapped = wrapped;
    if (full != null) result.full = full;
    if (entrySize != null) result.entrySize = entrySize;
    if (formatVersion != null) result.formatVersion = formatVersion;
    if (capacityRecords != null) result.capacityRecords = capacityRecords;
    if (usedRecords != null) result.usedRecords = usedRecords;
    if (totalRecords != null) result.totalRecords = totalRecords;
    if (seq != null) result.seq = seq;
    if (fieldMask != null) result.fieldMask = fieldMask;
    if (minIntervalMs != null) result.minIntervalMs = minIntervalMs;
    if (droppedRecords != null) result.droppedRecords = droppedRecords;
    return result;
  }

  ResponseSlideDiagStatus._();

  factory ResponseSlideDiagStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseSlideDiagStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseSlideDiagStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aE<$0.SlideDiagState>(1, _omitFieldNames ? '' : 'state',
        enumValues: $0.SlideDiagState.values)
    ..aOB(2, _omitFieldNames ? '' : 'wrap')
    ..aOB(3, _omitFieldNames ? '' : 'wrapped')
    ..aOB(4, _omitFieldNames ? '' : 'full')
    ..aI(5, _omitFieldNames ? '' : 'entrySize', fieldType: $pb.PbFieldType.OU3)
    ..aI(6, _omitFieldNames ? '' : 'formatVersion',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(7, _omitFieldNames ? '' : 'capacityRecords',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(8, _omitFieldNames ? '' : 'usedRecords',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(9, _omitFieldNames ? '' : 'totalRecords',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(10, _omitFieldNames ? '' : 'seq', fieldType: $pb.PbFieldType.OU3)
    ..aI(11, _omitFieldNames ? '' : 'fieldMask', fieldType: $pb.PbFieldType.OU3)
    ..aI(12, _omitFieldNames ? '' : 'minIntervalMs',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(13, _omitFieldNames ? '' : 'droppedRecords',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSlideDiagStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSlideDiagStatus copyWith(
          void Function(ResponseSlideDiagStatus) updates) =>
      super.copyWith((message) => updates(message as ResponseSlideDiagStatus))
          as ResponseSlideDiagStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseSlideDiagStatus create() => ResponseSlideDiagStatus._();
  @$core.override
  ResponseSlideDiagStatus createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseSlideDiagStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseSlideDiagStatus>(create);
  static ResponseSlideDiagStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $0.SlideDiagState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.SlideDiagState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get wrap => $_getBF(1);
  @$pb.TagNumber(2)
  set wrap($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWrap() => $_has(1);
  @$pb.TagNumber(2)
  void clearWrap() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get wrapped => $_getBF(2);
  @$pb.TagNumber(3)
  set wrapped($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWrapped() => $_has(2);
  @$pb.TagNumber(3)
  void clearWrapped() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get full => $_getBF(3);
  @$pb.TagNumber(4)
  set full($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFull() => $_has(3);
  @$pb.TagNumber(4)
  void clearFull() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get entrySize => $_getIZ(4);
  @$pb.TagNumber(5)
  set entrySize($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEntrySize() => $_has(4);
  @$pb.TagNumber(5)
  void clearEntrySize() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get formatVersion => $_getIZ(5);
  @$pb.TagNumber(6)
  set formatVersion($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFormatVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearFormatVersion() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get capacityRecords => $_getIZ(6);
  @$pb.TagNumber(7)
  set capacityRecords($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCapacityRecords() => $_has(6);
  @$pb.TagNumber(7)
  void clearCapacityRecords() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get usedRecords => $_getIZ(7);
  @$pb.TagNumber(8)
  set usedRecords($core.int value) => $_setUnsignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUsedRecords() => $_has(7);
  @$pb.TagNumber(8)
  void clearUsedRecords() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get totalRecords => $_getIZ(8);
  @$pb.TagNumber(9)
  set totalRecords($core.int value) => $_setUnsignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTotalRecords() => $_has(8);
  @$pb.TagNumber(9)
  void clearTotalRecords() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get seq => $_getIZ(9);
  @$pb.TagNumber(10)
  set seq($core.int value) => $_setUnsignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasSeq() => $_has(9);
  @$pb.TagNumber(10)
  void clearSeq() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get fieldMask => $_getIZ(10);
  @$pb.TagNumber(11)
  set fieldMask($core.int value) => $_setUnsignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasFieldMask() => $_has(10);
  @$pb.TagNumber(11)
  void clearFieldMask() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get minIntervalMs => $_getIZ(11);
  @$pb.TagNumber(12)
  set minIntervalMs($core.int value) => $_setUnsignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasMinIntervalMs() => $_has(11);
  @$pb.TagNumber(12)
  void clearMinIntervalMs() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get droppedRecords => $_getIZ(12);
  @$pb.TagNumber(13)
  set droppedRecords($core.int value) => $_setUnsignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasDroppedRecords() => $_has(12);
  @$pb.TagNumber(13)
  void clearDroppedRecords() => $_clearField(13);
}

/// 846 - Chronological ranged read of a FROZEN capture (SlideDiagStop first;
/// reading a running capture returns an error). Client recipe: fetch
/// used_records via SlideDiagStatus, then loop first_record += record_count,
/// sizing max_records so record_count * entry_size stays under the transport
/// frame (min(ws_buffer_size, 4096) - 64 bytes on WS, ~400 bytes on BLE).
/// The seq in every response of one download MUST match; if it changes the
/// capture was restarted - discard the data and start over.
/// Added in FW4.4
class RequestSlideDiagRead extends $pb.GeneratedMessage {
  factory RequestSlideDiagRead({
    $0.SlideDiagChannel? channel,
    $core.int? firstRecord,
    $core.int? maxRecords,
  }) {
    final result = create();
    if (channel != null) result.channel = channel;
    if (firstRecord != null) result.firstRecord = firstRecord;
    if (maxRecords != null) result.maxRecords = maxRecords;
    return result;
  }

  RequestSlideDiagRead._();

  factory RequestSlideDiagRead.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestSlideDiagRead.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestSlideDiagRead',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aE<$0.SlideDiagChannel>(1, _omitFieldNames ? '' : 'channel',
        enumValues: $0.SlideDiagChannel.values)
    ..aI(2, _omitFieldNames ? '' : 'firstRecord',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'maxRecords', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSlideDiagRead clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSlideDiagRead copyWith(void Function(RequestSlideDiagRead) updates) =>
      super.copyWith((message) => updates(message as RequestSlideDiagRead))
          as RequestSlideDiagRead;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestSlideDiagRead create() => RequestSlideDiagRead._();
  @$core.override
  RequestSlideDiagRead createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestSlideDiagRead getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestSlideDiagRead>(create);
  static RequestSlideDiagRead? _defaultInstance;

  @$pb.TagNumber(1)
  $0.SlideDiagChannel get channel => $_getN(0);
  @$pb.TagNumber(1)
  set channel($0.SlideDiagChannel value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChannel() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannel() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get firstRecord => $_getIZ(1);
  @$pb.TagNumber(2)
  set firstRecord($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFirstRecord() => $_has(1);
  @$pb.TagNumber(2)
  void clearFirstRecord() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get maxRecords => $_getIZ(2);
  @$pb.TagNumber(3)
  set maxRecords($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMaxRecords() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxRecords() => $_clearField(3);
}

class ResponseSlideDiagRead extends $pb.GeneratedMessage {
  factory ResponseSlideDiagRead({
    $core.List<$core.int>? data,
    $core.int? recordCount,
    $core.int? usedRecords,
    $core.int? seq,
  }) {
    final result = create();
    if (data != null) result.data = data;
    if (recordCount != null) result.recordCount = recordCount;
    if (usedRecords != null) result.usedRecords = usedRecords;
    if (seq != null) result.seq = seq;
    return result;
  }

  ResponseSlideDiagRead._();

  factory ResponseSlideDiagRead.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseSlideDiagRead.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseSlideDiagRead',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..aI(2, _omitFieldNames ? '' : 'recordCount',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'usedRecords',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(4, _omitFieldNames ? '' : 'seq', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSlideDiagRead clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSlideDiagRead copyWith(
          void Function(ResponseSlideDiagRead) updates) =>
      super.copyWith((message) => updates(message as ResponseSlideDiagRead))
          as ResponseSlideDiagRead;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseSlideDiagRead create() => ResponseSlideDiagRead._();
  @$core.override
  ResponseSlideDiagRead createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseSlideDiagRead getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseSlideDiagRead>(create);
  static ResponseSlideDiagRead? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get recordCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set recordCount($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecordCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecordCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get usedRecords => $_getIZ(2);
  @$pb.TagNumber(3)
  set usedRecords($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUsedRecords() => $_has(2);
  @$pb.TagNumber(3)
  void clearUsedRecords() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get seq => $_getIZ(3);
  @$pb.TagNumber(4)
  set seq($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSeq() => $_has(3);
  @$pb.TagNumber(4)
  void clearSeq() => $_clearField(4);
}

/// 847 - Freeze the capture so it can be read; free=true also releases the
/// buffer. Blank response.
/// Added in FW4.4
class RequestSlideDiagStop extends $pb.GeneratedMessage {
  factory RequestSlideDiagStop({
    $0.SlideDiagChannel? channel,
    $core.bool? free,
  }) {
    final result = create();
    if (channel != null) result.channel = channel;
    if (free != null) result.free = free;
    return result;
  }

  RequestSlideDiagStop._();

  factory RequestSlideDiagStop.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestSlideDiagStop.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestSlideDiagStop',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aE<$0.SlideDiagChannel>(1, _omitFieldNames ? '' : 'channel',
        enumValues: $0.SlideDiagChannel.values)
    ..aOB(2, _omitFieldNames ? '' : 'free')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSlideDiagStop clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSlideDiagStop copyWith(void Function(RequestSlideDiagStop) updates) =>
      super.copyWith((message) => updates(message as RequestSlideDiagStop))
          as RequestSlideDiagStop;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestSlideDiagStop create() => RequestSlideDiagStop._();
  @$core.override
  RequestSlideDiagStop createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestSlideDiagStop getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestSlideDiagStop>(create);
  static RequestSlideDiagStop? _defaultInstance;

  @$pb.TagNumber(1)
  $0.SlideDiagChannel get channel => $_getN(0);
  @$pb.TagNumber(1)
  set channel($0.SlideDiagChannel value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChannel() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannel() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get free => $_getBF(1);
  @$pb.TagNumber(2)
  set free($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFree() => $_has(1);
  @$pb.TagNumber(2)
  void clearFree() => $_clearField(2);
}

/// 848 - Per ring-state Hall distance calibration (6 multipliers).
/// Added in FW4.4
class RequestHallCalibrationGet extends $pb.GeneratedMessage {
  factory RequestHallCalibrationGet() => create();

  RequestHallCalibrationGet._();

  factory RequestHallCalibrationGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHallCalibrationGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHallCalibrationGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHallCalibrationGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHallCalibrationGet copyWith(
          void Function(RequestHallCalibrationGet) updates) =>
      super.copyWith((message) => updates(message as RequestHallCalibrationGet))
          as RequestHallCalibrationGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHallCalibrationGet create() => RequestHallCalibrationGet._();
  @$core.override
  RequestHallCalibrationGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHallCalibrationGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHallCalibrationGet>(create);
  static RequestHallCalibrationGet? _defaultInstance;
}

class ResponseHallCalibrationGet extends $pb.GeneratedMessage {
  factory ResponseHallCalibrationGet({
    $core.Iterable<$core.double>? scale,
    $core.bool? stored,
  }) {
    final result = create();
    if (scale != null) result.scale.addAll(scale);
    if (stored != null) result.stored = stored;
    return result;
  }

  ResponseHallCalibrationGet._();

  factory ResponseHallCalibrationGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHallCalibrationGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHallCalibrationGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..p<$core.double>(1, _omitFieldNames ? '' : 'scale', $pb.PbFieldType.KF)
    ..aOB(2, _omitFieldNames ? '' : 'stored')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHallCalibrationGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHallCalibrationGet copyWith(
          void Function(ResponseHallCalibrationGet) updates) =>
      super.copyWith(
              (message) => updates(message as ResponseHallCalibrationGet))
          as ResponseHallCalibrationGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHallCalibrationGet create() => ResponseHallCalibrationGet._();
  @$core.override
  ResponseHallCalibrationGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHallCalibrationGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHallCalibrationGet>(create);
  static ResponseHallCalibrationGet? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.double> get scale => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get stored => $_getBF(1);
  @$pb.TagNumber(2)
  set stored($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStored() => $_has(1);
  @$pb.TagNumber(2)
  void clearStored() => $_clearField(2);
}

/// 850 - Push-stream a FROZEN capture as NotificationSlideDiagData chunks
/// (SlideDiagStop first). Much faster than looping 846 on high-latency links:
/// the device sends every chunk back to back, in order, only to the transport
/// this request came in on, then the response arrives LAST as the completion
/// summary (mirrors the RequestConsoleCmd chunk flow).
/// CAUTION - accepted design limitation: the device's single RPC handler is
/// busy for the stream's whole duration (seconds on WS, minutes for a large
/// capture on BLE). Every other request queues behind it (dropped if the
/// queue overflows) - including RequestHspAdd, so NEVER stream during live
/// playback or the point feed starves; download while playing with chunked
/// 846 reads instead (each read is a quick call that interleaves fine).
/// Intended use: solo tuning sessions, motion stopped, client waiting for
/// the completion response. Chunks carry first_record + record_count,
/// so a lost chunk is a visible hole in the first_record sequence: re-fetch
/// just that range with 846. A capture restart mid-stream (seq change) aborts
/// the stream early - always check response.seq against the chunks'. Records
/// are packed per the channel's field_mask - parse exactly like 846 data.
/// Added in FW4.4
class RequestSlideDiagStream extends $pb.GeneratedMessage {
  factory RequestSlideDiagStream({
    $0.SlideDiagChannel? channel,
    $core.int? firstRecord,
    $core.int? maxRecords,
    $core.int? maxChunkBytes,
  }) {
    final result = create();
    if (channel != null) result.channel = channel;
    if (firstRecord != null) result.firstRecord = firstRecord;
    if (maxRecords != null) result.maxRecords = maxRecords;
    if (maxChunkBytes != null) result.maxChunkBytes = maxChunkBytes;
    return result;
  }

  RequestSlideDiagStream._();

  factory RequestSlideDiagStream.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestSlideDiagStream.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestSlideDiagStream',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aE<$0.SlideDiagChannel>(1, _omitFieldNames ? '' : 'channel',
        enumValues: $0.SlideDiagChannel.values)
    ..aI(2, _omitFieldNames ? '' : 'firstRecord',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'maxRecords', fieldType: $pb.PbFieldType.OU3)
    ..aI(4, _omitFieldNames ? '' : 'maxChunkBytes',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSlideDiagStream clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSlideDiagStream copyWith(
          void Function(RequestSlideDiagStream) updates) =>
      super.copyWith((message) => updates(message as RequestSlideDiagStream))
          as RequestSlideDiagStream;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestSlideDiagStream create() => RequestSlideDiagStream._();
  @$core.override
  RequestSlideDiagStream createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestSlideDiagStream getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestSlideDiagStream>(create);
  static RequestSlideDiagStream? _defaultInstance;

  @$pb.TagNumber(1)
  $0.SlideDiagChannel get channel => $_getN(0);
  @$pb.TagNumber(1)
  set channel($0.SlideDiagChannel value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChannel() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannel() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get firstRecord => $_getIZ(1);
  @$pb.TagNumber(2)
  set firstRecord($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFirstRecord() => $_has(1);
  @$pb.TagNumber(2)
  void clearFirstRecord() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get maxRecords => $_getIZ(2);
  @$pb.TagNumber(3)
  set maxRecords($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMaxRecords() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxRecords() => $_clearField(3);

  /// Cap on the record payload (data bytes) per NotificationSlideDiagData chunk. The firmware
  /// clamps it to the transport default (BLE 400 B, websocket 3600 B) - a request can only make
  /// chunks SMALLER, never larger. 0 = transport default. Use it when the link is tighter than
  /// the default assumes, above all a BLE connection that negotiated an ATT MTU below the 512
  /// the firmware asks for: a notification larger than MTU-3 arrives TRUNCATED (no error), so
  /// keep max_chunk_bytes + ~45 B of protobuf envelope under MTU-3. Records per chunk =
  /// max_chunk_bytes / entry_size, floored at 1. Added in FW4.4
  @$pb.TagNumber(4)
  $core.int get maxChunkBytes => $_getIZ(3);
  @$pb.TagNumber(4)
  set maxChunkBytes($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMaxChunkBytes() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxChunkBytes() => $_clearField(4);
}

class ResponseSlideDiagStream extends $pb.GeneratedMessage {
  factory ResponseSlideDiagStream({
    $core.int? recordCount,
    $core.int? chunks,
    $core.int? entrySize,
    $core.int? formatVersion,
    $core.int? seq,
    $core.int? fieldMask,
  }) {
    final result = create();
    if (recordCount != null) result.recordCount = recordCount;
    if (chunks != null) result.chunks = chunks;
    if (entrySize != null) result.entrySize = entrySize;
    if (formatVersion != null) result.formatVersion = formatVersion;
    if (seq != null) result.seq = seq;
    if (fieldMask != null) result.fieldMask = fieldMask;
    return result;
  }

  ResponseSlideDiagStream._();

  factory ResponseSlideDiagStream.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseSlideDiagStream.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseSlideDiagStream',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'recordCount',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'chunks', fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'entrySize', fieldType: $pb.PbFieldType.OU3)
    ..aI(4, _omitFieldNames ? '' : 'formatVersion',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(5, _omitFieldNames ? '' : 'seq', fieldType: $pb.PbFieldType.OU3)
    ..aI(6, _omitFieldNames ? '' : 'fieldMask', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSlideDiagStream clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSlideDiagStream copyWith(
          void Function(ResponseSlideDiagStream) updates) =>
      super.copyWith((message) => updates(message as ResponseSlideDiagStream))
          as ResponseSlideDiagStream;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseSlideDiagStream create() => ResponseSlideDiagStream._();
  @$core.override
  ResponseSlideDiagStream createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseSlideDiagStream getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseSlideDiagStream>(create);
  static ResponseSlideDiagStream? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get recordCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set recordCount($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get chunks => $_getIZ(1);
  @$pb.TagNumber(2)
  set chunks($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChunks() => $_has(1);
  @$pb.TagNumber(2)
  void clearChunks() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get entrySize => $_getIZ(2);
  @$pb.TagNumber(3)
  set entrySize($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEntrySize() => $_has(2);
  @$pb.TagNumber(3)
  void clearEntrySize() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get formatVersion => $_getIZ(3);
  @$pb.TagNumber(4)
  set formatVersion($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFormatVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearFormatVersion() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get seq => $_getIZ(4);
  @$pb.TagNumber(5)
  set seq($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSeq() => $_has(4);
  @$pb.TagNumber(5)
  void clearSeq() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get fieldMask => $_getIZ(5);
  @$pb.TagNumber(6)
  set fieldMask($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFieldMask() => $_has(5);
  @$pb.TagNumber(6)
  void clearFieldMask() => $_clearField(6);
}

/// 851 - Windowed speed/tuning telemetry, split per drive direction (the two
/// directions have separate feedforward/tuning, so these are the per-regulator
/// report cards). Averages cover regulator ticks (~1 kHz) while DRIVING; a
/// bucket with samples == 0 means the slide did not drive that way during the
/// window. seq increments once per completed window - poll Get, or subscribe
/// with 852 to get one NotificationSpeedStats per window.
/// Added in FW4.4
class RequestSpeedStatsGet extends $pb.GeneratedMessage {
  factory RequestSpeedStatsGet() => create();

  RequestSpeedStatsGet._();

  factory RequestSpeedStatsGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestSpeedStatsGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestSpeedStatsGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSpeedStatsGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSpeedStatsGet copyWith(void Function(RequestSpeedStatsGet) updates) =>
      super.copyWith((message) => updates(message as RequestSpeedStatsGet))
          as RequestSpeedStatsGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestSpeedStatsGet create() => RequestSpeedStatsGet._();
  @$core.override
  RequestSpeedStatsGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestSpeedStatsGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestSpeedStatsGet>(create);
  static RequestSpeedStatsGet? _defaultInstance;
}

class ResponseSpeedStatsGet extends $pb.GeneratedMessage {
  factory ResponseSpeedStatsGet({
    $0.SpeedStats? stats,
    $core.bool? notifications,
    $core.bool? notificationsMine,
  }) {
    final result = create();
    if (stats != null) result.stats = stats;
    if (notifications != null) result.notifications = notifications;
    if (notificationsMine != null) result.notificationsMine = notificationsMine;
    return result;
  }

  ResponseSpeedStatsGet._();

  factory ResponseSpeedStatsGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseSpeedStatsGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseSpeedStatsGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.SpeedStats>(1, _omitFieldNames ? '' : 'stats',
        subBuilder: $0.SpeedStats.create)
    ..aOB(2, _omitFieldNames ? '' : 'notifications')
    ..aOB(3, _omitFieldNames ? '' : 'notificationsMine')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSpeedStatsGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSpeedStatsGet copyWith(
          void Function(ResponseSpeedStatsGet) updates) =>
      super.copyWith((message) => updates(message as ResponseSpeedStatsGet))
          as ResponseSpeedStatsGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseSpeedStatsGet create() => ResponseSpeedStatsGet._();
  @$core.override
  ResponseSpeedStatsGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseSpeedStatsGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseSpeedStatsGet>(create);
  static ResponseSpeedStatsGet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.SpeedStats get stats => $_getN(0);
  @$pb.TagNumber(1)
  set stats($0.SpeedStats value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStats() => $_has(0);
  @$pb.TagNumber(1)
  void clearStats() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.SpeedStats ensureStats() => $_ensure(0);

  ///
  /// Subscription state, returned so a client can render its "stream" toggle
  /// truthfully after a reconnect / page reload, when its own memory of what
  /// it set is unreliable (same idea as 802 for the sensor stream).
  /// How the subscription works on the device:
  /// - There is exactly ONE subscriber slot. It records which TRANSPORT
  /// (BLE or WebSocket) asked for the stream, not which connection or
  /// client. Every client on that transport receives the notifications,
  /// and every one of them sees notifications_mine=true.
  /// - Ownership is advisory, not enforced. Any client on any transport may
  /// call 852 at any time: notifications=true takes the slot over,
  /// notifications=false clears it - even if another transport was
  /// streaming. The device never refuses, so a slot can never get stuck.
  /// - The slot is NOT released on disconnect. If the subscriber vanishes
  /// the device drops it after 5 consecutive failed sends, i.e. up to
  /// 5 windows (5 x window_ms, worst case 5 minutes at the 60 s maximum).
  /// Until then a Get from another transport still reports
  /// notifications=true / notifications_mine=false.
  /// How to use the two flags:
  /// notifications=false                         nobody is streaming; toggle OFF
  /// notifications=true, notifications_mine=true  my transport is streaming; toggle ON
  /// notifications=true, notifications_mine=false another transport is streaming;
  /// show that state instead of
  /// silently taking the slot -
  /// the user should choose.
  /// Added in FW4.4
  @$pb.TagNumber(2)
  $core.bool get notifications => $_getBF(1);
  @$pb.TagNumber(2)
  set notifications($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNotifications() => $_has(1);
  @$pb.TagNumber(2)
  void clearNotifications() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get notificationsMine => $_getBF(2);
  @$pb.TagNumber(3)
  set notificationsMine($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNotificationsMine() => $_has(2);
  @$pb.TagNumber(3)
  void clearNotificationsMine() => $_clearField(3);
}

/// 852 - Configure the averaging window and/or subscribe to per-window
/// NotificationSpeedStats on THIS transport (the window is also the
/// notification period, so window_ms sets the message rate). window_ms 0
/// keeps the current window; otherwise clamped to 100-60000 ms.
/// One subscriber slot, keyed by transport (see ResponseSpeedStatsGet for
/// the full rules): notifications=true replaces whoever held the slot,
/// notifications=false unsubscribes whoever held it. Neither is refused.
/// Added in FW4.4
class RequestSpeedStatsSet extends $pb.GeneratedMessage {
  factory RequestSpeedStatsSet({
    $core.int? windowMs,
    $core.bool? notifications,
  }) {
    final result = create();
    if (windowMs != null) result.windowMs = windowMs;
    if (notifications != null) result.notifications = notifications;
    return result;
  }

  RequestSpeedStatsSet._();

  factory RequestSpeedStatsSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestSpeedStatsSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestSpeedStatsSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'windowMs', fieldType: $pb.PbFieldType.OU3)
    ..aOB(2, _omitFieldNames ? '' : 'notifications')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSpeedStatsSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSpeedStatsSet copyWith(void Function(RequestSpeedStatsSet) updates) =>
      super.copyWith((message) => updates(message as RequestSpeedStatsSet))
          as RequestSpeedStatsSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestSpeedStatsSet create() => RequestSpeedStatsSet._();
  @$core.override
  RequestSpeedStatsSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestSpeedStatsSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestSpeedStatsSet>(create);
  static RequestSpeedStatsSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get windowMs => $_getIZ(0);
  @$pb.TagNumber(1)
  set windowMs($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWindowMs() => $_has(0);
  @$pb.TagNumber(1)
  void clearWindowMs() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get notifications => $_getBF(1);
  @$pb.TagNumber(2)
  set notifications($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNotifications() => $_has(1);
  @$pb.TagNumber(2)
  void clearNotifications() => $_clearField(2);
}

class ResponseSpeedStatsSet extends $pb.GeneratedMessage {
  factory ResponseSpeedStatsSet({
    $core.int? windowMs,
    $core.bool? notifications,
  }) {
    final result = create();
    if (windowMs != null) result.windowMs = windowMs;
    if (notifications != null) result.notifications = notifications;
    return result;
  }

  ResponseSpeedStatsSet._();

  factory ResponseSpeedStatsSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseSpeedStatsSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseSpeedStatsSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'windowMs', fieldType: $pb.PbFieldType.OU3)
    ..aOB(2, _omitFieldNames ? '' : 'notifications')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSpeedStatsSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSpeedStatsSet copyWith(
          void Function(ResponseSpeedStatsSet) updates) =>
      super.copyWith((message) => updates(message as ResponseSpeedStatsSet))
          as ResponseSpeedStatsSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseSpeedStatsSet create() => ResponseSpeedStatsSet._();
  @$core.override
  ResponseSpeedStatsSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseSpeedStatsSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseSpeedStatsSet>(create);
  static ResponseSpeedStatsSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get windowMs => $_getIZ(0);
  @$pb.TagNumber(1)
  set windowMs($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWindowMs() => $_has(0);
  @$pb.TagNumber(1)
  void clearWindowMs() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get notifications => $_getBF(1);
  @$pb.TagNumber(2)
  set notifications($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNotifications() => $_has(1);
  @$pb.TagNumber(2)
  void clearNotifications() => $_clearField(2);
}

/// 853 - Live regulator snapshot: the most recent control tick's state,
/// available WITHOUT arming any diag capture (a 1-record capture cannot be
/// polled live - reads require a frozen capture). valid=false until the
/// regulator has driven since boot; time_us tells how fresh the tick is.
/// Field meanings match the regulator capture record (see the capture docs).
/// Added in FW4.4
class RequestSlideSnapshotGet extends $pb.GeneratedMessage {
  factory RequestSlideSnapshotGet() => create();

  RequestSlideSnapshotGet._();

  factory RequestSlideSnapshotGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestSlideSnapshotGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestSlideSnapshotGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSlideSnapshotGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSlideSnapshotGet copyWith(
          void Function(RequestSlideSnapshotGet) updates) =>
      super.copyWith((message) => updates(message as RequestSlideSnapshotGet))
          as RequestSlideSnapshotGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestSlideSnapshotGet create() => RequestSlideSnapshotGet._();
  @$core.override
  RequestSlideSnapshotGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestSlideSnapshotGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestSlideSnapshotGet>(create);
  static RequestSlideSnapshotGet? _defaultInstance;
}

class ResponseSlideSnapshotGet extends $pb.GeneratedMessage {
  factory ResponseSlideSnapshotGet({
    $core.bool? valid,
    $fixnum.Int64? timeUs,
    $core.double? position,
    $core.double? speed,
    $core.double? targetSpeed,
    $core.double? trim,
    $core.double? output,
    $core.double? motor,
    $core.int? phase,
    $core.int? dir,
    $core.int? targetDir,
    $core.double? targetPos,
    $core.int? currentTimeMs,
    $core.double? expectedPos,
    $core.double? ff,
    $core.double? pTerm,
    $core.double? dTerm,
    $core.double? kick,
    $core.int? dtUs,
    $core.int? flags,
  }) {
    final result = create();
    if (valid != null) result.valid = valid;
    if (timeUs != null) result.timeUs = timeUs;
    if (position != null) result.position = position;
    if (speed != null) result.speed = speed;
    if (targetSpeed != null) result.targetSpeed = targetSpeed;
    if (trim != null) result.trim = trim;
    if (output != null) result.output = output;
    if (motor != null) result.motor = motor;
    if (phase != null) result.phase = phase;
    if (dir != null) result.dir = dir;
    if (targetDir != null) result.targetDir = targetDir;
    if (targetPos != null) result.targetPos = targetPos;
    if (currentTimeMs != null) result.currentTimeMs = currentTimeMs;
    if (expectedPos != null) result.expectedPos = expectedPos;
    if (ff != null) result.ff = ff;
    if (pTerm != null) result.pTerm = pTerm;
    if (dTerm != null) result.dTerm = dTerm;
    if (kick != null) result.kick = kick;
    if (dtUs != null) result.dtUs = dtUs;
    if (flags != null) result.flags = flags;
    return result;
  }

  ResponseSlideSnapshotGet._();

  factory ResponseSlideSnapshotGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseSlideSnapshotGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseSlideSnapshotGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'valid')
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'timeUs', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aD(3, _omitFieldNames ? '' : 'position', fieldType: $pb.PbFieldType.OF)
    ..aD(4, _omitFieldNames ? '' : 'speed', fieldType: $pb.PbFieldType.OF)
    ..aD(5, _omitFieldNames ? '' : 'targetSpeed', fieldType: $pb.PbFieldType.OF)
    ..aD(6, _omitFieldNames ? '' : 'trim', fieldType: $pb.PbFieldType.OF)
    ..aD(7, _omitFieldNames ? '' : 'output', fieldType: $pb.PbFieldType.OF)
    ..aD(8, _omitFieldNames ? '' : 'motor', fieldType: $pb.PbFieldType.OF)
    ..aI(9, _omitFieldNames ? '' : 'phase', fieldType: $pb.PbFieldType.OU3)
    ..aI(10, _omitFieldNames ? '' : 'dir', fieldType: $pb.PbFieldType.OU3)
    ..aI(11, _omitFieldNames ? '' : 'targetDir', fieldType: $pb.PbFieldType.OU3)
    ..aD(12, _omitFieldNames ? '' : 'targetPos', fieldType: $pb.PbFieldType.OF)
    ..aI(13, _omitFieldNames ? '' : 'currentTimeMs',
        fieldType: $pb.PbFieldType.OU3)
    ..aD(14, _omitFieldNames ? '' : 'expectedPos',
        fieldType: $pb.PbFieldType.OF)
    ..aD(15, _omitFieldNames ? '' : 'ff', fieldType: $pb.PbFieldType.OF)
    ..aD(16, _omitFieldNames ? '' : 'pTerm', fieldType: $pb.PbFieldType.OF)
    ..aD(17, _omitFieldNames ? '' : 'dTerm', fieldType: $pb.PbFieldType.OF)
    ..aD(18, _omitFieldNames ? '' : 'kick', fieldType: $pb.PbFieldType.OF)
    ..aI(19, _omitFieldNames ? '' : 'dtUs', fieldType: $pb.PbFieldType.OU3)
    ..aI(20, _omitFieldNames ? '' : 'flags', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSlideSnapshotGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSlideSnapshotGet copyWith(
          void Function(ResponseSlideSnapshotGet) updates) =>
      super.copyWith((message) => updates(message as ResponseSlideSnapshotGet))
          as ResponseSlideSnapshotGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseSlideSnapshotGet create() => ResponseSlideSnapshotGet._();
  @$core.override
  ResponseSlideSnapshotGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseSlideSnapshotGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseSlideSnapshotGet>(create);
  static ResponseSlideSnapshotGet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get valid => $_getBF(0);
  @$pb.TagNumber(1)
  set valid($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValid() => $_has(0);
  @$pb.TagNumber(1)
  void clearValid() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get timeUs => $_getI64(1);
  @$pb.TagNumber(2)
  set timeUs($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTimeUs() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimeUs() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get position => $_getN(2);
  @$pb.TagNumber(3)
  set position($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPosition() => $_has(2);
  @$pb.TagNumber(3)
  void clearPosition() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get speed => $_getN(3);
  @$pb.TagNumber(4)
  set speed($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSpeed() => $_has(3);
  @$pb.TagNumber(4)
  void clearSpeed() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get targetSpeed => $_getN(4);
  @$pb.TagNumber(5)
  set targetSpeed($core.double value) => $_setFloat(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTargetSpeed() => $_has(4);
  @$pb.TagNumber(5)
  void clearTargetSpeed() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get trim => $_getN(5);
  @$pb.TagNumber(6)
  set trim($core.double value) => $_setFloat(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTrim() => $_has(5);
  @$pb.TagNumber(6)
  void clearTrim() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get output => $_getN(6);
  @$pb.TagNumber(7)
  set output($core.double value) => $_setFloat(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOutput() => $_has(6);
  @$pb.TagNumber(7)
  void clearOutput() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get motor => $_getN(7);
  @$pb.TagNumber(8)
  set motor($core.double value) => $_setFloat(7, value);
  @$pb.TagNumber(8)
  $core.bool hasMotor() => $_has(7);
  @$pb.TagNumber(8)
  void clearMotor() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get phase => $_getIZ(8);
  @$pb.TagNumber(9)
  set phase($core.int value) => $_setUnsignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPhase() => $_has(8);
  @$pb.TagNumber(9)
  void clearPhase() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get dir => $_getIZ(9);
  @$pb.TagNumber(10)
  set dir($core.int value) => $_setUnsignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDir() => $_has(9);
  @$pb.TagNumber(10)
  void clearDir() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get targetDir => $_getIZ(10);
  @$pb.TagNumber(11)
  set targetDir($core.int value) => $_setUnsignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasTargetDir() => $_has(10);
  @$pb.TagNumber(11)
  void clearTargetDir() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.double get targetPos => $_getN(11);
  @$pb.TagNumber(12)
  set targetPos($core.double value) => $_setFloat(11, value);
  @$pb.TagNumber(12)
  $core.bool hasTargetPos() => $_has(11);
  @$pb.TagNumber(12)
  void clearTargetPos() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get currentTimeMs => $_getIZ(12);
  @$pb.TagNumber(13)
  set currentTimeMs($core.int value) => $_setUnsignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasCurrentTimeMs() => $_has(12);
  @$pb.TagNumber(13)
  void clearCurrentTimeMs() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.double get expectedPos => $_getN(13);
  @$pb.TagNumber(14)
  set expectedPos($core.double value) => $_setFloat(13, value);
  @$pb.TagNumber(14)
  $core.bool hasExpectedPos() => $_has(13);
  @$pb.TagNumber(14)
  void clearExpectedPos() => $_clearField(14);

  /// Controller decomposition (FW4.4): on a run record ff + p_term + d_term + kick + trim = the
  /// output BEFORE the clamps (min/max, soft start, slew, overspeed brake), so output minus that
  /// sum is what the clamps took this tick. All 0 on turn-phase records.
  @$pb.TagNumber(15)
  $core.double get ff => $_getN(14);
  @$pb.TagNumber(15)
  set ff($core.double value) => $_setFloat(14, value);
  @$pb.TagNumber(15)
  $core.bool hasFf() => $_has(14);
  @$pb.TagNumber(15)
  void clearFf() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.double get pTerm => $_getN(15);
  @$pb.TagNumber(16)
  set pTerm($core.double value) => $_setFloat(15, value);
  @$pb.TagNumber(16)
  $core.bool hasPTerm() => $_has(15);
  @$pb.TagNumber(16)
  void clearPTerm() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.double get dTerm => $_getN(16);
  @$pb.TagNumber(17)
  set dTerm($core.double value) => $_setFloat(16, value);
  @$pb.TagNumber(17)
  $core.bool hasDTerm() => $_has(16);
  @$pb.TagNumber(17)
  void clearDTerm() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.double get kick => $_getN(17);
  @$pb.TagNumber(18)
  set kick($core.double value) => $_setFloat(17, value);
  @$pb.TagNumber(18)
  $core.bool hasKick() => $_has(17);
  @$pb.TagNumber(18)
  void clearKick() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.int get dtUs => $_getIZ(18);
  @$pb.TagNumber(19)
  set dtUs($core.int value) => $_setUnsignedInt32(18, value);
  @$pb.TagNumber(19)
  $core.bool hasDtUs() => $_has(18);
  @$pb.TagNumber(19)
  void clearDtUs() => $_clearField(19);

  /// Per-tick state bits: 1 deadband (P/I/D saw 0), 2 trim frozen at max (anti-windup), 4 trim frozen
  /// at min, 8 soft-start capped the output, 16 slew limiter capped the output, 32 overspeed brake
  /// active (pulled trim AND output), 64 speed from the estimator (timeout tick, no fresh Hall edge),
  /// 128 ff+P+D+kick+trim hit the xMin/xMaxSpeedTheoretical clamp.
  @$pb.TagNumber(20)
  $core.int get flags => $_getIZ(19);
  @$pb.TagNumber(20)
  set flags($core.int value) => $_setUnsignedInt32(19, value);
  @$pb.TagNumber(20)
  $core.bool hasFlags() => $_has(19);
  @$pb.TagNumber(20)
  void clearFlags() => $_clearField(20);
}

/// /////////////////////// HSP /////////////////////////
/// 860
class RequestHspSetup extends $pb.GeneratedMessage {
  factory RequestHspSetup({
    $core.int? streamId,
  }) {
    final result = create();
    if (streamId != null) result.streamId = streamId;
    return result;
  }

  RequestHspSetup._();

  factory RequestHspSetup.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHspSetup.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHspSetup',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'streamId', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspSetup clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspSetup copyWith(void Function(RequestHspSetup) updates) =>
      super.copyWith((message) => updates(message as RequestHspSetup))
          as RequestHspSetup;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHspSetup create() => RequestHspSetup._();
  @$core.override
  RequestHspSetup createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHspSetup getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHspSetup>(create);
  static RequestHspSetup? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get streamId => $_getIZ(0);
  @$pb.TagNumber(1)
  set streamId($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStreamId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStreamId() => $_clearField(1);
}

class ResponseHspSetup extends $pb.GeneratedMessage {
  factory ResponseHspSetup({
    $0.HspState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHspSetup._();

  factory ResponseHspSetup.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHspSetup.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHspSetup',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HspState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HspState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspSetup clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspSetup copyWith(void Function(ResponseHspSetup) updates) =>
      super.copyWith((message) => updates(message as ResponseHspSetup))
          as ResponseHspSetup;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHspSetup create() => ResponseHspSetup._();
  @$core.override
  ResponseHspSetup createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHspSetup getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHspSetup>(create);
  static ResponseHspSetup? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HspState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HspState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HspState ensureState() => $_ensure(0);
}

/// 861
class RequestHspAdd extends $pb.GeneratedMessage {
  factory RequestHspAdd({
    $core.Iterable<$0.Point>? points,
    $core.bool? flush,
    $core.int? tailPointStreamIndex,
    $core.int? tailPointThreshold,
  }) {
    final result = create();
    if (points != null) result.points.addAll(points);
    if (flush != null) result.flush = flush;
    if (tailPointStreamIndex != null)
      result.tailPointStreamIndex = tailPointStreamIndex;
    if (tailPointThreshold != null)
      result.tailPointThreshold = tailPointThreshold;
    return result;
  }

  RequestHspAdd._();

  factory RequestHspAdd.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHspAdd.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHspAdd',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..pPM<$0.Point>(1, _omitFieldNames ? '' : 'points',
        subBuilder: $0.Point.create)
    ..aOB(2, _omitFieldNames ? '' : 'flush')
    ..aI(3, _omitFieldNames ? '' : 'tailPointStreamIndex',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(5, _omitFieldNames ? '' : 'tailPointThreshold',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspAdd clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspAdd copyWith(void Function(RequestHspAdd) updates) =>
      super.copyWith((message) => updates(message as RequestHspAdd))
          as RequestHspAdd;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHspAdd create() => RequestHspAdd._();
  @$core.override
  RequestHspAdd createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHspAdd getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHspAdd>(create);
  static RequestHspAdd? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$0.Point> get points => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get flush => $_getBF(1);
  @$pb.TagNumber(2)
  set flush($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFlush() => $_has(1);
  @$pb.TagNumber(2)
  void clearFlush() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get tailPointStreamIndex => $_getIZ(2);
  @$pb.TagNumber(3)
  set tailPointStreamIndex($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTailPointStreamIndex() => $_has(2);
  @$pb.TagNumber(3)
  void clearTailPointStreamIndex() => $_clearField(3);

  @$pb.TagNumber(5)
  $core.int get tailPointThreshold => $_getIZ(3);
  @$pb.TagNumber(5)
  set tailPointThreshold($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(5)
  $core.bool hasTailPointThreshold() => $_has(3);
  @$pb.TagNumber(5)
  void clearTailPointThreshold() => $_clearField(5);
}

class ResponseHspAdd extends $pb.GeneratedMessage {
  factory ResponseHspAdd({
    $0.HspState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHspAdd._();

  factory ResponseHspAdd.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHspAdd.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHspAdd',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HspState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HspState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspAdd clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspAdd copyWith(void Function(ResponseHspAdd) updates) =>
      super.copyWith((message) => updates(message as ResponseHspAdd))
          as ResponseHspAdd;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHspAdd create() => ResponseHspAdd._();
  @$core.override
  ResponseHspAdd createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHspAdd getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHspAdd>(create);
  static ResponseHspAdd? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HspState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HspState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HspState ensureState() => $_ensure(0);
}

/// 862
class RequestHspFlush extends $pb.GeneratedMessage {
  factory RequestHspFlush() => create();

  RequestHspFlush._();

  factory RequestHspFlush.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHspFlush.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHspFlush',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspFlush clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspFlush copyWith(void Function(RequestHspFlush) updates) =>
      super.copyWith((message) => updates(message as RequestHspFlush))
          as RequestHspFlush;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHspFlush create() => RequestHspFlush._();
  @$core.override
  RequestHspFlush createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHspFlush getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHspFlush>(create);
  static RequestHspFlush? _defaultInstance;
}

class ResponseHspFlush extends $pb.GeneratedMessage {
  factory ResponseHspFlush({
    $0.HspState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHspFlush._();

  factory ResponseHspFlush.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHspFlush.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHspFlush',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HspState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HspState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspFlush clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspFlush copyWith(void Function(ResponseHspFlush) updates) =>
      super.copyWith((message) => updates(message as ResponseHspFlush))
          as ResponseHspFlush;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHspFlush create() => ResponseHspFlush._();
  @$core.override
  ResponseHspFlush createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHspFlush getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHspFlush>(create);
  static ResponseHspFlush? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HspState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HspState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HspState ensureState() => $_ensure(0);
}

/// 863
class RequestHspPlay extends $pb.GeneratedMessage {
  factory RequestHspPlay({
    $core.int? startTime,
    $fixnum.Int64? serverTime,
    $core.double? playbackRate,
    $core.bool? loop,
    $core.bool? pauseOnStarving,
  }) {
    final result = create();
    if (startTime != null) result.startTime = startTime;
    if (serverTime != null) result.serverTime = serverTime;
    if (playbackRate != null) result.playbackRate = playbackRate;
    if (loop != null) result.loop = loop;
    if (pauseOnStarving != null) result.pauseOnStarving = pauseOnStarving;
    return result;
  }

  RequestHspPlay._();

  factory RequestHspPlay.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHspPlay.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHspPlay',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'startTime')
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'serverTime', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aD(3, _omitFieldNames ? '' : 'playbackRate',
        fieldType: $pb.PbFieldType.OF)
    ..aOB(4, _omitFieldNames ? '' : 'loop')
    ..aOB(5, _omitFieldNames ? '' : 'pauseOnStarving')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspPlay clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspPlay copyWith(void Function(RequestHspPlay) updates) =>
      super.copyWith((message) => updates(message as RequestHspPlay))
          as RequestHspPlay;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHspPlay create() => RequestHspPlay._();
  @$core.override
  RequestHspPlay createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHspPlay getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHspPlay>(create);
  static RequestHspPlay? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get startTime => $_getIZ(0);
  @$pb.TagNumber(1)
  set startTime($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStartTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearStartTime() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get serverTime => $_getI64(1);
  @$pb.TagNumber(2)
  set serverTime($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServerTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearServerTime() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get playbackRate => $_getN(2);
  @$pb.TagNumber(3)
  set playbackRate($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPlaybackRate() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlaybackRate() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get loop => $_getBF(3);
  @$pb.TagNumber(4)
  set loop($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLoop() => $_has(3);
  @$pb.TagNumber(4)
  void clearLoop() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get pauseOnStarving => $_getBF(4);
  @$pb.TagNumber(5)
  set pauseOnStarving($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPauseOnStarving() => $_has(4);
  @$pb.TagNumber(5)
  void clearPauseOnStarving() => $_clearField(5);
}

class ResponseHspPlay extends $pb.GeneratedMessage {
  factory ResponseHspPlay({
    $0.HspState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHspPlay._();

  factory ResponseHspPlay.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHspPlay.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHspPlay',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HspState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HspState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspPlay clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspPlay copyWith(void Function(ResponseHspPlay) updates) =>
      super.copyWith((message) => updates(message as ResponseHspPlay))
          as ResponseHspPlay;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHspPlay create() => ResponseHspPlay._();
  @$core.override
  ResponseHspPlay createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHspPlay getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHspPlay>(create);
  static ResponseHspPlay? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HspState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HspState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HspState ensureState() => $_ensure(0);
}

/// 864
class RequestHspStop extends $pb.GeneratedMessage {
  factory RequestHspStop() => create();

  RequestHspStop._();

  factory RequestHspStop.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHspStop.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHspStop',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspStop clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspStop copyWith(void Function(RequestHspStop) updates) =>
      super.copyWith((message) => updates(message as RequestHspStop))
          as RequestHspStop;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHspStop create() => RequestHspStop._();
  @$core.override
  RequestHspStop createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHspStop getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHspStop>(create);
  static RequestHspStop? _defaultInstance;
}

class ResponseHspStop extends $pb.GeneratedMessage {
  factory ResponseHspStop({
    $0.HspState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHspStop._();

  factory ResponseHspStop.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHspStop.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHspStop',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HspState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HspState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspStop clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspStop copyWith(void Function(ResponseHspStop) updates) =>
      super.copyWith((message) => updates(message as ResponseHspStop))
          as ResponseHspStop;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHspStop create() => ResponseHspStop._();
  @$core.override
  ResponseHspStop createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHspStop getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHspStop>(create);
  static ResponseHspStop? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HspState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HspState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HspState ensureState() => $_ensure(0);
}

/// 865
class RequestHspPause extends $pb.GeneratedMessage {
  factory RequestHspPause() => create();

  RequestHspPause._();

  factory RequestHspPause.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHspPause.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHspPause',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspPause clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspPause copyWith(void Function(RequestHspPause) updates) =>
      super.copyWith((message) => updates(message as RequestHspPause))
          as RequestHspPause;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHspPause create() => RequestHspPause._();
  @$core.override
  RequestHspPause createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHspPause getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHspPause>(create);
  static RequestHspPause? _defaultInstance;
}

class ResponseHspPause extends $pb.GeneratedMessage {
  factory ResponseHspPause({
    $0.HspState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHspPause._();

  factory ResponseHspPause.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHspPause.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHspPause',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HspState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HspState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspPause clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspPause copyWith(void Function(ResponseHspPause) updates) =>
      super.copyWith((message) => updates(message as ResponseHspPause))
          as ResponseHspPause;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHspPause create() => ResponseHspPause._();
  @$core.override
  ResponseHspPause createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHspPause getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHspPause>(create);
  static ResponseHspPause? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HspState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HspState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HspState ensureState() => $_ensure(0);
}

/// 866
class RequestHspResume extends $pb.GeneratedMessage {
  factory RequestHspResume({
    $core.bool? pickUp,
  }) {
    final result = create();
    if (pickUp != null) result.pickUp = pickUp;
    return result;
  }

  RequestHspResume._();

  factory RequestHspResume.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHspResume.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHspResume',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'pickUp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspResume clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspResume copyWith(void Function(RequestHspResume) updates) =>
      super.copyWith((message) => updates(message as RequestHspResume))
          as RequestHspResume;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHspResume create() => RequestHspResume._();
  @$core.override
  RequestHspResume createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHspResume getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHspResume>(create);
  static RequestHspResume? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get pickUp => $_getBF(0);
  @$pb.TagNumber(1)
  set pickUp($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPickUp() => $_has(0);
  @$pb.TagNumber(1)
  void clearPickUp() => $_clearField(1);
}

class ResponseHspResume extends $pb.GeneratedMessage {
  factory ResponseHspResume({
    $0.HspState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHspResume._();

  factory ResponseHspResume.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHspResume.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHspResume',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HspState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HspState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspResume clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspResume copyWith(void Function(ResponseHspResume) updates) =>
      super.copyWith((message) => updates(message as ResponseHspResume))
          as ResponseHspResume;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHspResume create() => ResponseHspResume._();
  @$core.override
  ResponseHspResume createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHspResume getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHspResume>(create);
  static ResponseHspResume? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HspState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HspState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HspState ensureState() => $_ensure(0);
}

/// 867
class RequestHspStateGet extends $pb.GeneratedMessage {
  factory RequestHspStateGet() => create();

  RequestHspStateGet._();

  factory RequestHspStateGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHspStateGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHspStateGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspStateGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspStateGet copyWith(void Function(RequestHspStateGet) updates) =>
      super.copyWith((message) => updates(message as RequestHspStateGet))
          as RequestHspStateGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHspStateGet create() => RequestHspStateGet._();
  @$core.override
  RequestHspStateGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHspStateGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHspStateGet>(create);
  static RequestHspStateGet? _defaultInstance;
}

class ResponseHspStateGet extends $pb.GeneratedMessage {
  factory ResponseHspStateGet({
    $0.HspState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHspStateGet._();

  factory ResponseHspStateGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHspStateGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHspStateGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HspState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HspState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspStateGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspStateGet copyWith(void Function(ResponseHspStateGet) updates) =>
      super.copyWith((message) => updates(message as ResponseHspStateGet))
          as ResponseHspStateGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHspStateGet create() => ResponseHspStateGet._();
  @$core.override
  ResponseHspStateGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHspStateGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHspStateGet>(create);
  static ResponseHspStateGet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HspState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HspState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HspState ensureState() => $_ensure(0);
}

/// 868
class RequestHspCurrentTimeSet extends $pb.GeneratedMessage {
  factory RequestHspCurrentTimeSet({
    $core.int? currentTime,
    $fixnum.Int64? serverTime,
    $core.double? filter,
  }) {
    final result = create();
    if (currentTime != null) result.currentTime = currentTime;
    if (serverTime != null) result.serverTime = serverTime;
    if (filter != null) result.filter = filter;
    return result;
  }

  RequestHspCurrentTimeSet._();

  factory RequestHspCurrentTimeSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHspCurrentTimeSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHspCurrentTimeSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'currentTime')
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'serverTime', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aD(3, _omitFieldNames ? '' : 'filter', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspCurrentTimeSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspCurrentTimeSet copyWith(
          void Function(RequestHspCurrentTimeSet) updates) =>
      super.copyWith((message) => updates(message as RequestHspCurrentTimeSet))
          as RequestHspCurrentTimeSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHspCurrentTimeSet create() => RequestHspCurrentTimeSet._();
  @$core.override
  RequestHspCurrentTimeSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHspCurrentTimeSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHspCurrentTimeSet>(create);
  static RequestHspCurrentTimeSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get currentTime => $_getIZ(0);
  @$pb.TagNumber(1)
  set currentTime($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCurrentTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrentTime() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get serverTime => $_getI64(1);
  @$pb.TagNumber(2)
  set serverTime($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServerTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearServerTime() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get filter => $_getN(2);
  @$pb.TagNumber(3)
  set filter($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFilter() => $_has(2);
  @$pb.TagNumber(3)
  void clearFilter() => $_clearField(3);
}

class ResponseHspCurrentTimeSet extends $pb.GeneratedMessage {
  factory ResponseHspCurrentTimeSet({
    $0.HspState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHspCurrentTimeSet._();

  factory ResponseHspCurrentTimeSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHspCurrentTimeSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHspCurrentTimeSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HspState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HspState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspCurrentTimeSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspCurrentTimeSet copyWith(
          void Function(ResponseHspCurrentTimeSet) updates) =>
      super.copyWith((message) => updates(message as ResponseHspCurrentTimeSet))
          as ResponseHspCurrentTimeSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHspCurrentTimeSet create() => ResponseHspCurrentTimeSet._();
  @$core.override
  ResponseHspCurrentTimeSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHspCurrentTimeSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHspCurrentTimeSet>(create);
  static ResponseHspCurrentTimeSet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HspState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HspState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HspState ensureState() => $_ensure(0);
}

/// 869
class RequestHspThresholdSet extends $pb.GeneratedMessage {
  factory RequestHspThresholdSet({
    $core.int? tailPointThreshold,
  }) {
    final result = create();
    if (tailPointThreshold != null)
      result.tailPointThreshold = tailPointThreshold;
    return result;
  }

  RequestHspThresholdSet._();

  factory RequestHspThresholdSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHspThresholdSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHspThresholdSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'tailPointThreshold',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspThresholdSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspThresholdSet copyWith(
          void Function(RequestHspThresholdSet) updates) =>
      super.copyWith((message) => updates(message as RequestHspThresholdSet))
          as RequestHspThresholdSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHspThresholdSet create() => RequestHspThresholdSet._();
  @$core.override
  RequestHspThresholdSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHspThresholdSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHspThresholdSet>(create);
  static RequestHspThresholdSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get tailPointThreshold => $_getIZ(0);
  @$pb.TagNumber(1)
  set tailPointThreshold($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTailPointThreshold() => $_has(0);
  @$pb.TagNumber(1)
  void clearTailPointThreshold() => $_clearField(1);
}

class ResponseHspThresholdSet extends $pb.GeneratedMessage {
  factory ResponseHspThresholdSet({
    $0.HspState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHspThresholdSet._();

  factory ResponseHspThresholdSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHspThresholdSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHspThresholdSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HspState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HspState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspThresholdSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspThresholdSet copyWith(
          void Function(ResponseHspThresholdSet) updates) =>
      super.copyWith((message) => updates(message as ResponseHspThresholdSet))
          as ResponseHspThresholdSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHspThresholdSet create() => ResponseHspThresholdSet._();
  @$core.override
  ResponseHspThresholdSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHspThresholdSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHspThresholdSet>(create);
  static ResponseHspThresholdSet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HspState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HspState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HspState ensureState() => $_ensure(0);
}

/// 870 - Added in FW4.0.13
class RequestHspPauseOnStarvingSet extends $pb.GeneratedMessage {
  factory RequestHspPauseOnStarvingSet({
    $core.bool? pauseOnStarving,
  }) {
    final result = create();
    if (pauseOnStarving != null) result.pauseOnStarving = pauseOnStarving;
    return result;
  }

  RequestHspPauseOnStarvingSet._();

  factory RequestHspPauseOnStarvingSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHspPauseOnStarvingSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHspPauseOnStarvingSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'pauseOnStarving')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspPauseOnStarvingSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspPauseOnStarvingSet copyWith(
          void Function(RequestHspPauseOnStarvingSet) updates) =>
      super.copyWith(
              (message) => updates(message as RequestHspPauseOnStarvingSet))
          as RequestHspPauseOnStarvingSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHspPauseOnStarvingSet create() =>
      RequestHspPauseOnStarvingSet._();
  @$core.override
  RequestHspPauseOnStarvingSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHspPauseOnStarvingSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHspPauseOnStarvingSet>(create);
  static RequestHspPauseOnStarvingSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get pauseOnStarving => $_getBF(0);
  @$pb.TagNumber(1)
  set pauseOnStarving($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPauseOnStarving() => $_has(0);
  @$pb.TagNumber(1)
  void clearPauseOnStarving() => $_clearField(1);
}

class ResponseHspPauseOnStarvingSet extends $pb.GeneratedMessage {
  factory ResponseHspPauseOnStarvingSet({
    $0.HspState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHspPauseOnStarvingSet._();

  factory ResponseHspPauseOnStarvingSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHspPauseOnStarvingSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHspPauseOnStarvingSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HspState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HspState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspPauseOnStarvingSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspPauseOnStarvingSet copyWith(
          void Function(ResponseHspPauseOnStarvingSet) updates) =>
      super.copyWith(
              (message) => updates(message as ResponseHspPauseOnStarvingSet))
          as ResponseHspPauseOnStarvingSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHspPauseOnStarvingSet create() =>
      ResponseHspPauseOnStarvingSet._();
  @$core.override
  ResponseHspPauseOnStarvingSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHspPauseOnStarvingSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHspPauseOnStarvingSet>(create);
  static ResponseHspPauseOnStarvingSet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HspState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HspState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HspState ensureState() => $_ensure(0);
}

/// 871 - Added in FW4.1.1
class RequestHspPlaybackRateSet extends $pb.GeneratedMessage {
  factory RequestHspPlaybackRateSet({
    $core.double? playbackRate,
  }) {
    final result = create();
    if (playbackRate != null) result.playbackRate = playbackRate;
    return result;
  }

  RequestHspPlaybackRateSet._();

  factory RequestHspPlaybackRateSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHspPlaybackRateSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHspPlaybackRateSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'playbackRate',
        fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspPlaybackRateSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspPlaybackRateSet copyWith(
          void Function(RequestHspPlaybackRateSet) updates) =>
      super.copyWith((message) => updates(message as RequestHspPlaybackRateSet))
          as RequestHspPlaybackRateSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHspPlaybackRateSet create() => RequestHspPlaybackRateSet._();
  @$core.override
  RequestHspPlaybackRateSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHspPlaybackRateSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHspPlaybackRateSet>(create);
  static RequestHspPlaybackRateSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get playbackRate => $_getN(0);
  @$pb.TagNumber(1)
  set playbackRate($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlaybackRate() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlaybackRate() => $_clearField(1);
}

class ResponseHspPlaybackRateSet extends $pb.GeneratedMessage {
  factory ResponseHspPlaybackRateSet({
    $0.HspState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHspPlaybackRateSet._();

  factory ResponseHspPlaybackRateSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHspPlaybackRateSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHspPlaybackRateSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HspState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HspState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspPlaybackRateSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspPlaybackRateSet copyWith(
          void Function(ResponseHspPlaybackRateSet) updates) =>
      super.copyWith(
              (message) => updates(message as ResponseHspPlaybackRateSet))
          as ResponseHspPlaybackRateSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHspPlaybackRateSet create() => ResponseHspPlaybackRateSet._();
  @$core.override
  ResponseHspPlaybackRateSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHspPlaybackRateSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHspPlaybackRateSet>(create);
  static ResponseHspPlaybackRateSet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HspState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HspState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HspState ensureState() => $_ensure(0);
}

/// 872 - Added in FW4.1.1
class RequestHspLoopSet extends $pb.GeneratedMessage {
  factory RequestHspLoopSet({
    $core.bool? loop,
  }) {
    final result = create();
    if (loop != null) result.loop = loop;
    return result;
  }

  RequestHspLoopSet._();

  factory RequestHspLoopSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHspLoopSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHspLoopSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'loop')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspLoopSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspLoopSet copyWith(void Function(RequestHspLoopSet) updates) =>
      super.copyWith((message) => updates(message as RequestHspLoopSet))
          as RequestHspLoopSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHspLoopSet create() => RequestHspLoopSet._();
  @$core.override
  RequestHspLoopSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHspLoopSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHspLoopSet>(create);
  static RequestHspLoopSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get loop => $_getBF(0);
  @$pb.TagNumber(1)
  set loop($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLoop() => $_has(0);
  @$pb.TagNumber(1)
  void clearLoop() => $_clearField(1);
}

class ResponseHspLoopSet extends $pb.GeneratedMessage {
  factory ResponseHspLoopSet({
    $0.HspState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHspLoopSet._();

  factory ResponseHspLoopSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHspLoopSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHspLoopSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HspState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HspState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspLoopSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspLoopSet copyWith(void Function(ResponseHspLoopSet) updates) =>
      super.copyWith((message) => updates(message as ResponseHspLoopSet))
          as ResponseHspLoopSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHspLoopSet create() => ResponseHspLoopSet._();
  @$core.override
  ResponseHspLoopSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHspLoopSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHspLoopSet>(create);
  static ResponseHspLoopSet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HspState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HspState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HspState ensureState() => $_ensure(0);
}

/// 873 - Added in FW4.4
class RequestHspJitterFilterSet extends $pb.GeneratedMessage {
  factory RequestHspJitterFilterSet({
    $core.bool? jitterFilter,
    $core.double? thresholdMm,
  }) {
    final result = create();
    if (jitterFilter != null) result.jitterFilter = jitterFilter;
    if (thresholdMm != null) result.thresholdMm = thresholdMm;
    return result;
  }

  RequestHspJitterFilterSet._();

  factory RequestHspJitterFilterSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHspJitterFilterSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHspJitterFilterSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'jitterFilter')
    ..aD(2, _omitFieldNames ? '' : 'thresholdMm', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspJitterFilterSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspJitterFilterSet copyWith(
          void Function(RequestHspJitterFilterSet) updates) =>
      super.copyWith((message) => updates(message as RequestHspJitterFilterSet))
          as RequestHspJitterFilterSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHspJitterFilterSet create() => RequestHspJitterFilterSet._();
  @$core.override
  RequestHspJitterFilterSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHspJitterFilterSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHspJitterFilterSet>(create);
  static RequestHspJitterFilterSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get jitterFilter => $_getBF(0);
  @$pb.TagNumber(1)
  set jitterFilter($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJitterFilter() => $_has(0);
  @$pb.TagNumber(1)
  void clearJitterFilter() => $_clearField(1);

  /// the current position. Enable for LIVE streamed input (hand jitter would
  /// otherwise buzz the slide); leave off for scripted playback - every authored
  /// point is dispatched. Swallowed points appear in the HSP diag capture as
  /// 'filtered' events (event 9). Reset to OFF by RequestHspSetup (860).
  /// Before FW4.4 the filter was always ON.
  @$pb.TagNumber(2)
  $core.double get thresholdMm => $_getN(1);
  @$pb.TagNumber(2)
  set thresholdMm($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasThresholdMm() => $_has(1);
  @$pb.TagNumber(2)
  void clearThresholdMm() => $_clearField(2);
}

class ResponseHspJitterFilterSet extends $pb.GeneratedMessage {
  factory ResponseHspJitterFilterSet({
    $0.HspState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHspJitterFilterSet._();

  factory ResponseHspJitterFilterSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHspJitterFilterSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHspJitterFilterSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HspState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HspState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspJitterFilterSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspJitterFilterSet copyWith(
          void Function(ResponseHspJitterFilterSet) updates) =>
      super.copyWith(
              (message) => updates(message as ResponseHspJitterFilterSet))
          as ResponseHspJitterFilterSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHspJitterFilterSet create() => ResponseHspJitterFilterSet._();
  @$core.override
  ResponseHspJitterFilterSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHspJitterFilterSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHspJitterFilterSet>(create);
  static ResponseHspJitterFilterSet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HspState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HspState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HspState ensureState() => $_ensure(0);
}

/// 874 - Added in FW4.4
class RequestHspScriptSpeedSet extends $pb.GeneratedMessage {
  factory RequestHspScriptSpeedSet({
    $core.bool? scriptSpeed,
  }) {
    final result = create();
    if (scriptSpeed != null) result.scriptSpeed = scriptSpeed;
    return result;
  }

  RequestHspScriptSpeedSet._();

  factory RequestHspScriptSpeedSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHspScriptSpeedSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHspScriptSpeedSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'scriptSpeed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspScriptSpeedSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspScriptSpeedSet copyWith(
          void Function(RequestHspScriptSpeedSet) updates) =>
      super.copyWith((message) => updates(message as RequestHspScriptSpeedSet))
          as RequestHspScriptSpeedSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHspScriptSpeedSet create() => RequestHspScriptSpeedSet._();
  @$core.override
  RequestHspScriptSpeedSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHspScriptSpeedSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHspScriptSpeedSet>(create);
  static RequestHspScriptSpeedSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get scriptSpeed => $_getBF(0);
  @$pb.TagNumber(1)
  set scriptSpeed($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasScriptSpeed() => $_has(0);
  @$pb.TagNumber(1)
  void clearScriptSpeed() => $_clearField(1);
}

class ResponseHspScriptSpeedSet extends $pb.GeneratedMessage {
  factory ResponseHspScriptSpeedSet({
    $0.HspState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHspScriptSpeedSet._();

  factory ResponseHspScriptSpeedSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHspScriptSpeedSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHspScriptSpeedSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HspState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HspState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspScriptSpeedSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHspScriptSpeedSet copyWith(
          void Function(ResponseHspScriptSpeedSet) updates) =>
      super.copyWith((message) => updates(message as ResponseHspScriptSpeedSet))
          as ResponseHspScriptSpeedSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHspScriptSpeedSet create() => ResponseHspScriptSpeedSet._();
  @$core.override
  ResponseHspScriptSpeedSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHspScriptSpeedSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHspScriptSpeedSet>(create);
  static ResponseHspScriptSpeedSet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HspState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HspState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HspState ensureState() => $_ensure(0);
}

/// /////////////////////// HMI 880->899 /////////////////////////
class RequestLedOverride extends $pb.GeneratedMessage {
  factory RequestLedOverride({
    $core.bool? override,
    $core.int? r,
    $core.int? g,
    $core.int? b,
    $core.int? intensity,
  }) {
    final result = create();
    if (override != null) result.override = override;
    if (r != null) result.r = r;
    if (g != null) result.g = g;
    if (b != null) result.b = b;
    if (intensity != null) result.intensity = intensity;
    return result;
  }

  RequestLedOverride._();

  factory RequestLedOverride.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestLedOverride.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestLedOverride',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'override')
    ..aI(2, _omitFieldNames ? '' : 'r', fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'g', fieldType: $pb.PbFieldType.OU3)
    ..aI(4, _omitFieldNames ? '' : 'b', fieldType: $pb.PbFieldType.OU3)
    ..aI(5, _omitFieldNames ? '' : 'intensity', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestLedOverride clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestLedOverride copyWith(void Function(RequestLedOverride) updates) =>
      super.copyWith((message) => updates(message as RequestLedOverride))
          as RequestLedOverride;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestLedOverride create() => RequestLedOverride._();
  @$core.override
  RequestLedOverride createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestLedOverride getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestLedOverride>(create);
  static RequestLedOverride? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get override => $_getBF(0);
  @$pb.TagNumber(1)
  set override($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOverride() => $_has(0);
  @$pb.TagNumber(1)
  void clearOverride() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get r => $_getIZ(1);
  @$pb.TagNumber(2)
  set r($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasR() => $_has(1);
  @$pb.TagNumber(2)
  void clearR() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get g => $_getIZ(2);
  @$pb.TagNumber(3)
  set g($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasG() => $_has(2);
  @$pb.TagNumber(3)
  void clearG() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get b => $_getIZ(3);
  @$pb.TagNumber(4)
  set b($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasB() => $_has(3);
  @$pb.TagNumber(4)
  void clearB() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get intensity => $_getIZ(4);
  @$pb.TagNumber(5)
  set intensity($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIntensity() => $_has(4);
  @$pb.TagNumber(5)
  void clearIntensity() => $_clearField(5);
}

/// /////////////////////// HVP /////////////////////////
/// 900
/// NB will also trigger a start
class RequestHvpSet extends $pb.GeneratedMessage {
  factory RequestHvpSet({
    $core.double? amplitude,
    $core.int? frequency,
    $core.double? position,
  }) {
    final result = create();
    if (amplitude != null) result.amplitude = amplitude;
    if (frequency != null) result.frequency = frequency;
    if (position != null) result.position = position;
    return result;
  }

  RequestHvpSet._();

  factory RequestHvpSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHvpSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHvpSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'amplitude', fieldType: $pb.PbFieldType.OF)
    ..aI(2, _omitFieldNames ? '' : 'frequency', fieldType: $pb.PbFieldType.OU3)
    ..aD(3, _omitFieldNames ? '' : 'position', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHvpSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHvpSet copyWith(void Function(RequestHvpSet) updates) =>
      super.copyWith((message) => updates(message as RequestHvpSet))
          as RequestHvpSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHvpSet create() => RequestHvpSet._();
  @$core.override
  RequestHvpSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHvpSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHvpSet>(create);
  static RequestHvpSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get amplitude => $_getN(0);
  @$pb.TagNumber(1)
  set amplitude($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAmplitude() => $_has(0);
  @$pb.TagNumber(1)
  void clearAmplitude() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get frequency => $_getIZ(1);
  @$pb.TagNumber(2)
  set frequency($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFrequency() => $_has(1);
  @$pb.TagNumber(2)
  void clearFrequency() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get position => $_getN(2);
  @$pb.TagNumber(3)
  set position($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPosition() => $_has(2);
  @$pb.TagNumber(3)
  void clearPosition() => $_clearField(3);
}

class ResponseHvpSet extends $pb.GeneratedMessage {
  factory ResponseHvpSet({
    $0.HvpState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHvpSet._();

  factory ResponseHvpSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHvpSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHvpSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HvpState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HvpState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHvpSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHvpSet copyWith(void Function(ResponseHvpSet) updates) =>
      super.copyWith((message) => updates(message as ResponseHvpSet))
          as ResponseHvpSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHvpSet create() => ResponseHvpSet._();
  @$core.override
  ResponseHvpSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHvpSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHvpSet>(create);
  static ResponseHvpSet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HvpState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HvpState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HvpState ensureState() => $_ensure(0);
}

/// 901
class RequestHvpStop extends $pb.GeneratedMessage {
  factory RequestHvpStop() => create();

  RequestHvpStop._();

  factory RequestHvpStop.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHvpStop.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHvpStop',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHvpStop clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHvpStop copyWith(void Function(RequestHvpStop) updates) =>
      super.copyWith((message) => updates(message as RequestHvpStop))
          as RequestHvpStop;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHvpStop create() => RequestHvpStop._();
  @$core.override
  RequestHvpStop createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHvpStop getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHvpStop>(create);
  static RequestHvpStop? _defaultInstance;
}

class ResponseHvpStop extends $pb.GeneratedMessage {
  factory ResponseHvpStop({
    $0.HvpState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHvpStop._();

  factory ResponseHvpStop.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHvpStop.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHvpStop',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HvpState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HvpState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHvpStop clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHvpStop copyWith(void Function(ResponseHvpStop) updates) =>
      super.copyWith((message) => updates(message as ResponseHvpStop))
          as ResponseHvpStop;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHvpStop create() => ResponseHvpStop._();
  @$core.override
  ResponseHvpStop createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHvpStop getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHvpStop>(create);
  static ResponseHvpStop? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HvpState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HvpState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HvpState ensureState() => $_ensure(0);
}

/// 902
class RequestHvpStart extends $pb.GeneratedMessage {
  factory RequestHvpStart() => create();

  RequestHvpStart._();

  factory RequestHvpStart.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHvpStart.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHvpStart',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHvpStart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHvpStart copyWith(void Function(RequestHvpStart) updates) =>
      super.copyWith((message) => updates(message as RequestHvpStart))
          as RequestHvpStart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHvpStart create() => RequestHvpStart._();
  @$core.override
  RequestHvpStart createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHvpStart getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHvpStart>(create);
  static RequestHvpStart? _defaultInstance;
}

class ResponseHvpStart extends $pb.GeneratedMessage {
  factory ResponseHvpStart({
    $0.HvpState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHvpStart._();

  factory ResponseHvpStart.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHvpStart.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHvpStart',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HvpState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HvpState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHvpStart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHvpStart copyWith(void Function(ResponseHvpStart) updates) =>
      super.copyWith((message) => updates(message as ResponseHvpStart))
          as ResponseHvpStart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHvpStart create() => ResponseHvpStart._();
  @$core.override
  ResponseHvpStart createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHvpStart getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHvpStart>(create);
  static ResponseHvpStart? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HvpState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HvpState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HvpState ensureState() => $_ensure(0);
}

/// 903
class RequestHvpStateGet extends $pb.GeneratedMessage {
  factory RequestHvpStateGet() => create();

  RequestHvpStateGet._();

  factory RequestHvpStateGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHvpStateGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHvpStateGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHvpStateGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHvpStateGet copyWith(void Function(RequestHvpStateGet) updates) =>
      super.copyWith((message) => updates(message as RequestHvpStateGet))
          as RequestHvpStateGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHvpStateGet create() => RequestHvpStateGet._();
  @$core.override
  RequestHvpStateGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHvpStateGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHvpStateGet>(create);
  static RequestHvpStateGet? _defaultInstance;
}

class ResponseHvpStateGet extends $pb.GeneratedMessage {
  factory ResponseHvpStateGet({
    $0.HvpState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHvpStateGet._();

  factory ResponseHvpStateGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHvpStateGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHvpStateGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HvpState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HvpState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHvpStateGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHvpStateGet copyWith(void Function(ResponseHvpStateGet) updates) =>
      super.copyWith((message) => updates(message as ResponseHvpStateGet))
          as ResponseHvpStateGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHvpStateGet create() => ResponseHvpStateGet._();
  @$core.override
  ResponseHvpStateGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHvpStateGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHvpStateGet>(create);
  static ResponseHvpStateGet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HvpState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HvpState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HvpState ensureState() => $_ensure(0);
}

/// Added in FW4.0.14 - But some messages where altered in FW4.0.15. So, only compatible with FW4.0.15 and later
/// 920-960
class RequestHrppStart extends $pb.GeneratedMessage {
  factory RequestHrppStart() => create();

  RequestHrppStart._();

  factory RequestHrppStart.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHrppStart.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHrppStart',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHrppStart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHrppStart copyWith(void Function(RequestHrppStart) updates) =>
      super.copyWith((message) => updates(message as RequestHrppStart))
          as RequestHrppStart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHrppStart create() => RequestHrppStart._();
  @$core.override
  RequestHrppStart createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHrppStart getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHrppStart>(create);
  static RequestHrppStart? _defaultInstance;
}

class ResponseHrppStart extends $pb.GeneratedMessage {
  factory ResponseHrppStart({
    $0.HrppState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHrppStart._();

  factory ResponseHrppStart.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHrppStart.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHrppStart',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HrppState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HrppState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHrppStart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHrppStart copyWith(void Function(ResponseHrppStart) updates) =>
      super.copyWith((message) => updates(message as ResponseHrppStart))
          as ResponseHrppStart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHrppStart create() => ResponseHrppStart._();
  @$core.override
  ResponseHrppStart createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHrppStart getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHrppStart>(create);
  static ResponseHrppStart? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HrppState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HrppState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HrppState ensureState() => $_ensure(0);
}

/// 921
class RequestHrppStop extends $pb.GeneratedMessage {
  factory RequestHrppStop() => create();

  RequestHrppStop._();

  factory RequestHrppStop.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHrppStop.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHrppStop',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHrppStop clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHrppStop copyWith(void Function(RequestHrppStop) updates) =>
      super.copyWith((message) => updates(message as RequestHrppStop))
          as RequestHrppStop;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHrppStop create() => RequestHrppStop._();
  @$core.override
  RequestHrppStop createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHrppStop getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHrppStop>(create);
  static RequestHrppStop? _defaultInstance;
}

class ResponseHrppStop extends $pb.GeneratedMessage {
  factory ResponseHrppStop({
    $0.HrppState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHrppStop._();

  factory ResponseHrppStop.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHrppStop.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHrppStop',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HrppState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HrppState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHrppStop clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHrppStop copyWith(void Function(ResponseHrppStop) updates) =>
      super.copyWith((message) => updates(message as ResponseHrppStop))
          as ResponseHrppStop;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHrppStop create() => ResponseHrppStop._();
  @$core.override
  ResponseHrppStop createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHrppStop getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHrppStop>(create);
  static ResponseHrppStop? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HrppState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HrppState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HrppState ensureState() => $_ensure(0);
}

/// 922
class RequestHrppAmplitudeSet extends $pb.GeneratedMessage {
  factory RequestHrppAmplitudeSet({
    $core.double? amplitude,
  }) {
    final result = create();
    if (amplitude != null) result.amplitude = amplitude;
    return result;
  }

  RequestHrppAmplitudeSet._();

  factory RequestHrppAmplitudeSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHrppAmplitudeSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHrppAmplitudeSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'amplitude', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHrppAmplitudeSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHrppAmplitudeSet copyWith(
          void Function(RequestHrppAmplitudeSet) updates) =>
      super.copyWith((message) => updates(message as RequestHrppAmplitudeSet))
          as RequestHrppAmplitudeSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHrppAmplitudeSet create() => RequestHrppAmplitudeSet._();
  @$core.override
  RequestHrppAmplitudeSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHrppAmplitudeSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHrppAmplitudeSet>(create);
  static RequestHrppAmplitudeSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get amplitude => $_getN(0);
  @$pb.TagNumber(1)
  set amplitude($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAmplitude() => $_has(0);
  @$pb.TagNumber(1)
  void clearAmplitude() => $_clearField(1);
}

class ResponseHrppAmplitudeSet extends $pb.GeneratedMessage {
  factory ResponseHrppAmplitudeSet({
    $0.HrppState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHrppAmplitudeSet._();

  factory ResponseHrppAmplitudeSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHrppAmplitudeSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHrppAmplitudeSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HrppState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HrppState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHrppAmplitudeSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHrppAmplitudeSet copyWith(
          void Function(ResponseHrppAmplitudeSet) updates) =>
      super.copyWith((message) => updates(message as ResponseHrppAmplitudeSet))
          as ResponseHrppAmplitudeSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHrppAmplitudeSet create() => ResponseHrppAmplitudeSet._();
  @$core.override
  ResponseHrppAmplitudeSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHrppAmplitudeSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHrppAmplitudeSet>(create);
  static ResponseHrppAmplitudeSet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HrppState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HrppState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HrppState ensureState() => $_ensure(0);
}

/// 923 deprecated in FW4.2 - use RequestHrppPlaybackRateSet instead
///  message RequestHrppPlaybackSpeedSet{
///      float speed = 1; //Must be bigger than 0
///  }
///  message ResponseHrppPlaybackSpeedSet{
///      HrppState state = 1;
///  }
/// 924
class RequestHrppPatternSet extends $pb.GeneratedMessage {
  factory RequestHrppPatternSet({
    $core.int? patternNr,
  }) {
    final result = create();
    if (patternNr != null) result.patternNr = patternNr;
    return result;
  }

  RequestHrppPatternSet._();

  factory RequestHrppPatternSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHrppPatternSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHrppPatternSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'patternNr', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHrppPatternSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHrppPatternSet copyWith(
          void Function(RequestHrppPatternSet) updates) =>
      super.copyWith((message) => updates(message as RequestHrppPatternSet))
          as RequestHrppPatternSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHrppPatternSet create() => RequestHrppPatternSet._();
  @$core.override
  RequestHrppPatternSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHrppPatternSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHrppPatternSet>(create);
  static RequestHrppPatternSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get patternNr => $_getIZ(0);
  @$pb.TagNumber(1)
  set patternNr($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatternNr() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatternNr() => $_clearField(1);
}

class ResponseHrppPatternSet extends $pb.GeneratedMessage {
  factory ResponseHrppPatternSet({
    $0.HrppState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHrppPatternSet._();

  factory ResponseHrppPatternSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHrppPatternSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHrppPatternSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HrppState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HrppState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHrppPatternSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHrppPatternSet copyWith(
          void Function(ResponseHrppPatternSet) updates) =>
      super.copyWith((message) => updates(message as ResponseHrppPatternSet))
          as ResponseHrppPatternSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHrppPatternSet create() => ResponseHrppPatternSet._();
  @$core.override
  ResponseHrppPatternSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHrppPatternSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHrppPatternSet>(create);
  static ResponseHrppPatternSet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HrppState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HrppState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HrppState ensureState() => $_ensure(0);
}

/// 925
class RequestHrppStateGet extends $pb.GeneratedMessage {
  factory RequestHrppStateGet() => create();

  RequestHrppStateGet._();

  factory RequestHrppStateGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHrppStateGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHrppStateGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHrppStateGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHrppStateGet copyWith(void Function(RequestHrppStateGet) updates) =>
      super.copyWith((message) => updates(message as RequestHrppStateGet))
          as RequestHrppStateGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHrppStateGet create() => RequestHrppStateGet._();
  @$core.override
  RequestHrppStateGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHrppStateGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHrppStateGet>(create);
  static RequestHrppStateGet? _defaultInstance;
}

class ResponseHrppStateGet extends $pb.GeneratedMessage {
  factory ResponseHrppStateGet({
    $0.HrppState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHrppStateGet._();

  factory ResponseHrppStateGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHrppStateGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHrppStateGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HrppState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HrppState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHrppStateGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHrppStateGet copyWith(void Function(ResponseHrppStateGet) updates) =>
      super.copyWith((message) => updates(message as ResponseHrppStateGet))
          as ResponseHrppStateGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHrppStateGet create() => ResponseHrppStateGet._();
  @$core.override
  ResponseHrppStateGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHrppStateGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHrppStateGet>(create);
  static ResponseHrppStateGet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HrppState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HrppState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HrppState ensureState() => $_ensure(0);
}

/// 926
class RequestHrppPatternsGet extends $pb.GeneratedMessage {
  factory RequestHrppPatternsGet() => create();

  RequestHrppPatternsGet._();

  factory RequestHrppPatternsGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHrppPatternsGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHrppPatternsGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHrppPatternsGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHrppPatternsGet copyWith(
          void Function(RequestHrppPatternsGet) updates) =>
      super.copyWith((message) => updates(message as RequestHrppPatternsGet))
          as RequestHrppPatternsGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHrppPatternsGet create() => RequestHrppPatternsGet._();
  @$core.override
  RequestHrppPatternsGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHrppPatternsGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHrppPatternsGet>(create);
  static RequestHrppPatternsGet? _defaultInstance;
}

class ResponseHrppPatternsGet extends $pb.GeneratedMessage {
  factory ResponseHrppPatternsGet({
    $0.HrppState? state,
    $core.Iterable<$0.HrppPattern>? patterns,
  }) {
    final result = create();
    if (state != null) result.state = state;
    if (patterns != null) result.patterns.addAll(patterns);
    return result;
  }

  ResponseHrppPatternsGet._();

  factory ResponseHrppPatternsGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHrppPatternsGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHrppPatternsGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HrppState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HrppState.create)
    ..pPM<$0.HrppPattern>(2, _omitFieldNames ? '' : 'patterns',
        subBuilder: $0.HrppPattern.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHrppPatternsGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHrppPatternsGet copyWith(
          void Function(ResponseHrppPatternsGet) updates) =>
      super.copyWith((message) => updates(message as ResponseHrppPatternsGet))
          as ResponseHrppPatternsGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHrppPatternsGet create() => ResponseHrppPatternsGet._();
  @$core.override
  ResponseHrppPatternsGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHrppPatternsGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHrppPatternsGet>(create);
  static ResponseHrppPatternsGet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HrppState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HrppState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HrppState ensureState() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<$0.HrppPattern> get patterns => $_getList(1);
}

/// 927 - Added in 4.2 replaces RequestHrppPlaybackSpeedSet
class RequestHrppPlaybackRateSet extends $pb.GeneratedMessage {
  factory RequestHrppPlaybackRateSet({
    $core.double? playbackRate,
  }) {
    final result = create();
    if (playbackRate != null) result.playbackRate = playbackRate;
    return result;
  }

  RequestHrppPlaybackRateSet._();

  factory RequestHrppPlaybackRateSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHrppPlaybackRateSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHrppPlaybackRateSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'playbackRate',
        fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHrppPlaybackRateSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHrppPlaybackRateSet copyWith(
          void Function(RequestHrppPlaybackRateSet) updates) =>
      super.copyWith(
              (message) => updates(message as RequestHrppPlaybackRateSet))
          as RequestHrppPlaybackRateSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHrppPlaybackRateSet create() => RequestHrppPlaybackRateSet._();
  @$core.override
  RequestHrppPlaybackRateSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHrppPlaybackRateSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHrppPlaybackRateSet>(create);
  static RequestHrppPlaybackRateSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get playbackRate => $_getN(0);
  @$pb.TagNumber(1)
  set playbackRate($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlaybackRate() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlaybackRate() => $_clearField(1);
}

class ResponseHrppPlaybackRateSet extends $pb.GeneratedMessage {
  factory ResponseHrppPlaybackRateSet({
    $0.HrppState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHrppPlaybackRateSet._();

  factory ResponseHrppPlaybackRateSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHrppPlaybackRateSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHrppPlaybackRateSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HrppState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HrppState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHrppPlaybackRateSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHrppPlaybackRateSet copyWith(
          void Function(ResponseHrppPlaybackRateSet) updates) =>
      super.copyWith(
              (message) => updates(message as ResponseHrppPlaybackRateSet))
          as ResponseHrppPlaybackRateSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHrppPlaybackRateSet create() =>
      ResponseHrppPlaybackRateSet._();
  @$core.override
  ResponseHrppPlaybackRateSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHrppPlaybackRateSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHrppPlaybackRateSet>(create);
  static ResponseHrppPlaybackRateSet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HrppState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HrppState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HrppState ensureState() => $_ensure(0);
}

/// Added in FW4.2
class RequestHrppPause extends $pb.GeneratedMessage {
  factory RequestHrppPause() => create();

  RequestHrppPause._();

  factory RequestHrppPause.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHrppPause.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHrppPause',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHrppPause clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHrppPause copyWith(void Function(RequestHrppPause) updates) =>
      super.copyWith((message) => updates(message as RequestHrppPause))
          as RequestHrppPause;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHrppPause create() => RequestHrppPause._();
  @$core.override
  RequestHrppPause createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestHrppPause getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHrppPause>(create);
  static RequestHrppPause? _defaultInstance;
}

class ResponseHrppPause extends $pb.GeneratedMessage {
  factory ResponseHrppPause({
    $0.HrppState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHrppPause._();

  factory ResponseHrppPause.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHrppPause.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHrppPause',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HrppState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HrppState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHrppPause clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHrppPause copyWith(void Function(ResponseHrppPause) updates) =>
      super.copyWith((message) => updates(message as ResponseHrppPause))
          as ResponseHrppPause;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHrppPause create() => ResponseHrppPause._();
  @$core.override
  ResponseHrppPause createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseHrppPause getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHrppPause>(create);
  static ResponseHrppPause? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HrppState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HrppState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.HrppState ensureState() => $_ensure(0);
}

/// 2015 - Motor regulator tuning. Values are clamped by the firmware; read
/// back after a Set to see what actually applied.
/// Field meanings: see DIAG_TUNING_GUIDE.md in the firmware repo.
/// Added in FW4.4
class RequestSettingsRegulatorGet extends $pb.GeneratedMessage {
  factory RequestSettingsRegulatorGet() => create();

  RequestSettingsRegulatorGet._();

  factory RequestSettingsRegulatorGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestSettingsRegulatorGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestSettingsRegulatorGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSettingsRegulatorGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSettingsRegulatorGet copyWith(
          void Function(RequestSettingsRegulatorGet) updates) =>
      super.copyWith(
              (message) => updates(message as RequestSettingsRegulatorGet))
          as RequestSettingsRegulatorGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestSettingsRegulatorGet create() =>
      RequestSettingsRegulatorGet._();
  @$core.override
  RequestSettingsRegulatorGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestSettingsRegulatorGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestSettingsRegulatorGet>(create);
  static RequestSettingsRegulatorGet? _defaultInstance;
}

class ResponseSettingsRegulatorGet extends $pb.GeneratedMessage {
  factory ResponseSettingsRegulatorGet({
    $core.int? profileId,
    $core.int? designId,
    $core.double? kp,
    $core.double? ki,
    $core.double? kd,
    $core.double? feedforwardGain,
    $core.double? feedforwardOffset,
    $core.double? trimLimit,
    $core.double? overspeedMargin,
    $core.double? errorDeadband,
    $core.double? derivativeAlpha,
    $core.double? turnBrakeScale,
    $core.double? turnMinPower,
    $core.double? turnPowerScale,
    $core.double? turnReversePower,
    $core.double? turnReverseSpeedThreshold,
    $core.double? turnReverseMinMs,
    $core.double? turnReverseHardMaxMs,
    $core.double? turnReverseBacktrackMm,
    $core.double? turnPostReverseBrakeMs,
    $core.bool? modified,
    $core.double? turnPowerScaleBack,
    $core.double? backlashMm,
    $core.double? backlashPower,
    $core.double? backlashMaxMs,
    ResponseSettingsRegulatorGet? defaults,
    RegulatorEffective? effective,
    $core.int? trimHandover,
    $core.double? trimNegLimit,
    $core.double? feedforwardGainDelta,
    $core.double? feedforwardOffsetDelta,
    $core.double? overspeedGain,
    $core.double? underspeedMargin,
    $core.double? underspeedGain,
    $core.double? turnFadeMs,
  }) {
    final result = create();
    if (profileId != null) result.profileId = profileId;
    if (designId != null) result.designId = designId;
    if (kp != null) result.kp = kp;
    if (ki != null) result.ki = ki;
    if (kd != null) result.kd = kd;
    if (feedforwardGain != null) result.feedforwardGain = feedforwardGain;
    if (feedforwardOffset != null) result.feedforwardOffset = feedforwardOffset;
    if (trimLimit != null) result.trimLimit = trimLimit;
    if (overspeedMargin != null) result.overspeedMargin = overspeedMargin;
    if (errorDeadband != null) result.errorDeadband = errorDeadband;
    if (derivativeAlpha != null) result.derivativeAlpha = derivativeAlpha;
    if (turnBrakeScale != null) result.turnBrakeScale = turnBrakeScale;
    if (turnMinPower != null) result.turnMinPower = turnMinPower;
    if (turnPowerScale != null) result.turnPowerScale = turnPowerScale;
    if (turnReversePower != null) result.turnReversePower = turnReversePower;
    if (turnReverseSpeedThreshold != null)
      result.turnReverseSpeedThreshold = turnReverseSpeedThreshold;
    if (turnReverseMinMs != null) result.turnReverseMinMs = turnReverseMinMs;
    if (turnReverseHardMaxMs != null)
      result.turnReverseHardMaxMs = turnReverseHardMaxMs;
    if (turnReverseBacktrackMm != null)
      result.turnReverseBacktrackMm = turnReverseBacktrackMm;
    if (turnPostReverseBrakeMs != null)
      result.turnPostReverseBrakeMs = turnPostReverseBrakeMs;
    if (modified != null) result.modified = modified;
    if (turnPowerScaleBack != null)
      result.turnPowerScaleBack = turnPowerScaleBack;
    if (backlashMm != null) result.backlashMm = backlashMm;
    if (backlashPower != null) result.backlashPower = backlashPower;
    if (backlashMaxMs != null) result.backlashMaxMs = backlashMaxMs;
    if (defaults != null) result.defaults = defaults;
    if (effective != null) result.effective = effective;
    if (trimHandover != null) result.trimHandover = trimHandover;
    if (trimNegLimit != null) result.trimNegLimit = trimNegLimit;
    if (feedforwardGainDelta != null)
      result.feedforwardGainDelta = feedforwardGainDelta;
    if (feedforwardOffsetDelta != null)
      result.feedforwardOffsetDelta = feedforwardOffsetDelta;
    if (overspeedGain != null) result.overspeedGain = overspeedGain;
    if (underspeedMargin != null) result.underspeedMargin = underspeedMargin;
    if (underspeedGain != null) result.underspeedGain = underspeedGain;
    if (turnFadeMs != null) result.turnFadeMs = turnFadeMs;
    return result;
  }

  ResponseSettingsRegulatorGet._();

  factory ResponseSettingsRegulatorGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseSettingsRegulatorGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseSettingsRegulatorGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'profileId', fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'designId', fieldType: $pb.PbFieldType.OU3)
    ..aD(3, _omitFieldNames ? '' : 'kp', fieldType: $pb.PbFieldType.OF)
    ..aD(4, _omitFieldNames ? '' : 'ki', fieldType: $pb.PbFieldType.OF)
    ..aD(5, _omitFieldNames ? '' : 'kd', fieldType: $pb.PbFieldType.OF)
    ..aD(6, _omitFieldNames ? '' : 'feedforwardGain',
        fieldType: $pb.PbFieldType.OF)
    ..aD(7, _omitFieldNames ? '' : 'feedforwardOffset',
        fieldType: $pb.PbFieldType.OF)
    ..aD(8, _omitFieldNames ? '' : 'trimLimit', fieldType: $pb.PbFieldType.OF)
    ..aD(9, _omitFieldNames ? '' : 'overspeedMargin',
        fieldType: $pb.PbFieldType.OF)
    ..aD(12, _omitFieldNames ? '' : 'errorDeadband',
        fieldType: $pb.PbFieldType.OF)
    ..aD(13, _omitFieldNames ? '' : 'derivativeAlpha',
        fieldType: $pb.PbFieldType.OF)
    ..aD(19, _omitFieldNames ? '' : 'turnBrakeScale',
        fieldType: $pb.PbFieldType.OF)
    ..aD(20, _omitFieldNames ? '' : 'turnMinPower',
        fieldType: $pb.PbFieldType.OF)
    ..aD(21, _omitFieldNames ? '' : 'turnPowerScale',
        fieldType: $pb.PbFieldType.OF)
    ..aD(23, _omitFieldNames ? '' : 'turnReversePower',
        fieldType: $pb.PbFieldType.OF)
    ..aD(24, _omitFieldNames ? '' : 'turnReverseSpeedThreshold',
        fieldType: $pb.PbFieldType.OF)
    ..aD(25, _omitFieldNames ? '' : 'turnReverseMinMs',
        fieldType: $pb.PbFieldType.OF)
    ..aD(26, _omitFieldNames ? '' : 'turnReverseHardMaxMs',
        fieldType: $pb.PbFieldType.OF)
    ..aD(27, _omitFieldNames ? '' : 'turnReverseBacktrackMm',
        fieldType: $pb.PbFieldType.OF)
    ..aD(28, _omitFieldNames ? '' : 'turnPostReverseBrakeMs',
        fieldType: $pb.PbFieldType.OF)
    ..aOB(29, _omitFieldNames ? '' : 'modified')
    ..aD(32, _omitFieldNames ? '' : 'turnPowerScaleBack',
        fieldType: $pb.PbFieldType.OF)
    ..aD(33, _omitFieldNames ? '' : 'backlashMm', fieldType: $pb.PbFieldType.OF)
    ..aD(34, _omitFieldNames ? '' : 'backlashPower',
        fieldType: $pb.PbFieldType.OF)
    ..aD(35, _omitFieldNames ? '' : 'backlashMaxMs',
        fieldType: $pb.PbFieldType.OF)
    ..aOM<ResponseSettingsRegulatorGet>(36, _omitFieldNames ? '' : 'defaults',
        subBuilder: ResponseSettingsRegulatorGet.create)
    ..aOM<RegulatorEffective>(37, _omitFieldNames ? '' : 'effective',
        subBuilder: RegulatorEffective.create)
    ..aI(38, _omitFieldNames ? '' : 'trimHandover',
        fieldType: $pb.PbFieldType.OU3)
    ..aD(40, _omitFieldNames ? '' : 'trimNegLimit',
        fieldType: $pb.PbFieldType.OF)
    ..aD(41, _omitFieldNames ? '' : 'feedforwardGainDelta',
        fieldType: $pb.PbFieldType.OF)
    ..aD(42, _omitFieldNames ? '' : 'feedforwardOffsetDelta',
        fieldType: $pb.PbFieldType.OF)
    ..aD(43, _omitFieldNames ? '' : 'overspeedGain',
        fieldType: $pb.PbFieldType.OF)
    ..aD(44, _omitFieldNames ? '' : 'underspeedMargin',
        fieldType: $pb.PbFieldType.OF)
    ..aD(45, _omitFieldNames ? '' : 'underspeedGain',
        fieldType: $pb.PbFieldType.OF)
    ..aD(46, _omitFieldNames ? '' : 'turnFadeMs', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSettingsRegulatorGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSettingsRegulatorGet copyWith(
          void Function(ResponseSettingsRegulatorGet) updates) =>
      super.copyWith(
              (message) => updates(message as ResponseSettingsRegulatorGet))
          as ResponseSettingsRegulatorGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseSettingsRegulatorGet create() =>
      ResponseSettingsRegulatorGet._();
  @$core.override
  ResponseSettingsRegulatorGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseSettingsRegulatorGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseSettingsRegulatorGet>(create);
  static ResponseSettingsRegulatorGet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get profileId => $_getIZ(0);
  @$pb.TagNumber(1)
  set profileId($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProfileId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProfileId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get designId => $_getIZ(1);
  @$pb.TagNumber(2)
  set designId($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDesignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDesignId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get kp => $_getN(2);
  @$pb.TagNumber(3)
  set kp($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasKp() => $_has(2);
  @$pb.TagNumber(3)
  void clearKp() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get ki => $_getN(3);
  @$pb.TagNumber(4)
  set ki($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasKi() => $_has(3);
  @$pb.TagNumber(4)
  void clearKi() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get kd => $_getN(4);
  @$pb.TagNumber(5)
  set kd($core.double value) => $_setFloat(4, value);
  @$pb.TagNumber(5)
  $core.bool hasKd() => $_has(4);
  @$pb.TagNumber(5)
  void clearKd() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get feedforwardGain => $_getN(5);
  @$pb.TagNumber(6)
  set feedforwardGain($core.double value) => $_setFloat(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFeedforwardGain() => $_has(5);
  @$pb.TagNumber(6)
  void clearFeedforwardGain() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get feedforwardOffset => $_getN(6);
  @$pb.TagNumber(7)
  set feedforwardOffset($core.double value) => $_setFloat(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFeedforwardOffset() => $_has(6);
  @$pb.TagNumber(7)
  void clearFeedforwardOffset() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get trimLimit => $_getN(7);
  @$pb.TagNumber(8)
  set trimLimit($core.double value) => $_setFloat(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTrimLimit() => $_has(7);
  @$pb.TagNumber(8)
  void clearTrimLimit() => $_clearField(8);

  /// Speed correction pair (2026-09-15) - ONE UI card, two rows (overspeed / underspeed), each a
  /// TRIGGER in mm/s beyond the target (0 = no dead zone) and a MULTIPLIER in output units per mm/s
  /// beyond the trigger (0 = that side off). Overspeed pulls output (and bleeds trim); underspeed
  /// adds output. Continuous at the trigger. Independent of the +180 hard stop (never disabled).
  /// NB semantics change: before 2026-09-15 overspeed_margin 0 meant OFF; off is now overspeed_gain 0.
  @$pb.TagNumber(9)
  $core.double get overspeedMargin => $_getN(8);
  @$pb.TagNumber(9)
  set overspeedMargin($core.double value) => $_setFloat(8, value);
  @$pb.TagNumber(9)
  $core.bool hasOverspeedMargin() => $_has(8);
  @$pb.TagNumber(9)
  void clearOverspeedMargin() => $_clearField(9);

  @$pb.TagNumber(12)
  $core.double get errorDeadband => $_getN(9);
  @$pb.TagNumber(12)
  set errorDeadband($core.double value) => $_setFloat(9, value);
  @$pb.TagNumber(12)
  $core.bool hasErrorDeadband() => $_has(9);
  @$pb.TagNumber(12)
  void clearErrorDeadband() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.double get derivativeAlpha => $_getN(10);
  @$pb.TagNumber(13)
  set derivativeAlpha($core.double value) => $_setFloat(10, value);
  @$pb.TagNumber(13)
  $core.bool hasDerivativeAlpha() => $_has(10);
  @$pb.TagNumber(13)
  void clearDerivativeAlpha() => $_clearField(13);

  @$pb.TagNumber(19)
  $core.double get turnBrakeScale => $_getN(11);
  @$pb.TagNumber(19)
  set turnBrakeScale($core.double value) => $_setFloat(11, value);
  @$pb.TagNumber(19)
  $core.bool hasTurnBrakeScale() => $_has(11);
  @$pb.TagNumber(19)
  void clearTurnBrakeScale() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.double get turnMinPower => $_getN(12);
  @$pb.TagNumber(20)
  set turnMinPower($core.double value) => $_setFloat(12, value);
  @$pb.TagNumber(20)
  $core.bool hasTurnMinPower() => $_has(12);
  @$pb.TagNumber(20)
  void clearTurnMinPower() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.double get turnPowerScale => $_getN(13);
  @$pb.TagNumber(21)
  set turnPowerScale($core.double value) => $_setFloat(13, value);
  @$pb.TagNumber(21)
  $core.bool hasTurnPowerScale() => $_has(13);
  @$pb.TagNumber(21)
  void clearTurnPowerScale() => $_clearField(21);

  @$pb.TagNumber(23)
  $core.double get turnReversePower => $_getN(14);
  @$pb.TagNumber(23)
  set turnReversePower($core.double value) => $_setFloat(14, value);
  @$pb.TagNumber(23)
  $core.bool hasTurnReversePower() => $_has(14);
  @$pb.TagNumber(23)
  void clearTurnReversePower() => $_clearField(23);

  @$pb.TagNumber(24)
  $core.double get turnReverseSpeedThreshold => $_getN(15);
  @$pb.TagNumber(24)
  set turnReverseSpeedThreshold($core.double value) => $_setFloat(15, value);
  @$pb.TagNumber(24)
  $core.bool hasTurnReverseSpeedThreshold() => $_has(15);
  @$pb.TagNumber(24)
  void clearTurnReverseSpeedThreshold() => $_clearField(24);

  @$pb.TagNumber(25)
  $core.double get turnReverseMinMs => $_getN(16);
  @$pb.TagNumber(25)
  set turnReverseMinMs($core.double value) => $_setFloat(16, value);
  @$pb.TagNumber(25)
  $core.bool hasTurnReverseMinMs() => $_has(16);
  @$pb.TagNumber(25)
  void clearTurnReverseMinMs() => $_clearField(25);

  @$pb.TagNumber(26)
  $core.double get turnReverseHardMaxMs => $_getN(17);
  @$pb.TagNumber(26)
  set turnReverseHardMaxMs($core.double value) => $_setFloat(17, value);
  @$pb.TagNumber(26)
  $core.bool hasTurnReverseHardMaxMs() => $_has(17);
  @$pb.TagNumber(26)
  void clearTurnReverseHardMaxMs() => $_clearField(26);

  @$pb.TagNumber(27)
  $core.double get turnReverseBacktrackMm => $_getN(18);
  @$pb.TagNumber(27)
  set turnReverseBacktrackMm($core.double value) => $_setFloat(18, value);
  @$pb.TagNumber(27)
  $core.bool hasTurnReverseBacktrackMm() => $_has(18);
  @$pb.TagNumber(27)
  void clearTurnReverseBacktrackMm() => $_clearField(27);

  @$pb.TagNumber(28)
  $core.double get turnPostReverseBrakeMs => $_getN(19);
  @$pb.TagNumber(28)
  set turnPostReverseBrakeMs($core.double value) => $_setFloat(19, value);
  @$pb.TagNumber(28)
  $core.bool hasTurnPostReverseBrakeMs() => $_has(19);
  @$pb.TagNumber(28)
  void clearTurnPostReverseBrakeMs() => $_clearField(28);

  /// RENAMED AGAIN in FW4.4 (is_default -> persisted -> modified, same field
  /// number): true = the live tuning differs from the SELECTED profile's
  /// saved values, i.e. unsaved RAM-only edits exist (lost on reboot or any
  /// profile Apply; keep them with SlideProfileStore 854). Same value as
  /// SlideProfileGet.modified. Per-field comparison: `defaults` below.
  @$pb.TagNumber(29)
  $core.bool get modified => $_getBF(20);
  @$pb.TagNumber(29)
  set modified($core.bool value) => $_setBool(20, value);
  @$pb.TagNumber(29)
  $core.bool hasModified() => $_has(20);
  @$pb.TagNumber(29)
  void clearModified() => $_clearField(29);

  @$pb.TagNumber(32)
  $core.double get turnPowerScaleBack => $_getN(21);
  @$pb.TagNumber(32)
  set turnPowerScaleBack($core.double value) => $_setFloat(21, value);
  @$pb.TagNumber(32)
  $core.bool hasTurnPowerScaleBack() => $_has(21);
  @$pb.TagNumber(32)
  void clearTurnPowerScaleBack() => $_clearField(32);

  /// Backlash take-up stage: after the turn brake, creep at backlash_power until
  /// backlash_mm of motor rotation (or backlash_max_ms), then launch. 0 mm = off.
  @$pb.TagNumber(33)
  $core.double get backlashMm => $_getN(22);
  @$pb.TagNumber(33)
  set backlashMm($core.double value) => $_setFloat(22, value);
  @$pb.TagNumber(33)
  $core.bool hasBacklashMm() => $_has(22);
  @$pb.TagNumber(33)
  void clearBacklashMm() => $_clearField(33);

  @$pb.TagNumber(34)
  $core.double get backlashPower => $_getN(23);
  @$pb.TagNumber(34)
  set backlashPower($core.double value) => $_setFloat(23, value);
  @$pb.TagNumber(34)
  $core.bool hasBacklashPower() => $_has(23);
  @$pb.TagNumber(34)
  void clearBacklashPower() => $_clearField(34);

  @$pb.TagNumber(35)
  $core.double get backlashMaxMs => $_getN(24);
  @$pb.TagNumber(35)
  set backlashMaxMs($core.double value) => $_setFloat(24, value);
  @$pb.TagNumber(35)
  $core.bool hasBacklashMaxMs() => $_has(24);
  @$pb.TagNumber(35)
  void clearBacklashMaxMs() => $_clearField(35);

  /// The SELECTED profile's baseline value for every field above (one level
  /// deep - defaults.defaults is never set; `modified` inside it is
  /// meaningless). Since FW4.4 `defaults` is the SELECTED profile's saved
  /// values - for a custom slot that is the slot's stored tuning (empty
  /// slot = Balanced), so per-field revert always targets YOUR baseline. Per-field revert UX: show defaults.<field> next to the
  /// live value, render a modified indicator when they differ, and revert by
  /// writing defaults.<field> through SettingsRegulatorSet. Since FW4.4 the
  /// setters accept 0 as a LITERAL value (off where meaningful) - 0 no
  /// longer means "reset to default"; this field replaces that mechanism.
  @$pb.TagNumber(36)
  ResponseSettingsRegulatorGet get defaults => $_getN(25);
  @$pb.TagNumber(36)
  set defaults(ResponseSettingsRegulatorGet value) => $_setField(36, value);
  @$pb.TagNumber(36)
  $core.bool hasDefaults() => $_has(25);
  @$pb.TagNumber(36)
  void clearDefaults() => $_clearField(36);
  @$pb.TagNumber(36)
  ResponseSettingsRegulatorGet ensureDefaults() => $_ensure(25);

  /// Read-only DERIVED values the control loop actually uses - the ceilings and compiled
  /// constants behind the tunables, resolved for this unit (OC raises x_max_speed and with it
  /// the trim ceiling). Show these next to the tunables; they are not settable through
  /// SettingsRegulatorSet. Not populated inside `defaults`. Added in FW4.4
  @$pb.TagNumber(37)
  RegulatorEffective get effective => $_getN(26);
  @$pb.TagNumber(37)
  set effective(RegulatorEffective value) => $_setField(37, value);
  @$pb.TagNumber(37)
  $core.bool hasEffective() => $_has(26);
  @$pb.TagNumber(37)
  void clearEffective() => $_clearField(37);
  @$pb.TagNumber(37)
  RegulatorEffective ensureEffective() => $_ensure(26);

  /// Trim handover (FW4.4, settled 2026-09-07). The integral trim is what the SINGLE
  /// feedforward line does not capture (gravity, load, unit variation). trim_handover 0 =
  /// every launch into a direction starts from ZERO trim (legacy); 1 (DEFAULT since 2026-09-10) = per-direction
  /// BANK: the trim a direction has when it ENDS (reversal or stop) is stored as it is (RAM
  /// only, cleared on any tuning or profile change) and restored at the next launch into that
  /// direction - so a loaded unit is not behind after every reversal, and a loop that cannot
  /// converge inside one stroke keeps accumulating across strokes instead of restarting from
  /// zero. No convergence gate or confidence ramp (removed 2026-09-08). Never carried across
  /// directions. effective.trim_bank_*_confidence is 0 until the direction has run once, then 1.
  /// Expert field.
  @$pb.TagNumber(38)
  $core.int get trimHandover => $_getIZ(27);
  @$pb.TagNumber(38)
  set trimHandover($core.int value) => $_setUnsignedInt32(27, value);
  @$pb.TagNumber(38)
  $core.bool hasTrimHandover() => $_has(27);
  @$pb.TagNumber(38)
  void clearTrimHandover() => $_clearField(38);

  /// The trim FLOOR in output units, a NEGATIVE number (default -150) so it reads as the bound
  /// it is. Positive trim may reach trim_limit x x_max_speed (see effective.trim_limit_output);
  /// negative trim stops here, small by design: a large negative trim is integrator windup,
  /// not load compensation. A positive value sent by a client is accepted as a magnitude and
  /// stored negative; 0 = legacy symmetric clamp. Expert field. Draw both bounds on the trim
  /// trace: [effective.trim_neg_limit_output, effective.trim_limit_output].
  @$pb.TagNumber(40)
  $core.double get trimNegLimit => $_getN(28);
  @$pb.TagNumber(40)
  set trimNegLimit($core.double value) => $_setFloat(28, value);
  @$pb.TagNumber(40)
  $core.bool hasTrimNegLimit() => $_has(28);
  @$pb.TagNumber(40)
  void clearTrimNegLimit() => $_clearField(40);

  /// Per-direction feedforward as a SYMMETRIC DELTA around the single line (2026-09-10, replaces
  /// the back twins 30/31): forward = feedforward_gain + delta, backward = feedforward_gain - delta,
  /// offset likewise. 0/0 = both directions identical (every built-in profile); positive = the
  /// forward direction needs more (gravity on an upright unit). EXPERT fields - but the UI should
  /// still SHOW the resolved forward/backward lines whenever a delta is non-zero, even with the
  /// expert group hidden: read them from effective.feedforward_*_forward/backward (23-26).
  /// Clamped on the device: |gain delta| <= feedforward_gain, |offset delta| <= 500.
  @$pb.TagNumber(41)
  $core.double get feedforwardGainDelta => $_getN(29);
  @$pb.TagNumber(41)
  set feedforwardGainDelta($core.double value) => $_setFloat(29, value);
  @$pb.TagNumber(41)
  $core.bool hasFeedforwardGainDelta() => $_has(29);
  @$pb.TagNumber(41)
  void clearFeedforwardGainDelta() => $_clearField(41);

  @$pb.TagNumber(42)
  $core.double get feedforwardOffsetDelta => $_getN(30);
  @$pb.TagNumber(42)
  set feedforwardOffsetDelta($core.double value) => $_setFloat(30, value);
  @$pb.TagNumber(42)
  $core.bool hasFeedforwardOffsetDelta() => $_has(30);
  @$pb.TagNumber(42)
  void clearFeedforwardOffsetDelta() => $_clearField(42);

  @$pb.TagNumber(43)
  $core.double get overspeedGain => $_getN(31);
  @$pb.TagNumber(43)
  set overspeedGain($core.double value) => $_setFloat(31, value);
  @$pb.TagNumber(43)
  $core.bool hasOverspeedGain() => $_has(31);
  @$pb.TagNumber(43)
  void clearOverspeedGain() => $_clearField(43);

  @$pb.TagNumber(44)
  $core.double get underspeedMargin => $_getN(32);
  @$pb.TagNumber(44)
  set underspeedMargin($core.double value) => $_setFloat(32, value);
  @$pb.TagNumber(44)
  $core.bool hasUnderspeedMargin() => $_has(32);
  @$pb.TagNumber(44)
  void clearUnderspeedMargin() => $_clearField(44);

  @$pb.TagNumber(45)
  $core.double get underspeedGain => $_getN(33);
  @$pb.TagNumber(45)
  set underspeedGain($core.double value) => $_setFloat(33, value);
  @$pb.TagNumber(45)
  $core.bool hasUnderspeedGain() => $_has(33);
  @$pb.TagNumber(45)
  void clearUnderspeedGain() => $_clearField(45);

  @$pb.TagNumber(46)
  $core.double get turnFadeMs => $_getN(34);
  @$pb.TagNumber(46)
  set turnFadeMs($core.double value) => $_setFloat(34, value);
  @$pb.TagNumber(46)
  $core.bool hasTurnFadeMs() => $_has(34);
  @$pb.TagNumber(46)
  void clearTurnFadeMs() => $_clearField(46);
}

class RegulatorEffective extends $pb.GeneratedMessage {
  factory RegulatorEffective({
    $core.double? trimLimitOutput,
    $core.double? derivativeOutputLimit,
    $core.double? effectiveMaxOutput,
    $core.double? overspeedStopMargin,
    $core.int? tickPeriodMs,
    $core.double? turnSpeedReference,
    $core.double? motorMaxPower,
    $core.int? pwmFreqHz,
    $core.int? pwmResolutionBits,
    $core.int? xMaxSpeed,
    $core.int? xMaxSpeedTheoretical,
    $core.int? xMinSpeedTheoretical,
    $core.double? turnSpeed,
    $core.int? turnStopMaxTimeMs,
    $core.int? turnStopSpeedThreshold,
    $core.double? trimBankForward,
    $core.double? trimBankForwardConfidence,
    $core.double? trimBankBackward,
    $core.double? trimBankBackwardConfidence,
    $core.double? trimNegLimitOutput,
    $core.double? feedforwardGainForward,
    $core.double? feedforwardOffsetForward,
    $core.double? feedforwardGainBackward,
    $core.double? feedforwardOffsetBackward,
  }) {
    final result = create();
    if (trimLimitOutput != null) result.trimLimitOutput = trimLimitOutput;
    if (derivativeOutputLimit != null)
      result.derivativeOutputLimit = derivativeOutputLimit;
    if (effectiveMaxOutput != null)
      result.effectiveMaxOutput = effectiveMaxOutput;
    if (overspeedStopMargin != null)
      result.overspeedStopMargin = overspeedStopMargin;
    if (tickPeriodMs != null) result.tickPeriodMs = tickPeriodMs;
    if (turnSpeedReference != null)
      result.turnSpeedReference = turnSpeedReference;
    if (motorMaxPower != null) result.motorMaxPower = motorMaxPower;
    if (pwmFreqHz != null) result.pwmFreqHz = pwmFreqHz;
    if (pwmResolutionBits != null) result.pwmResolutionBits = pwmResolutionBits;
    if (xMaxSpeed != null) result.xMaxSpeed = xMaxSpeed;
    if (xMaxSpeedTheoretical != null)
      result.xMaxSpeedTheoretical = xMaxSpeedTheoretical;
    if (xMinSpeedTheoretical != null)
      result.xMinSpeedTheoretical = xMinSpeedTheoretical;
    if (turnSpeed != null) result.turnSpeed = turnSpeed;
    if (turnStopMaxTimeMs != null) result.turnStopMaxTimeMs = turnStopMaxTimeMs;
    if (turnStopSpeedThreshold != null)
      result.turnStopSpeedThreshold = turnStopSpeedThreshold;
    if (trimBankForward != null) result.trimBankForward = trimBankForward;
    if (trimBankForwardConfidence != null)
      result.trimBankForwardConfidence = trimBankForwardConfidence;
    if (trimBankBackward != null) result.trimBankBackward = trimBankBackward;
    if (trimBankBackwardConfidence != null)
      result.trimBankBackwardConfidence = trimBankBackwardConfidence;
    if (trimNegLimitOutput != null)
      result.trimNegLimitOutput = trimNegLimitOutput;
    if (feedforwardGainForward != null)
      result.feedforwardGainForward = feedforwardGainForward;
    if (feedforwardOffsetForward != null)
      result.feedforwardOffsetForward = feedforwardOffsetForward;
    if (feedforwardGainBackward != null)
      result.feedforwardGainBackward = feedforwardGainBackward;
    if (feedforwardOffsetBackward != null)
      result.feedforwardOffsetBackward = feedforwardOffsetBackward;
    return result;
  }

  RegulatorEffective._();

  factory RegulatorEffective.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegulatorEffective.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegulatorEffective',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'trimLimitOutput',
        fieldType: $pb.PbFieldType.OF)
    ..aD(2, _omitFieldNames ? '' : 'derivativeOutputLimit',
        fieldType: $pb.PbFieldType.OF)
    ..aD(3, _omitFieldNames ? '' : 'effectiveMaxOutput',
        fieldType: $pb.PbFieldType.OF)
    ..aD(4, _omitFieldNames ? '' : 'overspeedStopMargin',
        fieldType: $pb.PbFieldType.OF)
    ..aI(5, _omitFieldNames ? '' : 'tickPeriodMs',
        fieldType: $pb.PbFieldType.OU3)
    ..aD(6, _omitFieldNames ? '' : 'turnSpeedReference',
        fieldType: $pb.PbFieldType.OF)
    ..aD(7, _omitFieldNames ? '' : 'motorMaxPower',
        fieldType: $pb.PbFieldType.OF)
    ..aI(8, _omitFieldNames ? '' : 'pwmFreqHz', fieldType: $pb.PbFieldType.OU3)
    ..aI(9, _omitFieldNames ? '' : 'pwmResolutionBits',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(10, _omitFieldNames ? '' : 'xMaxSpeed', fieldType: $pb.PbFieldType.OU3)
    ..aI(11, _omitFieldNames ? '' : 'xMaxSpeedTheoretical',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(12, _omitFieldNames ? '' : 'xMinSpeedTheoretical',
        fieldType: $pb.PbFieldType.OU3)
    ..aD(13, _omitFieldNames ? '' : 'turnSpeed', fieldType: $pb.PbFieldType.OF)
    ..aI(14, _omitFieldNames ? '' : 'turnStopMaxTimeMs',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(15, _omitFieldNames ? '' : 'turnStopSpeedThreshold',
        fieldType: $pb.PbFieldType.OU3)
    ..aD(16, _omitFieldNames ? '' : 'trimBankForward',
        fieldType: $pb.PbFieldType.OF)
    ..aD(18, _omitFieldNames ? '' : 'trimBankForwardConfidence',
        fieldType: $pb.PbFieldType.OF)
    ..aD(19, _omitFieldNames ? '' : 'trimBankBackward',
        fieldType: $pb.PbFieldType.OF)
    ..aD(21, _omitFieldNames ? '' : 'trimBankBackwardConfidence',
        fieldType: $pb.PbFieldType.OF)
    ..aD(22, _omitFieldNames ? '' : 'trimNegLimitOutput',
        fieldType: $pb.PbFieldType.OF)
    ..aD(23, _omitFieldNames ? '' : 'feedforwardGainForward',
        fieldType: $pb.PbFieldType.OF)
    ..aD(24, _omitFieldNames ? '' : 'feedforwardOffsetForward',
        fieldType: $pb.PbFieldType.OF)
    ..aD(25, _omitFieldNames ? '' : 'feedforwardGainBackward',
        fieldType: $pb.PbFieldType.OF)
    ..aD(26, _omitFieldNames ? '' : 'feedforwardOffsetBackward',
        fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegulatorEffective clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegulatorEffective copyWith(void Function(RegulatorEffective) updates) =>
      super.copyWith((message) => updates(message as RegulatorEffective))
          as RegulatorEffective;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegulatorEffective create() => RegulatorEffective._();
  @$core.override
  RegulatorEffective createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegulatorEffective getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegulatorEffective>(create);
  static RegulatorEffective? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get trimLimitOutput => $_getN(0);
  @$pb.TagNumber(1)
  set trimLimitOutput($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTrimLimitOutput() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrimLimitOutput() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get derivativeOutputLimit => $_getN(1);
  @$pb.TagNumber(2)
  set derivativeOutputLimit($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDerivativeOutputLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearDerivativeOutputLimit() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get effectiveMaxOutput => $_getN(2);
  @$pb.TagNumber(3)
  set effectiveMaxOutput($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEffectiveMaxOutput() => $_has(2);
  @$pb.TagNumber(3)
  void clearEffectiveMaxOutput() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get overspeedStopMargin => $_getN(3);
  @$pb.TagNumber(4)
  set overspeedStopMargin($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOverspeedStopMargin() => $_has(3);
  @$pb.TagNumber(4)
  void clearOverspeedStopMargin() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get tickPeriodMs => $_getIZ(4);
  @$pb.TagNumber(5)
  set tickPeriodMs($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTickPeriodMs() => $_has(4);
  @$pb.TagNumber(5)
  void clearTickPeriodMs() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get turnSpeedReference => $_getN(5);
  @$pb.TagNumber(6)
  set turnSpeedReference($core.double value) => $_setFloat(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTurnSpeedReference() => $_has(5);
  @$pb.TagNumber(6)
  void clearTurnSpeedReference() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get motorMaxPower => $_getN(6);
  @$pb.TagNumber(7)
  set motorMaxPower($core.double value) => $_setFloat(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMotorMaxPower() => $_has(6);
  @$pb.TagNumber(7)
  void clearMotorMaxPower() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get pwmFreqHz => $_getIZ(7);
  @$pb.TagNumber(8)
  set pwmFreqHz($core.int value) => $_setUnsignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPwmFreqHz() => $_has(7);
  @$pb.TagNumber(8)
  void clearPwmFreqHz() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get pwmResolutionBits => $_getIZ(8);
  @$pb.TagNumber(9)
  set pwmResolutionBits($core.int value) => $_setUnsignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPwmResolutionBits() => $_has(8);
  @$pb.TagNumber(9)
  void clearPwmResolutionBits() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get xMaxSpeed => $_getIZ(9);
  @$pb.TagNumber(10)
  set xMaxSpeed($core.int value) => $_setUnsignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasXMaxSpeed() => $_has(9);
  @$pb.TagNumber(10)
  void clearXMaxSpeed() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get xMaxSpeedTheoretical => $_getIZ(10);
  @$pb.TagNumber(11)
  set xMaxSpeedTheoretical($core.int value) => $_setUnsignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasXMaxSpeedTheoretical() => $_has(10);
  @$pb.TagNumber(11)
  void clearXMaxSpeedTheoretical() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get xMinSpeedTheoretical => $_getIZ(11);
  @$pb.TagNumber(12)
  set xMinSpeedTheoretical($core.int value) => $_setUnsignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasXMinSpeedTheoretical() => $_has(11);
  @$pb.TagNumber(12)
  void clearXMinSpeedTheoretical() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.double get turnSpeed => $_getN(12);
  @$pb.TagNumber(13)
  set turnSpeed($core.double value) => $_setFloat(12, value);
  @$pb.TagNumber(13)
  $core.bool hasTurnSpeed() => $_has(12);
  @$pb.TagNumber(13)
  void clearTurnSpeed() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.int get turnStopMaxTimeMs => $_getIZ(13);
  @$pb.TagNumber(14)
  set turnStopMaxTimeMs($core.int value) => $_setUnsignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasTurnStopMaxTimeMs() => $_has(13);
  @$pb.TagNumber(14)
  void clearTurnStopMaxTimeMs() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get turnStopSpeedThreshold => $_getIZ(14);
  @$pb.TagNumber(15)
  set turnStopSpeedThreshold($core.int value) => $_setUnsignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasTurnStopSpeedThreshold() => $_has(14);
  @$pb.TagNumber(15)
  void clearTurnStopSpeedThreshold() => $_clearField(15);

  /// Per-direction trim bank state (FW4.4, trim_handover 1), read-only, RAM-only: the learned
  /// residual [output units] that the single feedforward line does not capture (gravity, load,
  /// friction), the target speed it settled at [mm/s], and the confidence [0-1] a launch would
  /// load it with (0 until ~30 settled ticks, 1 from ~150). Show this in the tuning tool so a
  /// user can SEE what each direction has learned; it resets on any tuning or profile change.
  @$pb.TagNumber(16)
  $core.double get trimBankForward => $_getN(15);
  @$pb.TagNumber(16)
  set trimBankForward($core.double value) => $_setFloat(15, value);
  @$pb.TagNumber(16)
  $core.bool hasTrimBankForward() => $_has(15);
  @$pb.TagNumber(16)
  void clearTrimBankForward() => $_clearField(16);

  @$pb.TagNumber(18)
  $core.double get trimBankForwardConfidence => $_getN(16);
  @$pb.TagNumber(18)
  set trimBankForwardConfidence($core.double value) => $_setFloat(16, value);
  @$pb.TagNumber(18)
  $core.bool hasTrimBankForwardConfidence() => $_has(16);
  @$pb.TagNumber(18)
  void clearTrimBankForwardConfidence() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.double get trimBankBackward => $_getN(17);
  @$pb.TagNumber(19)
  set trimBankBackward($core.double value) => $_setFloat(17, value);
  @$pb.TagNumber(19)
  $core.bool hasTrimBankBackward() => $_has(17);
  @$pb.TagNumber(19)
  void clearTrimBankBackward() => $_clearField(19);

  @$pb.TagNumber(21)
  $core.double get trimBankBackwardConfidence => $_getN(18);
  @$pb.TagNumber(21)
  set trimBankBackwardConfidence($core.double value) => $_setFloat(18, value);
  @$pb.TagNumber(21)
  $core.bool hasTrimBankBackwardConfidence() => $_has(18);
  @$pb.TagNumber(21)
  void clearTrimBankBackwardConfidence() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.double get trimNegLimitOutput => $_getN(19);
  @$pb.TagNumber(22)
  set trimNegLimitOutput($core.double value) => $_setFloat(19, value);
  @$pb.TagNumber(22)
  $core.bool hasTrimNegLimitOutput() => $_has(19);
  @$pb.TagNumber(22)
  void clearTrimNegLimitOutput() => $_clearField(22);

  /// The RESOLVED per-direction feedforward lines (base +- delta, 2026-09-10). Show these as
  /// "forward: gain x v + offset / backward: ..." whenever feedforward_gain_delta or
  /// feedforward_offset_delta is non-zero, even when the expert delta fields themselves are hidden.
  @$pb.TagNumber(23)
  $core.double get feedforwardGainForward => $_getN(20);
  @$pb.TagNumber(23)
  set feedforwardGainForward($core.double value) => $_setFloat(20, value);
  @$pb.TagNumber(23)
  $core.bool hasFeedforwardGainForward() => $_has(20);
  @$pb.TagNumber(23)
  void clearFeedforwardGainForward() => $_clearField(23);

  @$pb.TagNumber(24)
  $core.double get feedforwardOffsetForward => $_getN(21);
  @$pb.TagNumber(24)
  set feedforwardOffsetForward($core.double value) => $_setFloat(21, value);
  @$pb.TagNumber(24)
  $core.bool hasFeedforwardOffsetForward() => $_has(21);
  @$pb.TagNumber(24)
  void clearFeedforwardOffsetForward() => $_clearField(24);

  @$pb.TagNumber(25)
  $core.double get feedforwardGainBackward => $_getN(22);
  @$pb.TagNumber(25)
  set feedforwardGainBackward($core.double value) => $_setFloat(22, value);
  @$pb.TagNumber(25)
  $core.bool hasFeedforwardGainBackward() => $_has(22);
  @$pb.TagNumber(25)
  void clearFeedforwardGainBackward() => $_clearField(25);

  @$pb.TagNumber(26)
  $core.double get feedforwardOffsetBackward => $_getN(23);
  @$pb.TagNumber(26)
  set feedforwardOffsetBackward($core.double value) => $_setFloat(23, value);
  @$pb.TagNumber(26)
  $core.bool hasFeedforwardOffsetBackward() => $_has(23);
  @$pb.TagNumber(26)
  void clearFeedforwardOffsetBackward() => $_clearField(26);
}

/// 2017 - Hall sensor / speed-estimate tuning. Same semantics as the
/// regulator settings (clamped, `persisted`, guide in DIAG_TUNING_GUIDE.md).
/// Added in FW4.4
class RequestSettingsHallGet extends $pb.GeneratedMessage {
  factory RequestSettingsHallGet() => create();

  RequestSettingsHallGet._();

  factory RequestSettingsHallGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestSettingsHallGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestSettingsHallGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSettingsHallGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSettingsHallGet copyWith(
          void Function(RequestSettingsHallGet) updates) =>
      super.copyWith((message) => updates(message as RequestSettingsHallGet))
          as RequestSettingsHallGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestSettingsHallGet create() => RequestSettingsHallGet._();
  @$core.override
  RequestSettingsHallGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestSettingsHallGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestSettingsHallGet>(create);
  static RequestSettingsHallGet? _defaultInstance;
}

class ResponseSettingsHallGet extends $pb.GeneratedMessage {
  factory ResponseSettingsHallGet({
    $core.int? profileId,
    $core.double? speedFilterAlpha,
    $core.int? reversalFilterUs,
    $core.int? zeroTimeoutTickMult,
    $core.int? zeroTimeoutMaxMs,
    $core.int? minDtUs,
    $core.int? maxDtUs,
    $core.bool? persisted,
  }) {
    final result = create();
    if (profileId != null) result.profileId = profileId;
    if (speedFilterAlpha != null) result.speedFilterAlpha = speedFilterAlpha;
    if (reversalFilterUs != null) result.reversalFilterUs = reversalFilterUs;
    if (zeroTimeoutTickMult != null)
      result.zeroTimeoutTickMult = zeroTimeoutTickMult;
    if (zeroTimeoutMaxMs != null) result.zeroTimeoutMaxMs = zeroTimeoutMaxMs;
    if (minDtUs != null) result.minDtUs = minDtUs;
    if (maxDtUs != null) result.maxDtUs = maxDtUs;
    if (persisted != null) result.persisted = persisted;
    return result;
  }

  ResponseSettingsHallGet._();

  factory ResponseSettingsHallGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseSettingsHallGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseSettingsHallGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'profileId', fieldType: $pb.PbFieldType.OU3)
    ..aD(2, _omitFieldNames ? '' : 'speedFilterAlpha',
        fieldType: $pb.PbFieldType.OF)
    ..aI(3, _omitFieldNames ? '' : 'reversalFilterUs',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(4, _omitFieldNames ? '' : 'zeroTimeoutTickMult',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(5, _omitFieldNames ? '' : 'zeroTimeoutMaxMs',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(6, _omitFieldNames ? '' : 'minDtUs', fieldType: $pb.PbFieldType.OU3)
    ..aI(7, _omitFieldNames ? '' : 'maxDtUs', fieldType: $pb.PbFieldType.OU3)
    ..aOB(8, _omitFieldNames ? '' : 'persisted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSettingsHallGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSettingsHallGet copyWith(
          void Function(ResponseSettingsHallGet) updates) =>
      super.copyWith((message) => updates(message as ResponseSettingsHallGet))
          as ResponseSettingsHallGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseSettingsHallGet create() => ResponseSettingsHallGet._();
  @$core.override
  ResponseSettingsHallGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseSettingsHallGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseSettingsHallGet>(create);
  static ResponseSettingsHallGet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get profileId => $_getIZ(0);
  @$pb.TagNumber(1)
  set profileId($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProfileId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProfileId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get speedFilterAlpha => $_getN(1);
  @$pb.TagNumber(2)
  set speedFilterAlpha($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSpeedFilterAlpha() => $_has(1);
  @$pb.TagNumber(2)
  void clearSpeedFilterAlpha() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get reversalFilterUs => $_getIZ(2);
  @$pb.TagNumber(3)
  set reversalFilterUs($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReversalFilterUs() => $_has(2);
  @$pb.TagNumber(3)
  void clearReversalFilterUs() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get zeroTimeoutTickMult => $_getIZ(3);
  @$pb.TagNumber(4)
  set zeroTimeoutTickMult($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasZeroTimeoutTickMult() => $_has(3);
  @$pb.TagNumber(4)
  void clearZeroTimeoutTickMult() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get zeroTimeoutMaxMs => $_getIZ(4);
  @$pb.TagNumber(5)
  set zeroTimeoutMaxMs($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasZeroTimeoutMaxMs() => $_has(4);
  @$pb.TagNumber(5)
  void clearZeroTimeoutMaxMs() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get minDtUs => $_getIZ(5);
  @$pb.TagNumber(6)
  set minDtUs($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMinDtUs() => $_has(5);
  @$pb.TagNumber(6)
  void clearMinDtUs() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get maxDtUs => $_getIZ(6);
  @$pb.TagNumber(7)
  set maxDtUs($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMaxDtUs() => $_has(6);
  @$pb.TagNumber(7)
  void clearMaxDtUs() => $_clearField(7);

  /// RENAMED in FW4.4 (was is_default, same field number, INVERTED):
  /// true = stored in NVS and survives a reboot.
  @$pb.TagNumber(8)
  $core.bool get persisted => $_getBF(7);
  @$pb.TagNumber(8)
  set persisted($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPersisted() => $_has(7);
  @$pb.TagNumber(8)
  void clearPersisted() => $_clearField(8);
}

/// 2019 - The SELECTED profile and its state. Since FW4.4 the profile system
/// is: 5 LOCKED curated profiles + 2 user banks (CUSTOM_1/2). One live tuning
/// exists in RAM; editing fields sets modified=true (RAM-only - a reboot or
/// any profile Apply discards edits); SlideProfileStore (854) is the ONLY way
/// to keep a tuning. Revert baselines: curated = compiled values; a saved
/// slot = its stored values; an empty slot = Balanced.
/// Added in FW4.4
class RequestSlideProfileGet extends $pb.GeneratedMessage {
  factory RequestSlideProfileGet() => create();

  RequestSlideProfileGet._();

  factory RequestSlideProfileGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestSlideProfileGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestSlideProfileGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSlideProfileGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSlideProfileGet copyWith(
          void Function(RequestSlideProfileGet) updates) =>
      super.copyWith((message) => updates(message as RequestSlideProfileGet))
          as RequestSlideProfileGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestSlideProfileGet create() => RequestSlideProfileGet._();
  @$core.override
  RequestSlideProfileGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestSlideProfileGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestSlideProfileGet>(create);
  static RequestSlideProfileGet? _defaultInstance;
}

class ResponseSlideProfileGet extends $pb.GeneratedMessage {
  factory ResponseSlideProfileGet({
    $0.SlideProfile? profile,
    $core.bool? modified,
    $core.bool? custom1Stored,
    $core.bool? custom2Stored,
    $0.SlideProfile? bootProfile,
  }) {
    final result = create();
    if (profile != null) result.profile = profile;
    if (modified != null) result.modified = modified;
    if (custom1Stored != null) result.custom1Stored = custom1Stored;
    if (custom2Stored != null) result.custom2Stored = custom2Stored;
    if (bootProfile != null) result.bootProfile = bootProfile;
    return result;
  }

  ResponseSlideProfileGet._();

  factory ResponseSlideProfileGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseSlideProfileGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseSlideProfileGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aE<$0.SlideProfile>(1, _omitFieldNames ? '' : 'profile',
        enumValues: $0.SlideProfile.values)
    ..aOB(2, _omitFieldNames ? '' : 'modified')
    ..aOB(3, _omitFieldNames ? '' : 'custom1Stored')
    ..aOB(4, _omitFieldNames ? '' : 'custom2Stored')
    ..aE<$0.SlideProfile>(5, _omitFieldNames ? '' : 'bootProfile',
        enumValues: $0.SlideProfile.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSlideProfileGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSlideProfileGet copyWith(
          void Function(ResponseSlideProfileGet) updates) =>
      super.copyWith((message) => updates(message as ResponseSlideProfileGet))
          as ResponseSlideProfileGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseSlideProfileGet create() => ResponseSlideProfileGet._();
  @$core.override
  ResponseSlideProfileGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseSlideProfileGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseSlideProfileGet>(create);
  static ResponseSlideProfileGet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.SlideProfile get profile => $_getN(0);
  @$pb.TagNumber(1)
  set profile($0.SlideProfile value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProfile() => $_has(0);
  @$pb.TagNumber(1)
  void clearProfile() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get modified => $_getBF(1);
  @$pb.TagNumber(2)
  set modified($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasModified() => $_has(1);
  @$pb.TagNumber(2)
  void clearModified() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get custom1Stored => $_getBF(2);
  @$pb.TagNumber(3)
  set custom1Stored($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCustom1Stored() => $_has(2);
  @$pb.TagNumber(3)
  void clearCustom1Stored() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get custom2Stored => $_getBF(3);
  @$pb.TagNumber(4)
  set custom2Stored($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCustom2Stored() => $_has(3);
  @$pb.TagNumber(4)
  void clearCustom2Stored() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.SlideProfile get bootProfile => $_getN(4);
  @$pb.TagNumber(5)
  set bootProfile($0.SlideProfile value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasBootProfile() => $_has(4);
  @$pb.TagNumber(5)
  void clearBootProfile() => $_clearField(5);
}

/// 855 - Read ANY profile's full tuning WITHOUT applying it: a pure read, no
/// side effects, safe during playback (the app can diff profiles side by side,
/// preview a slot, pre-fill an editor). `tuning` has the same shape as
/// ResponseSettingsRegulatorGet.defaults (one parser); its own `defaults` and
/// `modified` are unset. Values are reported normalized (= what Apply would
/// install). CUSTOM_1/2: stored=false means the slot is empty and the values
/// are the Balanced fallback. ACCURACY (deprecated) answers as SPORT. CUSTOM
/// (4) is rejected. One profile per call - the full set is too large for one
/// frame.
/// Added in FW4.4
class RequestSlideProfileTuningGet extends $pb.GeneratedMessage {
  factory RequestSlideProfileTuningGet({
    $0.SlideProfile? profile,
  }) {
    final result = create();
    if (profile != null) result.profile = profile;
    return result;
  }

  RequestSlideProfileTuningGet._();

  factory RequestSlideProfileTuningGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestSlideProfileTuningGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestSlideProfileTuningGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aE<$0.SlideProfile>(1, _omitFieldNames ? '' : 'profile',
        enumValues: $0.SlideProfile.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSlideProfileTuningGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSlideProfileTuningGet copyWith(
          void Function(RequestSlideProfileTuningGet) updates) =>
      super.copyWith(
              (message) => updates(message as RequestSlideProfileTuningGet))
          as RequestSlideProfileTuningGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestSlideProfileTuningGet create() =>
      RequestSlideProfileTuningGet._();
  @$core.override
  RequestSlideProfileTuningGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestSlideProfileTuningGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestSlideProfileTuningGet>(create);
  static RequestSlideProfileTuningGet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.SlideProfile get profile => $_getN(0);
  @$pb.TagNumber(1)
  set profile($0.SlideProfile value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProfile() => $_has(0);
  @$pb.TagNumber(1)
  void clearProfile() => $_clearField(1);
}

class ResponseSlideProfileTuningGet extends $pb.GeneratedMessage {
  factory ResponseSlideProfileTuningGet({
    $0.SlideProfile? profile,
    ResponseSettingsRegulatorGet? tuning,
    $core.bool? stored,
  }) {
    final result = create();
    if (profile != null) result.profile = profile;
    if (tuning != null) result.tuning = tuning;
    if (stored != null) result.stored = stored;
    return result;
  }

  ResponseSlideProfileTuningGet._();

  factory ResponseSlideProfileTuningGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseSlideProfileTuningGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseSlideProfileTuningGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aE<$0.SlideProfile>(1, _omitFieldNames ? '' : 'profile',
        enumValues: $0.SlideProfile.values)
    ..aOM<ResponseSettingsRegulatorGet>(2, _omitFieldNames ? '' : 'tuning',
        subBuilder: ResponseSettingsRegulatorGet.create)
    ..aOB(3, _omitFieldNames ? '' : 'stored')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSlideProfileTuningGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSlideProfileTuningGet copyWith(
          void Function(ResponseSlideProfileTuningGet) updates) =>
      super.copyWith(
              (message) => updates(message as ResponseSlideProfileTuningGet))
          as ResponseSlideProfileTuningGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseSlideProfileTuningGet create() =>
      ResponseSlideProfileTuningGet._();
  @$core.override
  ResponseSlideProfileTuningGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseSlideProfileTuningGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseSlideProfileTuningGet>(create);
  static ResponseSlideProfileTuningGet? _defaultInstance;

  @$pb.TagNumber(1)
  $0.SlideProfile get profile => $_getN(0);
  @$pb.TagNumber(1)
  set profile($0.SlideProfile value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProfile() => $_has(0);
  @$pb.TagNumber(1)
  void clearProfile() => $_clearField(1);

  @$pb.TagNumber(2)
  ResponseSettingsRegulatorGet get tuning => $_getN(1);
  @$pb.TagNumber(2)
  set tuning(ResponseSettingsRegulatorGet value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTuning() => $_has(1);
  @$pb.TagNumber(2)
  void clearTuning() => $_clearField(2);
  @$pb.TagNumber(2)
  ResponseSettingsRegulatorGet ensureTuning() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get stored => $_getBF(2);
  @$pb.TagNumber(3)
  set stored($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStored() => $_has(2);
  @$pb.TagNumber(3)
  void clearStored() => $_clearField(3);
}

/// 856 - Read the LAST results of the FW4.4 maintenance tests (RequestTestUniformity
/// 582, RequestTestMaxSpeed 583). Pure read, no motion. A result whose `result`
/// field is nonzero (or whose passes == 0) has not completed successfully since
/// boot - results are RAM only. Show `verdict` to the user; show the bins to a
/// technician / the factory (compare against a fleet template there).
/// Added in FW4.4
class RequestSlideMaintResultGet extends $pb.GeneratedMessage {
  factory RequestSlideMaintResultGet() => create();

  RequestSlideMaintResultGet._();

  factory RequestSlideMaintResultGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestSlideMaintResultGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestSlideMaintResultGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSlideMaintResultGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSlideMaintResultGet copyWith(
          void Function(RequestSlideMaintResultGet) updates) =>
      super.copyWith(
              (message) => updates(message as RequestSlideMaintResultGet))
          as RequestSlideMaintResultGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestSlideMaintResultGet create() => RequestSlideMaintResultGet._();
  @$core.override
  RequestSlideMaintResultGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestSlideMaintResultGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestSlideMaintResultGet>(create);
  static RequestSlideMaintResultGet? _defaultInstance;
}

class SlideMaintDirResult extends $pb.GeneratedMessage {
  factory SlideMaintDirResult({
    $core.Iterable<$core.double>? speed,
    $core.double? plateau,
    $core.double? riseMs,
    $core.double? worstDipPct,
    $core.int? worstDipBin,
    $core.int? passes,
    $core.double? mid,
    $core.double? gradientPct,
  }) {
    final result = create();
    if (speed != null) result.speed.addAll(speed);
    if (plateau != null) result.plateau = plateau;
    if (riseMs != null) result.riseMs = riseMs;
    if (worstDipPct != null) result.worstDipPct = worstDipPct;
    if (worstDipBin != null) result.worstDipBin = worstDipBin;
    if (passes != null) result.passes = passes;
    if (mid != null) result.mid = mid;
    if (gradientPct != null) result.gradientPct = gradientPct;
    return result;
  }

  SlideMaintDirResult._();

  factory SlideMaintDirResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SlideMaintDirResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SlideMaintDirResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..p<$core.double>(1, _omitFieldNames ? '' : 'speed', $pb.PbFieldType.KF)
    ..aD(2, _omitFieldNames ? '' : 'plateau', fieldType: $pb.PbFieldType.OF)
    ..aD(3, _omitFieldNames ? '' : 'riseMs', fieldType: $pb.PbFieldType.OF)
    ..aD(4, _omitFieldNames ? '' : 'worstDipPct', fieldType: $pb.PbFieldType.OF)
    ..aI(5, _omitFieldNames ? '' : 'worstDipBin',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(6, _omitFieldNames ? '' : 'passes', fieldType: $pb.PbFieldType.OU3)
    ..aD(7, _omitFieldNames ? '' : 'mid', fieldType: $pb.PbFieldType.OF)
    ..aD(8, _omitFieldNames ? '' : 'gradientPct', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SlideMaintDirResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SlideMaintDirResult copyWith(void Function(SlideMaintDirResult) updates) =>
      super.copyWith((message) => updates(message as SlideMaintDirResult))
          as SlideMaintDirResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SlideMaintDirResult create() => SlideMaintDirResult._();
  @$core.override
  SlideMaintDirResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SlideMaintDirResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SlideMaintDirResult>(create);
  static SlideMaintDirResult? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.double> get speed => $_getList(0);

  @$pb.TagNumber(2)
  $core.double get plateau => $_getN(1);
  @$pb.TagNumber(2)
  set plateau($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlateau() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlateau() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get riseMs => $_getN(2);
  @$pb.TagNumber(3)
  set riseMs($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRiseMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearRiseMs() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get worstDipPct => $_getN(3);
  @$pb.TagNumber(4)
  set worstDipPct($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWorstDipPct() => $_has(3);
  @$pb.TagNumber(4)
  void clearWorstDipPct() => $_clearField(4);

  /// acceleration peak, in travel order [%]. A bind is a notch; a gradient is not
  @$pb.TagNumber(5)
  $core.int get worstDipBin => $_getIZ(4);
  @$pb.TagNumber(5)
  set worstDipBin($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasWorstDipBin() => $_has(4);
  @$pb.TagNumber(5)
  void clearWorstDipBin() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get passes => $_getIZ(5);
  @$pb.TagNumber(6)
  set passes($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPasses() => $_has(5);
  @$pb.TagNumber(6)
  void clearPasses() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get mid => $_getN(6);
  @$pb.TagNumber(7)
  set mid($core.double value) => $_setFloat(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMid() => $_has(6);
  @$pb.TagNumber(7)
  void clearMid() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get gradientPct => $_getN(7);
  @$pb.TagNumber(8)
  set gradientPct($core.double value) => $_setFloat(7, value);
  @$pb.TagNumber(8)
  $core.bool hasGradientPct() => $_has(7);
  @$pb.TagNumber(8)
  void clearGradientPct() => $_clearField(8);
}

class SlideMaintUniformityResult extends $pb.GeneratedMessage {
  factory SlideMaintUniformityResult({
    $core.int? result,
    $core.double? duty,
    $core.double? binMm,
    $core.double? lo,
    $core.double? hi,
    SlideMaintDirResult? forward,
    SlideMaintDirResult? backward,
    $core.double? asymmetry,
    SlideMaintVerdict? verdict,
    $core.double? tempC,
    $core.int? timestampMs,
  }) {
    final result$ = create();
    if (result != null) result$.result = result;
    if (duty != null) result$.duty = duty;
    if (binMm != null) result$.binMm = binMm;
    if (lo != null) result$.lo = lo;
    if (hi != null) result$.hi = hi;
    if (forward != null) result$.forward = forward;
    if (backward != null) result$.backward = backward;
    if (asymmetry != null) result$.asymmetry = asymmetry;
    if (verdict != null) result$.verdict = verdict;
    if (tempC != null) result$.tempC = tempC;
    if (timestampMs != null) result$.timestampMs = timestampMs;
    return result$;
  }

  SlideMaintUniformityResult._();

  factory SlideMaintUniformityResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SlideMaintUniformityResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SlideMaintUniformityResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'result')
    ..aD(2, _omitFieldNames ? '' : 'duty', fieldType: $pb.PbFieldType.OF)
    ..aD(3, _omitFieldNames ? '' : 'binMm', fieldType: $pb.PbFieldType.OF)
    ..aD(4, _omitFieldNames ? '' : 'lo', fieldType: $pb.PbFieldType.OF)
    ..aD(5, _omitFieldNames ? '' : 'hi', fieldType: $pb.PbFieldType.OF)
    ..aOM<SlideMaintDirResult>(6, _omitFieldNames ? '' : 'forward',
        subBuilder: SlideMaintDirResult.create)
    ..aOM<SlideMaintDirResult>(7, _omitFieldNames ? '' : 'backward',
        subBuilder: SlideMaintDirResult.create)
    ..aD(8, _omitFieldNames ? '' : 'asymmetry', fieldType: $pb.PbFieldType.OF)
    ..aE<SlideMaintVerdict>(9, _omitFieldNames ? '' : 'verdict',
        enumValues: SlideMaintVerdict.values)
    ..aD(10, _omitFieldNames ? '' : 'tempC', fieldType: $pb.PbFieldType.OF)
    ..aI(11, _omitFieldNames ? '' : 'timestampMs',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SlideMaintUniformityResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SlideMaintUniformityResult copyWith(
          void Function(SlideMaintUniformityResult) updates) =>
      super.copyWith(
              (message) => updates(message as SlideMaintUniformityResult))
          as SlideMaintUniformityResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SlideMaintUniformityResult create() => SlideMaintUniformityResult._();
  @$core.override
  SlideMaintUniformityResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SlideMaintUniformityResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SlideMaintUniformityResult>(create);
  static SlideMaintUniformityResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get result => $_getIZ(0);
  @$pb.TagNumber(1)
  set result($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get duty => $_getN(1);
  @$pb.TagNumber(2)
  set duty($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDuty() => $_has(1);
  @$pb.TagNumber(2)
  void clearDuty() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get binMm => $_getN(2);
  @$pb.TagNumber(3)
  set binMm($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBinMm() => $_has(2);
  @$pb.TagNumber(3)
  void clearBinMm() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get lo => $_getN(3);
  @$pb.TagNumber(4)
  set lo($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLo() => $_has(3);
  @$pb.TagNumber(4)
  void clearLo() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get hi => $_getN(4);
  @$pb.TagNumber(5)
  set hi($core.double value) => $_setFloat(4, value);
  @$pb.TagNumber(5)
  $core.bool hasHi() => $_has(4);
  @$pb.TagNumber(5)
  void clearHi() => $_clearField(5);

  @$pb.TagNumber(6)
  SlideMaintDirResult get forward => $_getN(5);
  @$pb.TagNumber(6)
  set forward(SlideMaintDirResult value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasForward() => $_has(5);
  @$pb.TagNumber(6)
  void clearForward() => $_clearField(6);
  @$pb.TagNumber(6)
  SlideMaintDirResult ensureForward() => $_ensure(5);

  @$pb.TagNumber(7)
  SlideMaintDirResult get backward => $_getN(6);
  @$pb.TagNumber(7)
  set backward(SlideMaintDirResult value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasBackward() => $_has(6);
  @$pb.TagNumber(7)
  void clearBackward() => $_clearField(7);
  @$pb.TagNumber(7)
  SlideMaintDirResult ensureBackward() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.double get asymmetry => $_getN(7);
  @$pb.TagNumber(8)
  set asymmetry($core.double value) => $_setFloat(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAsymmetry() => $_has(7);
  @$pb.TagNumber(8)
  void clearAsymmetry() => $_clearField(8);

  @$pb.TagNumber(9)
  SlideMaintVerdict get verdict => $_getN(8);
  @$pb.TagNumber(9)
  set verdict(SlideMaintVerdict value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasVerdict() => $_has(8);
  @$pb.TagNumber(9)
  void clearVerdict() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get tempC => $_getN(9);
  @$pb.TagNumber(10)
  set tempC($core.double value) => $_setFloat(9, value);
  @$pb.TagNumber(10)
  $core.bool hasTempC() => $_has(9);
  @$pb.TagNumber(10)
  void clearTempC() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get timestampMs => $_getIZ(10);
  @$pb.TagNumber(11)
  set timestampMs($core.int value) => $_setUnsignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasTimestampMs() => $_has(10);
  @$pb.TagNumber(11)
  void clearTimestampMs() => $_clearField(11);
}

class SlideMaintMaxSpeedResult extends $pb.GeneratedMessage {
  factory SlideMaintMaxSpeedResult({
    $core.int? result,
    $core.double? peakForward,
    $core.double? peakBackward,
    $core.double? duty,
    $core.double? marginForward,
    $core.double? marginBackward,
    $core.bool? bufferHitForward,
    $core.bool? bufferHitBackward,
    $core.double? brakeK,
    $core.double? brakeCalSpeed,
    $core.double? brakeCalDist,
    $core.int? passes,
    SlideMaintVerdict? verdict,
    $core.double? tempC,
    $core.int? timestampMs,
  }) {
    final result$ = create();
    if (result != null) result$.result = result;
    if (peakForward != null) result$.peakForward = peakForward;
    if (peakBackward != null) result$.peakBackward = peakBackward;
    if (duty != null) result$.duty = duty;
    if (marginForward != null) result$.marginForward = marginForward;
    if (marginBackward != null) result$.marginBackward = marginBackward;
    if (bufferHitForward != null) result$.bufferHitForward = bufferHitForward;
    if (bufferHitBackward != null)
      result$.bufferHitBackward = bufferHitBackward;
    if (brakeK != null) result$.brakeK = brakeK;
    if (brakeCalSpeed != null) result$.brakeCalSpeed = brakeCalSpeed;
    if (brakeCalDist != null) result$.brakeCalDist = brakeCalDist;
    if (passes != null) result$.passes = passes;
    if (verdict != null) result$.verdict = verdict;
    if (tempC != null) result$.tempC = tempC;
    if (timestampMs != null) result$.timestampMs = timestampMs;
    return result$;
  }

  SlideMaintMaxSpeedResult._();

  factory SlideMaintMaxSpeedResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SlideMaintMaxSpeedResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SlideMaintMaxSpeedResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'result')
    ..aD(2, _omitFieldNames ? '' : 'peakForward', fieldType: $pb.PbFieldType.OF)
    ..aD(3, _omitFieldNames ? '' : 'peakBackward',
        fieldType: $pb.PbFieldType.OF)
    ..aD(4, _omitFieldNames ? '' : 'duty', fieldType: $pb.PbFieldType.OF)
    ..aD(5, _omitFieldNames ? '' : 'marginForward',
        fieldType: $pb.PbFieldType.OF)
    ..aD(6, _omitFieldNames ? '' : 'marginBackward',
        fieldType: $pb.PbFieldType.OF)
    ..aOB(7, _omitFieldNames ? '' : 'bufferHitForward')
    ..aOB(8, _omitFieldNames ? '' : 'bufferHitBackward')
    ..aD(9, _omitFieldNames ? '' : 'brakeK', fieldType: $pb.PbFieldType.OF)
    ..aD(10, _omitFieldNames ? '' : 'brakeCalSpeed',
        fieldType: $pb.PbFieldType.OF)
    ..aD(11, _omitFieldNames ? '' : 'brakeCalDist',
        fieldType: $pb.PbFieldType.OF)
    ..aI(12, _omitFieldNames ? '' : 'passes', fieldType: $pb.PbFieldType.OU3)
    ..aE<SlideMaintVerdict>(13, _omitFieldNames ? '' : 'verdict',
        enumValues: SlideMaintVerdict.values)
    ..aD(14, _omitFieldNames ? '' : 'tempC', fieldType: $pb.PbFieldType.OF)
    ..aI(15, _omitFieldNames ? '' : 'timestampMs',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SlideMaintMaxSpeedResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SlideMaintMaxSpeedResult copyWith(
          void Function(SlideMaintMaxSpeedResult) updates) =>
      super.copyWith((message) => updates(message as SlideMaintMaxSpeedResult))
          as SlideMaintMaxSpeedResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SlideMaintMaxSpeedResult create() => SlideMaintMaxSpeedResult._();
  @$core.override
  SlideMaintMaxSpeedResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SlideMaintMaxSpeedResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SlideMaintMaxSpeedResult>(create);
  static SlideMaintMaxSpeedResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get result => $_getIZ(0);
  @$pb.TagNumber(1)
  set result($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get peakForward => $_getN(1);
  @$pb.TagNumber(2)
  set peakForward($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPeakForward() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeakForward() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get peakBackward => $_getN(2);
  @$pb.TagNumber(3)
  set peakBackward($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPeakBackward() => $_has(2);
  @$pb.TagNumber(3)
  void clearPeakBackward() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get duty => $_getN(3);
  @$pb.TagNumber(4)
  set duty($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDuty() => $_has(3);
  @$pb.TagNumber(4)
  void clearDuty() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get marginForward => $_getN(4);
  @$pb.TagNumber(5)
  set marginForward($core.double value) => $_setFloat(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMarginForward() => $_has(4);
  @$pb.TagNumber(5)
  void clearMarginForward() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get marginBackward => $_getN(5);
  @$pb.TagNumber(6)
  set marginBackward($core.double value) => $_setFloat(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMarginBackward() => $_has(5);
  @$pb.TagNumber(6)
  void clearMarginBackward() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get bufferHitForward => $_getBF(6);
  @$pb.TagNumber(7)
  set bufferHitForward($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBufferHitForward() => $_has(6);
  @$pb.TagNumber(7)
  void clearBufferHitForward() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get bufferHitBackward => $_getBF(7);
  @$pb.TagNumber(8)
  set bufferHitBackward($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasBufferHitBackward() => $_has(7);
  @$pb.TagNumber(8)
  void clearBufferHitBackward() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get brakeK => $_getN(8);
  @$pb.TagNumber(9)
  set brakeK($core.double value) => $_setFloat(8, value);
  @$pb.TagNumber(9)
  $core.bool hasBrakeK() => $_has(8);
  @$pb.TagNumber(9)
  void clearBrakeK() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get brakeCalSpeed => $_getN(9);
  @$pb.TagNumber(10)
  set brakeCalSpeed($core.double value) => $_setFloat(9, value);
  @$pb.TagNumber(10)
  $core.bool hasBrakeCalSpeed() => $_has(9);
  @$pb.TagNumber(10)
  void clearBrakeCalSpeed() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get brakeCalDist => $_getN(10);
  @$pb.TagNumber(11)
  set brakeCalDist($core.double value) => $_setFloat(10, value);
  @$pb.TagNumber(11)
  $core.bool hasBrakeCalDist() => $_has(10);
  @$pb.TagNumber(11)
  void clearBrakeCalDist() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get passes => $_getIZ(11);
  @$pb.TagNumber(12)
  set passes($core.int value) => $_setUnsignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasPasses() => $_has(11);
  @$pb.TagNumber(12)
  void clearPasses() => $_clearField(12);

  @$pb.TagNumber(13)
  SlideMaintVerdict get verdict => $_getN(12);
  @$pb.TagNumber(13)
  set verdict(SlideMaintVerdict value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasVerdict() => $_has(12);
  @$pb.TagNumber(13)
  void clearVerdict() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.double get tempC => $_getN(13);
  @$pb.TagNumber(14)
  set tempC($core.double value) => $_setFloat(13, value);
  @$pb.TagNumber(14)
  $core.bool hasTempC() => $_has(13);
  @$pb.TagNumber(14)
  void clearTempC() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get timestampMs => $_getIZ(14);
  @$pb.TagNumber(15)
  set timestampMs($core.int value) => $_setUnsignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasTimestampMs() => $_has(14);
  @$pb.TagNumber(15)
  void clearTimestampMs() => $_clearField(15);
}

class ResponseSlideMaintResultGet extends $pb.GeneratedMessage {
  factory ResponseSlideMaintResultGet({
    SlideMaintUniformityResult? uniformity,
    SlideMaintMaxSpeedResult? maxSpeed,
    $core.bool? running,
  }) {
    final result = create();
    if (uniformity != null) result.uniformity = uniformity;
    if (maxSpeed != null) result.maxSpeed = maxSpeed;
    if (running != null) result.running = running;
    return result;
  }

  ResponseSlideMaintResultGet._();

  factory ResponseSlideMaintResultGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseSlideMaintResultGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseSlideMaintResultGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<SlideMaintUniformityResult>(1, _omitFieldNames ? '' : 'uniformity',
        subBuilder: SlideMaintUniformityResult.create)
    ..aOM<SlideMaintMaxSpeedResult>(2, _omitFieldNames ? '' : 'maxSpeed',
        subBuilder: SlideMaintMaxSpeedResult.create)
    ..aOB(3, _omitFieldNames ? '' : 'running')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSlideMaintResultGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSlideMaintResultGet copyWith(
          void Function(ResponseSlideMaintResultGet) updates) =>
      super.copyWith(
              (message) => updates(message as ResponseSlideMaintResultGet))
          as ResponseSlideMaintResultGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseSlideMaintResultGet create() =>
      ResponseSlideMaintResultGet._();
  @$core.override
  ResponseSlideMaintResultGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResponseSlideMaintResultGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseSlideMaintResultGet>(create);
  static ResponseSlideMaintResultGet? _defaultInstance;

  @$pb.TagNumber(1)
  SlideMaintUniformityResult get uniformity => $_getN(0);
  @$pb.TagNumber(1)
  set uniformity(SlideMaintUniformityResult value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUniformity() => $_has(0);
  @$pb.TagNumber(1)
  void clearUniformity() => $_clearField(1);
  @$pb.TagNumber(1)
  SlideMaintUniformityResult ensureUniformity() => $_ensure(0);

  @$pb.TagNumber(2)
  SlideMaintMaxSpeedResult get maxSpeed => $_getN(1);
  @$pb.TagNumber(2)
  set maxSpeed(SlideMaintMaxSpeedResult value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxSpeed() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxSpeed() => $_clearField(2);
  @$pb.TagNumber(2)
  SlideMaintMaxSpeedResult ensureMaxSpeed() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get running => $_getBF(2);
  @$pb.TagNumber(3)
  set running($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRunning() => $_has(2);
  @$pb.TagNumber(3)
  void clearRunning() => $_clearField(3);
}

/// 857 - Park the carriage at a PHYSICAL end (absolute bottom/top), e.g. so the
/// user can adjust the sleeve. Accepted in any motion mode (HAMP, HSP, HRPP, HDSP,
/// HVP, idle) and it does NOT change the mode: whatever is running is STOPPED first
/// (the mode and its settings stay; HSP/HRPP have to be played again), then the
/// slide crawls to the end at a fixed low speed with the end guard off for this
/// move only, and stops on contact (the position frame is kept - the contact is
/// intended). Blank response; completion = NotificationSliderEndReached. Any later
/// motion command cancels the move (then no notification). To continue, the app
/// starts the mode's activity again (hamp start, hsp play, hrpp start, ...).
/// Refused (ERROR_WRONG_MODE) in maintenance, OTA and disabled mode.
/// Added in FW4.4
class RequestSliderEndMove extends $pb.GeneratedMessage {
  factory RequestSliderEndMove({
    $core.bool? top,
  }) {
    final result = create();
    if (top != null) result.top = top;
    return result;
  }

  RequestSliderEndMove._();

  factory RequestSliderEndMove.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestSliderEndMove.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestSliderEndMove',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'top')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSliderEndMove clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSliderEndMove copyWith(void Function(RequestSliderEndMove) updates) =>
      super.copyWith((message) => updates(message as RequestSliderEndMove))
          as RequestSliderEndMove;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestSliderEndMove create() => RequestSliderEndMove._();
  @$core.override
  RequestSliderEndMove createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestSliderEndMove getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestSliderEndMove>(create);
  static RequestSliderEndMove? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get top => $_getBF(0);
  @$pb.TagNumber(1)
  set top($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTop() => $_has(0);
  @$pb.TagNumber(1)
  void clearTop() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
