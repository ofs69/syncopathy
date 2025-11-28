// This is a generated file - do not edit.
//
// Generated from messages.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'constants.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

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
  RequestConnectionKeyGet clone() =>
      RequestConnectionKeyGet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestConnectionKeyGet> createRepeated() =>
      $pb.PbList<RequestConnectionKeyGet>();
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
  ResponseConnectionKeyGet clone() =>
      ResponseConnectionKeyGet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseConnectionKeyGet> createRepeated() =>
      $pb.PbList<ResponseConnectionKeyGet>();
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
  RequestWifiStatusGet clone() =>
      RequestWifiStatusGet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestWifiStatusGet> createRepeated() =>
      $pb.PbList<RequestWifiStatusGet>();
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
    ..e<$0.WifiState>(2, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE,
        defaultOrMaker: $0.WifiState.WIFI_STATE_DISCONNECTED,
        valueOf: $0.WifiState.valueOf,
        enumValues: $0.WifiState.values)
    ..e<$0.WifiFailedReason>(
        3, _omitFieldNames ? '' : 'failedReason', $pb.PbFieldType.OE,
        defaultOrMaker: $0.WifiFailedReason.WIFI_REASON_DO_NOT_USE,
        valueOf: $0.WifiFailedReason.valueOf,
        enumValues: $0.WifiFailedReason.values)
    ..aOB(4, _omitFieldNames ? '' : 'socketConnected')
    ..aOS(5, _omitFieldNames ? '' : 'ssid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseWifiStatusGet clone() =>
      ResponseWifiStatusGet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseWifiStatusGet> createRepeated() =>
      $pb.PbList<ResponseWifiStatusGet>();
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
  RequestWifiSet clone() => RequestWifiSet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestWifiSet> createRepeated() =>
      $pb.PbList<RequestWifiSet>();
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
    ..a<$core.int>(3, _omitFieldNames ? '' : 'channel', $pb.PbFieldType.OU3)
    ..aOB(4, _omitFieldNames ? '' : 'showHidden')
    ..a<$core.int>(
        5, _omitFieldNames ? '' : 'passiveScanTime', $pb.PbFieldType.OU3)
    ..a<$core.int>(
        6, _omitFieldNames ? '' : 'activeScanTimeMin', $pb.PbFieldType.OU3)
    ..a<$core.int>(
        7, _omitFieldNames ? '' : 'activeScanTimeMax', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWifiScanStart clone() =>
      RequestWifiScanStart()..mergeFromMessage(this);
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
  static $pb.PbList<RequestWifiScanStart> createRepeated() =>
      $pb.PbList<RequestWifiScanStart>();
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
    ..a<$core.int>(1, _omitFieldNames ? '' : 'maxResults', $pb.PbFieldType.OU3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'offsetIndex', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWifiScanResultsGet clone() =>
      RequestWifiScanResultsGet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestWifiScanResultsGet> createRepeated() =>
      $pb.PbList<RequestWifiScanResultsGet>();
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
    ..pc<$0.ApInfo>(1, _omitFieldNames ? '' : 'apInfo', $pb.PbFieldType.PM,
        subBuilder: $0.ApInfo.create)
    ..a<$core.int>(
        2, _omitFieldNames ? '' : 'totalResults', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseWifiScanResultsGet clone() =>
      ResponseWifiScanResultsGet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseWifiScanResultsGet> createRepeated() =>
      $pb.PbList<ResponseWifiScanResultsGet>();
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
  RequestWifiScanStop clone() => RequestWifiScanStop()..mergeFromMessage(this);
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
  static $pb.PbList<RequestWifiScanStop> createRepeated() =>
      $pb.PbList<RequestWifiScanStop>();
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
  RequestModeGet clone() => RequestModeGet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestModeGet> createRepeated() =>
      $pb.PbList<RequestModeGet>();
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
    ..e<$0.Mode>(1, _omitFieldNames ? '' : 'mode', $pb.PbFieldType.OE,
        defaultOrMaker: $0.Mode.MODE_HAMP,
        valueOf: $0.Mode.valueOf,
        enumValues: $0.Mode.values)
    ..a<$core.int>(
        2, _omitFieldNames ? '' : 'modeSessionId', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseModeGet clone() => ResponseModeGet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseModeGet> createRepeated() =>
      $pb.PbList<ResponseModeGet>();
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
    ..e<$0.Mode>(1, _omitFieldNames ? '' : 'mode', $pb.PbFieldType.OE,
        defaultOrMaker: $0.Mode.MODE_HAMP,
        valueOf: $0.Mode.valueOf,
        enumValues: $0.Mode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestModeSet clone() => RequestModeSet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestModeSet> createRepeated() =>
      $pb.PbList<RequestModeSet>();
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
    ..e<$0.Mode>(1, _omitFieldNames ? '' : 'mode', $pb.PbFieldType.OE,
        defaultOrMaker: $0.Mode.MODE_HAMP,
        valueOf: $0.Mode.valueOf,
        enumValues: $0.Mode.values)
    ..a<$core.int>(
        2, _omitFieldNames ? '' : 'modeSessionId', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseModeSet clone() => ResponseModeSet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseModeSet> createRepeated() =>
      $pb.PbList<ResponseModeSet>();
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
    ..e<$0.ConnectionMode>(
        3, _omitFieldNames ? '' : 'connectionMode', $pb.PbFieldType.OE,
        defaultOrMaker: $0.ConnectionMode.CONNECTION_MODE_NOT_SET,
        valueOf: $0.ConnectionMode.valueOf,
        enumValues: $0.ConnectionMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestReboot clone() => RequestReboot()..mergeFromMessage(this);
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
  static $pb.PbList<RequestReboot> createRepeated() =>
      $pb.PbList<RequestReboot>();
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
    ..a<$core.int>(1, _omitFieldNames ? '' : 'button', $pb.PbFieldType.OU3)
    ..e<$0.ButtonEvent>(2, _omitFieldNames ? '' : 'event', $pb.PbFieldType.OE,
        defaultOrMaker: $0.ButtonEvent.BUTTON_EVENT_PRESSED,
        valueOf: $0.ButtonEvent.valueOf,
        enumValues: $0.ButtonEvent.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestButtonPress clone() => RequestButtonPress()..mergeFromMessage(this);
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
  static $pb.PbList<RequestButtonPress> createRepeated() =>
      $pb.PbList<RequestButtonPress>();
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
    ..a<$core.int>(2, _omitFieldNames ? '' : 'rtd', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestClockOffsetSet clone() =>
      RequestClockOffsetSet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestClockOffsetSet> createRepeated() =>
      $pb.PbList<RequestClockOffsetSet>();
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
    ..a<$core.int>(1, _omitFieldNames ? '' : 'time', $pb.PbFieldType.OU3)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'clockOffset', $pb.PbFieldType.OS6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'rtd', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseClockOffsetSet clone() =>
      ResponseClockOffsetSet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseClockOffsetSet> createRepeated() =>
      $pb.PbList<ResponseClockOffsetSet>();
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
  factory RequestBatteryGet() => create();

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
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestBatteryGet clone() => RequestBatteryGet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestBatteryGet> createRepeated() =>
      $pb.PbList<RequestBatteryGet>();
  @$core.pragma('dart2js:noInline')
  static RequestBatteryGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestBatteryGet>(create);
  static RequestBatteryGet? _defaultInstance;
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
  ResponseBatteryGet clone() => ResponseBatteryGet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseBatteryGet> createRepeated() =>
      $pb.PbList<ResponseBatteryGet>();
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
  RequestClockOffsetGet clone() =>
      RequestClockOffsetGet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestClockOffsetGet> createRepeated() =>
      $pb.PbList<RequestClockOffsetGet>();
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
    ..a<$core.int>(1, _omitFieldNames ? '' : 'time', $pb.PbFieldType.OU3)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'clockOffset', $pb.PbFieldType.OS6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'rtd', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseClockOffsetGet clone() =>
      ResponseClockOffsetGet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseClockOffsetGet> createRepeated() =>
      $pb.PbList<ResponseClockOffsetGet>();
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
  RequestCapabilitiesGet clone() =>
      RequestCapabilitiesGet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestCapabilitiesGet> createRepeated() =>
      $pb.PbList<RequestCapabilitiesGet>();
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
    ..a<$core.int>(3, _omitFieldNames ? '' : 'slider', $pb.PbFieldType.OU3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'lra', $pb.PbFieldType.OU3)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'erm', $pb.PbFieldType.OU3)
    ..aOB(6, _omitFieldNames ? '' : 'externalMemory')
    ..aOB(7, _omitFieldNames ? '' : 'rgbLedIndicator')
    ..aOB(8, _omitFieldNames ? '' : 'ledMatrix')
    ..a<$core.int>(
        9, _omitFieldNames ? '' : 'ledMatrixLedsX', $pb.PbFieldType.OU3)
    ..a<$core.int>(
        10, _omitFieldNames ? '' : 'ledMatrixLedsY', $pb.PbFieldType.OU3)
    ..aOB(11, _omitFieldNames ? '' : 'rgbRing')
    ..a<$core.int>(
        12, _omitFieldNames ? '' : 'rgbRingLeds', $pb.PbFieldType.OU3)
    ..a<$core.int>(
        13, _omitFieldNames ? '' : 'batteryCapacity', $pb.PbFieldType.OU3)
    ..e<$0.BatteryDriver>(
        14, _omitFieldNames ? '' : 'batteryDriver', $pb.PbFieldType.OE,
        defaultOrMaker: $0.BatteryDriver.BATTERY_DRIVER_NOT_SET,
        valueOf: $0.BatteryDriver.valueOf,
        enumValues: $0.BatteryDriver.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseCapabilitiesGet clone() =>
      ResponseCapabilitiesGet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseCapabilitiesGet> createRepeated() =>
      $pb.PbList<ResponseCapabilitiesGet>();
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
  RequestSessionIdsGet clone() =>
      RequestSessionIdsGet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestSessionIdsGet> createRepeated() =>
      $pb.PbList<RequestSessionIdsGet>();
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
    ..a<$core.int>(
        1, _omitFieldNames ? '' : 'bootSessionId', $pb.PbFieldType.OU3)
    ..a<$core.int>(
        2, _omitFieldNames ? '' : 'socketSessionId', $pb.PbFieldType.OU3)
    ..a<$core.int>(
        3, _omitFieldNames ? '' : 'modeSessionId', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSessionIdsGet clone() =>
      ResponseSessionIdsGet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseSessionIdsGet> createRepeated() =>
      $pb.PbList<ResponseSessionIdsGet>();
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
  RequestStopCurrentMode clone() =>
      RequestStopCurrentMode()..mergeFromMessage(this);
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
  static $pb.PbList<RequestStopCurrentMode> createRepeated() =>
      $pb.PbList<RequestStopCurrentMode>();
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
    ..e<$0.ConnectionMode>(1, _omitFieldNames ? '' : 'mode', $pb.PbFieldType.OE,
        defaultOrMaker: $0.ConnectionMode.CONNECTION_MODE_NOT_SET,
        valueOf: $0.ConnectionMode.valueOf,
        enumValues: $0.ConnectionMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestConnectionModeSet clone() =>
      RequestConnectionModeSet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestConnectionModeSet> createRepeated() =>
      $pb.PbList<RequestConnectionModeSet>();
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
  RequestConnectionModeGet clone() =>
      RequestConnectionModeGet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestConnectionModeGet> createRepeated() =>
      $pb.PbList<RequestConnectionModeGet>();
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
    ..e<$0.ConnectionMode>(1, _omitFieldNames ? '' : 'mode', $pb.PbFieldType.OE,
        defaultOrMaker: $0.ConnectionMode.CONNECTION_MODE_NOT_SET,
        valueOf: $0.ConnectionMode.valueOf,
        enumValues: $0.ConnectionMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseConnectionModeGet clone() =>
      ResponseConnectionModeGet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseConnectionModeGet> createRepeated() =>
      $pb.PbList<ResponseConnectionModeGet>();
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
  RequestHampStart clone() => RequestHampStart()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHampStart> createRepeated() =>
      $pb.PbList<RequestHampStart>();
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
  ResponseHampStart clone() => ResponseHampStart()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHampStart> createRepeated() =>
      $pb.PbList<ResponseHampStart>();
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
  RequestHampStop clone() => RequestHampStop()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHampStop> createRepeated() =>
      $pb.PbList<RequestHampStop>();
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
  ResponseHampStop clone() => ResponseHampStop()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHampStop> createRepeated() =>
      $pb.PbList<ResponseHampStop>();
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
    ..a<$core.double>(1, _omitFieldNames ? '' : 'velocity', $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHampVelocitySet clone() =>
      RequestHampVelocitySet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHampVelocitySet> createRepeated() =>
      $pb.PbList<RequestHampVelocitySet>();
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
  ResponseHampVelocitySet clone() =>
      ResponseHampVelocitySet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHampVelocitySet> createRepeated() =>
      $pb.PbList<ResponseHampVelocitySet>();
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
  RequestHampStateGet clone() => RequestHampStateGet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHampStateGet> createRepeated() =>
      $pb.PbList<RequestHampStateGet>();
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
  ResponseHampStateGet clone() =>
      ResponseHampStateGet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHampStateGet> createRepeated() =>
      $pb.PbList<ResponseHampStateGet>();
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
    ..a<$core.double>(1, _omitFieldNames ? '' : 'min', $pb.PbFieldType.OF)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'max', $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHampZoneSet clone() => RequestHampZoneSet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHampZoneSet> createRepeated() =>
      $pb.PbList<RequestHampZoneSet>();
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
  ResponseHampZoneSet clone() => ResponseHampZoneSet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHampZoneSet> createRepeated() =>
      $pb.PbList<ResponseHampZoneSet>();
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
    ..a<$core.double>(1, _omitFieldNames ? '' : 'xa', $pb.PbFieldType.OF)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'va', $pb.PbFieldType.OF)
    ..aOB(3, _omitFieldNames ? '' : 'stopOnTarget')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHdspXaVaSet clone() => RequestHdspXaVaSet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHdspXaVaSet> createRepeated() =>
      $pb.PbList<RequestHdspXaVaSet>();
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
    ..a<$core.double>(1, _omitFieldNames ? '' : 'xp', $pb.PbFieldType.OF)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'va', $pb.PbFieldType.OF)
    ..aOB(3, _omitFieldNames ? '' : 'stopOnTarget')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHdspXpVaSet clone() => RequestHdspXpVaSet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHdspXpVaSet> createRepeated() =>
      $pb.PbList<RequestHdspXpVaSet>();
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
    ..a<$core.double>(1, _omitFieldNames ? '' : 'xp', $pb.PbFieldType.OF)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'vp', $pb.PbFieldType.OF)
    ..aOB(3, _omitFieldNames ? '' : 'stopOnTarget')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHdspXpVpSet clone() => RequestHdspXpVpSet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHdspXpVpSet> createRepeated() =>
      $pb.PbList<RequestHdspXpVpSet>();
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
    ..a<$core.double>(1, _omitFieldNames ? '' : 'xa', $pb.PbFieldType.OF)
    ..a<$core.int>(2, _omitFieldNames ? '' : 't', $pb.PbFieldType.OU3)
    ..aOB(3, _omitFieldNames ? '' : 'stopOnTarget')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHdspXaTSet clone() => RequestHdspXaTSet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHdspXaTSet> createRepeated() =>
      $pb.PbList<RequestHdspXaTSet>();
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
    ..a<$core.double>(1, _omitFieldNames ? '' : 'xp', $pb.PbFieldType.OF)
    ..a<$core.int>(2, _omitFieldNames ? '' : 't', $pb.PbFieldType.OU3)
    ..aOB(3, _omitFieldNames ? '' : 'stopOnTarget')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHdspXpTSet clone() => RequestHdspXpTSet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHdspXpTSet> createRepeated() =>
      $pb.PbList<RequestHdspXpTSet>();
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
    ..a<$core.double>(1, _omitFieldNames ? '' : 'xa', $pb.PbFieldType.OF)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'vp', $pb.PbFieldType.OF)
    ..aOB(3, _omitFieldNames ? '' : 'stopOnTarget')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHdspXaVpSet clone() => RequestHdspXaVpSet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHdspXaVpSet> createRepeated() =>
      $pb.PbList<RequestHdspXaVpSet>();
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
  RequestHdspStop clone() => RequestHdspStop()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHdspStop> createRepeated() =>
      $pb.PbList<RequestHdspStop>();
  @$core.pragma('dart2js:noInline')
  static RequestHdspStop getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHdspStop>(create);
  static RequestHdspStop? _defaultInstance;
}

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
  RequestSliderStrokeGet clone() =>
      RequestSliderStrokeGet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestSliderStrokeGet> createRepeated() =>
      $pb.PbList<RequestSliderStrokeGet>();
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
    ..a<$core.double>(1, _omitFieldNames ? '' : 'min', $pb.PbFieldType.OF)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'max', $pb.PbFieldType.OF)
    ..a<$core.double>(
        3, _omitFieldNames ? '' : 'minAbsolute', $pb.PbFieldType.OF)
    ..a<$core.double>(
        4, _omitFieldNames ? '' : 'maxAbsolute', $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSliderStrokeGet clone() =>
      ResponseSliderStrokeGet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseSliderStrokeGet> createRepeated() =>
      $pb.PbList<ResponseSliderStrokeGet>();
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
    ..a<$core.double>(1, _omitFieldNames ? '' : 'min', $pb.PbFieldType.OF)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'max', $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestSliderStrokeSet clone() =>
      RequestSliderStrokeSet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestSliderStrokeSet> createRepeated() =>
      $pb.PbList<RequestSliderStrokeSet>();
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
    ..a<$core.double>(1, _omitFieldNames ? '' : 'min', $pb.PbFieldType.OF)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'max', $pb.PbFieldType.OF)
    ..a<$core.double>(
        3, _omitFieldNames ? '' : 'minAbsolute', $pb.PbFieldType.OF)
    ..a<$core.double>(
        4, _omitFieldNames ? '' : 'maxAbsolute', $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSliderStrokeSet clone() =>
      ResponseSliderStrokeSet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseSliderStrokeSet> createRepeated() =>
      $pb.PbList<ResponseSliderStrokeSet>();
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
  RequestSliderStateGet clone() =>
      RequestSliderStateGet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestSliderStateGet> createRepeated() =>
      $pb.PbList<RequestSliderStateGet>();
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
    ..a<$core.double>(1, _omitFieldNames ? '' : 'position', $pb.PbFieldType.OF)
    ..a<$core.double>(
        2, _omitFieldNames ? '' : 'positionAbsolute', $pb.PbFieldType.OF)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'motorTemp', $pb.PbFieldType.OF)
    ..a<$core.double>(
        4, _omitFieldNames ? '' : 'speedAbsolute', $pb.PbFieldType.OF)
    ..aOB(5, _omitFieldNames ? '' : 'dir')
    ..a<$core.int>(
        6, _omitFieldNames ? '' : 'motorPosition', $pb.PbFieldType.OU3)
    ..a<$core.int>(
        7, _omitFieldNames ? '' : 'motorTempAdcValue', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseSliderStateGet clone() =>
      ResponseSliderStateGet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseSliderStateGet> createRepeated() =>
      $pb.PbList<ResponseSliderStateGet>();
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
  RequestSliderCalibrate clone() =>
      RequestSliderCalibrate()..mergeFromMessage(this);
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
  static $pb.PbList<RequestSliderCalibrate> createRepeated() =>
      $pb.PbList<RequestSliderCalibrate>();
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
  ResponseSliderCalibrate clone() =>
      ResponseSliderCalibrate()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseSliderCalibrate> createRepeated() =>
      $pb.PbList<ResponseSliderCalibrate>();
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
    ..a<$core.int>(1, _omitFieldNames ? '' : 'streamId', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspSetup clone() => RequestHspSetup()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHspSetup> createRepeated() =>
      $pb.PbList<RequestHspSetup>();
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
  ResponseHspSetup clone() => ResponseHspSetup()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHspSetup> createRepeated() =>
      $pb.PbList<ResponseHspSetup>();
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
    ..pc<$0.Point>(1, _omitFieldNames ? '' : 'points', $pb.PbFieldType.PM,
        subBuilder: $0.Point.create)
    ..aOB(2, _omitFieldNames ? '' : 'flush')
    ..a<$core.int>(
        3, _omitFieldNames ? '' : 'tailPointStreamIndex', $pb.PbFieldType.OU3)
    ..a<$core.int>(
        5, _omitFieldNames ? '' : 'tailPointThreshold', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspAdd clone() => RequestHspAdd()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHspAdd> createRepeated() =>
      $pb.PbList<RequestHspAdd>();
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
  ResponseHspAdd clone() => ResponseHspAdd()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHspAdd> createRepeated() =>
      $pb.PbList<ResponseHspAdd>();
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
  RequestHspFlush clone() => RequestHspFlush()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHspFlush> createRepeated() =>
      $pb.PbList<RequestHspFlush>();
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
  ResponseHspFlush clone() => ResponseHspFlush()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHspFlush> createRepeated() =>
      $pb.PbList<ResponseHspFlush>();
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
    ..a<$core.int>(1, _omitFieldNames ? '' : 'startTime', $pb.PbFieldType.O3)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'serverTime', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.double>(
        3, _omitFieldNames ? '' : 'playbackRate', $pb.PbFieldType.OF)
    ..aOB(4, _omitFieldNames ? '' : 'loop')
    ..aOB(5, _omitFieldNames ? '' : 'pauseOnStarving')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspPlay clone() => RequestHspPlay()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHspPlay> createRepeated() =>
      $pb.PbList<RequestHspPlay>();
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
  ResponseHspPlay clone() => ResponseHspPlay()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHspPlay> createRepeated() =>
      $pb.PbList<ResponseHspPlay>();
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
  RequestHspStop clone() => RequestHspStop()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHspStop> createRepeated() =>
      $pb.PbList<RequestHspStop>();
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
  ResponseHspStop clone() => ResponseHspStop()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHspStop> createRepeated() =>
      $pb.PbList<ResponseHspStop>();
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
  RequestHspPause clone() => RequestHspPause()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHspPause> createRepeated() =>
      $pb.PbList<RequestHspPause>();
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
  ResponseHspPause clone() => ResponseHspPause()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHspPause> createRepeated() =>
      $pb.PbList<ResponseHspPause>();
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
  RequestHspResume clone() => RequestHspResume()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHspResume> createRepeated() =>
      $pb.PbList<RequestHspResume>();
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
  ResponseHspResume clone() => ResponseHspResume()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHspResume> createRepeated() =>
      $pb.PbList<ResponseHspResume>();
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
  RequestHspStateGet clone() => RequestHspStateGet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHspStateGet> createRepeated() =>
      $pb.PbList<RequestHspStateGet>();
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
  ResponseHspStateGet clone() => ResponseHspStateGet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHspStateGet> createRepeated() =>
      $pb.PbList<ResponseHspStateGet>();
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
    ..a<$core.int>(1, _omitFieldNames ? '' : 'currentTime', $pb.PbFieldType.O3)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'serverTime', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'filter', $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspCurrentTimeSet clone() =>
      RequestHspCurrentTimeSet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHspCurrentTimeSet> createRepeated() =>
      $pb.PbList<RequestHspCurrentTimeSet>();
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
  ResponseHspCurrentTimeSet clone() =>
      ResponseHspCurrentTimeSet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHspCurrentTimeSet> createRepeated() =>
      $pb.PbList<ResponseHspCurrentTimeSet>();
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
    ..a<$core.int>(
        1, _omitFieldNames ? '' : 'tailPointThreshold', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspThresholdSet clone() =>
      RequestHspThresholdSet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHspThresholdSet> createRepeated() =>
      $pb.PbList<RequestHspThresholdSet>();
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
  ResponseHspThresholdSet clone() =>
      ResponseHspThresholdSet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHspThresholdSet> createRepeated() =>
      $pb.PbList<ResponseHspThresholdSet>();
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
  RequestHspPauseOnStarvingSet clone() =>
      RequestHspPauseOnStarvingSet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHspPauseOnStarvingSet> createRepeated() =>
      $pb.PbList<RequestHspPauseOnStarvingSet>();
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
  ResponseHspPauseOnStarvingSet clone() =>
      ResponseHspPauseOnStarvingSet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHspPauseOnStarvingSet> createRepeated() =>
      $pb.PbList<ResponseHspPauseOnStarvingSet>();
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
    ..a<$core.double>(
        1, _omitFieldNames ? '' : 'playbackRate', $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHspPlaybackRateSet clone() =>
      RequestHspPlaybackRateSet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHspPlaybackRateSet> createRepeated() =>
      $pb.PbList<RequestHspPlaybackRateSet>();
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
  ResponseHspPlaybackRateSet clone() =>
      ResponseHspPlaybackRateSet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHspPlaybackRateSet> createRepeated() =>
      $pb.PbList<ResponseHspPlaybackRateSet>();
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
  RequestHspLoopSet clone() => RequestHspLoopSet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHspLoopSet> createRepeated() =>
      $pb.PbList<RequestHspLoopSet>();
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
  ResponseHspLoopSet clone() => ResponseHspLoopSet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHspLoopSet> createRepeated() =>
      $pb.PbList<ResponseHspLoopSet>();
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
    ..a<$core.int>(2, _omitFieldNames ? '' : 'r', $pb.PbFieldType.OU3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'g', $pb.PbFieldType.OU3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'b', $pb.PbFieldType.OU3)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'intensity', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestLedOverride clone() => RequestLedOverride()..mergeFromMessage(this);
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
  static $pb.PbList<RequestLedOverride> createRepeated() =>
      $pb.PbList<RequestLedOverride>();
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
    ..a<$core.double>(1, _omitFieldNames ? '' : 'amplitude', $pb.PbFieldType.OF)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'frequency', $pb.PbFieldType.OU3)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'position', $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHvpSet clone() => RequestHvpSet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHvpSet> createRepeated() =>
      $pb.PbList<RequestHvpSet>();
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
  ResponseHvpSet clone() => ResponseHvpSet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHvpSet> createRepeated() =>
      $pb.PbList<ResponseHvpSet>();
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
  RequestHvpStop clone() => RequestHvpStop()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHvpStop> createRepeated() =>
      $pb.PbList<RequestHvpStop>();
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
  ResponseHvpStop clone() => ResponseHvpStop()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHvpStop> createRepeated() =>
      $pb.PbList<ResponseHvpStop>();
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
  RequestHvpStart clone() => RequestHvpStart()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHvpStart> createRepeated() =>
      $pb.PbList<RequestHvpStart>();
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
  ResponseHvpStart clone() => ResponseHvpStart()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHvpStart> createRepeated() =>
      $pb.PbList<ResponseHvpStart>();
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
  RequestHvpStateGet clone() => RequestHvpStateGet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHvpStateGet> createRepeated() =>
      $pb.PbList<RequestHvpStateGet>();
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
  ResponseHvpStateGet clone() => ResponseHvpStateGet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHvpStateGet> createRepeated() =>
      $pb.PbList<ResponseHvpStateGet>();
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

/// /////////////////////// HRPP /////////////////////////
/// Added in FW4.0.14 - But some messages where altered in FW4.0.15. So, only compatible with FW4.0.15 and later
/// 920
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
  RequestHrppStart clone() => RequestHrppStart()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHrppStart> createRepeated() =>
      $pb.PbList<RequestHrppStart>();
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
  ResponseHrppStart clone() => ResponseHrppStart()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHrppStart> createRepeated() =>
      $pb.PbList<ResponseHrppStart>();
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
  RequestHrppStop clone() => RequestHrppStop()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHrppStop> createRepeated() =>
      $pb.PbList<RequestHrppStop>();
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
  ResponseHrppStop clone() => ResponseHrppStop()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHrppStop> createRepeated() =>
      $pb.PbList<ResponseHrppStop>();
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
    ..a<$core.double>(1, _omitFieldNames ? '' : 'amplitude', $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHrppAmplitudeSet clone() =>
      RequestHrppAmplitudeSet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHrppAmplitudeSet> createRepeated() =>
      $pb.PbList<RequestHrppAmplitudeSet>();
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
  ResponseHrppAmplitudeSet clone() =>
      ResponseHrppAmplitudeSet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHrppAmplitudeSet> createRepeated() =>
      $pb.PbList<ResponseHrppAmplitudeSet>();
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

/// 923
class RequestHrppPlaybackSpeedSet extends $pb.GeneratedMessage {
  factory RequestHrppPlaybackSpeedSet({
    $core.double? speed,
  }) {
    final result = create();
    if (speed != null) result.speed = speed;
    return result;
  }

  RequestHrppPlaybackSpeedSet._();

  factory RequestHrppPlaybackSpeedSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHrppPlaybackSpeedSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHrppPlaybackSpeedSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'speed', $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHrppPlaybackSpeedSet clone() =>
      RequestHrppPlaybackSpeedSet()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHrppPlaybackSpeedSet copyWith(
          void Function(RequestHrppPlaybackSpeedSet) updates) =>
      super.copyWith(
              (message) => updates(message as RequestHrppPlaybackSpeedSet))
          as RequestHrppPlaybackSpeedSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHrppPlaybackSpeedSet create() =>
      RequestHrppPlaybackSpeedSet._();
  @$core.override
  RequestHrppPlaybackSpeedSet createEmptyInstance() => create();
  static $pb.PbList<RequestHrppPlaybackSpeedSet> createRepeated() =>
      $pb.PbList<RequestHrppPlaybackSpeedSet>();
  @$core.pragma('dart2js:noInline')
  static RequestHrppPlaybackSpeedSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHrppPlaybackSpeedSet>(create);
  static RequestHrppPlaybackSpeedSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get speed => $_getN(0);
  @$pb.TagNumber(1)
  set speed($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSpeed() => $_has(0);
  @$pb.TagNumber(1)
  void clearSpeed() => $_clearField(1);
}

class ResponseHrppPlaybackSpeedSet extends $pb.GeneratedMessage {
  factory ResponseHrppPlaybackSpeedSet({
    $0.HrppState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  ResponseHrppPlaybackSpeedSet._();

  factory ResponseHrppPlaybackSpeedSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseHrppPlaybackSpeedSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseHrppPlaybackSpeedSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HrppState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HrppState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHrppPlaybackSpeedSet clone() =>
      ResponseHrppPlaybackSpeedSet()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHrppPlaybackSpeedSet copyWith(
          void Function(ResponseHrppPlaybackSpeedSet) updates) =>
      super.copyWith(
              (message) => updates(message as ResponseHrppPlaybackSpeedSet))
          as ResponseHrppPlaybackSpeedSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseHrppPlaybackSpeedSet create() =>
      ResponseHrppPlaybackSpeedSet._();
  @$core.override
  ResponseHrppPlaybackSpeedSet createEmptyInstance() => create();
  static $pb.PbList<ResponseHrppPlaybackSpeedSet> createRepeated() =>
      $pb.PbList<ResponseHrppPlaybackSpeedSet>();
  @$core.pragma('dart2js:noInline')
  static ResponseHrppPlaybackSpeedSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseHrppPlaybackSpeedSet>(create);
  static ResponseHrppPlaybackSpeedSet? _defaultInstance;

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
    ..a<$core.int>(1, _omitFieldNames ? '' : 'patternNr', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHrppPatternSet clone() =>
      RequestHrppPatternSet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHrppPatternSet> createRepeated() =>
      $pb.PbList<RequestHrppPatternSet>();
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
  ResponseHrppPatternSet clone() =>
      ResponseHrppPatternSet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHrppPatternSet> createRepeated() =>
      $pb.PbList<ResponseHrppPatternSet>();
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
  RequestHrppStateGet clone() => RequestHrppStateGet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHrppStateGet> createRepeated() =>
      $pb.PbList<RequestHrppStateGet>();
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
  ResponseHrppStateGet clone() =>
      ResponseHrppStateGet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHrppStateGet> createRepeated() =>
      $pb.PbList<ResponseHrppStateGet>();
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
  RequestHrppPatternsGet clone() =>
      RequestHrppPatternsGet()..mergeFromMessage(this);
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
  static $pb.PbList<RequestHrppPatternsGet> createRepeated() =>
      $pb.PbList<RequestHrppPatternsGet>();
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
    ..pc<$0.HrppPattern>(
        2, _omitFieldNames ? '' : 'patterns', $pb.PbFieldType.PM,
        subBuilder: $0.HrppPattern.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseHrppPatternsGet clone() =>
      ResponseHrppPatternsGet()..mergeFromMessage(this);
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
  static $pb.PbList<ResponseHrppPatternsGet> createRepeated() =>
      $pb.PbList<ResponseHrppPatternsGet>();
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

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
