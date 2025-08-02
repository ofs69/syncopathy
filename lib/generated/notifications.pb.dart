// This is a generated file - do not edit.
//
// Generated from notifications.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'constants.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// ******* NOTIFICATIONS *********/
/// 601 - wifi
class NotificationWifiStatusChanged extends $pb.GeneratedMessage {
  factory NotificationWifiStatusChanged({
    $0.WifiState? state,
    $core.bool? socketConnected,
    $core.int? socketSessionId,
  }) {
    final result = create();
    if (state != null) result.state = state;
    if (socketConnected != null) result.socketConnected = socketConnected;
    if (socketSessionId != null) result.socketSessionId = socketSessionId;
    return result;
  }

  NotificationWifiStatusChanged._();

  factory NotificationWifiStatusChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationWifiStatusChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationWifiStatusChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..e<$0.WifiState>(2, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE,
        defaultOrMaker: $0.WifiState.WIFI_STATE_DISCONNECTED,
        valueOf: $0.WifiState.valueOf,
        enumValues: $0.WifiState.values)
    ..aOB(4, _omitFieldNames ? '' : 'socketConnected')
    ..a<$core.int>(
        5, _omitFieldNames ? '' : 'socketSessionId', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationWifiStatusChanged clone() =>
      NotificationWifiStatusChanged()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationWifiStatusChanged copyWith(
          void Function(NotificationWifiStatusChanged) updates) =>
      super.copyWith(
              (message) => updates(message as NotificationWifiStatusChanged))
          as NotificationWifiStatusChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationWifiStatusChanged create() =>
      NotificationWifiStatusChanged._();
  @$core.override
  NotificationWifiStatusChanged createEmptyInstance() => create();
  static $pb.PbList<NotificationWifiStatusChanged> createRepeated() =>
      $pb.PbList<NotificationWifiStatusChanged>();
  @$core.pragma('dart2js:noInline')
  static NotificationWifiStatusChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationWifiStatusChanged>(create);
  static NotificationWifiStatusChanged? _defaultInstance;

  @$pb.TagNumber(2)
  $0.WifiState get state => $_getN(0);
  @$pb.TagNumber(2)
  set state($0.WifiState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  @$pb.TagNumber(4)
  $core.bool get socketConnected => $_getBF(1);
  @$pb.TagNumber(4)
  set socketConnected($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(4)
  $core.bool hasSocketConnected() => $_has(1);
  @$pb.TagNumber(4)
  void clearSocketConnected() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get socketSessionId => $_getIZ(2);
  @$pb.TagNumber(5)
  set socketSessionId($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(5)
  $core.bool hasSocketSessionId() => $_has(2);
  @$pb.TagNumber(5)
  void clearSocketSessionId() => $_clearField(5);
}

/// 602 - BLE
class NotificationBleStatusChanged extends $pb.GeneratedMessage {
  factory NotificationBleStatusChanged({
    $0.BleState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  NotificationBleStatusChanged._();

  factory NotificationBleStatusChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationBleStatusChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationBleStatusChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..e<$0.BleState>(1, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE,
        defaultOrMaker: $0.BleState.BLE_STATE_NOT_INITIALIZED,
        valueOf: $0.BleState.valueOf,
        enumValues: $0.BleState.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationBleStatusChanged clone() =>
      NotificationBleStatusChanged()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationBleStatusChanged copyWith(
          void Function(NotificationBleStatusChanged) updates) =>
      super.copyWith(
              (message) => updates(message as NotificationBleStatusChanged))
          as NotificationBleStatusChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationBleStatusChanged create() =>
      NotificationBleStatusChanged._();
  @$core.override
  NotificationBleStatusChanged createEmptyInstance() => create();
  static $pb.PbList<NotificationBleStatusChanged> createRepeated() =>
      $pb.PbList<NotificationBleStatusChanged>();
  @$core.pragma('dart2js:noInline')
  static NotificationBleStatusChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationBleStatusChanged>(create);
  static NotificationBleStatusChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $0.BleState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.BleState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
}

/// 603 - OTA complete - Sent when the OTA is completed successfully - It is now safe to reboot
class NotificationOtaComplete extends $pb.GeneratedMessage {
  factory NotificationOtaComplete() => create();

  NotificationOtaComplete._();

  factory NotificationOtaComplete.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationOtaComplete.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationOtaComplete',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationOtaComplete clone() =>
      NotificationOtaComplete()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationOtaComplete copyWith(
          void Function(NotificationOtaComplete) updates) =>
      super.copyWith((message) => updates(message as NotificationOtaComplete))
          as NotificationOtaComplete;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationOtaComplete create() => NotificationOtaComplete._();
  @$core.override
  NotificationOtaComplete createEmptyInstance() => create();
  static $pb.PbList<NotificationOtaComplete> createRepeated() =>
      $pb.PbList<NotificationOtaComplete>();
  @$core.pragma('dart2js:noInline')
  static NotificationOtaComplete getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationOtaComplete>(create);
  static NotificationOtaComplete? _defaultInstance;
}

/// 700
class NotificationModeChanged extends $pb.GeneratedMessage {
  factory NotificationModeChanged({
    $0.Mode? mode,
    $core.int? modeSessionId,
  }) {
    final result = create();
    if (mode != null) result.mode = mode;
    if (modeSessionId != null) result.modeSessionId = modeSessionId;
    return result;
  }

  NotificationModeChanged._();

  factory NotificationModeChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationModeChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationModeChanged',
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
  NotificationModeChanged clone() =>
      NotificationModeChanged()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationModeChanged copyWith(
          void Function(NotificationModeChanged) updates) =>
      super.copyWith((message) => updates(message as NotificationModeChanged))
          as NotificationModeChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationModeChanged create() => NotificationModeChanged._();
  @$core.override
  NotificationModeChanged createEmptyInstance() => create();
  static $pb.PbList<NotificationModeChanged> createRepeated() =>
      $pb.PbList<NotificationModeChanged>();
  @$core.pragma('dart2js:noInline')
  static NotificationModeChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationModeChanged>(create);
  static NotificationModeChanged? _defaultInstance;

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
class NotificationStrokeChanged extends $pb.GeneratedMessage {
  factory NotificationStrokeChanged({
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

  NotificationStrokeChanged._();

  factory NotificationStrokeChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationStrokeChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationStrokeChanged',
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
  NotificationStrokeChanged clone() =>
      NotificationStrokeChanged()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationStrokeChanged copyWith(
          void Function(NotificationStrokeChanged) updates) =>
      super.copyWith((message) => updates(message as NotificationStrokeChanged))
          as NotificationStrokeChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationStrokeChanged create() => NotificationStrokeChanged._();
  @$core.override
  NotificationStrokeChanged createEmptyInstance() => create();
  static $pb.PbList<NotificationStrokeChanged> createRepeated() =>
      $pb.PbList<NotificationStrokeChanged>();
  @$core.pragma('dart2js:noInline')
  static NotificationStrokeChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationStrokeChanged>(create);
  static NotificationStrokeChanged? _defaultInstance;

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

/// 703
class NotificationButtonEvent extends $pb.GeneratedMessage {
  factory NotificationButtonEvent({
    $0.Button? button,
    $0.ButtonEvent? event,
  }) {
    final result = create();
    if (button != null) result.button = button;
    if (event != null) result.event = event;
    return result;
  }

  NotificationButtonEvent._();

  factory NotificationButtonEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationButtonEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationButtonEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..e<$0.Button>(1, _omitFieldNames ? '' : 'button', $pb.PbFieldType.OE,
        defaultOrMaker: $0.Button.BUTTON_ON,
        valueOf: $0.Button.valueOf,
        enumValues: $0.Button.values)
    ..e<$0.ButtonEvent>(2, _omitFieldNames ? '' : 'event', $pb.PbFieldType.OE,
        defaultOrMaker: $0.ButtonEvent.BUTTON_EVENT_PRESSED,
        valueOf: $0.ButtonEvent.valueOf,
        enumValues: $0.ButtonEvent.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationButtonEvent clone() =>
      NotificationButtonEvent()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationButtonEvent copyWith(
          void Function(NotificationButtonEvent) updates) =>
      super.copyWith((message) => updates(message as NotificationButtonEvent))
          as NotificationButtonEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationButtonEvent create() => NotificationButtonEvent._();
  @$core.override
  NotificationButtonEvent createEmptyInstance() => create();
  static $pb.PbList<NotificationButtonEvent> createRepeated() =>
      $pb.PbList<NotificationButtonEvent>();
  @$core.pragma('dart2js:noInline')
  static NotificationButtonEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationButtonEvent>(create);
  static NotificationButtonEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Button get button => $_getN(0);
  @$pb.TagNumber(1)
  set button($0.Button value) => $_setField(1, value);
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

/// 705
class NotificationBatteryChanged extends $pb.GeneratedMessage {
  factory NotificationBatteryChanged({
    $0.BatteryState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  NotificationBatteryChanged._();

  factory NotificationBatteryChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationBatteryChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationBatteryChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.BatteryState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.BatteryState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationBatteryChanged clone() =>
      NotificationBatteryChanged()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationBatteryChanged copyWith(
          void Function(NotificationBatteryChanged) updates) =>
      super.copyWith(
              (message) => updates(message as NotificationBatteryChanged))
          as NotificationBatteryChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationBatteryChanged create() => NotificationBatteryChanged._();
  @$core.override
  NotificationBatteryChanged createEmptyInstance() => create();
  static $pb.PbList<NotificationBatteryChanged> createRepeated() =>
      $pb.PbList<NotificationBatteryChanged>();
  @$core.pragma('dart2js:noInline')
  static NotificationBatteryChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationBatteryChanged>(create);
  static NotificationBatteryChanged? _defaultInstance;

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

/// 720
class NotificationHampChanged extends $pb.GeneratedMessage {
  factory NotificationHampChanged({
    $0.HampState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  NotificationHampChanged._();

  factory NotificationHampChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationHampChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationHampChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HampState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HampState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationHampChanged clone() =>
      NotificationHampChanged()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationHampChanged copyWith(
          void Function(NotificationHampChanged) updates) =>
      super.copyWith((message) => updates(message as NotificationHampChanged))
          as NotificationHampChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationHampChanged create() => NotificationHampChanged._();
  @$core.override
  NotificationHampChanged createEmptyInstance() => create();
  static $pb.PbList<NotificationHampChanged> createRepeated() =>
      $pb.PbList<NotificationHampChanged>();
  @$core.pragma('dart2js:noInline')
  static NotificationHampChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationHampChanged>(create);
  static NotificationHampChanged? _defaultInstance;

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

/// 740
class NotificationHdspChanged extends $pb.GeneratedMessage {
  factory NotificationHdspChanged({
    $0.HdspPlayState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  NotificationHdspChanged._();

  factory NotificationHdspChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationHdspChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationHdspChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..e<$0.HdspPlayState>(1, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE,
        defaultOrMaker: $0.HdspPlayState.HDSP_STATE_STOPPED,
        valueOf: $0.HdspPlayState.valueOf,
        enumValues: $0.HdspPlayState.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationHdspChanged clone() =>
      NotificationHdspChanged()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationHdspChanged copyWith(
          void Function(NotificationHdspChanged) updates) =>
      super.copyWith((message) => updates(message as NotificationHdspChanged))
          as NotificationHdspChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationHdspChanged create() => NotificationHdspChanged._();
  @$core.override
  NotificationHdspChanged createEmptyInstance() => create();
  static $pb.PbList<NotificationHdspChanged> createRepeated() =>
      $pb.PbList<NotificationHdspChanged>();
  @$core.pragma('dart2js:noInline')
  static NotificationHdspChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationHdspChanged>(create);
  static NotificationHdspChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HdspPlayState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state($0.HdspPlayState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
}

/// 860 - tail_point_stream_index_threashold reached
class NotificationHspThresholdReached extends $pb.GeneratedMessage {
  factory NotificationHspThresholdReached({
    $0.HspState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  NotificationHspThresholdReached._();

  factory NotificationHspThresholdReached.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationHspThresholdReached.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationHspThresholdReached',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HspState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HspState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationHspThresholdReached clone() =>
      NotificationHspThresholdReached()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationHspThresholdReached copyWith(
          void Function(NotificationHspThresholdReached) updates) =>
      super.copyWith(
              (message) => updates(message as NotificationHspThresholdReached))
          as NotificationHspThresholdReached;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationHspThresholdReached create() =>
      NotificationHspThresholdReached._();
  @$core.override
  NotificationHspThresholdReached createEmptyInstance() => create();
  static $pb.PbList<NotificationHspThresholdReached> createRepeated() =>
      $pb.PbList<NotificationHspThresholdReached>();
  @$core.pragma('dart2js:noInline')
  static NotificationHspThresholdReached getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationHspThresholdReached>(
          create);
  static NotificationHspThresholdReached? _defaultInstance;

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

class NotificationHspStateChanged extends $pb.GeneratedMessage {
  factory NotificationHspStateChanged({
    $0.HspState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  NotificationHspStateChanged._();

  factory NotificationHspStateChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationHspStateChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationHspStateChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HspState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HspState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationHspStateChanged clone() =>
      NotificationHspStateChanged()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationHspStateChanged copyWith(
          void Function(NotificationHspStateChanged) updates) =>
      super.copyWith(
              (message) => updates(message as NotificationHspStateChanged))
          as NotificationHspStateChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationHspStateChanged create() =>
      NotificationHspStateChanged._();
  @$core.override
  NotificationHspStateChanged createEmptyInstance() => create();
  static $pb.PbList<NotificationHspStateChanged> createRepeated() =>
      $pb.PbList<NotificationHspStateChanged>();
  @$core.pragma('dart2js:noInline')
  static NotificationHspStateChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationHspStateChanged>(create);
  static NotificationHspStateChanged? _defaultInstance;

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

/// Limited to 2 messages per second (0.5s interval) -> Prevents spamming on short scripts
class NotificationHspLooping extends $pb.GeneratedMessage {
  factory NotificationHspLooping({
    $0.HspState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  NotificationHspLooping._();

  factory NotificationHspLooping.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationHspLooping.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationHspLooping',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HspState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HspState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationHspLooping clone() =>
      NotificationHspLooping()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationHspLooping copyWith(
          void Function(NotificationHspLooping) updates) =>
      super.copyWith((message) => updates(message as NotificationHspLooping))
          as NotificationHspLooping;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationHspLooping create() => NotificationHspLooping._();
  @$core.override
  NotificationHspLooping createEmptyInstance() => create();
  static $pb.PbList<NotificationHspLooping> createRepeated() =>
      $pb.PbList<NotificationHspLooping>();
  @$core.pragma('dart2js:noInline')
  static NotificationHspLooping getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationHspLooping>(create);
  static NotificationHspLooping? _defaultInstance;

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

class NotificationHspStarving extends $pb.GeneratedMessage {
  factory NotificationHspStarving({
    $0.HspState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  NotificationHspStarving._();

  factory NotificationHspStarving.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationHspStarving.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationHspStarving',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HspState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HspState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationHspStarving clone() =>
      NotificationHspStarving()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationHspStarving copyWith(
          void Function(NotificationHspStarving) updates) =>
      super.copyWith((message) => updates(message as NotificationHspStarving))
          as NotificationHspStarving;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationHspStarving create() => NotificationHspStarving._();
  @$core.override
  NotificationHspStarving createEmptyInstance() => create();
  static $pb.PbList<NotificationHspStarving> createRepeated() =>
      $pb.PbList<NotificationHspStarving>();
  @$core.pragma('dart2js:noInline')
  static NotificationHspStarving getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationHspStarving>(create);
  static NotificationHspStarving? _defaultInstance;

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

/// When pauseOnEmptyBuffer == true and we reached starving state. When adding more data to the buffer, we will RESUME the HSP and send this notification
class NotificationHspResumedOnNonStarving extends $pb.GeneratedMessage {
  factory NotificationHspResumedOnNonStarving({
    $0.HspState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  NotificationHspResumedOnNonStarving._();

  factory NotificationHspResumedOnNonStarving.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationHspResumedOnNonStarving.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationHspResumedOnNonStarving',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HspState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HspState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationHspResumedOnNonStarving clone() =>
      NotificationHspResumedOnNonStarving()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationHspResumedOnNonStarving copyWith(
          void Function(NotificationHspResumedOnNonStarving) updates) =>
      super.copyWith((message) =>
              updates(message as NotificationHspResumedOnNonStarving))
          as NotificationHspResumedOnNonStarving;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationHspResumedOnNonStarving create() =>
      NotificationHspResumedOnNonStarving._();
  @$core.override
  NotificationHspResumedOnNonStarving createEmptyInstance() => create();
  static $pb.PbList<NotificationHspResumedOnNonStarving> createRepeated() =>
      $pb.PbList<NotificationHspResumedOnNonStarving>();
  @$core.pragma('dart2js:noInline')
  static NotificationHspResumedOnNonStarving getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          NotificationHspResumedOnNonStarving>(create);
  static NotificationHspResumedOnNonStarving? _defaultInstance;

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

/// When pauseOnEmptyBuffer == true and we reached starving state we send this notification after PAUSE HSP
class NotificationHspPausedOnStarving extends $pb.GeneratedMessage {
  factory NotificationHspPausedOnStarving({
    $0.HspState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  NotificationHspPausedOnStarving._();

  factory NotificationHspPausedOnStarving.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationHspPausedOnStarving.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationHspPausedOnStarving',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HspState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HspState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationHspPausedOnStarving clone() =>
      NotificationHspPausedOnStarving()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationHspPausedOnStarving copyWith(
          void Function(NotificationHspPausedOnStarving) updates) =>
      super.copyWith(
              (message) => updates(message as NotificationHspPausedOnStarving))
          as NotificationHspPausedOnStarving;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationHspPausedOnStarving create() =>
      NotificationHspPausedOnStarving._();
  @$core.override
  NotificationHspPausedOnStarving createEmptyInstance() => create();
  static $pb.PbList<NotificationHspPausedOnStarving> createRepeated() =>
      $pb.PbList<NotificationHspPausedOnStarving>();
  @$core.pragma('dart2js:noInline')
  static NotificationHspPausedOnStarving getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationHspPausedOnStarving>(
          create);
  static NotificationHspPausedOnStarving? _defaultInstance;

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

/// 900
class NotificationHvpChanged extends $pb.GeneratedMessage {
  factory NotificationHvpChanged({
    $0.HvpState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  NotificationHvpChanged._();

  factory NotificationHvpChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationHvpChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationHvpChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HvpState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HvpState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationHvpChanged clone() =>
      NotificationHvpChanged()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationHvpChanged copyWith(
          void Function(NotificationHvpChanged) updates) =>
      super.copyWith((message) => updates(message as NotificationHvpChanged))
          as NotificationHvpChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationHvpChanged create() => NotificationHvpChanged._();
  @$core.override
  NotificationHvpChanged createEmptyInstance() => create();
  static $pb.PbList<NotificationHvpChanged> createRepeated() =>
      $pb.PbList<NotificationHvpChanged>();
  @$core.pragma('dart2js:noInline')
  static NotificationHvpChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationHvpChanged>(create);
  static NotificationHvpChanged? _defaultInstance;

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

/// 920
class NotificationHrppChanged extends $pb.GeneratedMessage {
  factory NotificationHrppChanged({
    $0.HrppState? state,
  }) {
    final result = create();
    if (state != null) result.state = state;
    return result;
  }

  NotificationHrppChanged._();

  factory NotificationHrppChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationHrppChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationHrppChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aOM<$0.HrppState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: $0.HrppState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationHrppChanged clone() =>
      NotificationHrppChanged()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationHrppChanged copyWith(
          void Function(NotificationHrppChanged) updates) =>
      super.copyWith((message) => updates(message as NotificationHrppChanged))
          as NotificationHrppChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationHrppChanged create() => NotificationHrppChanged._();
  @$core.override
  NotificationHrppChanged createEmptyInstance() => create();
  static $pb.PbList<NotificationHrppChanged> createRepeated() =>
      $pb.PbList<NotificationHrppChanged>();
  @$core.pragma('dart2js:noInline')
  static NotificationHrppChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationHrppChanged>(create);
  static NotificationHrppChanged? _defaultInstance;

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

///  Handy error notifications starts at 800
/// 800
class NotificationTempHigh extends $pb.GeneratedMessage {
  factory NotificationTempHigh() => create();

  NotificationTempHigh._();

  factory NotificationTempHigh.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationTempHigh.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationTempHigh',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationTempHigh clone() =>
      NotificationTempHigh()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationTempHigh copyWith(void Function(NotificationTempHigh) updates) =>
      super.copyWith((message) => updates(message as NotificationTempHigh))
          as NotificationTempHigh;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationTempHigh create() => NotificationTempHigh._();
  @$core.override
  NotificationTempHigh createEmptyInstance() => create();
  static $pb.PbList<NotificationTempHigh> createRepeated() =>
      $pb.PbList<NotificationTempHigh>();
  @$core.pragma('dart2js:noInline')
  static NotificationTempHigh getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationTempHigh>(create);
  static NotificationTempHigh? _defaultInstance;
}

/// 801
class NotificationTempOk extends $pb.GeneratedMessage {
  factory NotificationTempOk() => create();

  NotificationTempOk._();

  factory NotificationTempOk.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationTempOk.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationTempOk',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationTempOk clone() => NotificationTempOk()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationTempOk copyWith(void Function(NotificationTempOk) updates) =>
      super.copyWith((message) => updates(message as NotificationTempOk))
          as NotificationTempOk;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationTempOk create() => NotificationTempOk._();
  @$core.override
  NotificationTempOk createEmptyInstance() => create();
  static $pb.PbList<NotificationTempOk> createRepeated() =>
      $pb.PbList<NotificationTempOk>();
  @$core.pragma('dart2js:noInline')
  static NotificationTempOk getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationTempOk>(create);
  static NotificationTempOk? _defaultInstance;
}

/// 802
class NotificationSliderBlocked extends $pb.GeneratedMessage {
  factory NotificationSliderBlocked() => create();

  NotificationSliderBlocked._();

  factory NotificationSliderBlocked.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationSliderBlocked.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationSliderBlocked',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationSliderBlocked clone() =>
      NotificationSliderBlocked()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationSliderBlocked copyWith(
          void Function(NotificationSliderBlocked) updates) =>
      super.copyWith((message) => updates(message as NotificationSliderBlocked))
          as NotificationSliderBlocked;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationSliderBlocked create() => NotificationSliderBlocked._();
  @$core.override
  NotificationSliderBlocked createEmptyInstance() => create();
  static $pb.PbList<NotificationSliderBlocked> createRepeated() =>
      $pb.PbList<NotificationSliderBlocked>();
  @$core.pragma('dart2js:noInline')
  static NotificationSliderBlocked getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationSliderBlocked>(create);
  static NotificationSliderBlocked? _defaultInstance;
}

/// 803
class NotificationSliderUnblocked extends $pb.GeneratedMessage {
  factory NotificationSliderUnblocked() => create();

  NotificationSliderUnblocked._();

  factory NotificationSliderUnblocked.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationSliderUnblocked.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationSliderUnblocked',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationSliderUnblocked clone() =>
      NotificationSliderUnblocked()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationSliderUnblocked copyWith(
          void Function(NotificationSliderUnblocked) updates) =>
      super.copyWith(
              (message) => updates(message as NotificationSliderUnblocked))
          as NotificationSliderUnblocked;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationSliderUnblocked create() =>
      NotificationSliderUnblocked._();
  @$core.override
  NotificationSliderUnblocked createEmptyInstance() => create();
  static $pb.PbList<NotificationSliderUnblocked> createRepeated() =>
      $pb.PbList<NotificationSliderUnblocked>();
  @$core.pragma('dart2js:noInline')
  static NotificationSliderUnblocked getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationSliderUnblocked>(create);
  static NotificationSliderUnblocked? _defaultInstance;
}

/// Sent when a message is discarded due to low memory (we do not have memory to parse the message, so the only thing we can do to identify the message is to check the size)
class NotificationLowMemoryError extends $pb.GeneratedMessage {
  factory NotificationLowMemoryError({
    $core.int? availableHeap,
    $core.int? largestFreeBlock,
    $core.int? discardedMsgSize,
  }) {
    final result = create();
    if (availableHeap != null) result.availableHeap = availableHeap;
    if (largestFreeBlock != null) result.largestFreeBlock = largestFreeBlock;
    if (discardedMsgSize != null) result.discardedMsgSize = discardedMsgSize;
    return result;
  }

  NotificationLowMemoryError._();

  factory NotificationLowMemoryError.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationLowMemoryError.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationLowMemoryError',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1, _omitFieldNames ? '' : 'availableHeap', $pb.PbFieldType.OU3)
    ..a<$core.int>(
        2, _omitFieldNames ? '' : 'largestFreeBlock', $pb.PbFieldType.OU3)
    ..a<$core.int>(
        3, _omitFieldNames ? '' : 'discardedMsgSize', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationLowMemoryError clone() =>
      NotificationLowMemoryError()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationLowMemoryError copyWith(
          void Function(NotificationLowMemoryError) updates) =>
      super.copyWith(
              (message) => updates(message as NotificationLowMemoryError))
          as NotificationLowMemoryError;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationLowMemoryError create() => NotificationLowMemoryError._();
  @$core.override
  NotificationLowMemoryError createEmptyInstance() => create();
  static $pb.PbList<NotificationLowMemoryError> createRepeated() =>
      $pb.PbList<NotificationLowMemoryError>();
  @$core.pragma('dart2js:noInline')
  static NotificationLowMemoryError getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationLowMemoryError>(create);
  static NotificationLowMemoryError? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get availableHeap => $_getIZ(0);
  @$pb.TagNumber(1)
  set availableHeap($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAvailableHeap() => $_has(0);
  @$pb.TagNumber(1)
  void clearAvailableHeap() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get largestFreeBlock => $_getIZ(1);
  @$pb.TagNumber(2)
  set largestFreeBlock($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLargestFreeBlock() => $_has(1);
  @$pb.TagNumber(2)
  void clearLargestFreeBlock() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get discardedMsgSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set discardedMsgSize($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDiscardedMsgSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearDiscardedMsgSize() => $_clearField(3);
}

/// Triggers when we ahve very little memory left. Little is TBD
class NotificationLowMemoryWarning extends $pb.GeneratedMessage {
  factory NotificationLowMemoryWarning({
    $core.int? availableHeap,
    $core.int? largestFreeBlock,
  }) {
    final result = create();
    if (availableHeap != null) result.availableHeap = availableHeap;
    if (largestFreeBlock != null) result.largestFreeBlock = largestFreeBlock;
    return result;
  }

  NotificationLowMemoryWarning._();

  factory NotificationLowMemoryWarning.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationLowMemoryWarning.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationLowMemoryWarning',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1, _omitFieldNames ? '' : 'availableHeap', $pb.PbFieldType.OU3)
    ..a<$core.int>(
        2, _omitFieldNames ? '' : 'largestFreeBlock', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationLowMemoryWarning clone() =>
      NotificationLowMemoryWarning()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationLowMemoryWarning copyWith(
          void Function(NotificationLowMemoryWarning) updates) =>
      super.copyWith(
              (message) => updates(message as NotificationLowMemoryWarning))
          as NotificationLowMemoryWarning;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationLowMemoryWarning create() =>
      NotificationLowMemoryWarning._();
  @$core.override
  NotificationLowMemoryWarning createEmptyInstance() => create();
  static $pb.PbList<NotificationLowMemoryWarning> createRepeated() =>
      $pb.PbList<NotificationLowMemoryWarning>();
  @$core.pragma('dart2js:noInline')
  static NotificationLowMemoryWarning getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationLowMemoryWarning>(create);
  static NotificationLowMemoryWarning? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get availableHeap => $_getIZ(0);
  @$pb.TagNumber(1)
  set availableHeap($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAvailableHeap() => $_has(0);
  @$pb.TagNumber(1)
  void clearAvailableHeap() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get largestFreeBlock => $_getIZ(1);
  @$pb.TagNumber(2)
  set largestFreeBlock($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLargestFreeBlock() => $_has(1);
  @$pb.TagNumber(2)
  void clearLargestFreeBlock() => $_clearField(2);
}

/// Generic error message
class NotificationError extends $pb.GeneratedMessage {
  factory NotificationError({
    $core.int? code,
    $core.String? message,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (message != null) result.message = message;
    return result;
  }

  NotificationError._();

  factory NotificationError.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationError.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationError',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'code', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationError clone() => NotificationError()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationError copyWith(void Function(NotificationError) updates) =>
      super.copyWith((message) => updates(message as NotificationError))
          as NotificationError;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationError create() => NotificationError._();
  @$core.override
  NotificationError createEmptyInstance() => create();
  static $pb.PbList<NotificationError> createRepeated() =>
      $pb.PbList<NotificationError>();
  @$core.pragma('dart2js:noInline')
  static NotificationError getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationError>(create);
  static NotificationError? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

class NotificationWifiScanComplete extends $pb.GeneratedMessage {
  factory NotificationWifiScanComplete({
    $core.int? nrOfNetworks,
  }) {
    final result = create();
    if (nrOfNetworks != null) result.nrOfNetworks = nrOfNetworks;
    return result;
  }

  NotificationWifiScanComplete._();

  factory NotificationWifiScanComplete.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationWifiScanComplete.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationWifiScanComplete',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1, _omitFieldNames ? '' : 'nrOfNetworks', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationWifiScanComplete clone() =>
      NotificationWifiScanComplete()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationWifiScanComplete copyWith(
          void Function(NotificationWifiScanComplete) updates) =>
      super.copyWith(
              (message) => updates(message as NotificationWifiScanComplete))
          as NotificationWifiScanComplete;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationWifiScanComplete create() =>
      NotificationWifiScanComplete._();
  @$core.override
  NotificationWifiScanComplete createEmptyInstance() => create();
  static $pb.PbList<NotificationWifiScanComplete> createRepeated() =>
      $pb.PbList<NotificationWifiScanComplete>();
  @$core.pragma('dart2js:noInline')
  static NotificationWifiScanComplete getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationWifiScanComplete>(create);
  static NotificationWifiScanComplete? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get nrOfNetworks => $_getIZ(0);
  @$pb.TagNumber(1)
  set nrOfNetworks($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNrOfNetworks() => $_has(0);
  @$pb.TagNumber(1)
  void clearNrOfNetworks() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
