// This is a generated file - do not edit.
//
// Generated from handy_rpc.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'handy_rpc.pbenum.dart';
import 'messages.pb.dart' as $1;
import 'notifications.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'handy_rpc.pbenum.dart';

enum Notification_Notification {
  notificationConnectedChanged,
  notificationWifiScanComplete,
  notificationWifiStatusChanged,
  notificationBleStatusChanged,
  notificationOtaComplete,
  notificationModeChanged,
  notificationStrokeChanged,
  notificationButtonEvent,
  notificationBatteryChanged,
  notificationError,
  notificationIdleTimeout,
  notificationHampChanged,
  notificationHdspChanged,
  notificationSensorUpdate,
  notificationSlideDiagData,
  notificationSpeedStats,
  notificationSliderEndReached,
  notificationHspThresholdReached,
  notificationHspStateChanged,
  notificationHspLooping,
  notificationHspStarving,
  notificationHspResumedOnNonStarving,
  notificationHspPausedOnStarving,
  notificationHvpChanged,
  notificationHrppChanged,
  notificationTempHigh,
  notificationTempOk,
  notificationSliderBlocked,
  notificationSliderUnblocked,
  notificationLowMemoryError,
  notificationLowMemoryWarning,
  notificationSettingsChanged,
  notSet
}

///
/// Concepts
/// - All commands are sent as a request and a response
/// - All commands should give response "instantly" -> If there is a command that will take time to execute, the device should send an OK/error to the msg instantly, and then a notification when it is done.
/// - All commands should have a response
/// - Response can be blank
/// - All commands should have a unique ID for response
/// - All responses should have a result code
/// - All responses should match the request ID
/// - You can send a bundle of request in one requests message
/// - The responses will be sent back individually
/// - Some messages need to set a has_xxx flag to true for the FW to handle the corresponding value
class Notification extends $pb.GeneratedMessage {
  factory Notification({
    $core.int? id,
    $0.NotificationConnectedChanged? notificationConnectedChanged,
    $0.NotificationWifiScanComplete? notificationWifiScanComplete,
    $0.NotificationWifiStatusChanged? notificationWifiStatusChanged,
    $0.NotificationBleStatusChanged? notificationBleStatusChanged,
    $0.NotificationOtaComplete? notificationOtaComplete,
    $0.NotificationModeChanged? notificationModeChanged,
    $0.NotificationStrokeChanged? notificationStrokeChanged,
    $0.NotificationButtonEvent? notificationButtonEvent,
    $0.NotificationBatteryChanged? notificationBatteryChanged,
    $0.NotificationError? notificationError,
    $0.NotificationIdleTimeout? notificationIdleTimeout,
    $0.NotificationHampChanged? notificationHampChanged,
    $0.NotificationHdspChanged? notificationHdspChanged,
    $0.NotificationSensorUpdate? notificationSensorUpdate,
    $0.NotificationSlideDiagData? notificationSlideDiagData,
    $0.NotificationSpeedStats? notificationSpeedStats,
    $0.NotificationSliderEndReached? notificationSliderEndReached,
    $0.NotificationHspThresholdReached? notificationHspThresholdReached,
    $0.NotificationHspStateChanged? notificationHspStateChanged,
    $0.NotificationHspLooping? notificationHspLooping,
    $0.NotificationHspStarving? notificationHspStarving,
    $0.NotificationHspResumedOnNonStarving? notificationHspResumedOnNonStarving,
    $0.NotificationHspPausedOnStarving? notificationHspPausedOnStarving,
    $0.NotificationHvpChanged? notificationHvpChanged,
    $0.NotificationHrppChanged? notificationHrppChanged,
    $0.NotificationTempHigh? notificationTempHigh,
    $0.NotificationTempOk? notificationTempOk,
    $0.NotificationSliderBlocked? notificationSliderBlocked,
    $0.NotificationSliderUnblocked? notificationSliderUnblocked,
    $0.NotificationLowMemoryError? notificationLowMemoryError,
    $0.NotificationLowMemoryWarning? notificationLowMemoryWarning,
    $0.NotificationSettingsChanged? notificationSettingsChanged,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (notificationConnectedChanged != null)
      result.notificationConnectedChanged = notificationConnectedChanged;
    if (notificationWifiScanComplete != null)
      result.notificationWifiScanComplete = notificationWifiScanComplete;
    if (notificationWifiStatusChanged != null)
      result.notificationWifiStatusChanged = notificationWifiStatusChanged;
    if (notificationBleStatusChanged != null)
      result.notificationBleStatusChanged = notificationBleStatusChanged;
    if (notificationOtaComplete != null)
      result.notificationOtaComplete = notificationOtaComplete;
    if (notificationModeChanged != null)
      result.notificationModeChanged = notificationModeChanged;
    if (notificationStrokeChanged != null)
      result.notificationStrokeChanged = notificationStrokeChanged;
    if (notificationButtonEvent != null)
      result.notificationButtonEvent = notificationButtonEvent;
    if (notificationBatteryChanged != null)
      result.notificationBatteryChanged = notificationBatteryChanged;
    if (notificationError != null) result.notificationError = notificationError;
    if (notificationIdleTimeout != null)
      result.notificationIdleTimeout = notificationIdleTimeout;
    if (notificationHampChanged != null)
      result.notificationHampChanged = notificationHampChanged;
    if (notificationHdspChanged != null)
      result.notificationHdspChanged = notificationHdspChanged;
    if (notificationSensorUpdate != null)
      result.notificationSensorUpdate = notificationSensorUpdate;
    if (notificationSlideDiagData != null)
      result.notificationSlideDiagData = notificationSlideDiagData;
    if (notificationSpeedStats != null)
      result.notificationSpeedStats = notificationSpeedStats;
    if (notificationSliderEndReached != null)
      result.notificationSliderEndReached = notificationSliderEndReached;
    if (notificationHspThresholdReached != null)
      result.notificationHspThresholdReached = notificationHspThresholdReached;
    if (notificationHspStateChanged != null)
      result.notificationHspStateChanged = notificationHspStateChanged;
    if (notificationHspLooping != null)
      result.notificationHspLooping = notificationHspLooping;
    if (notificationHspStarving != null)
      result.notificationHspStarving = notificationHspStarving;
    if (notificationHspResumedOnNonStarving != null)
      result.notificationHspResumedOnNonStarving =
          notificationHspResumedOnNonStarving;
    if (notificationHspPausedOnStarving != null)
      result.notificationHspPausedOnStarving = notificationHspPausedOnStarving;
    if (notificationHvpChanged != null)
      result.notificationHvpChanged = notificationHvpChanged;
    if (notificationHrppChanged != null)
      result.notificationHrppChanged = notificationHrppChanged;
    if (notificationTempHigh != null)
      result.notificationTempHigh = notificationTempHigh;
    if (notificationTempOk != null)
      result.notificationTempOk = notificationTempOk;
    if (notificationSliderBlocked != null)
      result.notificationSliderBlocked = notificationSliderBlocked;
    if (notificationSliderUnblocked != null)
      result.notificationSliderUnblocked = notificationSliderUnblocked;
    if (notificationLowMemoryError != null)
      result.notificationLowMemoryError = notificationLowMemoryError;
    if (notificationLowMemoryWarning != null)
      result.notificationLowMemoryWarning = notificationLowMemoryWarning;
    if (notificationSettingsChanged != null)
      result.notificationSettingsChanged = notificationSettingsChanged;
    return result;
  }

  Notification._();

  factory Notification.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Notification.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Notification_Notification>
      _Notification_NotificationByTag = {
    300: Notification_Notification.notificationConnectedChanged,
    600: Notification_Notification.notificationWifiScanComplete,
    601: Notification_Notification.notificationWifiStatusChanged,
    602: Notification_Notification.notificationBleStatusChanged,
    603: Notification_Notification.notificationOtaComplete,
    700: Notification_Notification.notificationModeChanged,
    701: Notification_Notification.notificationStrokeChanged,
    703: Notification_Notification.notificationButtonEvent,
    705: Notification_Notification.notificationBatteryChanged,
    706: Notification_Notification.notificationError,
    707: Notification_Notification.notificationIdleTimeout,
    720: Notification_Notification.notificationHampChanged,
    740: Notification_Notification.notificationHdspChanged,
    800: Notification_Notification.notificationSensorUpdate,
    844: Notification_Notification.notificationSlideDiagData,
    851: Notification_Notification.notificationSpeedStats,
    857: Notification_Notification.notificationSliderEndReached,
    860: Notification_Notification.notificationHspThresholdReached,
    861: Notification_Notification.notificationHspStateChanged,
    862: Notification_Notification.notificationHspLooping,
    863: Notification_Notification.notificationHspStarving,
    864: Notification_Notification.notificationHspResumedOnNonStarving,
    865: Notification_Notification.notificationHspPausedOnStarving,
    900: Notification_Notification.notificationHvpChanged,
    920: Notification_Notification.notificationHrppChanged,
    1000: Notification_Notification.notificationTempHigh,
    1001: Notification_Notification.notificationTempOk,
    1002: Notification_Notification.notificationSliderBlocked,
    1003: Notification_Notification.notificationSliderUnblocked,
    1004: Notification_Notification.notificationLowMemoryError,
    1005: Notification_Notification.notificationLowMemoryWarning,
    2000: Notification_Notification.notificationSettingsChanged,
    0: Notification_Notification.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Notification',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..oo(0, [
      300,
      600,
      601,
      602,
      603,
      700,
      701,
      703,
      705,
      706,
      707,
      720,
      740,
      800,
      844,
      851,
      857,
      860,
      861,
      862,
      863,
      864,
      865,
      900,
      920,
      1000,
      1001,
      1002,
      1003,
      1004,
      1005,
      2000
    ])
    ..aI(2, _omitFieldNames ? '' : 'id', fieldType: $pb.PbFieldType.OU3)
    ..aOM<$0.NotificationConnectedChanged>(
        300, _omitFieldNames ? '' : 'notificationConnectedChanged',
        subBuilder: $0.NotificationConnectedChanged.create)
    ..aOM<$0.NotificationWifiScanComplete>(
        600, _omitFieldNames ? '' : 'notificationWifiScanComplete',
        subBuilder: $0.NotificationWifiScanComplete.create)
    ..aOM<$0.NotificationWifiStatusChanged>(
        601, _omitFieldNames ? '' : 'notificationWifiStatusChanged',
        subBuilder: $0.NotificationWifiStatusChanged.create)
    ..aOM<$0.NotificationBleStatusChanged>(
        602, _omitFieldNames ? '' : 'notificationBleStatusChanged',
        subBuilder: $0.NotificationBleStatusChanged.create)
    ..aOM<$0.NotificationOtaComplete>(
        603, _omitFieldNames ? '' : 'notificationOtaComplete',
        subBuilder: $0.NotificationOtaComplete.create)
    ..aOM<$0.NotificationModeChanged>(
        700, _omitFieldNames ? '' : 'notificationModeChanged',
        subBuilder: $0.NotificationModeChanged.create)
    ..aOM<$0.NotificationStrokeChanged>(
        701, _omitFieldNames ? '' : 'notificationStrokeChanged',
        subBuilder: $0.NotificationStrokeChanged.create)
    ..aOM<$0.NotificationButtonEvent>(
        703, _omitFieldNames ? '' : 'notificationButtonEvent',
        subBuilder: $0.NotificationButtonEvent.create)
    ..aOM<$0.NotificationBatteryChanged>(
        705, _omitFieldNames ? '' : 'notificationBatteryChanged',
        subBuilder: $0.NotificationBatteryChanged.create)
    ..aOM<$0.NotificationError>(706, _omitFieldNames ? '' : 'notificationError',
        subBuilder: $0.NotificationError.create)
    ..aOM<$0.NotificationIdleTimeout>(
        707, _omitFieldNames ? '' : 'notificationIdleTimeout',
        subBuilder: $0.NotificationIdleTimeout.create)
    ..aOM<$0.NotificationHampChanged>(
        720, _omitFieldNames ? '' : 'notificationHampChanged',
        subBuilder: $0.NotificationHampChanged.create)
    ..aOM<$0.NotificationHdspChanged>(
        740, _omitFieldNames ? '' : 'notificationHdspChanged',
        subBuilder: $0.NotificationHdspChanged.create)
    ..aOM<$0.NotificationSensorUpdate>(
        800, _omitFieldNames ? '' : 'notificationSensorUpdate',
        subBuilder: $0.NotificationSensorUpdate.create)
    ..aOM<$0.NotificationSlideDiagData>(
        844, _omitFieldNames ? '' : 'notificationSlideDiagData',
        subBuilder: $0.NotificationSlideDiagData.create)
    ..aOM<$0.NotificationSpeedStats>(
        851, _omitFieldNames ? '' : 'notificationSpeedStats',
        subBuilder: $0.NotificationSpeedStats.create)
    ..aOM<$0.NotificationSliderEndReached>(
        857, _omitFieldNames ? '' : 'notificationSliderEndReached',
        subBuilder: $0.NotificationSliderEndReached.create)
    ..aOM<$0.NotificationHspThresholdReached>(
        860, _omitFieldNames ? '' : 'notificationHspThresholdReached',
        subBuilder: $0.NotificationHspThresholdReached.create)
    ..aOM<$0.NotificationHspStateChanged>(
        861, _omitFieldNames ? '' : 'notificationHspStateChanged',
        subBuilder: $0.NotificationHspStateChanged.create)
    ..aOM<$0.NotificationHspLooping>(
        862, _omitFieldNames ? '' : 'notificationHspLooping',
        subBuilder: $0.NotificationHspLooping.create)
    ..aOM<$0.NotificationHspStarving>(
        863, _omitFieldNames ? '' : 'notificationHspStarving',
        subBuilder: $0.NotificationHspStarving.create)
    ..aOM<$0.NotificationHspResumedOnNonStarving>(
        864, _omitFieldNames ? '' : 'notificationHspResumedOnNonStarving',
        subBuilder: $0.NotificationHspResumedOnNonStarving.create)
    ..aOM<$0.NotificationHspPausedOnStarving>(
        865, _omitFieldNames ? '' : 'notificationHspPausedOnStarving',
        subBuilder: $0.NotificationHspPausedOnStarving.create)
    ..aOM<$0.NotificationHvpChanged>(
        900, _omitFieldNames ? '' : 'notificationHvpChanged',
        subBuilder: $0.NotificationHvpChanged.create)
    ..aOM<$0.NotificationHrppChanged>(
        920, _omitFieldNames ? '' : 'notificationHrppChanged',
        subBuilder: $0.NotificationHrppChanged.create)
    ..aOM<$0.NotificationTempHigh>(
        1000, _omitFieldNames ? '' : 'notificationTempHigh',
        subBuilder: $0.NotificationTempHigh.create)
    ..aOM<$0.NotificationTempOk>(
        1001, _omitFieldNames ? '' : 'notificationTempOk',
        subBuilder: $0.NotificationTempOk.create)
    ..aOM<$0.NotificationSliderBlocked>(
        1002, _omitFieldNames ? '' : 'notificationSliderBlocked',
        subBuilder: $0.NotificationSliderBlocked.create)
    ..aOM<$0.NotificationSliderUnblocked>(
        1003, _omitFieldNames ? '' : 'notificationSliderUnblocked',
        subBuilder: $0.NotificationSliderUnblocked.create)
    ..aOM<$0.NotificationLowMemoryError>(
        1004, _omitFieldNames ? '' : 'notificationLowMemoryError',
        subBuilder: $0.NotificationLowMemoryError.create)
    ..aOM<$0.NotificationLowMemoryWarning>(
        1005, _omitFieldNames ? '' : 'notificationLowMemoryWarning',
        subBuilder: $0.NotificationLowMemoryWarning.create)
    ..aOM<$0.NotificationSettingsChanged>(
        2000, _omitFieldNames ? '' : 'notificationSettingsChanged',
        subBuilder: $0.NotificationSettingsChanged.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notification clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notification copyWith(void Function(Notification) updates) =>
      super.copyWith((message) => updates(message as Notification))
          as Notification;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notification create() => Notification._();
  @$core.override
  Notification createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Notification getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Notification>(create);
  static Notification? _defaultInstance;

  @$pb.TagNumber(300)
  @$pb.TagNumber(600)
  @$pb.TagNumber(601)
  @$pb.TagNumber(602)
  @$pb.TagNumber(603)
  @$pb.TagNumber(700)
  @$pb.TagNumber(701)
  @$pb.TagNumber(703)
  @$pb.TagNumber(705)
  @$pb.TagNumber(706)
  @$pb.TagNumber(707)
  @$pb.TagNumber(720)
  @$pb.TagNumber(740)
  @$pb.TagNumber(800)
  @$pb.TagNumber(844)
  @$pb.TagNumber(851)
  @$pb.TagNumber(857)
  @$pb.TagNumber(860)
  @$pb.TagNumber(861)
  @$pb.TagNumber(862)
  @$pb.TagNumber(863)
  @$pb.TagNumber(864)
  @$pb.TagNumber(865)
  @$pb.TagNumber(900)
  @$pb.TagNumber(920)
  @$pb.TagNumber(1000)
  @$pb.TagNumber(1001)
  @$pb.TagNumber(1002)
  @$pb.TagNumber(1003)
  @$pb.TagNumber(1004)
  @$pb.TagNumber(1005)
  @$pb.TagNumber(2000)
  Notification_Notification whichNotification() =>
      _Notification_NotificationByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(300)
  @$pb.TagNumber(600)
  @$pb.TagNumber(601)
  @$pb.TagNumber(602)
  @$pb.TagNumber(603)
  @$pb.TagNumber(700)
  @$pb.TagNumber(701)
  @$pb.TagNumber(703)
  @$pb.TagNumber(705)
  @$pb.TagNumber(706)
  @$pb.TagNumber(707)
  @$pb.TagNumber(720)
  @$pb.TagNumber(740)
  @$pb.TagNumber(800)
  @$pb.TagNumber(844)
  @$pb.TagNumber(851)
  @$pb.TagNumber(857)
  @$pb.TagNumber(860)
  @$pb.TagNumber(861)
  @$pb.TagNumber(862)
  @$pb.TagNumber(863)
  @$pb.TagNumber(864)
  @$pb.TagNumber(865)
  @$pb.TagNumber(900)
  @$pb.TagNumber(920)
  @$pb.TagNumber(1000)
  @$pb.TagNumber(1001)
  @$pb.TagNumber(1002)
  @$pb.TagNumber(1003)
  @$pb.TagNumber(1004)
  @$pb.TagNumber(1005)
  @$pb.TagNumber(2000)
  void clearNotification() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(2)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(2)
  set id($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);

  /// Server Notification that are public starts with 300
  @$pb.TagNumber(300)
  $0.NotificationConnectedChanged get notificationConnectedChanged => $_getN(1);
  @$pb.TagNumber(300)
  set notificationConnectedChanged($0.NotificationConnectedChanged value) =>
      $_setField(300, value);
  @$pb.TagNumber(300)
  $core.bool hasNotificationConnectedChanged() => $_has(1);
  @$pb.TagNumber(300)
  void clearNotificationConnectedChanged() => $_clearField(300);
  @$pb.TagNumber(300)
  $0.NotificationConnectedChanged ensureNotificationConnectedChanged() =>
      $_ensure(1);

  /// BLE specific notifications starts with 600
  @$pb.TagNumber(600)
  $0.NotificationWifiScanComplete get notificationWifiScanComplete => $_getN(2);
  @$pb.TagNumber(600)
  set notificationWifiScanComplete($0.NotificationWifiScanComplete value) =>
      $_setField(600, value);
  @$pb.TagNumber(600)
  $core.bool hasNotificationWifiScanComplete() => $_has(2);
  @$pb.TagNumber(600)
  void clearNotificationWifiScanComplete() => $_clearField(600);
  @$pb.TagNumber(600)
  $0.NotificationWifiScanComplete ensureNotificationWifiScanComplete() =>
      $_ensure(2);

  @$pb.TagNumber(601)
  $0.NotificationWifiStatusChanged get notificationWifiStatusChanged =>
      $_getN(3);
  @$pb.TagNumber(601)
  set notificationWifiStatusChanged($0.NotificationWifiStatusChanged value) =>
      $_setField(601, value);
  @$pb.TagNumber(601)
  $core.bool hasNotificationWifiStatusChanged() => $_has(3);
  @$pb.TagNumber(601)
  void clearNotificationWifiStatusChanged() => $_clearField(601);
  @$pb.TagNumber(601)
  $0.NotificationWifiStatusChanged ensureNotificationWifiStatusChanged() =>
      $_ensure(3);

  @$pb.TagNumber(602)
  $0.NotificationBleStatusChanged get notificationBleStatusChanged => $_getN(4);
  @$pb.TagNumber(602)
  set notificationBleStatusChanged($0.NotificationBleStatusChanged value) =>
      $_setField(602, value);
  @$pb.TagNumber(602)
  $core.bool hasNotificationBleStatusChanged() => $_has(4);
  @$pb.TagNumber(602)
  void clearNotificationBleStatusChanged() => $_clearField(602);
  @$pb.TagNumber(602)
  $0.NotificationBleStatusChanged ensureNotificationBleStatusChanged() =>
      $_ensure(4);

  @$pb.TagNumber(603)
  $0.NotificationOtaComplete get notificationOtaComplete => $_getN(5);
  @$pb.TagNumber(603)
  set notificationOtaComplete($0.NotificationOtaComplete value) =>
      $_setField(603, value);
  @$pb.TagNumber(603)
  $core.bool hasNotificationOtaComplete() => $_has(5);
  @$pb.TagNumber(603)
  void clearNotificationOtaComplete() => $_clearField(603);
  @$pb.TagNumber(603)
  $0.NotificationOtaComplete ensureNotificationOtaComplete() => $_ensure(5);

  /// Handy Notifications starts with 700
  @$pb.TagNumber(700)
  $0.NotificationModeChanged get notificationModeChanged => $_getN(6);
  @$pb.TagNumber(700)
  set notificationModeChanged($0.NotificationModeChanged value) =>
      $_setField(700, value);
  @$pb.TagNumber(700)
  $core.bool hasNotificationModeChanged() => $_has(6);
  @$pb.TagNumber(700)
  void clearNotificationModeChanged() => $_clearField(700);
  @$pb.TagNumber(700)
  $0.NotificationModeChanged ensureNotificationModeChanged() => $_ensure(6);

  @$pb.TagNumber(701)
  $0.NotificationStrokeChanged get notificationStrokeChanged => $_getN(7);
  @$pb.TagNumber(701)
  set notificationStrokeChanged($0.NotificationStrokeChanged value) =>
      $_setField(701, value);
  @$pb.TagNumber(701)
  $core.bool hasNotificationStrokeChanged() => $_has(7);
  @$pb.TagNumber(701)
  void clearNotificationStrokeChanged() => $_clearField(701);
  @$pb.TagNumber(701)
  $0.NotificationStrokeChanged ensureNotificationStrokeChanged() => $_ensure(7);

  @$pb.TagNumber(703)
  $0.NotificationButtonEvent get notificationButtonEvent => $_getN(8);
  @$pb.TagNumber(703)
  set notificationButtonEvent($0.NotificationButtonEvent value) =>
      $_setField(703, value);
  @$pb.TagNumber(703)
  $core.bool hasNotificationButtonEvent() => $_has(8);
  @$pb.TagNumber(703)
  void clearNotificationButtonEvent() => $_clearField(703);
  @$pb.TagNumber(703)
  $0.NotificationButtonEvent ensureNotificationButtonEvent() => $_ensure(8);

  @$pb.TagNumber(705)
  $0.NotificationBatteryChanged get notificationBatteryChanged => $_getN(9);
  @$pb.TagNumber(705)
  set notificationBatteryChanged($0.NotificationBatteryChanged value) =>
      $_setField(705, value);
  @$pb.TagNumber(705)
  $core.bool hasNotificationBatteryChanged() => $_has(9);
  @$pb.TagNumber(705)
  void clearNotificationBatteryChanged() => $_clearField(705);
  @$pb.TagNumber(705)
  $0.NotificationBatteryChanged ensureNotificationBatteryChanged() =>
      $_ensure(9);

  @$pb.TagNumber(706)
  $0.NotificationError get notificationError => $_getN(10);
  @$pb.TagNumber(706)
  set notificationError($0.NotificationError value) => $_setField(706, value);
  @$pb.TagNumber(706)
  $core.bool hasNotificationError() => $_has(10);
  @$pb.TagNumber(706)
  void clearNotificationError() => $_clearField(706);
  @$pb.TagNumber(706)
  $0.NotificationError ensureNotificationError() => $_ensure(10);

  @$pb.TagNumber(707)
  $0.NotificationIdleTimeout get notificationIdleTimeout => $_getN(11);
  @$pb.TagNumber(707)
  set notificationIdleTimeout($0.NotificationIdleTimeout value) =>
      $_setField(707, value);
  @$pb.TagNumber(707)
  $core.bool hasNotificationIdleTimeout() => $_has(11);
  @$pb.TagNumber(707)
  void clearNotificationIdleTimeout() => $_clearField(707);
  @$pb.TagNumber(707)
  $0.NotificationIdleTimeout ensureNotificationIdleTimeout() => $_ensure(11);

  @$pb.TagNumber(720)
  $0.NotificationHampChanged get notificationHampChanged => $_getN(12);
  @$pb.TagNumber(720)
  set notificationHampChanged($0.NotificationHampChanged value) =>
      $_setField(720, value);
  @$pb.TagNumber(720)
  $core.bool hasNotificationHampChanged() => $_has(12);
  @$pb.TagNumber(720)
  void clearNotificationHampChanged() => $_clearField(720);
  @$pb.TagNumber(720)
  $0.NotificationHampChanged ensureNotificationHampChanged() => $_ensure(12);

  @$pb.TagNumber(740)
  $0.NotificationHdspChanged get notificationHdspChanged => $_getN(13);
  @$pb.TagNumber(740)
  set notificationHdspChanged($0.NotificationHdspChanged value) =>
      $_setField(740, value);
  @$pb.TagNumber(740)
  $core.bool hasNotificationHdspChanged() => $_has(13);
  @$pb.TagNumber(740)
  void clearNotificationHdspChanged() => $_clearField(740);
  @$pb.TagNumber(740)
  $0.NotificationHdspChanged ensureNotificationHdspChanged() => $_ensure(13);

  /// Sensor - 800
  @$pb.TagNumber(800)
  $0.NotificationSensorUpdate get notificationSensorUpdate => $_getN(14);
  @$pb.TagNumber(800)
  set notificationSensorUpdate($0.NotificationSensorUpdate value) =>
      $_setField(800, value);
  @$pb.TagNumber(800)
  $core.bool hasNotificationSensorUpdate() => $_has(14);
  @$pb.TagNumber(800)
  void clearNotificationSensorUpdate() => $_clearField(800);
  @$pb.TagNumber(800)
  $0.NotificationSensorUpdate ensureNotificationSensorUpdate() => $_ensure(14);

  @$pb.TagNumber(844)
  $0.NotificationSlideDiagData get notificationSlideDiagData => $_getN(15);
  @$pb.TagNumber(844)
  set notificationSlideDiagData($0.NotificationSlideDiagData value) =>
      $_setField(844, value);
  @$pb.TagNumber(844)
  $core.bool hasNotificationSlideDiagData() => $_has(15);
  @$pb.TagNumber(844)
  void clearNotificationSlideDiagData() => $_clearField(844);
  @$pb.TagNumber(844)
  $0.NotificationSlideDiagData ensureNotificationSlideDiagData() =>
      $_ensure(15);

  @$pb.TagNumber(851)
  $0.NotificationSpeedStats get notificationSpeedStats => $_getN(16);
  @$pb.TagNumber(851)
  set notificationSpeedStats($0.NotificationSpeedStats value) =>
      $_setField(851, value);
  @$pb.TagNumber(851)
  $core.bool hasNotificationSpeedStats() => $_has(16);
  @$pb.TagNumber(851)
  void clearNotificationSpeedStats() => $_clearField(851);
  @$pb.TagNumber(851)
  $0.NotificationSpeedStats ensureNotificationSpeedStats() => $_ensure(16);

  @$pb.TagNumber(857)
  $0.NotificationSliderEndReached get notificationSliderEndReached =>
      $_getN(17);
  @$pb.TagNumber(857)
  set notificationSliderEndReached($0.NotificationSliderEndReached value) =>
      $_setField(857, value);
  @$pb.TagNumber(857)
  $core.bool hasNotificationSliderEndReached() => $_has(17);
  @$pb.TagNumber(857)
  void clearNotificationSliderEndReached() => $_clearField(857);
  @$pb.TagNumber(857)
  $0.NotificationSliderEndReached ensureNotificationSliderEndReached() =>
      $_ensure(17);

  @$pb.TagNumber(860)
  $0.NotificationHspThresholdReached get notificationHspThresholdReached =>
      $_getN(18);
  @$pb.TagNumber(860)
  set notificationHspThresholdReached(
          $0.NotificationHspThresholdReached value) =>
      $_setField(860, value);
  @$pb.TagNumber(860)
  $core.bool hasNotificationHspThresholdReached() => $_has(18);
  @$pb.TagNumber(860)
  void clearNotificationHspThresholdReached() => $_clearField(860);
  @$pb.TagNumber(860)
  $0.NotificationHspThresholdReached ensureNotificationHspThresholdReached() =>
      $_ensure(18);

  @$pb.TagNumber(861)
  $0.NotificationHspStateChanged get notificationHspStateChanged => $_getN(19);
  @$pb.TagNumber(861)
  set notificationHspStateChanged($0.NotificationHspStateChanged value) =>
      $_setField(861, value);
  @$pb.TagNumber(861)
  $core.bool hasNotificationHspStateChanged() => $_has(19);
  @$pb.TagNumber(861)
  void clearNotificationHspStateChanged() => $_clearField(861);
  @$pb.TagNumber(861)
  $0.NotificationHspStateChanged ensureNotificationHspStateChanged() =>
      $_ensure(19);

  @$pb.TagNumber(862)
  $0.NotificationHspLooping get notificationHspLooping => $_getN(20);
  @$pb.TagNumber(862)
  set notificationHspLooping($0.NotificationHspLooping value) =>
      $_setField(862, value);
  @$pb.TagNumber(862)
  $core.bool hasNotificationHspLooping() => $_has(20);
  @$pb.TagNumber(862)
  void clearNotificationHspLooping() => $_clearField(862);
  @$pb.TagNumber(862)
  $0.NotificationHspLooping ensureNotificationHspLooping() => $_ensure(20);

  @$pb.TagNumber(863)
  $0.NotificationHspStarving get notificationHspStarving => $_getN(21);
  @$pb.TagNumber(863)
  set notificationHspStarving($0.NotificationHspStarving value) =>
      $_setField(863, value);
  @$pb.TagNumber(863)
  $core.bool hasNotificationHspStarving() => $_has(21);
  @$pb.TagNumber(863)
  void clearNotificationHspStarving() => $_clearField(863);
  @$pb.TagNumber(863)
  $0.NotificationHspStarving ensureNotificationHspStarving() => $_ensure(21);

  @$pb.TagNumber(864)
  $0.NotificationHspResumedOnNonStarving
      get notificationHspResumedOnNonStarving => $_getN(22);
  @$pb.TagNumber(864)
  set notificationHspResumedOnNonStarving(
          $0.NotificationHspResumedOnNonStarving value) =>
      $_setField(864, value);
  @$pb.TagNumber(864)
  $core.bool hasNotificationHspResumedOnNonStarving() => $_has(22);
  @$pb.TagNumber(864)
  void clearNotificationHspResumedOnNonStarving() => $_clearField(864);
  @$pb.TagNumber(864)
  $0.NotificationHspResumedOnNonStarving
      ensureNotificationHspResumedOnNonStarving() => $_ensure(22);

  @$pb.TagNumber(865)
  $0.NotificationHspPausedOnStarving get notificationHspPausedOnStarving =>
      $_getN(23);
  @$pb.TagNumber(865)
  set notificationHspPausedOnStarving(
          $0.NotificationHspPausedOnStarving value) =>
      $_setField(865, value);
  @$pb.TagNumber(865)
  $core.bool hasNotificationHspPausedOnStarving() => $_has(23);
  @$pb.TagNumber(865)
  void clearNotificationHspPausedOnStarving() => $_clearField(865);
  @$pb.TagNumber(865)
  $0.NotificationHspPausedOnStarving ensureNotificationHspPausedOnStarving() =>
      $_ensure(23);

  /// 900 - HVP
  @$pb.TagNumber(900)
  $0.NotificationHvpChanged get notificationHvpChanged => $_getN(24);
  @$pb.TagNumber(900)
  set notificationHvpChanged($0.NotificationHvpChanged value) =>
      $_setField(900, value);
  @$pb.TagNumber(900)
  $core.bool hasNotificationHvpChanged() => $_has(24);
  @$pb.TagNumber(900)
  void clearNotificationHvpChanged() => $_clearField(900);
  @$pb.TagNumber(900)
  $0.NotificationHvpChanged ensureNotificationHvpChanged() => $_ensure(24);

  /// HRPP - 920
  @$pb.TagNumber(920)
  $0.NotificationHrppChanged get notificationHrppChanged => $_getN(25);
  @$pb.TagNumber(920)
  set notificationHrppChanged($0.NotificationHrppChanged value) =>
      $_setField(920, value);
  @$pb.TagNumber(920)
  $core.bool hasNotificationHrppChanged() => $_has(25);
  @$pb.TagNumber(920)
  void clearNotificationHrppChanged() => $_clearField(920);
  @$pb.TagNumber(920)
  $0.NotificationHrppChanged ensureNotificationHrppChanged() => $_ensure(25);

  /// Handy error notifications starts with 1000
  @$pb.TagNumber(1000)
  $0.NotificationTempHigh get notificationTempHigh => $_getN(26);
  @$pb.TagNumber(1000)
  set notificationTempHigh($0.NotificationTempHigh value) =>
      $_setField(1000, value);
  @$pb.TagNumber(1000)
  $core.bool hasNotificationTempHigh() => $_has(26);
  @$pb.TagNumber(1000)
  void clearNotificationTempHigh() => $_clearField(1000);
  @$pb.TagNumber(1000)
  $0.NotificationTempHigh ensureNotificationTempHigh() => $_ensure(26);

  @$pb.TagNumber(1001)
  $0.NotificationTempOk get notificationTempOk => $_getN(27);
  @$pb.TagNumber(1001)
  set notificationTempOk($0.NotificationTempOk value) =>
      $_setField(1001, value);
  @$pb.TagNumber(1001)
  $core.bool hasNotificationTempOk() => $_has(27);
  @$pb.TagNumber(1001)
  void clearNotificationTempOk() => $_clearField(1001);
  @$pb.TagNumber(1001)
  $0.NotificationTempOk ensureNotificationTempOk() => $_ensure(27);

  @$pb.TagNumber(1002)
  $0.NotificationSliderBlocked get notificationSliderBlocked => $_getN(28);
  @$pb.TagNumber(1002)
  set notificationSliderBlocked($0.NotificationSliderBlocked value) =>
      $_setField(1002, value);
  @$pb.TagNumber(1002)
  $core.bool hasNotificationSliderBlocked() => $_has(28);
  @$pb.TagNumber(1002)
  void clearNotificationSliderBlocked() => $_clearField(1002);
  @$pb.TagNumber(1002)
  $0.NotificationSliderBlocked ensureNotificationSliderBlocked() =>
      $_ensure(28);

  @$pb.TagNumber(1003)
  $0.NotificationSliderUnblocked get notificationSliderUnblocked => $_getN(29);
  @$pb.TagNumber(1003)
  set notificationSliderUnblocked($0.NotificationSliderUnblocked value) =>
      $_setField(1003, value);
  @$pb.TagNumber(1003)
  $core.bool hasNotificationSliderUnblocked() => $_has(29);
  @$pb.TagNumber(1003)
  void clearNotificationSliderUnblocked() => $_clearField(1003);
  @$pb.TagNumber(1003)
  $0.NotificationSliderUnblocked ensureNotificationSliderUnblocked() =>
      $_ensure(29);

  @$pb.TagNumber(1004)
  $0.NotificationLowMemoryError get notificationLowMemoryError => $_getN(30);
  @$pb.TagNumber(1004)
  set notificationLowMemoryError($0.NotificationLowMemoryError value) =>
      $_setField(1004, value);
  @$pb.TagNumber(1004)
  $core.bool hasNotificationLowMemoryError() => $_has(30);
  @$pb.TagNumber(1004)
  void clearNotificationLowMemoryError() => $_clearField(1004);
  @$pb.TagNumber(1004)
  $0.NotificationLowMemoryError ensureNotificationLowMemoryError() =>
      $_ensure(30);

  @$pb.TagNumber(1005)
  $0.NotificationLowMemoryWarning get notificationLowMemoryWarning =>
      $_getN(31);
  @$pb.TagNumber(1005)
  set notificationLowMemoryWarning($0.NotificationLowMemoryWarning value) =>
      $_setField(1005, value);
  @$pb.TagNumber(1005)
  $core.bool hasNotificationLowMemoryWarning() => $_has(31);
  @$pb.TagNumber(1005)
  void clearNotificationLowMemoryWarning() => $_clearField(1005);
  @$pb.TagNumber(1005)
  $0.NotificationLowMemoryWarning ensureNotificationLowMemoryWarning() =>
      $_ensure(31);

  @$pb.TagNumber(2000)
  $0.NotificationSettingsChanged get notificationSettingsChanged => $_getN(32);
  @$pb.TagNumber(2000)
  set notificationSettingsChanged($0.NotificationSettingsChanged value) =>
      $_setField(2000, value);
  @$pb.TagNumber(2000)
  $core.bool hasNotificationSettingsChanged() => $_has(32);
  @$pb.TagNumber(2000)
  void clearNotificationSettingsChanged() => $_clearField(2000);
  @$pb.TagNumber(2000)
  $0.NotificationSettingsChanged ensureNotificationSettingsChanged() =>
      $_ensure(32);
}

enum Request_Params {
  requestServerTimeGet,
  requestConnectedGet,
  requestFwStatusGet,
  requestConnectionKeyGet,
  requestWifiStatusGet,
  requestWifiSet,
  requestWifiScanStart,
  requestWifiScanResultsGet,
  requestWifiScanStop,
  requestModeGet,
  requestModeSet,
  requestReboot,
  requestButtonPress,
  requestClockOffsetSet,
  requestBatteryGet,
  requestClockOffsetGet,
  requestCapabilitiesGet,
  requestSessionIdsGet,
  requestStopCurrentMode,
  requestConnectionModeSet,
  requestConnectionModeGet,
  requestPublicInfoGet,
  requestHampStart,
  requestHampStop,
  requestHampVelocitySet,
  requestHampStateGet,
  requestHampZoneSet,
  requestHdspXaVaSet,
  requestHdspXpVaSet,
  requestHdspXpVpSet,
  requestHdspXaTSet,
  requestHdspXpTSet,
  requestHdspXaVpSet,
  requestHdspStop,
  requestSensorNotificationSet,
  requestSensorStateGet,
  requestSensorNotificationGet,
  requestMemsStatusGet,
  requestMemsRead,
  requestMemsTare,
  requestMemsTempGet,
  requestMemsReset,
  requestMemsRegister,
  requestMemsConfigSet,
  requestMemsTestStart,
  requestMemsTestResultGet,
  requestSliderStrokeGet,
  requestSliderStrokeSet,
  requestSliderStateGet,
  requestSliderCalibrate,
  requestSlideDiagStart,
  requestSlideDiagStatus,
  requestSlideDiagRead,
  requestSlideDiagStop,
  requestHallCalibrationGet,
  requestSlideDiagStream,
  requestSpeedStatsGet,
  requestSpeedStatsSet,
  requestSlideSnapshotGet,
  requestSlideProfileTuningGet,
  requestSlideMaintResultGet,
  requestSliderEndMove,
  requestHspSetup,
  requestHspAdd,
  requestHspFlush,
  requestHspPlay,
  requestHspStop,
  requestHspPause,
  requestHspResume,
  requestHspStateGet,
  requestHspCurrentTimeSet,
  requestHspThresholdSet,
  requestHspPauseOnStarvingSet,
  requestHspPlaybackRateSet,
  requestHspLoopSet,
  requestHspJitterFilterSet,
  requestHspScriptSpeedSet,
  requestLedOverride,
  requestHvpSet,
  requestHvpStop,
  requestHvpStart,
  requestHvpStateGet,
  requestHrppStart,
  requestHrppStop,
  requestHrppAmplitudeSet,
  requestHrppPatternSet,
  requestHrppStateGet,
  requestHrppPatternsGet,
  requestHrppPlaybackRateSet,
  requestHrppPause,
  requestSettingsRegulatorGet,
  requestSettingsHallGet,
  requestSlideProfileGet,
  notSet
}

class Request extends $pb.GeneratedMessage {
  factory Request({
    $core.int? id,
    $1.RequestServerTimeGet? requestServerTimeGet,
    $1.RequestConnectedGet? requestConnectedGet,
    $1.RequestFwStatusGet? requestFwStatusGet,
    $1.RequestConnectionKeyGet? requestConnectionKeyGet,
    $1.RequestWifiStatusGet? requestWifiStatusGet,
    $1.RequestWifiSet? requestWifiSet,
    $1.RequestWifiScanStart? requestWifiScanStart,
    $1.RequestWifiScanResultsGet? requestWifiScanResultsGet,
    $1.RequestWifiScanStop? requestWifiScanStop,
    $1.RequestModeGet? requestModeGet,
    $1.RequestModeSet? requestModeSet,
    $1.RequestReboot? requestReboot,
    $1.RequestButtonPress? requestButtonPress,
    $1.RequestClockOffsetSet? requestClockOffsetSet,
    $1.RequestBatteryGet? requestBatteryGet,
    $1.RequestClockOffsetGet? requestClockOffsetGet,
    $1.RequestCapabilitiesGet? requestCapabilitiesGet,
    $1.RequestSessionIdsGet? requestSessionIdsGet,
    $1.RequestStopCurrentMode? requestStopCurrentMode,
    $1.RequestConnectionModeSet? requestConnectionModeSet,
    $1.RequestConnectionModeGet? requestConnectionModeGet,
    $1.RequestPublicInfoGet? requestPublicInfoGet,
    $1.RequestHampStart? requestHampStart,
    $1.RequestHampStop? requestHampStop,
    $1.RequestHampVelocitySet? requestHampVelocitySet,
    $1.RequestHampStateGet? requestHampStateGet,
    $1.RequestHampZoneSet? requestHampZoneSet,
    $1.RequestHdspXaVaSet? requestHdspXaVaSet,
    $1.RequestHdspXpVaSet? requestHdspXpVaSet,
    $1.RequestHdspXpVpSet? requestHdspXpVpSet,
    $1.RequestHdspXaTSet? requestHdspXaTSet,
    $1.RequestHdspXpTSet? requestHdspXpTSet,
    $1.RequestHdspXaVpSet? requestHdspXaVpSet,
    $1.RequestHdspStop? requestHdspStop,
    $1.RequestSensorNotificationSet? requestSensorNotificationSet,
    $1.RequestSensorStateGet? requestSensorStateGet,
    $1.RequestSensorNotificationGet? requestSensorNotificationGet,
    $1.RequestMemsStatusGet? requestMemsStatusGet,
    $1.RequestMemsRead? requestMemsRead,
    $1.RequestMemsTare? requestMemsTare,
    $1.RequestMemsTempGet? requestMemsTempGet,
    $1.RequestMemsReset? requestMemsReset,
    $1.RequestMemsRegister? requestMemsRegister,
    $1.RequestMemsConfigSet? requestMemsConfigSet,
    $1.RequestMemsTestStart? requestMemsTestStart,
    $1.RequestMemsTestResultGet? requestMemsTestResultGet,
    $1.RequestSliderStrokeGet? requestSliderStrokeGet,
    $1.RequestSliderStrokeSet? requestSliderStrokeSet,
    $1.RequestSliderStateGet? requestSliderStateGet,
    $1.RequestSliderCalibrate? requestSliderCalibrate,
    $1.RequestSlideDiagStart? requestSlideDiagStart,
    $1.RequestSlideDiagStatus? requestSlideDiagStatus,
    $1.RequestSlideDiagRead? requestSlideDiagRead,
    $1.RequestSlideDiagStop? requestSlideDiagStop,
    $1.RequestHallCalibrationGet? requestHallCalibrationGet,
    $1.RequestSlideDiagStream? requestSlideDiagStream,
    $1.RequestSpeedStatsGet? requestSpeedStatsGet,
    $1.RequestSpeedStatsSet? requestSpeedStatsSet,
    $1.RequestSlideSnapshotGet? requestSlideSnapshotGet,
    $1.RequestSlideProfileTuningGet? requestSlideProfileTuningGet,
    $1.RequestSlideMaintResultGet? requestSlideMaintResultGet,
    $1.RequestSliderEndMove? requestSliderEndMove,
    $1.RequestHspSetup? requestHspSetup,
    $1.RequestHspAdd? requestHspAdd,
    $1.RequestHspFlush? requestHspFlush,
    $1.RequestHspPlay? requestHspPlay,
    $1.RequestHspStop? requestHspStop,
    $1.RequestHspPause? requestHspPause,
    $1.RequestHspResume? requestHspResume,
    $1.RequestHspStateGet? requestHspStateGet,
    $1.RequestHspCurrentTimeSet? requestHspCurrentTimeSet,
    $1.RequestHspThresholdSet? requestHspThresholdSet,
    $1.RequestHspPauseOnStarvingSet? requestHspPauseOnStarvingSet,
    $1.RequestHspPlaybackRateSet? requestHspPlaybackRateSet,
    $1.RequestHspLoopSet? requestHspLoopSet,
    $1.RequestHspJitterFilterSet? requestHspJitterFilterSet,
    $1.RequestHspScriptSpeedSet? requestHspScriptSpeedSet,
    $1.RequestLedOverride? requestLedOverride,
    $1.RequestHvpSet? requestHvpSet,
    $1.RequestHvpStop? requestHvpStop,
    $1.RequestHvpStart? requestHvpStart,
    $1.RequestHvpStateGet? requestHvpStateGet,
    $1.RequestHrppStart? requestHrppStart,
    $1.RequestHrppStop? requestHrppStop,
    $1.RequestHrppAmplitudeSet? requestHrppAmplitudeSet,
    $1.RequestHrppPatternSet? requestHrppPatternSet,
    $1.RequestHrppStateGet? requestHrppStateGet,
    $1.RequestHrppPatternsGet? requestHrppPatternsGet,
    $1.RequestHrppPlaybackRateSet? requestHrppPlaybackRateSet,
    $1.RequestHrppPause? requestHrppPause,
    $1.RequestSettingsRegulatorGet? requestSettingsRegulatorGet,
    $1.RequestSettingsHallGet? requestSettingsHallGet,
    $1.RequestSlideProfileGet? requestSlideProfileGet,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (requestServerTimeGet != null)
      result.requestServerTimeGet = requestServerTimeGet;
    if (requestConnectedGet != null)
      result.requestConnectedGet = requestConnectedGet;
    if (requestFwStatusGet != null)
      result.requestFwStatusGet = requestFwStatusGet;
    if (requestConnectionKeyGet != null)
      result.requestConnectionKeyGet = requestConnectionKeyGet;
    if (requestWifiStatusGet != null)
      result.requestWifiStatusGet = requestWifiStatusGet;
    if (requestWifiSet != null) result.requestWifiSet = requestWifiSet;
    if (requestWifiScanStart != null)
      result.requestWifiScanStart = requestWifiScanStart;
    if (requestWifiScanResultsGet != null)
      result.requestWifiScanResultsGet = requestWifiScanResultsGet;
    if (requestWifiScanStop != null)
      result.requestWifiScanStop = requestWifiScanStop;
    if (requestModeGet != null) result.requestModeGet = requestModeGet;
    if (requestModeSet != null) result.requestModeSet = requestModeSet;
    if (requestReboot != null) result.requestReboot = requestReboot;
    if (requestButtonPress != null)
      result.requestButtonPress = requestButtonPress;
    if (requestClockOffsetSet != null)
      result.requestClockOffsetSet = requestClockOffsetSet;
    if (requestBatteryGet != null) result.requestBatteryGet = requestBatteryGet;
    if (requestClockOffsetGet != null)
      result.requestClockOffsetGet = requestClockOffsetGet;
    if (requestCapabilitiesGet != null)
      result.requestCapabilitiesGet = requestCapabilitiesGet;
    if (requestSessionIdsGet != null)
      result.requestSessionIdsGet = requestSessionIdsGet;
    if (requestStopCurrentMode != null)
      result.requestStopCurrentMode = requestStopCurrentMode;
    if (requestConnectionModeSet != null)
      result.requestConnectionModeSet = requestConnectionModeSet;
    if (requestConnectionModeGet != null)
      result.requestConnectionModeGet = requestConnectionModeGet;
    if (requestPublicInfoGet != null)
      result.requestPublicInfoGet = requestPublicInfoGet;
    if (requestHampStart != null) result.requestHampStart = requestHampStart;
    if (requestHampStop != null) result.requestHampStop = requestHampStop;
    if (requestHampVelocitySet != null)
      result.requestHampVelocitySet = requestHampVelocitySet;
    if (requestHampStateGet != null)
      result.requestHampStateGet = requestHampStateGet;
    if (requestHampZoneSet != null)
      result.requestHampZoneSet = requestHampZoneSet;
    if (requestHdspXaVaSet != null)
      result.requestHdspXaVaSet = requestHdspXaVaSet;
    if (requestHdspXpVaSet != null)
      result.requestHdspXpVaSet = requestHdspXpVaSet;
    if (requestHdspXpVpSet != null)
      result.requestHdspXpVpSet = requestHdspXpVpSet;
    if (requestHdspXaTSet != null) result.requestHdspXaTSet = requestHdspXaTSet;
    if (requestHdspXpTSet != null) result.requestHdspXpTSet = requestHdspXpTSet;
    if (requestHdspXaVpSet != null)
      result.requestHdspXaVpSet = requestHdspXaVpSet;
    if (requestHdspStop != null) result.requestHdspStop = requestHdspStop;
    if (requestSensorNotificationSet != null)
      result.requestSensorNotificationSet = requestSensorNotificationSet;
    if (requestSensorStateGet != null)
      result.requestSensorStateGet = requestSensorStateGet;
    if (requestSensorNotificationGet != null)
      result.requestSensorNotificationGet = requestSensorNotificationGet;
    if (requestMemsStatusGet != null)
      result.requestMemsStatusGet = requestMemsStatusGet;
    if (requestMemsRead != null) result.requestMemsRead = requestMemsRead;
    if (requestMemsTare != null) result.requestMemsTare = requestMemsTare;
    if (requestMemsTempGet != null)
      result.requestMemsTempGet = requestMemsTempGet;
    if (requestMemsReset != null) result.requestMemsReset = requestMemsReset;
    if (requestMemsRegister != null)
      result.requestMemsRegister = requestMemsRegister;
    if (requestMemsConfigSet != null)
      result.requestMemsConfigSet = requestMemsConfigSet;
    if (requestMemsTestStart != null)
      result.requestMemsTestStart = requestMemsTestStart;
    if (requestMemsTestResultGet != null)
      result.requestMemsTestResultGet = requestMemsTestResultGet;
    if (requestSliderStrokeGet != null)
      result.requestSliderStrokeGet = requestSliderStrokeGet;
    if (requestSliderStrokeSet != null)
      result.requestSliderStrokeSet = requestSliderStrokeSet;
    if (requestSliderStateGet != null)
      result.requestSliderStateGet = requestSliderStateGet;
    if (requestSliderCalibrate != null)
      result.requestSliderCalibrate = requestSliderCalibrate;
    if (requestSlideDiagStart != null)
      result.requestSlideDiagStart = requestSlideDiagStart;
    if (requestSlideDiagStatus != null)
      result.requestSlideDiagStatus = requestSlideDiagStatus;
    if (requestSlideDiagRead != null)
      result.requestSlideDiagRead = requestSlideDiagRead;
    if (requestSlideDiagStop != null)
      result.requestSlideDiagStop = requestSlideDiagStop;
    if (requestHallCalibrationGet != null)
      result.requestHallCalibrationGet = requestHallCalibrationGet;
    if (requestSlideDiagStream != null)
      result.requestSlideDiagStream = requestSlideDiagStream;
    if (requestSpeedStatsGet != null)
      result.requestSpeedStatsGet = requestSpeedStatsGet;
    if (requestSpeedStatsSet != null)
      result.requestSpeedStatsSet = requestSpeedStatsSet;
    if (requestSlideSnapshotGet != null)
      result.requestSlideSnapshotGet = requestSlideSnapshotGet;
    if (requestSlideProfileTuningGet != null)
      result.requestSlideProfileTuningGet = requestSlideProfileTuningGet;
    if (requestSlideMaintResultGet != null)
      result.requestSlideMaintResultGet = requestSlideMaintResultGet;
    if (requestSliderEndMove != null)
      result.requestSliderEndMove = requestSliderEndMove;
    if (requestHspSetup != null) result.requestHspSetup = requestHspSetup;
    if (requestHspAdd != null) result.requestHspAdd = requestHspAdd;
    if (requestHspFlush != null) result.requestHspFlush = requestHspFlush;
    if (requestHspPlay != null) result.requestHspPlay = requestHspPlay;
    if (requestHspStop != null) result.requestHspStop = requestHspStop;
    if (requestHspPause != null) result.requestHspPause = requestHspPause;
    if (requestHspResume != null) result.requestHspResume = requestHspResume;
    if (requestHspStateGet != null)
      result.requestHspStateGet = requestHspStateGet;
    if (requestHspCurrentTimeSet != null)
      result.requestHspCurrentTimeSet = requestHspCurrentTimeSet;
    if (requestHspThresholdSet != null)
      result.requestHspThresholdSet = requestHspThresholdSet;
    if (requestHspPauseOnStarvingSet != null)
      result.requestHspPauseOnStarvingSet = requestHspPauseOnStarvingSet;
    if (requestHspPlaybackRateSet != null)
      result.requestHspPlaybackRateSet = requestHspPlaybackRateSet;
    if (requestHspLoopSet != null) result.requestHspLoopSet = requestHspLoopSet;
    if (requestHspJitterFilterSet != null)
      result.requestHspJitterFilterSet = requestHspJitterFilterSet;
    if (requestHspScriptSpeedSet != null)
      result.requestHspScriptSpeedSet = requestHspScriptSpeedSet;
    if (requestLedOverride != null)
      result.requestLedOverride = requestLedOverride;
    if (requestHvpSet != null) result.requestHvpSet = requestHvpSet;
    if (requestHvpStop != null) result.requestHvpStop = requestHvpStop;
    if (requestHvpStart != null) result.requestHvpStart = requestHvpStart;
    if (requestHvpStateGet != null)
      result.requestHvpStateGet = requestHvpStateGet;
    if (requestHrppStart != null) result.requestHrppStart = requestHrppStart;
    if (requestHrppStop != null) result.requestHrppStop = requestHrppStop;
    if (requestHrppAmplitudeSet != null)
      result.requestHrppAmplitudeSet = requestHrppAmplitudeSet;
    if (requestHrppPatternSet != null)
      result.requestHrppPatternSet = requestHrppPatternSet;
    if (requestHrppStateGet != null)
      result.requestHrppStateGet = requestHrppStateGet;
    if (requestHrppPatternsGet != null)
      result.requestHrppPatternsGet = requestHrppPatternsGet;
    if (requestHrppPlaybackRateSet != null)
      result.requestHrppPlaybackRateSet = requestHrppPlaybackRateSet;
    if (requestHrppPause != null) result.requestHrppPause = requestHrppPause;
    if (requestSettingsRegulatorGet != null)
      result.requestSettingsRegulatorGet = requestSettingsRegulatorGet;
    if (requestSettingsHallGet != null)
      result.requestSettingsHallGet = requestSettingsHallGet;
    if (requestSlideProfileGet != null)
      result.requestSlideProfileGet = requestSlideProfileGet;
    return result;
  }

  Request._();

  factory Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Request.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Request_Params> _Request_ParamsByTag = {
    300: Request_Params.requestServerTimeGet,
    301: Request_Params.requestConnectedGet,
    304: Request_Params.requestFwStatusGet,
    606: Request_Params.requestConnectionKeyGet,
    620: Request_Params.requestWifiStatusGet,
    621: Request_Params.requestWifiSet,
    623: Request_Params.requestWifiScanStart,
    624: Request_Params.requestWifiScanResultsGet,
    625: Request_Params.requestWifiScanStop,
    700: Request_Params.requestModeGet,
    701: Request_Params.requestModeSet,
    707: Request_Params.requestReboot,
    708: Request_Params.requestButtonPress,
    709: Request_Params.requestClockOffsetSet,
    710: Request_Params.requestBatteryGet,
    712: Request_Params.requestClockOffsetGet,
    713: Request_Params.requestCapabilitiesGet,
    714: Request_Params.requestSessionIdsGet,
    715: Request_Params.requestStopCurrentMode,
    716: Request_Params.requestConnectionModeSet,
    717: Request_Params.requestConnectionModeGet,
    718: Request_Params.requestPublicInfoGet,
    720: Request_Params.requestHampStart,
    721: Request_Params.requestHampStop,
    723: Request_Params.requestHampVelocitySet,
    724: Request_Params.requestHampStateGet,
    725: Request_Params.requestHampZoneSet,
    740: Request_Params.requestHdspXaVaSet,
    741: Request_Params.requestHdspXpVaSet,
    742: Request_Params.requestHdspXpVpSet,
    743: Request_Params.requestHdspXaTSet,
    744: Request_Params.requestHdspXpTSet,
    745: Request_Params.requestHdspXaVpSet,
    746: Request_Params.requestHdspStop,
    800: Request_Params.requestSensorNotificationSet,
    801: Request_Params.requestSensorStateGet,
    802: Request_Params.requestSensorNotificationGet,
    810: Request_Params.requestMemsStatusGet,
    811: Request_Params.requestMemsRead,
    812: Request_Params.requestMemsTare,
    813: Request_Params.requestMemsTempGet,
    814: Request_Params.requestMemsReset,
    815: Request_Params.requestMemsRegister,
    816: Request_Params.requestMemsConfigSet,
    817: Request_Params.requestMemsTestStart,
    818: Request_Params.requestMemsTestResultGet,
    840: Request_Params.requestSliderStrokeGet,
    841: Request_Params.requestSliderStrokeSet,
    842: Request_Params.requestSliderStateGet,
    843: Request_Params.requestSliderCalibrate,
    844: Request_Params.requestSlideDiagStart,
    845: Request_Params.requestSlideDiagStatus,
    846: Request_Params.requestSlideDiagRead,
    847: Request_Params.requestSlideDiagStop,
    848: Request_Params.requestHallCalibrationGet,
    850: Request_Params.requestSlideDiagStream,
    851: Request_Params.requestSpeedStatsGet,
    852: Request_Params.requestSpeedStatsSet,
    853: Request_Params.requestSlideSnapshotGet,
    855: Request_Params.requestSlideProfileTuningGet,
    856: Request_Params.requestSlideMaintResultGet,
    857: Request_Params.requestSliderEndMove,
    860: Request_Params.requestHspSetup,
    861: Request_Params.requestHspAdd,
    862: Request_Params.requestHspFlush,
    863: Request_Params.requestHspPlay,
    864: Request_Params.requestHspStop,
    865: Request_Params.requestHspPause,
    866: Request_Params.requestHspResume,
    867: Request_Params.requestHspStateGet,
    868: Request_Params.requestHspCurrentTimeSet,
    869: Request_Params.requestHspThresholdSet,
    870: Request_Params.requestHspPauseOnStarvingSet,
    871: Request_Params.requestHspPlaybackRateSet,
    872: Request_Params.requestHspLoopSet,
    873: Request_Params.requestHspJitterFilterSet,
    874: Request_Params.requestHspScriptSpeedSet,
    880: Request_Params.requestLedOverride,
    900: Request_Params.requestHvpSet,
    901: Request_Params.requestHvpStop,
    902: Request_Params.requestHvpStart,
    903: Request_Params.requestHvpStateGet,
    920: Request_Params.requestHrppStart,
    921: Request_Params.requestHrppStop,
    922: Request_Params.requestHrppAmplitudeSet,
    924: Request_Params.requestHrppPatternSet,
    925: Request_Params.requestHrppStateGet,
    926: Request_Params.requestHrppPatternsGet,
    927: Request_Params.requestHrppPlaybackRateSet,
    928: Request_Params.requestHrppPause,
    2015: Request_Params.requestSettingsRegulatorGet,
    2017: Request_Params.requestSettingsHallGet,
    2019: Request_Params.requestSlideProfileGet,
    0: Request_Params.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..oo(0, [
      300,
      301,
      304,
      606,
      620,
      621,
      623,
      624,
      625,
      700,
      701,
      707,
      708,
      709,
      710,
      712,
      713,
      714,
      715,
      716,
      717,
      718,
      720,
      721,
      723,
      724,
      725,
      740,
      741,
      742,
      743,
      744,
      745,
      746,
      800,
      801,
      802,
      810,
      811,
      812,
      813,
      814,
      815,
      816,
      817,
      818,
      840,
      841,
      842,
      843,
      844,
      845,
      846,
      847,
      848,
      850,
      851,
      852,
      853,
      855,
      856,
      857,
      860,
      861,
      862,
      863,
      864,
      865,
      866,
      867,
      868,
      869,
      870,
      871,
      872,
      873,
      874,
      880,
      900,
      901,
      902,
      903,
      920,
      921,
      922,
      924,
      925,
      926,
      927,
      928,
      2015,
      2017,
      2019
    ])
    ..aI(2, _omitFieldNames ? '' : 'id', fieldType: $pb.PbFieldType.OU3)
    ..aOM<$1.RequestServerTimeGet>(
        300, _omitFieldNames ? '' : 'requestServerTimeGet',
        subBuilder: $1.RequestServerTimeGet.create)
    ..aOM<$1.RequestConnectedGet>(
        301, _omitFieldNames ? '' : 'requestConnectedGet',
        subBuilder: $1.RequestConnectedGet.create)
    ..aOM<$1.RequestFwStatusGet>(
        304, _omitFieldNames ? '' : 'requestFwStatusGet',
        subBuilder: $1.RequestFwStatusGet.create)
    ..aOM<$1.RequestConnectionKeyGet>(
        606, _omitFieldNames ? '' : 'requestConnectionKeyGet',
        subBuilder: $1.RequestConnectionKeyGet.create)
    ..aOM<$1.RequestWifiStatusGet>(
        620, _omitFieldNames ? '' : 'requestWifiStatusGet',
        subBuilder: $1.RequestWifiStatusGet.create)
    ..aOM<$1.RequestWifiSet>(621, _omitFieldNames ? '' : 'requestWifiSet',
        subBuilder: $1.RequestWifiSet.create)
    ..aOM<$1.RequestWifiScanStart>(
        623, _omitFieldNames ? '' : 'requestWifiScanStart',
        subBuilder: $1.RequestWifiScanStart.create)
    ..aOM<$1.RequestWifiScanResultsGet>(
        624, _omitFieldNames ? '' : 'requestWifiScanResultsGet',
        subBuilder: $1.RequestWifiScanResultsGet.create)
    ..aOM<$1.RequestWifiScanStop>(
        625, _omitFieldNames ? '' : 'requestWifiScanStop',
        subBuilder: $1.RequestWifiScanStop.create)
    ..aOM<$1.RequestModeGet>(700, _omitFieldNames ? '' : 'requestModeGet',
        subBuilder: $1.RequestModeGet.create)
    ..aOM<$1.RequestModeSet>(701, _omitFieldNames ? '' : 'requestModeSet',
        subBuilder: $1.RequestModeSet.create)
    ..aOM<$1.RequestReboot>(707, _omitFieldNames ? '' : 'requestReboot',
        subBuilder: $1.RequestReboot.create)
    ..aOM<$1.RequestButtonPress>(
        708, _omitFieldNames ? '' : 'requestButtonPress',
        subBuilder: $1.RequestButtonPress.create)
    ..aOM<$1.RequestClockOffsetSet>(
        709, _omitFieldNames ? '' : 'requestClockOffsetSet',
        subBuilder: $1.RequestClockOffsetSet.create)
    ..aOM<$1.RequestBatteryGet>(710, _omitFieldNames ? '' : 'requestBatteryGet',
        subBuilder: $1.RequestBatteryGet.create)
    ..aOM<$1.RequestClockOffsetGet>(
        712, _omitFieldNames ? '' : 'requestClockOffsetGet',
        subBuilder: $1.RequestClockOffsetGet.create)
    ..aOM<$1.RequestCapabilitiesGet>(
        713, _omitFieldNames ? '' : 'requestCapabilitiesGet',
        subBuilder: $1.RequestCapabilitiesGet.create)
    ..aOM<$1.RequestSessionIdsGet>(
        714, _omitFieldNames ? '' : 'requestSessionIdsGet',
        subBuilder: $1.RequestSessionIdsGet.create)
    ..aOM<$1.RequestStopCurrentMode>(
        715, _omitFieldNames ? '' : 'requestStopCurrentMode',
        subBuilder: $1.RequestStopCurrentMode.create)
    ..aOM<$1.RequestConnectionModeSet>(
        716, _omitFieldNames ? '' : 'requestConnectionModeSet',
        subBuilder: $1.RequestConnectionModeSet.create)
    ..aOM<$1.RequestConnectionModeGet>(
        717, _omitFieldNames ? '' : 'requestConnectionModeGet',
        subBuilder: $1.RequestConnectionModeGet.create)
    ..aOM<$1.RequestPublicInfoGet>(
        718, _omitFieldNames ? '' : 'requestPublicInfoGet',
        subBuilder: $1.RequestPublicInfoGet.create)
    ..aOM<$1.RequestHampStart>(720, _omitFieldNames ? '' : 'requestHampStart',
        subBuilder: $1.RequestHampStart.create)
    ..aOM<$1.RequestHampStop>(721, _omitFieldNames ? '' : 'requestHampStop',
        subBuilder: $1.RequestHampStop.create)
    ..aOM<$1.RequestHampVelocitySet>(
        723, _omitFieldNames ? '' : 'requestHampVelocitySet',
        subBuilder: $1.RequestHampVelocitySet.create)
    ..aOM<$1.RequestHampStateGet>(
        724, _omitFieldNames ? '' : 'requestHampStateGet',
        subBuilder: $1.RequestHampStateGet.create)
    ..aOM<$1.RequestHampZoneSet>(
        725, _omitFieldNames ? '' : 'requestHampZoneSet',
        subBuilder: $1.RequestHampZoneSet.create)
    ..aOM<$1.RequestHdspXaVaSet>(
        740, _omitFieldNames ? '' : 'requestHdspXaVaSet',
        subBuilder: $1.RequestHdspXaVaSet.create)
    ..aOM<$1.RequestHdspXpVaSet>(
        741, _omitFieldNames ? '' : 'requestHdspXpVaSet',
        subBuilder: $1.RequestHdspXpVaSet.create)
    ..aOM<$1.RequestHdspXpVpSet>(
        742, _omitFieldNames ? '' : 'requestHdspXpVpSet',
        subBuilder: $1.RequestHdspXpVpSet.create)
    ..aOM<$1.RequestHdspXaTSet>(743, _omitFieldNames ? '' : 'requestHdspXaTSet',
        subBuilder: $1.RequestHdspXaTSet.create)
    ..aOM<$1.RequestHdspXpTSet>(744, _omitFieldNames ? '' : 'requestHdspXpTSet',
        subBuilder: $1.RequestHdspXpTSet.create)
    ..aOM<$1.RequestHdspXaVpSet>(
        745, _omitFieldNames ? '' : 'requestHdspXaVpSet',
        subBuilder: $1.RequestHdspXaVpSet.create)
    ..aOM<$1.RequestHdspStop>(746, _omitFieldNames ? '' : 'requestHdspStop',
        subBuilder: $1.RequestHdspStop.create)
    ..aOM<$1.RequestSensorNotificationSet>(
        800, _omitFieldNames ? '' : 'requestSensorNotificationSet',
        subBuilder: $1.RequestSensorNotificationSet.create)
    ..aOM<$1.RequestSensorStateGet>(
        801, _omitFieldNames ? '' : 'requestSensorStateGet',
        subBuilder: $1.RequestSensorStateGet.create)
    ..aOM<$1.RequestSensorNotificationGet>(
        802, _omitFieldNames ? '' : 'requestSensorNotificationGet',
        subBuilder: $1.RequestSensorNotificationGet.create)
    ..aOM<$1.RequestMemsStatusGet>(
        810, _omitFieldNames ? '' : 'requestMemsStatusGet',
        subBuilder: $1.RequestMemsStatusGet.create)
    ..aOM<$1.RequestMemsRead>(811, _omitFieldNames ? '' : 'requestMemsRead',
        subBuilder: $1.RequestMemsRead.create)
    ..aOM<$1.RequestMemsTare>(812, _omitFieldNames ? '' : 'requestMemsTare',
        subBuilder: $1.RequestMemsTare.create)
    ..aOM<$1.RequestMemsTempGet>(
        813, _omitFieldNames ? '' : 'requestMemsTempGet',
        subBuilder: $1.RequestMemsTempGet.create)
    ..aOM<$1.RequestMemsReset>(814, _omitFieldNames ? '' : 'requestMemsReset',
        subBuilder: $1.RequestMemsReset.create)
    ..aOM<$1.RequestMemsRegister>(
        815, _omitFieldNames ? '' : 'requestMemsRegister',
        subBuilder: $1.RequestMemsRegister.create)
    ..aOM<$1.RequestMemsConfigSet>(
        816, _omitFieldNames ? '' : 'requestMemsConfigSet',
        subBuilder: $1.RequestMemsConfigSet.create)
    ..aOM<$1.RequestMemsTestStart>(
        817, _omitFieldNames ? '' : 'requestMemsTestStart',
        subBuilder: $1.RequestMemsTestStart.create)
    ..aOM<$1.RequestMemsTestResultGet>(
        818, _omitFieldNames ? '' : 'requestMemsTestResultGet',
        subBuilder: $1.RequestMemsTestResultGet.create)
    ..aOM<$1.RequestSliderStrokeGet>(
        840, _omitFieldNames ? '' : 'requestSliderStrokeGet',
        subBuilder: $1.RequestSliderStrokeGet.create)
    ..aOM<$1.RequestSliderStrokeSet>(
        841, _omitFieldNames ? '' : 'requestSliderStrokeSet',
        subBuilder: $1.RequestSliderStrokeSet.create)
    ..aOM<$1.RequestSliderStateGet>(
        842, _omitFieldNames ? '' : 'requestSliderStateGet',
        subBuilder: $1.RequestSliderStateGet.create)
    ..aOM<$1.RequestSliderCalibrate>(
        843, _omitFieldNames ? '' : 'requestSliderCalibrate',
        subBuilder: $1.RequestSliderCalibrate.create)
    ..aOM<$1.RequestSlideDiagStart>(
        844, _omitFieldNames ? '' : 'requestSlideDiagStart',
        subBuilder: $1.RequestSlideDiagStart.create)
    ..aOM<$1.RequestSlideDiagStatus>(
        845, _omitFieldNames ? '' : 'requestSlideDiagStatus',
        subBuilder: $1.RequestSlideDiagStatus.create)
    ..aOM<$1.RequestSlideDiagRead>(
        846, _omitFieldNames ? '' : 'requestSlideDiagRead',
        subBuilder: $1.RequestSlideDiagRead.create)
    ..aOM<$1.RequestSlideDiagStop>(
        847, _omitFieldNames ? '' : 'requestSlideDiagStop',
        subBuilder: $1.RequestSlideDiagStop.create)
    ..aOM<$1.RequestHallCalibrationGet>(
        848, _omitFieldNames ? '' : 'requestHallCalibrationGet',
        subBuilder: $1.RequestHallCalibrationGet.create)
    ..aOM<$1.RequestSlideDiagStream>(
        850, _omitFieldNames ? '' : 'requestSlideDiagStream',
        subBuilder: $1.RequestSlideDiagStream.create)
    ..aOM<$1.RequestSpeedStatsGet>(
        851, _omitFieldNames ? '' : 'requestSpeedStatsGet',
        subBuilder: $1.RequestSpeedStatsGet.create)
    ..aOM<$1.RequestSpeedStatsSet>(
        852, _omitFieldNames ? '' : 'requestSpeedStatsSet',
        subBuilder: $1.RequestSpeedStatsSet.create)
    ..aOM<$1.RequestSlideSnapshotGet>(
        853, _omitFieldNames ? '' : 'requestSlideSnapshotGet',
        subBuilder: $1.RequestSlideSnapshotGet.create)
    ..aOM<$1.RequestSlideProfileTuningGet>(
        855, _omitFieldNames ? '' : 'requestSlideProfileTuningGet',
        subBuilder: $1.RequestSlideProfileTuningGet.create)
    ..aOM<$1.RequestSlideMaintResultGet>(
        856, _omitFieldNames ? '' : 'requestSlideMaintResultGet',
        subBuilder: $1.RequestSlideMaintResultGet.create)
    ..aOM<$1.RequestSliderEndMove>(
        857, _omitFieldNames ? '' : 'requestSliderEndMove',
        subBuilder: $1.RequestSliderEndMove.create)
    ..aOM<$1.RequestHspSetup>(860, _omitFieldNames ? '' : 'requestHspSetup',
        subBuilder: $1.RequestHspSetup.create)
    ..aOM<$1.RequestHspAdd>(861, _omitFieldNames ? '' : 'requestHspAdd',
        subBuilder: $1.RequestHspAdd.create)
    ..aOM<$1.RequestHspFlush>(862, _omitFieldNames ? '' : 'requestHspFlush',
        subBuilder: $1.RequestHspFlush.create)
    ..aOM<$1.RequestHspPlay>(863, _omitFieldNames ? '' : 'requestHspPlay',
        subBuilder: $1.RequestHspPlay.create)
    ..aOM<$1.RequestHspStop>(864, _omitFieldNames ? '' : 'requestHspStop',
        subBuilder: $1.RequestHspStop.create)
    ..aOM<$1.RequestHspPause>(865, _omitFieldNames ? '' : 'requestHspPause',
        subBuilder: $1.RequestHspPause.create)
    ..aOM<$1.RequestHspResume>(866, _omitFieldNames ? '' : 'requestHspResume',
        subBuilder: $1.RequestHspResume.create)
    ..aOM<$1.RequestHspStateGet>(
        867, _omitFieldNames ? '' : 'requestHspStateGet',
        subBuilder: $1.RequestHspStateGet.create)
    ..aOM<$1.RequestHspCurrentTimeSet>(
        868, _omitFieldNames ? '' : 'requestHspCurrentTimeSet',
        subBuilder: $1.RequestHspCurrentTimeSet.create)
    ..aOM<$1.RequestHspThresholdSet>(
        869, _omitFieldNames ? '' : 'requestHspThresholdSet',
        subBuilder: $1.RequestHspThresholdSet.create)
    ..aOM<$1.RequestHspPauseOnStarvingSet>(
        870, _omitFieldNames ? '' : 'requestHspPauseOnStarvingSet',
        subBuilder: $1.RequestHspPauseOnStarvingSet.create)
    ..aOM<$1.RequestHspPlaybackRateSet>(
        871, _omitFieldNames ? '' : 'requestHspPlaybackRateSet',
        subBuilder: $1.RequestHspPlaybackRateSet.create)
    ..aOM<$1.RequestHspLoopSet>(872, _omitFieldNames ? '' : 'requestHspLoopSet',
        subBuilder: $1.RequestHspLoopSet.create)
    ..aOM<$1.RequestHspJitterFilterSet>(
        873, _omitFieldNames ? '' : 'requestHspJitterFilterSet',
        subBuilder: $1.RequestHspJitterFilterSet.create)
    ..aOM<$1.RequestHspScriptSpeedSet>(
        874, _omitFieldNames ? '' : 'requestHspScriptSpeedSet',
        subBuilder: $1.RequestHspScriptSpeedSet.create)
    ..aOM<$1.RequestLedOverride>(
        880, _omitFieldNames ? '' : 'requestLedOverride',
        subBuilder: $1.RequestLedOverride.create)
    ..aOM<$1.RequestHvpSet>(900, _omitFieldNames ? '' : 'requestHvpSet',
        subBuilder: $1.RequestHvpSet.create)
    ..aOM<$1.RequestHvpStop>(901, _omitFieldNames ? '' : 'requestHvpStop',
        subBuilder: $1.RequestHvpStop.create)
    ..aOM<$1.RequestHvpStart>(902, _omitFieldNames ? '' : 'requestHvpStart',
        subBuilder: $1.RequestHvpStart.create)
    ..aOM<$1.RequestHvpStateGet>(
        903, _omitFieldNames ? '' : 'requestHvpStateGet',
        subBuilder: $1.RequestHvpStateGet.create)
    ..aOM<$1.RequestHrppStart>(920, _omitFieldNames ? '' : 'requestHrppStart',
        subBuilder: $1.RequestHrppStart.create)
    ..aOM<$1.RequestHrppStop>(921, _omitFieldNames ? '' : 'requestHrppStop',
        subBuilder: $1.RequestHrppStop.create)
    ..aOM<$1.RequestHrppAmplitudeSet>(
        922, _omitFieldNames ? '' : 'requestHrppAmplitudeSet',
        subBuilder: $1.RequestHrppAmplitudeSet.create)
    ..aOM<$1.RequestHrppPatternSet>(
        924, _omitFieldNames ? '' : 'requestHrppPatternSet',
        subBuilder: $1.RequestHrppPatternSet.create)
    ..aOM<$1.RequestHrppStateGet>(
        925, _omitFieldNames ? '' : 'requestHrppStateGet',
        subBuilder: $1.RequestHrppStateGet.create)
    ..aOM<$1.RequestHrppPatternsGet>(
        926, _omitFieldNames ? '' : 'requestHrppPatternsGet',
        subBuilder: $1.RequestHrppPatternsGet.create)
    ..aOM<$1.RequestHrppPlaybackRateSet>(
        927, _omitFieldNames ? '' : 'requestHrppPlaybackRateSet',
        subBuilder: $1.RequestHrppPlaybackRateSet.create)
    ..aOM<$1.RequestHrppPause>(928, _omitFieldNames ? '' : 'requestHrppPause',
        subBuilder: $1.RequestHrppPause.create)
    ..aOM<$1.RequestSettingsRegulatorGet>(
        2015, _omitFieldNames ? '' : 'requestSettingsRegulatorGet',
        subBuilder: $1.RequestSettingsRegulatorGet.create)
    ..aOM<$1.RequestSettingsHallGet>(
        2017, _omitFieldNames ? '' : 'requestSettingsHallGet',
        subBuilder: $1.RequestSettingsHallGet.create)
    ..aOM<$1.RequestSlideProfileGet>(
        2019, _omitFieldNames ? '' : 'requestSlideProfileGet',
        subBuilder: $1.RequestSlideProfileGet.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Request copyWith(void Function(Request) updates) =>
      super.copyWith((message) => updates(message as Request)) as Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Request create() => Request._();
  @$core.override
  Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Request>(create);
  static Request? _defaultInstance;

  @$pb.TagNumber(300)
  @$pb.TagNumber(301)
  @$pb.TagNumber(304)
  @$pb.TagNumber(606)
  @$pb.TagNumber(620)
  @$pb.TagNumber(621)
  @$pb.TagNumber(623)
  @$pb.TagNumber(624)
  @$pb.TagNumber(625)
  @$pb.TagNumber(700)
  @$pb.TagNumber(701)
  @$pb.TagNumber(707)
  @$pb.TagNumber(708)
  @$pb.TagNumber(709)
  @$pb.TagNumber(710)
  @$pb.TagNumber(712)
  @$pb.TagNumber(713)
  @$pb.TagNumber(714)
  @$pb.TagNumber(715)
  @$pb.TagNumber(716)
  @$pb.TagNumber(717)
  @$pb.TagNumber(718)
  @$pb.TagNumber(720)
  @$pb.TagNumber(721)
  @$pb.TagNumber(723)
  @$pb.TagNumber(724)
  @$pb.TagNumber(725)
  @$pb.TagNumber(740)
  @$pb.TagNumber(741)
  @$pb.TagNumber(742)
  @$pb.TagNumber(743)
  @$pb.TagNumber(744)
  @$pb.TagNumber(745)
  @$pb.TagNumber(746)
  @$pb.TagNumber(800)
  @$pb.TagNumber(801)
  @$pb.TagNumber(802)
  @$pb.TagNumber(810)
  @$pb.TagNumber(811)
  @$pb.TagNumber(812)
  @$pb.TagNumber(813)
  @$pb.TagNumber(814)
  @$pb.TagNumber(815)
  @$pb.TagNumber(816)
  @$pb.TagNumber(817)
  @$pb.TagNumber(818)
  @$pb.TagNumber(840)
  @$pb.TagNumber(841)
  @$pb.TagNumber(842)
  @$pb.TagNumber(843)
  @$pb.TagNumber(844)
  @$pb.TagNumber(845)
  @$pb.TagNumber(846)
  @$pb.TagNumber(847)
  @$pb.TagNumber(848)
  @$pb.TagNumber(850)
  @$pb.TagNumber(851)
  @$pb.TagNumber(852)
  @$pb.TagNumber(853)
  @$pb.TagNumber(855)
  @$pb.TagNumber(856)
  @$pb.TagNumber(857)
  @$pb.TagNumber(860)
  @$pb.TagNumber(861)
  @$pb.TagNumber(862)
  @$pb.TagNumber(863)
  @$pb.TagNumber(864)
  @$pb.TagNumber(865)
  @$pb.TagNumber(866)
  @$pb.TagNumber(867)
  @$pb.TagNumber(868)
  @$pb.TagNumber(869)
  @$pb.TagNumber(870)
  @$pb.TagNumber(871)
  @$pb.TagNumber(872)
  @$pb.TagNumber(873)
  @$pb.TagNumber(874)
  @$pb.TagNumber(880)
  @$pb.TagNumber(900)
  @$pb.TagNumber(901)
  @$pb.TagNumber(902)
  @$pb.TagNumber(903)
  @$pb.TagNumber(920)
  @$pb.TagNumber(921)
  @$pb.TagNumber(922)
  @$pb.TagNumber(924)
  @$pb.TagNumber(925)
  @$pb.TagNumber(926)
  @$pb.TagNumber(927)
  @$pb.TagNumber(928)
  @$pb.TagNumber(2015)
  @$pb.TagNumber(2017)
  @$pb.TagNumber(2019)
  Request_Params whichParams() => _Request_ParamsByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(300)
  @$pb.TagNumber(301)
  @$pb.TagNumber(304)
  @$pb.TagNumber(606)
  @$pb.TagNumber(620)
  @$pb.TagNumber(621)
  @$pb.TagNumber(623)
  @$pb.TagNumber(624)
  @$pb.TagNumber(625)
  @$pb.TagNumber(700)
  @$pb.TagNumber(701)
  @$pb.TagNumber(707)
  @$pb.TagNumber(708)
  @$pb.TagNumber(709)
  @$pb.TagNumber(710)
  @$pb.TagNumber(712)
  @$pb.TagNumber(713)
  @$pb.TagNumber(714)
  @$pb.TagNumber(715)
  @$pb.TagNumber(716)
  @$pb.TagNumber(717)
  @$pb.TagNumber(718)
  @$pb.TagNumber(720)
  @$pb.TagNumber(721)
  @$pb.TagNumber(723)
  @$pb.TagNumber(724)
  @$pb.TagNumber(725)
  @$pb.TagNumber(740)
  @$pb.TagNumber(741)
  @$pb.TagNumber(742)
  @$pb.TagNumber(743)
  @$pb.TagNumber(744)
  @$pb.TagNumber(745)
  @$pb.TagNumber(746)
  @$pb.TagNumber(800)
  @$pb.TagNumber(801)
  @$pb.TagNumber(802)
  @$pb.TagNumber(810)
  @$pb.TagNumber(811)
  @$pb.TagNumber(812)
  @$pb.TagNumber(813)
  @$pb.TagNumber(814)
  @$pb.TagNumber(815)
  @$pb.TagNumber(816)
  @$pb.TagNumber(817)
  @$pb.TagNumber(818)
  @$pb.TagNumber(840)
  @$pb.TagNumber(841)
  @$pb.TagNumber(842)
  @$pb.TagNumber(843)
  @$pb.TagNumber(844)
  @$pb.TagNumber(845)
  @$pb.TagNumber(846)
  @$pb.TagNumber(847)
  @$pb.TagNumber(848)
  @$pb.TagNumber(850)
  @$pb.TagNumber(851)
  @$pb.TagNumber(852)
  @$pb.TagNumber(853)
  @$pb.TagNumber(855)
  @$pb.TagNumber(856)
  @$pb.TagNumber(857)
  @$pb.TagNumber(860)
  @$pb.TagNumber(861)
  @$pb.TagNumber(862)
  @$pb.TagNumber(863)
  @$pb.TagNumber(864)
  @$pb.TagNumber(865)
  @$pb.TagNumber(866)
  @$pb.TagNumber(867)
  @$pb.TagNumber(868)
  @$pb.TagNumber(869)
  @$pb.TagNumber(870)
  @$pb.TagNumber(871)
  @$pb.TagNumber(872)
  @$pb.TagNumber(873)
  @$pb.TagNumber(874)
  @$pb.TagNumber(880)
  @$pb.TagNumber(900)
  @$pb.TagNumber(901)
  @$pb.TagNumber(902)
  @$pb.TagNumber(903)
  @$pb.TagNumber(920)
  @$pb.TagNumber(921)
  @$pb.TagNumber(922)
  @$pb.TagNumber(924)
  @$pb.TagNumber(925)
  @$pb.TagNumber(926)
  @$pb.TagNumber(927)
  @$pb.TagNumber(928)
  @$pb.TagNumber(2015)
  @$pb.TagNumber(2017)
  @$pb.TagNumber(2019)
  void clearParams() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(2)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(2)
  set id($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);

  /// Server methods that are public starts with 300
  @$pb.TagNumber(300)
  $1.RequestServerTimeGet get requestServerTimeGet => $_getN(1);
  @$pb.TagNumber(300)
  set requestServerTimeGet($1.RequestServerTimeGet value) =>
      $_setField(300, value);
  @$pb.TagNumber(300)
  $core.bool hasRequestServerTimeGet() => $_has(1);
  @$pb.TagNumber(300)
  void clearRequestServerTimeGet() => $_clearField(300);
  @$pb.TagNumber(300)
  $1.RequestServerTimeGet ensureRequestServerTimeGet() => $_ensure(1);

  @$pb.TagNumber(301)
  $1.RequestConnectedGet get requestConnectedGet => $_getN(2);
  @$pb.TagNumber(301)
  set requestConnectedGet($1.RequestConnectedGet value) =>
      $_setField(301, value);
  @$pb.TagNumber(301)
  $core.bool hasRequestConnectedGet() => $_has(2);
  @$pb.TagNumber(301)
  void clearRequestConnectedGet() => $_clearField(301);
  @$pb.TagNumber(301)
  $1.RequestConnectedGet ensureRequestConnectedGet() => $_ensure(2);

  @$pb.TagNumber(304)
  $1.RequestFwStatusGet get requestFwStatusGet => $_getN(3);
  @$pb.TagNumber(304)
  set requestFwStatusGet($1.RequestFwStatusGet value) => $_setField(304, value);
  @$pb.TagNumber(304)
  $core.bool hasRequestFwStatusGet() => $_has(3);
  @$pb.TagNumber(304)
  void clearRequestFwStatusGet() => $_clearField(304);
  @$pb.TagNumber(304)
  $1.RequestFwStatusGet ensureRequestFwStatusGet() => $_ensure(3);

  @$pb.TagNumber(606)
  $1.RequestConnectionKeyGet get requestConnectionKeyGet => $_getN(4);
  @$pb.TagNumber(606)
  set requestConnectionKeyGet($1.RequestConnectionKeyGet value) =>
      $_setField(606, value);
  @$pb.TagNumber(606)
  $core.bool hasRequestConnectionKeyGet() => $_has(4);
  @$pb.TagNumber(606)
  void clearRequestConnectionKeyGet() => $_clearField(606);
  @$pb.TagNumber(606)
  $1.RequestConnectionKeyGet ensureRequestConnectionKeyGet() => $_ensure(4);

  @$pb.TagNumber(620)
  $1.RequestWifiStatusGet get requestWifiStatusGet => $_getN(5);
  @$pb.TagNumber(620)
  set requestWifiStatusGet($1.RequestWifiStatusGet value) =>
      $_setField(620, value);
  @$pb.TagNumber(620)
  $core.bool hasRequestWifiStatusGet() => $_has(5);
  @$pb.TagNumber(620)
  void clearRequestWifiStatusGet() => $_clearField(620);
  @$pb.TagNumber(620)
  $1.RequestWifiStatusGet ensureRequestWifiStatusGet() => $_ensure(5);

  @$pb.TagNumber(621)
  $1.RequestWifiSet get requestWifiSet => $_getN(6);
  @$pb.TagNumber(621)
  set requestWifiSet($1.RequestWifiSet value) => $_setField(621, value);
  @$pb.TagNumber(621)
  $core.bool hasRequestWifiSet() => $_has(6);
  @$pb.TagNumber(621)
  void clearRequestWifiSet() => $_clearField(621);
  @$pb.TagNumber(621)
  $1.RequestWifiSet ensureRequestWifiSet() => $_ensure(6);

  @$pb.TagNumber(623)
  $1.RequestWifiScanStart get requestWifiScanStart => $_getN(7);
  @$pb.TagNumber(623)
  set requestWifiScanStart($1.RequestWifiScanStart value) =>
      $_setField(623, value);
  @$pb.TagNumber(623)
  $core.bool hasRequestWifiScanStart() => $_has(7);
  @$pb.TagNumber(623)
  void clearRequestWifiScanStart() => $_clearField(623);
  @$pb.TagNumber(623)
  $1.RequestWifiScanStart ensureRequestWifiScanStart() => $_ensure(7);

  @$pb.TagNumber(624)
  $1.RequestWifiScanResultsGet get requestWifiScanResultsGet => $_getN(8);
  @$pb.TagNumber(624)
  set requestWifiScanResultsGet($1.RequestWifiScanResultsGet value) =>
      $_setField(624, value);
  @$pb.TagNumber(624)
  $core.bool hasRequestWifiScanResultsGet() => $_has(8);
  @$pb.TagNumber(624)
  void clearRequestWifiScanResultsGet() => $_clearField(624);
  @$pb.TagNumber(624)
  $1.RequestWifiScanResultsGet ensureRequestWifiScanResultsGet() => $_ensure(8);

  @$pb.TagNumber(625)
  $1.RequestWifiScanStop get requestWifiScanStop => $_getN(9);
  @$pb.TagNumber(625)
  set requestWifiScanStop($1.RequestWifiScanStop value) =>
      $_setField(625, value);
  @$pb.TagNumber(625)
  $core.bool hasRequestWifiScanStop() => $_has(9);
  @$pb.TagNumber(625)
  void clearRequestWifiScanStop() => $_clearField(625);
  @$pb.TagNumber(625)
  $1.RequestWifiScanStop ensureRequestWifiScanStop() => $_ensure(9);

  /// client public requests starts at 700
  @$pb.TagNumber(700)
  $1.RequestModeGet get requestModeGet => $_getN(10);
  @$pb.TagNumber(700)
  set requestModeGet($1.RequestModeGet value) => $_setField(700, value);
  @$pb.TagNumber(700)
  $core.bool hasRequestModeGet() => $_has(10);
  @$pb.TagNumber(700)
  void clearRequestModeGet() => $_clearField(700);
  @$pb.TagNumber(700)
  $1.RequestModeGet ensureRequestModeGet() => $_ensure(10);

  @$pb.TagNumber(701)
  $1.RequestModeSet get requestModeSet => $_getN(11);
  @$pb.TagNumber(701)
  set requestModeSet($1.RequestModeSet value) => $_setField(701, value);
  @$pb.TagNumber(701)
  $core.bool hasRequestModeSet() => $_has(11);
  @$pb.TagNumber(701)
  void clearRequestModeSet() => $_clearField(701);
  @$pb.TagNumber(701)
  $1.RequestModeSet ensureRequestModeSet() => $_ensure(11);

  @$pb.TagNumber(707)
  $1.RequestReboot get requestReboot => $_getN(12);
  @$pb.TagNumber(707)
  set requestReboot($1.RequestReboot value) => $_setField(707, value);
  @$pb.TagNumber(707)
  $core.bool hasRequestReboot() => $_has(12);
  @$pb.TagNumber(707)
  void clearRequestReboot() => $_clearField(707);
  @$pb.TagNumber(707)
  $1.RequestReboot ensureRequestReboot() => $_ensure(12);

  @$pb.TagNumber(708)
  $1.RequestButtonPress get requestButtonPress => $_getN(13);
  @$pb.TagNumber(708)
  set requestButtonPress($1.RequestButtonPress value) => $_setField(708, value);
  @$pb.TagNumber(708)
  $core.bool hasRequestButtonPress() => $_has(13);
  @$pb.TagNumber(708)
  void clearRequestButtonPress() => $_clearField(708);
  @$pb.TagNumber(708)
  $1.RequestButtonPress ensureRequestButtonPress() => $_ensure(13);

  @$pb.TagNumber(709)
  $1.RequestClockOffsetSet get requestClockOffsetSet => $_getN(14);
  @$pb.TagNumber(709)
  set requestClockOffsetSet($1.RequestClockOffsetSet value) =>
      $_setField(709, value);
  @$pb.TagNumber(709)
  $core.bool hasRequestClockOffsetSet() => $_has(14);
  @$pb.TagNumber(709)
  void clearRequestClockOffsetSet() => $_clearField(709);
  @$pb.TagNumber(709)
  $1.RequestClockOffsetSet ensureRequestClockOffsetSet() => $_ensure(14);

  @$pb.TagNumber(710)
  $1.RequestBatteryGet get requestBatteryGet => $_getN(15);
  @$pb.TagNumber(710)
  set requestBatteryGet($1.RequestBatteryGet value) => $_setField(710, value);
  @$pb.TagNumber(710)
  $core.bool hasRequestBatteryGet() => $_has(15);
  @$pb.TagNumber(710)
  void clearRequestBatteryGet() => $_clearField(710);
  @$pb.TagNumber(710)
  $1.RequestBatteryGet ensureRequestBatteryGet() => $_ensure(15);

  @$pb.TagNumber(712)
  $1.RequestClockOffsetGet get requestClockOffsetGet => $_getN(16);
  @$pb.TagNumber(712)
  set requestClockOffsetGet($1.RequestClockOffsetGet value) =>
      $_setField(712, value);
  @$pb.TagNumber(712)
  $core.bool hasRequestClockOffsetGet() => $_has(16);
  @$pb.TagNumber(712)
  void clearRequestClockOffsetGet() => $_clearField(712);
  @$pb.TagNumber(712)
  $1.RequestClockOffsetGet ensureRequestClockOffsetGet() => $_ensure(16);

  @$pb.TagNumber(713)
  $1.RequestCapabilitiesGet get requestCapabilitiesGet => $_getN(17);
  @$pb.TagNumber(713)
  set requestCapabilitiesGet($1.RequestCapabilitiesGet value) =>
      $_setField(713, value);
  @$pb.TagNumber(713)
  $core.bool hasRequestCapabilitiesGet() => $_has(17);
  @$pb.TagNumber(713)
  void clearRequestCapabilitiesGet() => $_clearField(713);
  @$pb.TagNumber(713)
  $1.RequestCapabilitiesGet ensureRequestCapabilitiesGet() => $_ensure(17);

  @$pb.TagNumber(714)
  $1.RequestSessionIdsGet get requestSessionIdsGet => $_getN(18);
  @$pb.TagNumber(714)
  set requestSessionIdsGet($1.RequestSessionIdsGet value) =>
      $_setField(714, value);
  @$pb.TagNumber(714)
  $core.bool hasRequestSessionIdsGet() => $_has(18);
  @$pb.TagNumber(714)
  void clearRequestSessionIdsGet() => $_clearField(714);
  @$pb.TagNumber(714)
  $1.RequestSessionIdsGet ensureRequestSessionIdsGet() => $_ensure(18);

  @$pb.TagNumber(715)
  $1.RequestStopCurrentMode get requestStopCurrentMode => $_getN(19);
  @$pb.TagNumber(715)
  set requestStopCurrentMode($1.RequestStopCurrentMode value) =>
      $_setField(715, value);
  @$pb.TagNumber(715)
  $core.bool hasRequestStopCurrentMode() => $_has(19);
  @$pb.TagNumber(715)
  void clearRequestStopCurrentMode() => $_clearField(715);
  @$pb.TagNumber(715)
  $1.RequestStopCurrentMode ensureRequestStopCurrentMode() => $_ensure(19);

  @$pb.TagNumber(716)
  $1.RequestConnectionModeSet get requestConnectionModeSet => $_getN(20);
  @$pb.TagNumber(716)
  set requestConnectionModeSet($1.RequestConnectionModeSet value) =>
      $_setField(716, value);
  @$pb.TagNumber(716)
  $core.bool hasRequestConnectionModeSet() => $_has(20);
  @$pb.TagNumber(716)
  void clearRequestConnectionModeSet() => $_clearField(716);
  @$pb.TagNumber(716)
  $1.RequestConnectionModeSet ensureRequestConnectionModeSet() => $_ensure(20);

  @$pb.TagNumber(717)
  $1.RequestConnectionModeGet get requestConnectionModeGet => $_getN(21);
  @$pb.TagNumber(717)
  set requestConnectionModeGet($1.RequestConnectionModeGet value) =>
      $_setField(717, value);
  @$pb.TagNumber(717)
  $core.bool hasRequestConnectionModeGet() => $_has(21);
  @$pb.TagNumber(717)
  void clearRequestConnectionModeGet() => $_clearField(717);
  @$pb.TagNumber(717)
  $1.RequestConnectionModeGet ensureRequestConnectionModeGet() => $_ensure(21);

  @$pb.TagNumber(718)
  $1.RequestPublicInfoGet get requestPublicInfoGet => $_getN(22);
  @$pb.TagNumber(718)
  set requestPublicInfoGet($1.RequestPublicInfoGet value) =>
      $_setField(718, value);
  @$pb.TagNumber(718)
  $core.bool hasRequestPublicInfoGet() => $_has(22);
  @$pb.TagNumber(718)
  void clearRequestPublicInfoGet() => $_clearField(718);
  @$pb.TagNumber(718)
  $1.RequestPublicInfoGet ensureRequestPublicInfoGet() => $_ensure(22);

  /// HAMP - 720
  @$pb.TagNumber(720)
  $1.RequestHampStart get requestHampStart => $_getN(23);
  @$pb.TagNumber(720)
  set requestHampStart($1.RequestHampStart value) => $_setField(720, value);
  @$pb.TagNumber(720)
  $core.bool hasRequestHampStart() => $_has(23);
  @$pb.TagNumber(720)
  void clearRequestHampStart() => $_clearField(720);
  @$pb.TagNumber(720)
  $1.RequestHampStart ensureRequestHampStart() => $_ensure(23);

  @$pb.TagNumber(721)
  $1.RequestHampStop get requestHampStop => $_getN(24);
  @$pb.TagNumber(721)
  set requestHampStop($1.RequestHampStop value) => $_setField(721, value);
  @$pb.TagNumber(721)
  $core.bool hasRequestHampStop() => $_has(24);
  @$pb.TagNumber(721)
  void clearRequestHampStop() => $_clearField(721);
  @$pb.TagNumber(721)
  $1.RequestHampStop ensureRequestHampStop() => $_ensure(24);

  @$pb.TagNumber(723)
  $1.RequestHampVelocitySet get requestHampVelocitySet => $_getN(25);
  @$pb.TagNumber(723)
  set requestHampVelocitySet($1.RequestHampVelocitySet value) =>
      $_setField(723, value);
  @$pb.TagNumber(723)
  $core.bool hasRequestHampVelocitySet() => $_has(25);
  @$pb.TagNumber(723)
  void clearRequestHampVelocitySet() => $_clearField(723);
  @$pb.TagNumber(723)
  $1.RequestHampVelocitySet ensureRequestHampVelocitySet() => $_ensure(25);

  @$pb.TagNumber(724)
  $1.RequestHampStateGet get requestHampStateGet => $_getN(26);
  @$pb.TagNumber(724)
  set requestHampStateGet($1.RequestHampStateGet value) =>
      $_setField(724, value);
  @$pb.TagNumber(724)
  $core.bool hasRequestHampStateGet() => $_has(26);
  @$pb.TagNumber(724)
  void clearRequestHampStateGet() => $_clearField(724);
  @$pb.TagNumber(724)
  $1.RequestHampStateGet ensureRequestHampStateGet() => $_ensure(26);

  @$pb.TagNumber(725)
  $1.RequestHampZoneSet get requestHampZoneSet => $_getN(27);
  @$pb.TagNumber(725)
  set requestHampZoneSet($1.RequestHampZoneSet value) => $_setField(725, value);
  @$pb.TagNumber(725)
  $core.bool hasRequestHampZoneSet() => $_has(27);
  @$pb.TagNumber(725)
  void clearRequestHampZoneSet() => $_clearField(725);
  @$pb.TagNumber(725)
  $1.RequestHampZoneSet ensureRequestHampZoneSet() => $_ensure(27);

  /// HDSP - 740
  @$pb.TagNumber(740)
  $1.RequestHdspXaVaSet get requestHdspXaVaSet => $_getN(28);
  @$pb.TagNumber(740)
  set requestHdspXaVaSet($1.RequestHdspXaVaSet value) => $_setField(740, value);
  @$pb.TagNumber(740)
  $core.bool hasRequestHdspXaVaSet() => $_has(28);
  @$pb.TagNumber(740)
  void clearRequestHdspXaVaSet() => $_clearField(740);
  @$pb.TagNumber(740)
  $1.RequestHdspXaVaSet ensureRequestHdspXaVaSet() => $_ensure(28);

  @$pb.TagNumber(741)
  $1.RequestHdspXpVaSet get requestHdspXpVaSet => $_getN(29);
  @$pb.TagNumber(741)
  set requestHdspXpVaSet($1.RequestHdspXpVaSet value) => $_setField(741, value);
  @$pb.TagNumber(741)
  $core.bool hasRequestHdspXpVaSet() => $_has(29);
  @$pb.TagNumber(741)
  void clearRequestHdspXpVaSet() => $_clearField(741);
  @$pb.TagNumber(741)
  $1.RequestHdspXpVaSet ensureRequestHdspXpVaSet() => $_ensure(29);

  @$pb.TagNumber(742)
  $1.RequestHdspXpVpSet get requestHdspXpVpSet => $_getN(30);
  @$pb.TagNumber(742)
  set requestHdspXpVpSet($1.RequestHdspXpVpSet value) => $_setField(742, value);
  @$pb.TagNumber(742)
  $core.bool hasRequestHdspXpVpSet() => $_has(30);
  @$pb.TagNumber(742)
  void clearRequestHdspXpVpSet() => $_clearField(742);
  @$pb.TagNumber(742)
  $1.RequestHdspXpVpSet ensureRequestHdspXpVpSet() => $_ensure(30);

  @$pb.TagNumber(743)
  $1.RequestHdspXaTSet get requestHdspXaTSet => $_getN(31);
  @$pb.TagNumber(743)
  set requestHdspXaTSet($1.RequestHdspXaTSet value) => $_setField(743, value);
  @$pb.TagNumber(743)
  $core.bool hasRequestHdspXaTSet() => $_has(31);
  @$pb.TagNumber(743)
  void clearRequestHdspXaTSet() => $_clearField(743);
  @$pb.TagNumber(743)
  $1.RequestHdspXaTSet ensureRequestHdspXaTSet() => $_ensure(31);

  @$pb.TagNumber(744)
  $1.RequestHdspXpTSet get requestHdspXpTSet => $_getN(32);
  @$pb.TagNumber(744)
  set requestHdspXpTSet($1.RequestHdspXpTSet value) => $_setField(744, value);
  @$pb.TagNumber(744)
  $core.bool hasRequestHdspXpTSet() => $_has(32);
  @$pb.TagNumber(744)
  void clearRequestHdspXpTSet() => $_clearField(744);
  @$pb.TagNumber(744)
  $1.RequestHdspXpTSet ensureRequestHdspXpTSet() => $_ensure(32);

  @$pb.TagNumber(745)
  $1.RequestHdspXaVpSet get requestHdspXaVpSet => $_getN(33);
  @$pb.TagNumber(745)
  set requestHdspXaVpSet($1.RequestHdspXaVpSet value) => $_setField(745, value);
  @$pb.TagNumber(745)
  $core.bool hasRequestHdspXaVpSet() => $_has(33);
  @$pb.TagNumber(745)
  void clearRequestHdspXaVpSet() => $_clearField(745);
  @$pb.TagNumber(745)
  $1.RequestHdspXaVpSet ensureRequestHdspXaVpSet() => $_ensure(33);

  @$pb.TagNumber(746)
  $1.RequestHdspStop get requestHdspStop => $_getN(34);
  @$pb.TagNumber(746)
  set requestHdspStop($1.RequestHdspStop value) => $_setField(746, value);
  @$pb.TagNumber(746)
  $core.bool hasRequestHdspStop() => $_has(34);
  @$pb.TagNumber(746)
  void clearRequestHdspStop() => $_clearField(746);
  @$pb.TagNumber(746)
  $1.RequestHdspStop ensureRequestHdspStop() => $_ensure(34);

  /// Sensor - 800
  @$pb.TagNumber(800)
  $1.RequestSensorNotificationSet get requestSensorNotificationSet =>
      $_getN(35);
  @$pb.TagNumber(800)
  set requestSensorNotificationSet($1.RequestSensorNotificationSet value) =>
      $_setField(800, value);
  @$pb.TagNumber(800)
  $core.bool hasRequestSensorNotificationSet() => $_has(35);
  @$pb.TagNumber(800)
  void clearRequestSensorNotificationSet() => $_clearField(800);
  @$pb.TagNumber(800)
  $1.RequestSensorNotificationSet ensureRequestSensorNotificationSet() =>
      $_ensure(35);

  @$pb.TagNumber(801)
  $1.RequestSensorStateGet get requestSensorStateGet => $_getN(36);
  @$pb.TagNumber(801)
  set requestSensorStateGet($1.RequestSensorStateGet value) =>
      $_setField(801, value);
  @$pb.TagNumber(801)
  $core.bool hasRequestSensorStateGet() => $_has(36);
  @$pb.TagNumber(801)
  void clearRequestSensorStateGet() => $_clearField(801);
  @$pb.TagNumber(801)
  $1.RequestSensorStateGet ensureRequestSensorStateGet() => $_ensure(36);

  @$pb.TagNumber(802)
  $1.RequestSensorNotificationGet get requestSensorNotificationGet =>
      $_getN(37);
  @$pb.TagNumber(802)
  set requestSensorNotificationGet($1.RequestSensorNotificationGet value) =>
      $_setField(802, value);
  @$pb.TagNumber(802)
  $core.bool hasRequestSensorNotificationGet() => $_has(37);
  @$pb.TagNumber(802)
  void clearRequestSensorNotificationGet() => $_clearField(802);
  @$pb.TagNumber(802)
  $1.RequestSensorNotificationGet ensureRequestSensorNotificationGet() =>
      $_ensure(37);

  /// MEMS force strip 810-818 - WORK IN PROGRESS, NOT FINALIZED: may change or be removed (see messages.proto)
  @$pb.TagNumber(810)
  $1.RequestMemsStatusGet get requestMemsStatusGet => $_getN(38);
  @$pb.TagNumber(810)
  set requestMemsStatusGet($1.RequestMemsStatusGet value) =>
      $_setField(810, value);
  @$pb.TagNumber(810)
  $core.bool hasRequestMemsStatusGet() => $_has(38);
  @$pb.TagNumber(810)
  void clearRequestMemsStatusGet() => $_clearField(810);
  @$pb.TagNumber(810)
  $1.RequestMemsStatusGet ensureRequestMemsStatusGet() => $_ensure(38);

  @$pb.TagNumber(811)
  $1.RequestMemsRead get requestMemsRead => $_getN(39);
  @$pb.TagNumber(811)
  set requestMemsRead($1.RequestMemsRead value) => $_setField(811, value);
  @$pb.TagNumber(811)
  $core.bool hasRequestMemsRead() => $_has(39);
  @$pb.TagNumber(811)
  void clearRequestMemsRead() => $_clearField(811);
  @$pb.TagNumber(811)
  $1.RequestMemsRead ensureRequestMemsRead() => $_ensure(39);

  @$pb.TagNumber(812)
  $1.RequestMemsTare get requestMemsTare => $_getN(40);
  @$pb.TagNumber(812)
  set requestMemsTare($1.RequestMemsTare value) => $_setField(812, value);
  @$pb.TagNumber(812)
  $core.bool hasRequestMemsTare() => $_has(40);
  @$pb.TagNumber(812)
  void clearRequestMemsTare() => $_clearField(812);
  @$pb.TagNumber(812)
  $1.RequestMemsTare ensureRequestMemsTare() => $_ensure(40);

  @$pb.TagNumber(813)
  $1.RequestMemsTempGet get requestMemsTempGet => $_getN(41);
  @$pb.TagNumber(813)
  set requestMemsTempGet($1.RequestMemsTempGet value) => $_setField(813, value);
  @$pb.TagNumber(813)
  $core.bool hasRequestMemsTempGet() => $_has(41);
  @$pb.TagNumber(813)
  void clearRequestMemsTempGet() => $_clearField(813);
  @$pb.TagNumber(813)
  $1.RequestMemsTempGet ensureRequestMemsTempGet() => $_ensure(41);

  @$pb.TagNumber(814)
  $1.RequestMemsReset get requestMemsReset => $_getN(42);
  @$pb.TagNumber(814)
  set requestMemsReset($1.RequestMemsReset value) => $_setField(814, value);
  @$pb.TagNumber(814)
  $core.bool hasRequestMemsReset() => $_has(42);
  @$pb.TagNumber(814)
  void clearRequestMemsReset() => $_clearField(814);
  @$pb.TagNumber(814)
  $1.RequestMemsReset ensureRequestMemsReset() => $_ensure(42);

  @$pb.TagNumber(815)
  $1.RequestMemsRegister get requestMemsRegister => $_getN(43);
  @$pb.TagNumber(815)
  set requestMemsRegister($1.RequestMemsRegister value) =>
      $_setField(815, value);
  @$pb.TagNumber(815)
  $core.bool hasRequestMemsRegister() => $_has(43);
  @$pb.TagNumber(815)
  void clearRequestMemsRegister() => $_clearField(815);
  @$pb.TagNumber(815)
  $1.RequestMemsRegister ensureRequestMemsRegister() => $_ensure(43);

  @$pb.TagNumber(816)
  $1.RequestMemsConfigSet get requestMemsConfigSet => $_getN(44);
  @$pb.TagNumber(816)
  set requestMemsConfigSet($1.RequestMemsConfigSet value) =>
      $_setField(816, value);
  @$pb.TagNumber(816)
  $core.bool hasRequestMemsConfigSet() => $_has(44);
  @$pb.TagNumber(816)
  void clearRequestMemsConfigSet() => $_clearField(816);
  @$pb.TagNumber(816)
  $1.RequestMemsConfigSet ensureRequestMemsConfigSet() => $_ensure(44);

  @$pb.TagNumber(817)
  $1.RequestMemsTestStart get requestMemsTestStart => $_getN(45);
  @$pb.TagNumber(817)
  set requestMemsTestStart($1.RequestMemsTestStart value) =>
      $_setField(817, value);
  @$pb.TagNumber(817)
  $core.bool hasRequestMemsTestStart() => $_has(45);
  @$pb.TagNumber(817)
  void clearRequestMemsTestStart() => $_clearField(817);
  @$pb.TagNumber(817)
  $1.RequestMemsTestStart ensureRequestMemsTestStart() => $_ensure(45);

  @$pb.TagNumber(818)
  $1.RequestMemsTestResultGet get requestMemsTestResultGet => $_getN(46);
  @$pb.TagNumber(818)
  set requestMemsTestResultGet($1.RequestMemsTestResultGet value) =>
      $_setField(818, value);
  @$pb.TagNumber(818)
  $core.bool hasRequestMemsTestResultGet() => $_has(46);
  @$pb.TagNumber(818)
  void clearRequestMemsTestResultGet() => $_clearField(818);
  @$pb.TagNumber(818)
  $1.RequestMemsTestResultGet ensureRequestMemsTestResultGet() => $_ensure(46);

  /// SLIDE - 840
  @$pb.TagNumber(840)
  $1.RequestSliderStrokeGet get requestSliderStrokeGet => $_getN(47);
  @$pb.TagNumber(840)
  set requestSliderStrokeGet($1.RequestSliderStrokeGet value) =>
      $_setField(840, value);
  @$pb.TagNumber(840)
  $core.bool hasRequestSliderStrokeGet() => $_has(47);
  @$pb.TagNumber(840)
  void clearRequestSliderStrokeGet() => $_clearField(840);
  @$pb.TagNumber(840)
  $1.RequestSliderStrokeGet ensureRequestSliderStrokeGet() => $_ensure(47);

  @$pb.TagNumber(841)
  $1.RequestSliderStrokeSet get requestSliderStrokeSet => $_getN(48);
  @$pb.TagNumber(841)
  set requestSliderStrokeSet($1.RequestSliderStrokeSet value) =>
      $_setField(841, value);
  @$pb.TagNumber(841)
  $core.bool hasRequestSliderStrokeSet() => $_has(48);
  @$pb.TagNumber(841)
  void clearRequestSliderStrokeSet() => $_clearField(841);
  @$pb.TagNumber(841)
  $1.RequestSliderStrokeSet ensureRequestSliderStrokeSet() => $_ensure(48);

  @$pb.TagNumber(842)
  $1.RequestSliderStateGet get requestSliderStateGet => $_getN(49);
  @$pb.TagNumber(842)
  set requestSliderStateGet($1.RequestSliderStateGet value) =>
      $_setField(842, value);
  @$pb.TagNumber(842)
  $core.bool hasRequestSliderStateGet() => $_has(49);
  @$pb.TagNumber(842)
  void clearRequestSliderStateGet() => $_clearField(842);
  @$pb.TagNumber(842)
  $1.RequestSliderStateGet ensureRequestSliderStateGet() => $_ensure(49);

  @$pb.TagNumber(843)
  $1.RequestSliderCalibrate get requestSliderCalibrate => $_getN(50);
  @$pb.TagNumber(843)
  set requestSliderCalibrate($1.RequestSliderCalibrate value) =>
      $_setField(843, value);
  @$pb.TagNumber(843)
  $core.bool hasRequestSliderCalibrate() => $_has(50);
  @$pb.TagNumber(843)
  void clearRequestSliderCalibrate() => $_clearField(843);
  @$pb.TagNumber(843)
  $1.RequestSliderCalibrate ensureRequestSliderCalibrate() => $_ensure(50);

  @$pb.TagNumber(844)
  $1.RequestSlideDiagStart get requestSlideDiagStart => $_getN(51);
  @$pb.TagNumber(844)
  set requestSlideDiagStart($1.RequestSlideDiagStart value) =>
      $_setField(844, value);
  @$pb.TagNumber(844)
  $core.bool hasRequestSlideDiagStart() => $_has(51);
  @$pb.TagNumber(844)
  void clearRequestSlideDiagStart() => $_clearField(844);
  @$pb.TagNumber(844)
  $1.RequestSlideDiagStart ensureRequestSlideDiagStart() => $_ensure(51);

  @$pb.TagNumber(845)
  $1.RequestSlideDiagStatus get requestSlideDiagStatus => $_getN(52);
  @$pb.TagNumber(845)
  set requestSlideDiagStatus($1.RequestSlideDiagStatus value) =>
      $_setField(845, value);
  @$pb.TagNumber(845)
  $core.bool hasRequestSlideDiagStatus() => $_has(52);
  @$pb.TagNumber(845)
  void clearRequestSlideDiagStatus() => $_clearField(845);
  @$pb.TagNumber(845)
  $1.RequestSlideDiagStatus ensureRequestSlideDiagStatus() => $_ensure(52);

  @$pb.TagNumber(846)
  $1.RequestSlideDiagRead get requestSlideDiagRead => $_getN(53);
  @$pb.TagNumber(846)
  set requestSlideDiagRead($1.RequestSlideDiagRead value) =>
      $_setField(846, value);
  @$pb.TagNumber(846)
  $core.bool hasRequestSlideDiagRead() => $_has(53);
  @$pb.TagNumber(846)
  void clearRequestSlideDiagRead() => $_clearField(846);
  @$pb.TagNumber(846)
  $1.RequestSlideDiagRead ensureRequestSlideDiagRead() => $_ensure(53);

  @$pb.TagNumber(847)
  $1.RequestSlideDiagStop get requestSlideDiagStop => $_getN(54);
  @$pb.TagNumber(847)
  set requestSlideDiagStop($1.RequestSlideDiagStop value) =>
      $_setField(847, value);
  @$pb.TagNumber(847)
  $core.bool hasRequestSlideDiagStop() => $_has(54);
  @$pb.TagNumber(847)
  void clearRequestSlideDiagStop() => $_clearField(847);
  @$pb.TagNumber(847)
  $1.RequestSlideDiagStop ensureRequestSlideDiagStop() => $_ensure(54);

  @$pb.TagNumber(848)
  $1.RequestHallCalibrationGet get requestHallCalibrationGet => $_getN(55);
  @$pb.TagNumber(848)
  set requestHallCalibrationGet($1.RequestHallCalibrationGet value) =>
      $_setField(848, value);
  @$pb.TagNumber(848)
  $core.bool hasRequestHallCalibrationGet() => $_has(55);
  @$pb.TagNumber(848)
  void clearRequestHallCalibrationGet() => $_clearField(848);
  @$pb.TagNumber(848)
  $1.RequestHallCalibrationGet ensureRequestHallCalibrationGet() =>
      $_ensure(55);

  @$pb.TagNumber(850)
  $1.RequestSlideDiagStream get requestSlideDiagStream => $_getN(56);
  @$pb.TagNumber(850)
  set requestSlideDiagStream($1.RequestSlideDiagStream value) =>
      $_setField(850, value);
  @$pb.TagNumber(850)
  $core.bool hasRequestSlideDiagStream() => $_has(56);
  @$pb.TagNumber(850)
  void clearRequestSlideDiagStream() => $_clearField(850);
  @$pb.TagNumber(850)
  $1.RequestSlideDiagStream ensureRequestSlideDiagStream() => $_ensure(56);

  @$pb.TagNumber(851)
  $1.RequestSpeedStatsGet get requestSpeedStatsGet => $_getN(57);
  @$pb.TagNumber(851)
  set requestSpeedStatsGet($1.RequestSpeedStatsGet value) =>
      $_setField(851, value);
  @$pb.TagNumber(851)
  $core.bool hasRequestSpeedStatsGet() => $_has(57);
  @$pb.TagNumber(851)
  void clearRequestSpeedStatsGet() => $_clearField(851);
  @$pb.TagNumber(851)
  $1.RequestSpeedStatsGet ensureRequestSpeedStatsGet() => $_ensure(57);

  @$pb.TagNumber(852)
  $1.RequestSpeedStatsSet get requestSpeedStatsSet => $_getN(58);
  @$pb.TagNumber(852)
  set requestSpeedStatsSet($1.RequestSpeedStatsSet value) =>
      $_setField(852, value);
  @$pb.TagNumber(852)
  $core.bool hasRequestSpeedStatsSet() => $_has(58);
  @$pb.TagNumber(852)
  void clearRequestSpeedStatsSet() => $_clearField(852);
  @$pb.TagNumber(852)
  $1.RequestSpeedStatsSet ensureRequestSpeedStatsSet() => $_ensure(58);

  @$pb.TagNumber(853)
  $1.RequestSlideSnapshotGet get requestSlideSnapshotGet => $_getN(59);
  @$pb.TagNumber(853)
  set requestSlideSnapshotGet($1.RequestSlideSnapshotGet value) =>
      $_setField(853, value);
  @$pb.TagNumber(853)
  $core.bool hasRequestSlideSnapshotGet() => $_has(59);
  @$pb.TagNumber(853)
  void clearRequestSlideSnapshotGet() => $_clearField(853);
  @$pb.TagNumber(853)
  $1.RequestSlideSnapshotGet ensureRequestSlideSnapshotGet() => $_ensure(59);

  @$pb.TagNumber(855)
  $1.RequestSlideProfileTuningGet get requestSlideProfileTuningGet =>
      $_getN(60);
  @$pb.TagNumber(855)
  set requestSlideProfileTuningGet($1.RequestSlideProfileTuningGet value) =>
      $_setField(855, value);
  @$pb.TagNumber(855)
  $core.bool hasRequestSlideProfileTuningGet() => $_has(60);
  @$pb.TagNumber(855)
  void clearRequestSlideProfileTuningGet() => $_clearField(855);
  @$pb.TagNumber(855)
  $1.RequestSlideProfileTuningGet ensureRequestSlideProfileTuningGet() =>
      $_ensure(60);

  @$pb.TagNumber(856)
  $1.RequestSlideMaintResultGet get requestSlideMaintResultGet => $_getN(61);
  @$pb.TagNumber(856)
  set requestSlideMaintResultGet($1.RequestSlideMaintResultGet value) =>
      $_setField(856, value);
  @$pb.TagNumber(856)
  $core.bool hasRequestSlideMaintResultGet() => $_has(61);
  @$pb.TagNumber(856)
  void clearRequestSlideMaintResultGet() => $_clearField(856);
  @$pb.TagNumber(856)
  $1.RequestSlideMaintResultGet ensureRequestSlideMaintResultGet() =>
      $_ensure(61);

  @$pb.TagNumber(857)
  $1.RequestSliderEndMove get requestSliderEndMove => $_getN(62);
  @$pb.TagNumber(857)
  set requestSliderEndMove($1.RequestSliderEndMove value) =>
      $_setField(857, value);
  @$pb.TagNumber(857)
  $core.bool hasRequestSliderEndMove() => $_has(62);
  @$pb.TagNumber(857)
  void clearRequestSliderEndMove() => $_clearField(857);
  @$pb.TagNumber(857)
  $1.RequestSliderEndMove ensureRequestSliderEndMove() => $_ensure(62);

  /// HSP - 860
  @$pb.TagNumber(860)
  $1.RequestHspSetup get requestHspSetup => $_getN(63);
  @$pb.TagNumber(860)
  set requestHspSetup($1.RequestHspSetup value) => $_setField(860, value);
  @$pb.TagNumber(860)
  $core.bool hasRequestHspSetup() => $_has(63);
  @$pb.TagNumber(860)
  void clearRequestHspSetup() => $_clearField(860);
  @$pb.TagNumber(860)
  $1.RequestHspSetup ensureRequestHspSetup() => $_ensure(63);

  @$pb.TagNumber(861)
  $1.RequestHspAdd get requestHspAdd => $_getN(64);
  @$pb.TagNumber(861)
  set requestHspAdd($1.RequestHspAdd value) => $_setField(861, value);
  @$pb.TagNumber(861)
  $core.bool hasRequestHspAdd() => $_has(64);
  @$pb.TagNumber(861)
  void clearRequestHspAdd() => $_clearField(861);
  @$pb.TagNumber(861)
  $1.RequestHspAdd ensureRequestHspAdd() => $_ensure(64);

  @$pb.TagNumber(862)
  $1.RequestHspFlush get requestHspFlush => $_getN(65);
  @$pb.TagNumber(862)
  set requestHspFlush($1.RequestHspFlush value) => $_setField(862, value);
  @$pb.TagNumber(862)
  $core.bool hasRequestHspFlush() => $_has(65);
  @$pb.TagNumber(862)
  void clearRequestHspFlush() => $_clearField(862);
  @$pb.TagNumber(862)
  $1.RequestHspFlush ensureRequestHspFlush() => $_ensure(65);

  @$pb.TagNumber(863)
  $1.RequestHspPlay get requestHspPlay => $_getN(66);
  @$pb.TagNumber(863)
  set requestHspPlay($1.RequestHspPlay value) => $_setField(863, value);
  @$pb.TagNumber(863)
  $core.bool hasRequestHspPlay() => $_has(66);
  @$pb.TagNumber(863)
  void clearRequestHspPlay() => $_clearField(863);
  @$pb.TagNumber(863)
  $1.RequestHspPlay ensureRequestHspPlay() => $_ensure(66);

  @$pb.TagNumber(864)
  $1.RequestHspStop get requestHspStop => $_getN(67);
  @$pb.TagNumber(864)
  set requestHspStop($1.RequestHspStop value) => $_setField(864, value);
  @$pb.TagNumber(864)
  $core.bool hasRequestHspStop() => $_has(67);
  @$pb.TagNumber(864)
  void clearRequestHspStop() => $_clearField(864);
  @$pb.TagNumber(864)
  $1.RequestHspStop ensureRequestHspStop() => $_ensure(67);

  @$pb.TagNumber(865)
  $1.RequestHspPause get requestHspPause => $_getN(68);
  @$pb.TagNumber(865)
  set requestHspPause($1.RequestHspPause value) => $_setField(865, value);
  @$pb.TagNumber(865)
  $core.bool hasRequestHspPause() => $_has(68);
  @$pb.TagNumber(865)
  void clearRequestHspPause() => $_clearField(865);
  @$pb.TagNumber(865)
  $1.RequestHspPause ensureRequestHspPause() => $_ensure(68);

  @$pb.TagNumber(866)
  $1.RequestHspResume get requestHspResume => $_getN(69);
  @$pb.TagNumber(866)
  set requestHspResume($1.RequestHspResume value) => $_setField(866, value);
  @$pb.TagNumber(866)
  $core.bool hasRequestHspResume() => $_has(69);
  @$pb.TagNumber(866)
  void clearRequestHspResume() => $_clearField(866);
  @$pb.TagNumber(866)
  $1.RequestHspResume ensureRequestHspResume() => $_ensure(69);

  @$pb.TagNumber(867)
  $1.RequestHspStateGet get requestHspStateGet => $_getN(70);
  @$pb.TagNumber(867)
  set requestHspStateGet($1.RequestHspStateGet value) => $_setField(867, value);
  @$pb.TagNumber(867)
  $core.bool hasRequestHspStateGet() => $_has(70);
  @$pb.TagNumber(867)
  void clearRequestHspStateGet() => $_clearField(867);
  @$pb.TagNumber(867)
  $1.RequestHspStateGet ensureRequestHspStateGet() => $_ensure(70);

  @$pb.TagNumber(868)
  $1.RequestHspCurrentTimeSet get requestHspCurrentTimeSet => $_getN(71);
  @$pb.TagNumber(868)
  set requestHspCurrentTimeSet($1.RequestHspCurrentTimeSet value) =>
      $_setField(868, value);
  @$pb.TagNumber(868)
  $core.bool hasRequestHspCurrentTimeSet() => $_has(71);
  @$pb.TagNumber(868)
  void clearRequestHspCurrentTimeSet() => $_clearField(868);
  @$pb.TagNumber(868)
  $1.RequestHspCurrentTimeSet ensureRequestHspCurrentTimeSet() => $_ensure(71);

  @$pb.TagNumber(869)
  $1.RequestHspThresholdSet get requestHspThresholdSet => $_getN(72);
  @$pb.TagNumber(869)
  set requestHspThresholdSet($1.RequestHspThresholdSet value) =>
      $_setField(869, value);
  @$pb.TagNumber(869)
  $core.bool hasRequestHspThresholdSet() => $_has(72);
  @$pb.TagNumber(869)
  void clearRequestHspThresholdSet() => $_clearField(869);
  @$pb.TagNumber(869)
  $1.RequestHspThresholdSet ensureRequestHspThresholdSet() => $_ensure(72);

  @$pb.TagNumber(870)
  $1.RequestHspPauseOnStarvingSet get requestHspPauseOnStarvingSet =>
      $_getN(73);
  @$pb.TagNumber(870)
  set requestHspPauseOnStarvingSet($1.RequestHspPauseOnStarvingSet value) =>
      $_setField(870, value);
  @$pb.TagNumber(870)
  $core.bool hasRequestHspPauseOnStarvingSet() => $_has(73);
  @$pb.TagNumber(870)
  void clearRequestHspPauseOnStarvingSet() => $_clearField(870);
  @$pb.TagNumber(870)
  $1.RequestHspPauseOnStarvingSet ensureRequestHspPauseOnStarvingSet() =>
      $_ensure(73);

  @$pb.TagNumber(871)
  $1.RequestHspPlaybackRateSet get requestHspPlaybackRateSet => $_getN(74);
  @$pb.TagNumber(871)
  set requestHspPlaybackRateSet($1.RequestHspPlaybackRateSet value) =>
      $_setField(871, value);
  @$pb.TagNumber(871)
  $core.bool hasRequestHspPlaybackRateSet() => $_has(74);
  @$pb.TagNumber(871)
  void clearRequestHspPlaybackRateSet() => $_clearField(871);
  @$pb.TagNumber(871)
  $1.RequestHspPlaybackRateSet ensureRequestHspPlaybackRateSet() =>
      $_ensure(74);

  @$pb.TagNumber(872)
  $1.RequestHspLoopSet get requestHspLoopSet => $_getN(75);
  @$pb.TagNumber(872)
  set requestHspLoopSet($1.RequestHspLoopSet value) => $_setField(872, value);
  @$pb.TagNumber(872)
  $core.bool hasRequestHspLoopSet() => $_has(75);
  @$pb.TagNumber(872)
  void clearRequestHspLoopSet() => $_clearField(872);
  @$pb.TagNumber(872)
  $1.RequestHspLoopSet ensureRequestHspLoopSet() => $_ensure(75);

  @$pb.TagNumber(873)
  $1.RequestHspJitterFilterSet get requestHspJitterFilterSet => $_getN(76);
  @$pb.TagNumber(873)
  set requestHspJitterFilterSet($1.RequestHspJitterFilterSet value) =>
      $_setField(873, value);
  @$pb.TagNumber(873)
  $core.bool hasRequestHspJitterFilterSet() => $_has(76);
  @$pb.TagNumber(873)
  void clearRequestHspJitterFilterSet() => $_clearField(873);
  @$pb.TagNumber(873)
  $1.RequestHspJitterFilterSet ensureRequestHspJitterFilterSet() =>
      $_ensure(76);

  @$pb.TagNumber(874)
  $1.RequestHspScriptSpeedSet get requestHspScriptSpeedSet => $_getN(77);
  @$pb.TagNumber(874)
  set requestHspScriptSpeedSet($1.RequestHspScriptSpeedSet value) =>
      $_setField(874, value);
  @$pb.TagNumber(874)
  $core.bool hasRequestHspScriptSpeedSet() => $_has(77);
  @$pb.TagNumber(874)
  void clearRequestHspScriptSpeedSet() => $_clearField(874);
  @$pb.TagNumber(874)
  $1.RequestHspScriptSpeedSet ensureRequestHspScriptSpeedSet() => $_ensure(77);

  /// HMI (LED, screen and so on) - 880
  @$pb.TagNumber(880)
  $1.RequestLedOverride get requestLedOverride => $_getN(78);
  @$pb.TagNumber(880)
  set requestLedOverride($1.RequestLedOverride value) => $_setField(880, value);
  @$pb.TagNumber(880)
  $core.bool hasRequestLedOverride() => $_has(78);
  @$pb.TagNumber(880)
  void clearRequestLedOverride() => $_clearField(880);
  @$pb.TagNumber(880)
  $1.RequestLedOverride ensureRequestLedOverride() => $_ensure(78);

  /// HVP (vibration) - 900
  @$pb.TagNumber(900)
  $1.RequestHvpSet get requestHvpSet => $_getN(79);
  @$pb.TagNumber(900)
  set requestHvpSet($1.RequestHvpSet value) => $_setField(900, value);
  @$pb.TagNumber(900)
  $core.bool hasRequestHvpSet() => $_has(79);
  @$pb.TagNumber(900)
  void clearRequestHvpSet() => $_clearField(900);
  @$pb.TagNumber(900)
  $1.RequestHvpSet ensureRequestHvpSet() => $_ensure(79);

  @$pb.TagNumber(901)
  $1.RequestHvpStop get requestHvpStop => $_getN(80);
  @$pb.TagNumber(901)
  set requestHvpStop($1.RequestHvpStop value) => $_setField(901, value);
  @$pb.TagNumber(901)
  $core.bool hasRequestHvpStop() => $_has(80);
  @$pb.TagNumber(901)
  void clearRequestHvpStop() => $_clearField(901);
  @$pb.TagNumber(901)
  $1.RequestHvpStop ensureRequestHvpStop() => $_ensure(80);

  @$pb.TagNumber(902)
  $1.RequestHvpStart get requestHvpStart => $_getN(81);
  @$pb.TagNumber(902)
  set requestHvpStart($1.RequestHvpStart value) => $_setField(902, value);
  @$pb.TagNumber(902)
  $core.bool hasRequestHvpStart() => $_has(81);
  @$pb.TagNumber(902)
  void clearRequestHvpStart() => $_clearField(902);
  @$pb.TagNumber(902)
  $1.RequestHvpStart ensureRequestHvpStart() => $_ensure(81);

  @$pb.TagNumber(903)
  $1.RequestHvpStateGet get requestHvpStateGet => $_getN(82);
  @$pb.TagNumber(903)
  set requestHvpStateGet($1.RequestHvpStateGet value) => $_setField(903, value);
  @$pb.TagNumber(903)
  $core.bool hasRequestHvpStateGet() => $_has(82);
  @$pb.TagNumber(903)
  void clearRequestHvpStateGet() => $_clearField(903);
  @$pb.TagNumber(903)
  $1.RequestHvpStateGet ensureRequestHvpStateGet() => $_ensure(82);

  /// HRPP - 920
  @$pb.TagNumber(920)
  $1.RequestHrppStart get requestHrppStart => $_getN(83);
  @$pb.TagNumber(920)
  set requestHrppStart($1.RequestHrppStart value) => $_setField(920, value);
  @$pb.TagNumber(920)
  $core.bool hasRequestHrppStart() => $_has(83);
  @$pb.TagNumber(920)
  void clearRequestHrppStart() => $_clearField(920);
  @$pb.TagNumber(920)
  $1.RequestHrppStart ensureRequestHrppStart() => $_ensure(83);

  @$pb.TagNumber(921)
  $1.RequestHrppStop get requestHrppStop => $_getN(84);
  @$pb.TagNumber(921)
  set requestHrppStop($1.RequestHrppStop value) => $_setField(921, value);
  @$pb.TagNumber(921)
  $core.bool hasRequestHrppStop() => $_has(84);
  @$pb.TagNumber(921)
  void clearRequestHrppStop() => $_clearField(921);
  @$pb.TagNumber(921)
  $1.RequestHrppStop ensureRequestHrppStop() => $_ensure(84);

  @$pb.TagNumber(922)
  $1.RequestHrppAmplitudeSet get requestHrppAmplitudeSet => $_getN(85);
  @$pb.TagNumber(922)
  set requestHrppAmplitudeSet($1.RequestHrppAmplitudeSet value) =>
      $_setField(922, value);
  @$pb.TagNumber(922)
  $core.bool hasRequestHrppAmplitudeSet() => $_has(85);
  @$pb.TagNumber(922)
  void clearRequestHrppAmplitudeSet() => $_clearField(922);
  @$pb.TagNumber(922)
  $1.RequestHrppAmplitudeSet ensureRequestHrppAmplitudeSet() => $_ensure(85);

  /// RequestHrppPlaybackSpeedSet request_hrpp_playback_speed_set = 923; //DEPRECATED in FW4.2 use RequestHrppPlaybackRateSet instead
  @$pb.TagNumber(924)
  $1.RequestHrppPatternSet get requestHrppPatternSet => $_getN(86);
  @$pb.TagNumber(924)
  set requestHrppPatternSet($1.RequestHrppPatternSet value) =>
      $_setField(924, value);
  @$pb.TagNumber(924)
  $core.bool hasRequestHrppPatternSet() => $_has(86);
  @$pb.TagNumber(924)
  void clearRequestHrppPatternSet() => $_clearField(924);
  @$pb.TagNumber(924)
  $1.RequestHrppPatternSet ensureRequestHrppPatternSet() => $_ensure(86);

  @$pb.TagNumber(925)
  $1.RequestHrppStateGet get requestHrppStateGet => $_getN(87);
  @$pb.TagNumber(925)
  set requestHrppStateGet($1.RequestHrppStateGet value) =>
      $_setField(925, value);
  @$pb.TagNumber(925)
  $core.bool hasRequestHrppStateGet() => $_has(87);
  @$pb.TagNumber(925)
  void clearRequestHrppStateGet() => $_clearField(925);
  @$pb.TagNumber(925)
  $1.RequestHrppStateGet ensureRequestHrppStateGet() => $_ensure(87);

  @$pb.TagNumber(926)
  $1.RequestHrppPatternsGet get requestHrppPatternsGet => $_getN(88);
  @$pb.TagNumber(926)
  set requestHrppPatternsGet($1.RequestHrppPatternsGet value) =>
      $_setField(926, value);
  @$pb.TagNumber(926)
  $core.bool hasRequestHrppPatternsGet() => $_has(88);
  @$pb.TagNumber(926)
  void clearRequestHrppPatternsGet() => $_clearField(926);
  @$pb.TagNumber(926)
  $1.RequestHrppPatternsGet ensureRequestHrppPatternsGet() => $_ensure(88);

  @$pb.TagNumber(927)
  $1.RequestHrppPlaybackRateSet get requestHrppPlaybackRateSet => $_getN(89);
  @$pb.TagNumber(927)
  set requestHrppPlaybackRateSet($1.RequestHrppPlaybackRateSet value) =>
      $_setField(927, value);
  @$pb.TagNumber(927)
  $core.bool hasRequestHrppPlaybackRateSet() => $_has(89);
  @$pb.TagNumber(927)
  void clearRequestHrppPlaybackRateSet() => $_clearField(927);
  @$pb.TagNumber(927)
  $1.RequestHrppPlaybackRateSet ensureRequestHrppPlaybackRateSet() =>
      $_ensure(89);

  @$pb.TagNumber(928)
  $1.RequestHrppPause get requestHrppPause => $_getN(90);
  @$pb.TagNumber(928)
  set requestHrppPause($1.RequestHrppPause value) => $_setField(928, value);
  @$pb.TagNumber(928)
  $core.bool hasRequestHrppPause() => $_has(90);
  @$pb.TagNumber(928)
  void clearRequestHrppPause() => $_clearField(928);
  @$pb.TagNumber(928)
  $1.RequestHrppPause ensureRequestHrppPause() => $_ensure(90);

  /// Motor tuning (FW4.4): the read-only getters are public; the setters modify the motion profile and are private
  @$pb.TagNumber(2015)
  $1.RequestSettingsRegulatorGet get requestSettingsRegulatorGet => $_getN(91);
  @$pb.TagNumber(2015)
  set requestSettingsRegulatorGet($1.RequestSettingsRegulatorGet value) =>
      $_setField(2015, value);
  @$pb.TagNumber(2015)
  $core.bool hasRequestSettingsRegulatorGet() => $_has(91);
  @$pb.TagNumber(2015)
  void clearRequestSettingsRegulatorGet() => $_clearField(2015);
  @$pb.TagNumber(2015)
  $1.RequestSettingsRegulatorGet ensureRequestSettingsRegulatorGet() =>
      $_ensure(91);

  @$pb.TagNumber(2017)
  $1.RequestSettingsHallGet get requestSettingsHallGet => $_getN(92);
  @$pb.TagNumber(2017)
  set requestSettingsHallGet($1.RequestSettingsHallGet value) =>
      $_setField(2017, value);
  @$pb.TagNumber(2017)
  $core.bool hasRequestSettingsHallGet() => $_has(92);
  @$pb.TagNumber(2017)
  void clearRequestSettingsHallGet() => $_clearField(2017);
  @$pb.TagNumber(2017)
  $1.RequestSettingsHallGet ensureRequestSettingsHallGet() => $_ensure(92);

  @$pb.TagNumber(2019)
  $1.RequestSlideProfileGet get requestSlideProfileGet => $_getN(93);
  @$pb.TagNumber(2019)
  set requestSlideProfileGet($1.RequestSlideProfileGet value) =>
      $_setField(2019, value);
  @$pb.TagNumber(2019)
  $core.bool hasRequestSlideProfileGet() => $_has(93);
  @$pb.TagNumber(2019)
  void clearRequestSlideProfileGet() => $_clearField(2019);
  @$pb.TagNumber(2019)
  $1.RequestSlideProfileGet ensureRequestSlideProfileGet() => $_ensure(93);
}

/// Responses are sent back individually as they are handled
class Requests extends $pb.GeneratedMessage {
  factory Requests({
    $core.Iterable<Request>? requests,
  }) {
    final result = create();
    if (requests != null) result.requests.addAll(requests);
    return result;
  }

  Requests._();

  factory Requests.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Requests.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Requests',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..pPM<Request>(1, _omitFieldNames ? '' : 'requests',
        subBuilder: Request.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Requests clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Requests copyWith(void Function(Requests) updates) =>
      super.copyWith((message) => updates(message as Requests)) as Requests;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Requests create() => Requests._();
  @$core.override
  Requests createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Requests getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Requests>(create);
  static Requests? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Request> get requests => $_getList(0);
}

enum Response_Result {
  responseServerTimeGet,
  responseConnectedGet,
  responseFwStatusGet,
  responseConnectionKeyGet,
  responseWifiStatusGet,
  responseWifiScanResultsGet,
  responseModeGet,
  responseModeSet,
  responseClockOffsetSet,
  responseBatteryGet,
  responseClockOffsetGet,
  responseCapabilitiesGet,
  responseSessionIdsGet,
  responseConnectionModeGet,
  responsePublicInfoGet,
  responseHampStart,
  responseHampStop,
  responseHampVelocitySet,
  responseHampStateGet,
  responseHampZoneSet,
  responseSensorNotificationSet,
  responseSensorStateGet,
  responseSensorNotificationGet,
  responseMemsStatusGet,
  responseMemsRead,
  responseMemsTare,
  responseMemsTempGet,
  responseMemsReset,
  responseMemsRegister,
  responseMemsConfigSet,
  responseMemsTestStart,
  responseMemsTestResultGet,
  responseSliderStrokeGet,
  responseSliderStrokeSet,
  responseSliderStateGet,
  responseSliderCalibrate,
  responseSlideDiagStart,
  responseSlideDiagStatus,
  responseSlideDiagRead,
  responseHallCalibrationGet,
  responseSlideDiagStream,
  responseSpeedStatsGet,
  responseSpeedStatsSet,
  responseSlideSnapshotGet,
  responseSlideProfileTuningGet,
  responseSlideMaintResultGet,
  responseHspSetup,
  responseHspAdd,
  responseHspFlush,
  responseHspPlay,
  responseHspStop,
  responseHspPause,
  responseHspResume,
  responseHspStateGet,
  responseHspCurrentTimeSet,
  responseHspThresholdSet,
  responseHspPauseOnStarvingSet,
  responseHspPlaybackRateSet,
  responseHspLoopSet,
  responseHspJitterFilterSet,
  responseHspScriptSpeedSet,
  responseHvpSet,
  responseHvpStop,
  responseHvpStart,
  responseHvpStateGet,
  responseHrppStart,
  responseHrppStop,
  responseHrppAmplitudeSet,
  responseHrppPatternSet,
  responseHrppStateGet,
  responseHrppPatternsGet,
  responseHrppPlaybackRateSet,
  responseHrppPause,
  responseSettingsRegulatorGet,
  responseSettingsHallGet,
  responseSlideProfileGet,
  notSet
}

/// Responses have the same ID as the request. NB! not all requests will have a result, and just return a blank response
class Response extends $pb.GeneratedMessage {
  factory Response({
    $core.int? id,
    Error? error,
    $1.ResponseServerTimeGet? responseServerTimeGet,
    $1.ResponseConnectedGet? responseConnectedGet,
    $1.ResponseFwStatusGet? responseFwStatusGet,
    $1.ResponseConnectionKeyGet? responseConnectionKeyGet,
    $1.ResponseWifiStatusGet? responseWifiStatusGet,
    $1.ResponseWifiScanResultsGet? responseWifiScanResultsGet,
    $1.ResponseModeGet? responseModeGet,
    $1.ResponseModeSet? responseModeSet,
    $1.ResponseClockOffsetSet? responseClockOffsetSet,
    $1.ResponseBatteryGet? responseBatteryGet,
    $1.ResponseClockOffsetGet? responseClockOffsetGet,
    $1.ResponseCapabilitiesGet? responseCapabilitiesGet,
    $1.ResponseSessionIdsGet? responseSessionIdsGet,
    $1.ResponseConnectionModeGet? responseConnectionModeGet,
    $1.ResponsePublicInfoGet? responsePublicInfoGet,
    $1.ResponseHampStart? responseHampStart,
    $1.ResponseHampStop? responseHampStop,
    $1.ResponseHampVelocitySet? responseHampVelocitySet,
    $1.ResponseHampStateGet? responseHampStateGet,
    $1.ResponseHampZoneSet? responseHampZoneSet,
    $1.ResponseSensorNotificationSet? responseSensorNotificationSet,
    $1.ResponseSensorStateGet? responseSensorStateGet,
    $1.ResponseSensorNotificationGet? responseSensorNotificationGet,
    $1.ResponseMemsStatusGet? responseMemsStatusGet,
    $1.ResponseMemsRead? responseMemsRead,
    $1.ResponseMemsTare? responseMemsTare,
    $1.ResponseMemsTempGet? responseMemsTempGet,
    $1.ResponseMemsReset? responseMemsReset,
    $1.ResponseMemsRegister? responseMemsRegister,
    $1.ResponseMemsConfigSet? responseMemsConfigSet,
    $1.ResponseMemsTestStart? responseMemsTestStart,
    $1.ResponseMemsTestResultGet? responseMemsTestResultGet,
    $1.ResponseSliderStrokeGet? responseSliderStrokeGet,
    $1.ResponseSliderStrokeSet? responseSliderStrokeSet,
    $1.ResponseSliderStateGet? responseSliderStateGet,
    $1.ResponseSliderCalibrate? responseSliderCalibrate,
    $1.ResponseSlideDiagStart? responseSlideDiagStart,
    $1.ResponseSlideDiagStatus? responseSlideDiagStatus,
    $1.ResponseSlideDiagRead? responseSlideDiagRead,
    $1.ResponseHallCalibrationGet? responseHallCalibrationGet,
    $1.ResponseSlideDiagStream? responseSlideDiagStream,
    $1.ResponseSpeedStatsGet? responseSpeedStatsGet,
    $1.ResponseSpeedStatsSet? responseSpeedStatsSet,
    $1.ResponseSlideSnapshotGet? responseSlideSnapshotGet,
    $1.ResponseSlideProfileTuningGet? responseSlideProfileTuningGet,
    $1.ResponseSlideMaintResultGet? responseSlideMaintResultGet,
    $1.ResponseHspSetup? responseHspSetup,
    $1.ResponseHspAdd? responseHspAdd,
    $1.ResponseHspFlush? responseHspFlush,
    $1.ResponseHspPlay? responseHspPlay,
    $1.ResponseHspStop? responseHspStop,
    $1.ResponseHspPause? responseHspPause,
    $1.ResponseHspResume? responseHspResume,
    $1.ResponseHspStateGet? responseHspStateGet,
    $1.ResponseHspCurrentTimeSet? responseHspCurrentTimeSet,
    $1.ResponseHspThresholdSet? responseHspThresholdSet,
    $1.ResponseHspPauseOnStarvingSet? responseHspPauseOnStarvingSet,
    $1.ResponseHspPlaybackRateSet? responseHspPlaybackRateSet,
    $1.ResponseHspLoopSet? responseHspLoopSet,
    $1.ResponseHspJitterFilterSet? responseHspJitterFilterSet,
    $1.ResponseHspScriptSpeedSet? responseHspScriptSpeedSet,
    $1.ResponseHvpSet? responseHvpSet,
    $1.ResponseHvpStop? responseHvpStop,
    $1.ResponseHvpStart? responseHvpStart,
    $1.ResponseHvpStateGet? responseHvpStateGet,
    $1.ResponseHrppStart? responseHrppStart,
    $1.ResponseHrppStop? responseHrppStop,
    $1.ResponseHrppAmplitudeSet? responseHrppAmplitudeSet,
    $1.ResponseHrppPatternSet? responseHrppPatternSet,
    $1.ResponseHrppStateGet? responseHrppStateGet,
    $1.ResponseHrppPatternsGet? responseHrppPatternsGet,
    $1.ResponseHrppPlaybackRateSet? responseHrppPlaybackRateSet,
    $1.ResponseHrppPause? responseHrppPause,
    $1.ResponseSettingsRegulatorGet? responseSettingsRegulatorGet,
    $1.ResponseSettingsHallGet? responseSettingsHallGet,
    $1.ResponseSlideProfileGet? responseSlideProfileGet,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (error != null) result.error = error;
    if (responseServerTimeGet != null)
      result.responseServerTimeGet = responseServerTimeGet;
    if (responseConnectedGet != null)
      result.responseConnectedGet = responseConnectedGet;
    if (responseFwStatusGet != null)
      result.responseFwStatusGet = responseFwStatusGet;
    if (responseConnectionKeyGet != null)
      result.responseConnectionKeyGet = responseConnectionKeyGet;
    if (responseWifiStatusGet != null)
      result.responseWifiStatusGet = responseWifiStatusGet;
    if (responseWifiScanResultsGet != null)
      result.responseWifiScanResultsGet = responseWifiScanResultsGet;
    if (responseModeGet != null) result.responseModeGet = responseModeGet;
    if (responseModeSet != null) result.responseModeSet = responseModeSet;
    if (responseClockOffsetSet != null)
      result.responseClockOffsetSet = responseClockOffsetSet;
    if (responseBatteryGet != null)
      result.responseBatteryGet = responseBatteryGet;
    if (responseClockOffsetGet != null)
      result.responseClockOffsetGet = responseClockOffsetGet;
    if (responseCapabilitiesGet != null)
      result.responseCapabilitiesGet = responseCapabilitiesGet;
    if (responseSessionIdsGet != null)
      result.responseSessionIdsGet = responseSessionIdsGet;
    if (responseConnectionModeGet != null)
      result.responseConnectionModeGet = responseConnectionModeGet;
    if (responsePublicInfoGet != null)
      result.responsePublicInfoGet = responsePublicInfoGet;
    if (responseHampStart != null) result.responseHampStart = responseHampStart;
    if (responseHampStop != null) result.responseHampStop = responseHampStop;
    if (responseHampVelocitySet != null)
      result.responseHampVelocitySet = responseHampVelocitySet;
    if (responseHampStateGet != null)
      result.responseHampStateGet = responseHampStateGet;
    if (responseHampZoneSet != null)
      result.responseHampZoneSet = responseHampZoneSet;
    if (responseSensorNotificationSet != null)
      result.responseSensorNotificationSet = responseSensorNotificationSet;
    if (responseSensorStateGet != null)
      result.responseSensorStateGet = responseSensorStateGet;
    if (responseSensorNotificationGet != null)
      result.responseSensorNotificationGet = responseSensorNotificationGet;
    if (responseMemsStatusGet != null)
      result.responseMemsStatusGet = responseMemsStatusGet;
    if (responseMemsRead != null) result.responseMemsRead = responseMemsRead;
    if (responseMemsTare != null) result.responseMemsTare = responseMemsTare;
    if (responseMemsTempGet != null)
      result.responseMemsTempGet = responseMemsTempGet;
    if (responseMemsReset != null) result.responseMemsReset = responseMemsReset;
    if (responseMemsRegister != null)
      result.responseMemsRegister = responseMemsRegister;
    if (responseMemsConfigSet != null)
      result.responseMemsConfigSet = responseMemsConfigSet;
    if (responseMemsTestStart != null)
      result.responseMemsTestStart = responseMemsTestStart;
    if (responseMemsTestResultGet != null)
      result.responseMemsTestResultGet = responseMemsTestResultGet;
    if (responseSliderStrokeGet != null)
      result.responseSliderStrokeGet = responseSliderStrokeGet;
    if (responseSliderStrokeSet != null)
      result.responseSliderStrokeSet = responseSliderStrokeSet;
    if (responseSliderStateGet != null)
      result.responseSliderStateGet = responseSliderStateGet;
    if (responseSliderCalibrate != null)
      result.responseSliderCalibrate = responseSliderCalibrate;
    if (responseSlideDiagStart != null)
      result.responseSlideDiagStart = responseSlideDiagStart;
    if (responseSlideDiagStatus != null)
      result.responseSlideDiagStatus = responseSlideDiagStatus;
    if (responseSlideDiagRead != null)
      result.responseSlideDiagRead = responseSlideDiagRead;
    if (responseHallCalibrationGet != null)
      result.responseHallCalibrationGet = responseHallCalibrationGet;
    if (responseSlideDiagStream != null)
      result.responseSlideDiagStream = responseSlideDiagStream;
    if (responseSpeedStatsGet != null)
      result.responseSpeedStatsGet = responseSpeedStatsGet;
    if (responseSpeedStatsSet != null)
      result.responseSpeedStatsSet = responseSpeedStatsSet;
    if (responseSlideSnapshotGet != null)
      result.responseSlideSnapshotGet = responseSlideSnapshotGet;
    if (responseSlideProfileTuningGet != null)
      result.responseSlideProfileTuningGet = responseSlideProfileTuningGet;
    if (responseSlideMaintResultGet != null)
      result.responseSlideMaintResultGet = responseSlideMaintResultGet;
    if (responseHspSetup != null) result.responseHspSetup = responseHspSetup;
    if (responseHspAdd != null) result.responseHspAdd = responseHspAdd;
    if (responseHspFlush != null) result.responseHspFlush = responseHspFlush;
    if (responseHspPlay != null) result.responseHspPlay = responseHspPlay;
    if (responseHspStop != null) result.responseHspStop = responseHspStop;
    if (responseHspPause != null) result.responseHspPause = responseHspPause;
    if (responseHspResume != null) result.responseHspResume = responseHspResume;
    if (responseHspStateGet != null)
      result.responseHspStateGet = responseHspStateGet;
    if (responseHspCurrentTimeSet != null)
      result.responseHspCurrentTimeSet = responseHspCurrentTimeSet;
    if (responseHspThresholdSet != null)
      result.responseHspThresholdSet = responseHspThresholdSet;
    if (responseHspPauseOnStarvingSet != null)
      result.responseHspPauseOnStarvingSet = responseHspPauseOnStarvingSet;
    if (responseHspPlaybackRateSet != null)
      result.responseHspPlaybackRateSet = responseHspPlaybackRateSet;
    if (responseHspLoopSet != null)
      result.responseHspLoopSet = responseHspLoopSet;
    if (responseHspJitterFilterSet != null)
      result.responseHspJitterFilterSet = responseHspJitterFilterSet;
    if (responseHspScriptSpeedSet != null)
      result.responseHspScriptSpeedSet = responseHspScriptSpeedSet;
    if (responseHvpSet != null) result.responseHvpSet = responseHvpSet;
    if (responseHvpStop != null) result.responseHvpStop = responseHvpStop;
    if (responseHvpStart != null) result.responseHvpStart = responseHvpStart;
    if (responseHvpStateGet != null)
      result.responseHvpStateGet = responseHvpStateGet;
    if (responseHrppStart != null) result.responseHrppStart = responseHrppStart;
    if (responseHrppStop != null) result.responseHrppStop = responseHrppStop;
    if (responseHrppAmplitudeSet != null)
      result.responseHrppAmplitudeSet = responseHrppAmplitudeSet;
    if (responseHrppPatternSet != null)
      result.responseHrppPatternSet = responseHrppPatternSet;
    if (responseHrppStateGet != null)
      result.responseHrppStateGet = responseHrppStateGet;
    if (responseHrppPatternsGet != null)
      result.responseHrppPatternsGet = responseHrppPatternsGet;
    if (responseHrppPlaybackRateSet != null)
      result.responseHrppPlaybackRateSet = responseHrppPlaybackRateSet;
    if (responseHrppPause != null) result.responseHrppPause = responseHrppPause;
    if (responseSettingsRegulatorGet != null)
      result.responseSettingsRegulatorGet = responseSettingsRegulatorGet;
    if (responseSettingsHallGet != null)
      result.responseSettingsHallGet = responseSettingsHallGet;
    if (responseSlideProfileGet != null)
      result.responseSlideProfileGet = responseSlideProfileGet;
    return result;
  }

  Response._();

  factory Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Response.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Response_Result> _Response_ResultByTag = {
    300: Response_Result.responseServerTimeGet,
    301: Response_Result.responseConnectedGet,
    304: Response_Result.responseFwStatusGet,
    606: Response_Result.responseConnectionKeyGet,
    620: Response_Result.responseWifiStatusGet,
    624: Response_Result.responseWifiScanResultsGet,
    700: Response_Result.responseModeGet,
    701: Response_Result.responseModeSet,
    709: Response_Result.responseClockOffsetSet,
    710: Response_Result.responseBatteryGet,
    712: Response_Result.responseClockOffsetGet,
    713: Response_Result.responseCapabilitiesGet,
    714: Response_Result.responseSessionIdsGet,
    717: Response_Result.responseConnectionModeGet,
    718: Response_Result.responsePublicInfoGet,
    720: Response_Result.responseHampStart,
    721: Response_Result.responseHampStop,
    723: Response_Result.responseHampVelocitySet,
    724: Response_Result.responseHampStateGet,
    725: Response_Result.responseHampZoneSet,
    800: Response_Result.responseSensorNotificationSet,
    801: Response_Result.responseSensorStateGet,
    802: Response_Result.responseSensorNotificationGet,
    810: Response_Result.responseMemsStatusGet,
    811: Response_Result.responseMemsRead,
    812: Response_Result.responseMemsTare,
    813: Response_Result.responseMemsTempGet,
    814: Response_Result.responseMemsReset,
    815: Response_Result.responseMemsRegister,
    816: Response_Result.responseMemsConfigSet,
    817: Response_Result.responseMemsTestStart,
    818: Response_Result.responseMemsTestResultGet,
    840: Response_Result.responseSliderStrokeGet,
    841: Response_Result.responseSliderStrokeSet,
    842: Response_Result.responseSliderStateGet,
    843: Response_Result.responseSliderCalibrate,
    844: Response_Result.responseSlideDiagStart,
    845: Response_Result.responseSlideDiagStatus,
    846: Response_Result.responseSlideDiagRead,
    848: Response_Result.responseHallCalibrationGet,
    850: Response_Result.responseSlideDiagStream,
    851: Response_Result.responseSpeedStatsGet,
    852: Response_Result.responseSpeedStatsSet,
    853: Response_Result.responseSlideSnapshotGet,
    855: Response_Result.responseSlideProfileTuningGet,
    856: Response_Result.responseSlideMaintResultGet,
    860: Response_Result.responseHspSetup,
    861: Response_Result.responseHspAdd,
    862: Response_Result.responseHspFlush,
    863: Response_Result.responseHspPlay,
    864: Response_Result.responseHspStop,
    865: Response_Result.responseHspPause,
    866: Response_Result.responseHspResume,
    867: Response_Result.responseHspStateGet,
    868: Response_Result.responseHspCurrentTimeSet,
    869: Response_Result.responseHspThresholdSet,
    870: Response_Result.responseHspPauseOnStarvingSet,
    871: Response_Result.responseHspPlaybackRateSet,
    872: Response_Result.responseHspLoopSet,
    873: Response_Result.responseHspJitterFilterSet,
    874: Response_Result.responseHspScriptSpeedSet,
    900: Response_Result.responseHvpSet,
    901: Response_Result.responseHvpStop,
    902: Response_Result.responseHvpStart,
    903: Response_Result.responseHvpStateGet,
    920: Response_Result.responseHrppStart,
    921: Response_Result.responseHrppStop,
    922: Response_Result.responseHrppAmplitudeSet,
    924: Response_Result.responseHrppPatternSet,
    925: Response_Result.responseHrppStateGet,
    926: Response_Result.responseHrppPatternsGet,
    927: Response_Result.responseHrppPlaybackRateSet,
    928: Response_Result.responseHrppPause,
    2015: Response_Result.responseSettingsRegulatorGet,
    2017: Response_Result.responseSettingsHallGet,
    2019: Response_Result.responseSlideProfileGet,
    0: Response_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..oo(0, [
      300,
      301,
      304,
      606,
      620,
      624,
      700,
      701,
      709,
      710,
      712,
      713,
      714,
      717,
      718,
      720,
      721,
      723,
      724,
      725,
      800,
      801,
      802,
      810,
      811,
      812,
      813,
      814,
      815,
      816,
      817,
      818,
      840,
      841,
      842,
      843,
      844,
      845,
      846,
      848,
      850,
      851,
      852,
      853,
      855,
      856,
      860,
      861,
      862,
      863,
      864,
      865,
      866,
      867,
      868,
      869,
      870,
      871,
      872,
      873,
      874,
      900,
      901,
      902,
      903,
      920,
      921,
      922,
      924,
      925,
      926,
      927,
      928,
      2015,
      2017,
      2019
    ])
    ..aI(1, _omitFieldNames ? '' : 'id', fieldType: $pb.PbFieldType.OU3)
    ..aOM<Error>(2, _omitFieldNames ? '' : 'error', subBuilder: Error.create)
    ..aOM<$1.ResponseServerTimeGet>(
        300, _omitFieldNames ? '' : 'responseServerTimeGet',
        subBuilder: $1.ResponseServerTimeGet.create)
    ..aOM<$1.ResponseConnectedGet>(
        301, _omitFieldNames ? '' : 'responseConnectedGet',
        subBuilder: $1.ResponseConnectedGet.create)
    ..aOM<$1.ResponseFwStatusGet>(
        304, _omitFieldNames ? '' : 'responseFwStatusGet',
        subBuilder: $1.ResponseFwStatusGet.create)
    ..aOM<$1.ResponseConnectionKeyGet>(
        606, _omitFieldNames ? '' : 'responseConnectionKeyGet',
        subBuilder: $1.ResponseConnectionKeyGet.create)
    ..aOM<$1.ResponseWifiStatusGet>(
        620, _omitFieldNames ? '' : 'responseWifiStatusGet',
        subBuilder: $1.ResponseWifiStatusGet.create)
    ..aOM<$1.ResponseWifiScanResultsGet>(
        624, _omitFieldNames ? '' : 'responseWifiScanResultsGet',
        subBuilder: $1.ResponseWifiScanResultsGet.create)
    ..aOM<$1.ResponseModeGet>(700, _omitFieldNames ? '' : 'responseModeGet',
        subBuilder: $1.ResponseModeGet.create)
    ..aOM<$1.ResponseModeSet>(701, _omitFieldNames ? '' : 'responseModeSet',
        subBuilder: $1.ResponseModeSet.create)
    ..aOM<$1.ResponseClockOffsetSet>(
        709, _omitFieldNames ? '' : 'responseClockOffsetSet',
        subBuilder: $1.ResponseClockOffsetSet.create)
    ..aOM<$1.ResponseBatteryGet>(
        710, _omitFieldNames ? '' : 'responseBatteryGet',
        subBuilder: $1.ResponseBatteryGet.create)
    ..aOM<$1.ResponseClockOffsetGet>(
        712, _omitFieldNames ? '' : 'responseClockOffsetGet',
        subBuilder: $1.ResponseClockOffsetGet.create)
    ..aOM<$1.ResponseCapabilitiesGet>(
        713, _omitFieldNames ? '' : 'responseCapabilitiesGet',
        subBuilder: $1.ResponseCapabilitiesGet.create)
    ..aOM<$1.ResponseSessionIdsGet>(
        714, _omitFieldNames ? '' : 'responseSessionIdsGet',
        subBuilder: $1.ResponseSessionIdsGet.create)
    ..aOM<$1.ResponseConnectionModeGet>(
        717, _omitFieldNames ? '' : 'responseConnectionModeGet',
        subBuilder: $1.ResponseConnectionModeGet.create)
    ..aOM<$1.ResponsePublicInfoGet>(
        718, _omitFieldNames ? '' : 'responsePublicInfoGet',
        subBuilder: $1.ResponsePublicInfoGet.create)
    ..aOM<$1.ResponseHampStart>(720, _omitFieldNames ? '' : 'responseHampStart',
        subBuilder: $1.ResponseHampStart.create)
    ..aOM<$1.ResponseHampStop>(721, _omitFieldNames ? '' : 'responseHampStop',
        subBuilder: $1.ResponseHampStop.create)
    ..aOM<$1.ResponseHampVelocitySet>(
        723, _omitFieldNames ? '' : 'responseHampVelocitySet',
        subBuilder: $1.ResponseHampVelocitySet.create)
    ..aOM<$1.ResponseHampStateGet>(
        724, _omitFieldNames ? '' : 'responseHampStateGet',
        subBuilder: $1.ResponseHampStateGet.create)
    ..aOM<$1.ResponseHampZoneSet>(
        725, _omitFieldNames ? '' : 'responseHampZoneSet',
        subBuilder: $1.ResponseHampZoneSet.create)
    ..aOM<$1.ResponseSensorNotificationSet>(
        800, _omitFieldNames ? '' : 'responseSensorNotificationSet',
        subBuilder: $1.ResponseSensorNotificationSet.create)
    ..aOM<$1.ResponseSensorStateGet>(
        801, _omitFieldNames ? '' : 'responseSensorStateGet',
        subBuilder: $1.ResponseSensorStateGet.create)
    ..aOM<$1.ResponseSensorNotificationGet>(
        802, _omitFieldNames ? '' : 'responseSensorNotificationGet',
        subBuilder: $1.ResponseSensorNotificationGet.create)
    ..aOM<$1.ResponseMemsStatusGet>(
        810, _omitFieldNames ? '' : 'responseMemsStatusGet',
        subBuilder: $1.ResponseMemsStatusGet.create)
    ..aOM<$1.ResponseMemsRead>(811, _omitFieldNames ? '' : 'responseMemsRead',
        subBuilder: $1.ResponseMemsRead.create)
    ..aOM<$1.ResponseMemsTare>(812, _omitFieldNames ? '' : 'responseMemsTare',
        subBuilder: $1.ResponseMemsTare.create)
    ..aOM<$1.ResponseMemsTempGet>(
        813, _omitFieldNames ? '' : 'responseMemsTempGet',
        subBuilder: $1.ResponseMemsTempGet.create)
    ..aOM<$1.ResponseMemsReset>(814, _omitFieldNames ? '' : 'responseMemsReset',
        subBuilder: $1.ResponseMemsReset.create)
    ..aOM<$1.ResponseMemsRegister>(
        815, _omitFieldNames ? '' : 'responseMemsRegister',
        subBuilder: $1.ResponseMemsRegister.create)
    ..aOM<$1.ResponseMemsConfigSet>(
        816, _omitFieldNames ? '' : 'responseMemsConfigSet',
        subBuilder: $1.ResponseMemsConfigSet.create)
    ..aOM<$1.ResponseMemsTestStart>(
        817, _omitFieldNames ? '' : 'responseMemsTestStart',
        subBuilder: $1.ResponseMemsTestStart.create)
    ..aOM<$1.ResponseMemsTestResultGet>(
        818, _omitFieldNames ? '' : 'responseMemsTestResultGet',
        subBuilder: $1.ResponseMemsTestResultGet.create)
    ..aOM<$1.ResponseSliderStrokeGet>(
        840, _omitFieldNames ? '' : 'responseSliderStrokeGet',
        subBuilder: $1.ResponseSliderStrokeGet.create)
    ..aOM<$1.ResponseSliderStrokeSet>(
        841, _omitFieldNames ? '' : 'responseSliderStrokeSet',
        subBuilder: $1.ResponseSliderStrokeSet.create)
    ..aOM<$1.ResponseSliderStateGet>(
        842, _omitFieldNames ? '' : 'responseSliderStateGet',
        subBuilder: $1.ResponseSliderStateGet.create)
    ..aOM<$1.ResponseSliderCalibrate>(
        843, _omitFieldNames ? '' : 'responseSliderCalibrate',
        subBuilder: $1.ResponseSliderCalibrate.create)
    ..aOM<$1.ResponseSlideDiagStart>(
        844, _omitFieldNames ? '' : 'responseSlideDiagStart',
        subBuilder: $1.ResponseSlideDiagStart.create)
    ..aOM<$1.ResponseSlideDiagStatus>(
        845, _omitFieldNames ? '' : 'responseSlideDiagStatus',
        subBuilder: $1.ResponseSlideDiagStatus.create)
    ..aOM<$1.ResponseSlideDiagRead>(
        846, _omitFieldNames ? '' : 'responseSlideDiagRead',
        subBuilder: $1.ResponseSlideDiagRead.create)
    ..aOM<$1.ResponseHallCalibrationGet>(
        848, _omitFieldNames ? '' : 'responseHallCalibrationGet',
        subBuilder: $1.ResponseHallCalibrationGet.create)
    ..aOM<$1.ResponseSlideDiagStream>(
        850, _omitFieldNames ? '' : 'responseSlideDiagStream',
        subBuilder: $1.ResponseSlideDiagStream.create)
    ..aOM<$1.ResponseSpeedStatsGet>(
        851, _omitFieldNames ? '' : 'responseSpeedStatsGet',
        subBuilder: $1.ResponseSpeedStatsGet.create)
    ..aOM<$1.ResponseSpeedStatsSet>(
        852, _omitFieldNames ? '' : 'responseSpeedStatsSet',
        subBuilder: $1.ResponseSpeedStatsSet.create)
    ..aOM<$1.ResponseSlideSnapshotGet>(
        853, _omitFieldNames ? '' : 'responseSlideSnapshotGet',
        subBuilder: $1.ResponseSlideSnapshotGet.create)
    ..aOM<$1.ResponseSlideProfileTuningGet>(
        855, _omitFieldNames ? '' : 'responseSlideProfileTuningGet',
        subBuilder: $1.ResponseSlideProfileTuningGet.create)
    ..aOM<$1.ResponseSlideMaintResultGet>(
        856, _omitFieldNames ? '' : 'responseSlideMaintResultGet',
        subBuilder: $1.ResponseSlideMaintResultGet.create)
    ..aOM<$1.ResponseHspSetup>(860, _omitFieldNames ? '' : 'responseHspSetup',
        subBuilder: $1.ResponseHspSetup.create)
    ..aOM<$1.ResponseHspAdd>(861, _omitFieldNames ? '' : 'responseHspAdd',
        subBuilder: $1.ResponseHspAdd.create)
    ..aOM<$1.ResponseHspFlush>(862, _omitFieldNames ? '' : 'responseHspFlush',
        subBuilder: $1.ResponseHspFlush.create)
    ..aOM<$1.ResponseHspPlay>(863, _omitFieldNames ? '' : 'responseHspPlay',
        subBuilder: $1.ResponseHspPlay.create)
    ..aOM<$1.ResponseHspStop>(864, _omitFieldNames ? '' : 'responseHspStop',
        subBuilder: $1.ResponseHspStop.create)
    ..aOM<$1.ResponseHspPause>(865, _omitFieldNames ? '' : 'responseHspPause',
        subBuilder: $1.ResponseHspPause.create)
    ..aOM<$1.ResponseHspResume>(866, _omitFieldNames ? '' : 'responseHspResume',
        subBuilder: $1.ResponseHspResume.create)
    ..aOM<$1.ResponseHspStateGet>(
        867, _omitFieldNames ? '' : 'responseHspStateGet',
        subBuilder: $1.ResponseHspStateGet.create)
    ..aOM<$1.ResponseHspCurrentTimeSet>(
        868, _omitFieldNames ? '' : 'responseHspCurrentTimeSet',
        subBuilder: $1.ResponseHspCurrentTimeSet.create)
    ..aOM<$1.ResponseHspThresholdSet>(
        869, _omitFieldNames ? '' : 'responseHspThresholdSet',
        subBuilder: $1.ResponseHspThresholdSet.create)
    ..aOM<$1.ResponseHspPauseOnStarvingSet>(
        870, _omitFieldNames ? '' : 'responseHspPauseOnStarvingSet',
        subBuilder: $1.ResponseHspPauseOnStarvingSet.create)
    ..aOM<$1.ResponseHspPlaybackRateSet>(
        871, _omitFieldNames ? '' : 'responseHspPlaybackRateSet',
        subBuilder: $1.ResponseHspPlaybackRateSet.create)
    ..aOM<$1.ResponseHspLoopSet>(
        872, _omitFieldNames ? '' : 'responseHspLoopSet',
        subBuilder: $1.ResponseHspLoopSet.create)
    ..aOM<$1.ResponseHspJitterFilterSet>(
        873, _omitFieldNames ? '' : 'responseHspJitterFilterSet',
        subBuilder: $1.ResponseHspJitterFilterSet.create)
    ..aOM<$1.ResponseHspScriptSpeedSet>(
        874, _omitFieldNames ? '' : 'responseHspScriptSpeedSet',
        subBuilder: $1.ResponseHspScriptSpeedSet.create)
    ..aOM<$1.ResponseHvpSet>(900, _omitFieldNames ? '' : 'responseHvpSet',
        subBuilder: $1.ResponseHvpSet.create)
    ..aOM<$1.ResponseHvpStop>(901, _omitFieldNames ? '' : 'responseHvpStop',
        subBuilder: $1.ResponseHvpStop.create)
    ..aOM<$1.ResponseHvpStart>(902, _omitFieldNames ? '' : 'responseHvpStart',
        subBuilder: $1.ResponseHvpStart.create)
    ..aOM<$1.ResponseHvpStateGet>(
        903, _omitFieldNames ? '' : 'responseHvpStateGet',
        subBuilder: $1.ResponseHvpStateGet.create)
    ..aOM<$1.ResponseHrppStart>(920, _omitFieldNames ? '' : 'responseHrppStart',
        subBuilder: $1.ResponseHrppStart.create)
    ..aOM<$1.ResponseHrppStop>(921, _omitFieldNames ? '' : 'responseHrppStop',
        subBuilder: $1.ResponseHrppStop.create)
    ..aOM<$1.ResponseHrppAmplitudeSet>(
        922, _omitFieldNames ? '' : 'responseHrppAmplitudeSet',
        subBuilder: $1.ResponseHrppAmplitudeSet.create)
    ..aOM<$1.ResponseHrppPatternSet>(
        924, _omitFieldNames ? '' : 'responseHrppPatternSet',
        subBuilder: $1.ResponseHrppPatternSet.create)
    ..aOM<$1.ResponseHrppStateGet>(
        925, _omitFieldNames ? '' : 'responseHrppStateGet',
        subBuilder: $1.ResponseHrppStateGet.create)
    ..aOM<$1.ResponseHrppPatternsGet>(
        926, _omitFieldNames ? '' : 'responseHrppPatternsGet',
        subBuilder: $1.ResponseHrppPatternsGet.create)
    ..aOM<$1.ResponseHrppPlaybackRateSet>(
        927, _omitFieldNames ? '' : 'responseHrppPlaybackRateSet',
        subBuilder: $1.ResponseHrppPlaybackRateSet.create)
    ..aOM<$1.ResponseHrppPause>(928, _omitFieldNames ? '' : 'responseHrppPause',
        subBuilder: $1.ResponseHrppPause.create)
    ..aOM<$1.ResponseSettingsRegulatorGet>(
        2015, _omitFieldNames ? '' : 'responseSettingsRegulatorGet',
        subBuilder: $1.ResponseSettingsRegulatorGet.create)
    ..aOM<$1.ResponseSettingsHallGet>(
        2017, _omitFieldNames ? '' : 'responseSettingsHallGet',
        subBuilder: $1.ResponseSettingsHallGet.create)
    ..aOM<$1.ResponseSlideProfileGet>(
        2019, _omitFieldNames ? '' : 'responseSlideProfileGet',
        subBuilder: $1.ResponseSlideProfileGet.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Response copyWith(void Function(Response) updates) =>
      super.copyWith((message) => updates(message as Response)) as Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Response create() => Response._();
  @$core.override
  Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Response>(create);
  static Response? _defaultInstance;

  @$pb.TagNumber(300)
  @$pb.TagNumber(301)
  @$pb.TagNumber(304)
  @$pb.TagNumber(606)
  @$pb.TagNumber(620)
  @$pb.TagNumber(624)
  @$pb.TagNumber(700)
  @$pb.TagNumber(701)
  @$pb.TagNumber(709)
  @$pb.TagNumber(710)
  @$pb.TagNumber(712)
  @$pb.TagNumber(713)
  @$pb.TagNumber(714)
  @$pb.TagNumber(717)
  @$pb.TagNumber(718)
  @$pb.TagNumber(720)
  @$pb.TagNumber(721)
  @$pb.TagNumber(723)
  @$pb.TagNumber(724)
  @$pb.TagNumber(725)
  @$pb.TagNumber(800)
  @$pb.TagNumber(801)
  @$pb.TagNumber(802)
  @$pb.TagNumber(810)
  @$pb.TagNumber(811)
  @$pb.TagNumber(812)
  @$pb.TagNumber(813)
  @$pb.TagNumber(814)
  @$pb.TagNumber(815)
  @$pb.TagNumber(816)
  @$pb.TagNumber(817)
  @$pb.TagNumber(818)
  @$pb.TagNumber(840)
  @$pb.TagNumber(841)
  @$pb.TagNumber(842)
  @$pb.TagNumber(843)
  @$pb.TagNumber(844)
  @$pb.TagNumber(845)
  @$pb.TagNumber(846)
  @$pb.TagNumber(848)
  @$pb.TagNumber(850)
  @$pb.TagNumber(851)
  @$pb.TagNumber(852)
  @$pb.TagNumber(853)
  @$pb.TagNumber(855)
  @$pb.TagNumber(856)
  @$pb.TagNumber(860)
  @$pb.TagNumber(861)
  @$pb.TagNumber(862)
  @$pb.TagNumber(863)
  @$pb.TagNumber(864)
  @$pb.TagNumber(865)
  @$pb.TagNumber(866)
  @$pb.TagNumber(867)
  @$pb.TagNumber(868)
  @$pb.TagNumber(869)
  @$pb.TagNumber(870)
  @$pb.TagNumber(871)
  @$pb.TagNumber(872)
  @$pb.TagNumber(873)
  @$pb.TagNumber(874)
  @$pb.TagNumber(900)
  @$pb.TagNumber(901)
  @$pb.TagNumber(902)
  @$pb.TagNumber(903)
  @$pb.TagNumber(920)
  @$pb.TagNumber(921)
  @$pb.TagNumber(922)
  @$pb.TagNumber(924)
  @$pb.TagNumber(925)
  @$pb.TagNumber(926)
  @$pb.TagNumber(927)
  @$pb.TagNumber(928)
  @$pb.TagNumber(2015)
  @$pb.TagNumber(2017)
  @$pb.TagNumber(2019)
  Response_Result whichResult() => _Response_ResultByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(300)
  @$pb.TagNumber(301)
  @$pb.TagNumber(304)
  @$pb.TagNumber(606)
  @$pb.TagNumber(620)
  @$pb.TagNumber(624)
  @$pb.TagNumber(700)
  @$pb.TagNumber(701)
  @$pb.TagNumber(709)
  @$pb.TagNumber(710)
  @$pb.TagNumber(712)
  @$pb.TagNumber(713)
  @$pb.TagNumber(714)
  @$pb.TagNumber(717)
  @$pb.TagNumber(718)
  @$pb.TagNumber(720)
  @$pb.TagNumber(721)
  @$pb.TagNumber(723)
  @$pb.TagNumber(724)
  @$pb.TagNumber(725)
  @$pb.TagNumber(800)
  @$pb.TagNumber(801)
  @$pb.TagNumber(802)
  @$pb.TagNumber(810)
  @$pb.TagNumber(811)
  @$pb.TagNumber(812)
  @$pb.TagNumber(813)
  @$pb.TagNumber(814)
  @$pb.TagNumber(815)
  @$pb.TagNumber(816)
  @$pb.TagNumber(817)
  @$pb.TagNumber(818)
  @$pb.TagNumber(840)
  @$pb.TagNumber(841)
  @$pb.TagNumber(842)
  @$pb.TagNumber(843)
  @$pb.TagNumber(844)
  @$pb.TagNumber(845)
  @$pb.TagNumber(846)
  @$pb.TagNumber(848)
  @$pb.TagNumber(850)
  @$pb.TagNumber(851)
  @$pb.TagNumber(852)
  @$pb.TagNumber(853)
  @$pb.TagNumber(855)
  @$pb.TagNumber(856)
  @$pb.TagNumber(860)
  @$pb.TagNumber(861)
  @$pb.TagNumber(862)
  @$pb.TagNumber(863)
  @$pb.TagNumber(864)
  @$pb.TagNumber(865)
  @$pb.TagNumber(866)
  @$pb.TagNumber(867)
  @$pb.TagNumber(868)
  @$pb.TagNumber(869)
  @$pb.TagNumber(870)
  @$pb.TagNumber(871)
  @$pb.TagNumber(872)
  @$pb.TagNumber(873)
  @$pb.TagNumber(874)
  @$pb.TagNumber(900)
  @$pb.TagNumber(901)
  @$pb.TagNumber(902)
  @$pb.TagNumber(903)
  @$pb.TagNumber(920)
  @$pb.TagNumber(921)
  @$pb.TagNumber(922)
  @$pb.TagNumber(924)
  @$pb.TagNumber(925)
  @$pb.TagNumber(926)
  @$pb.TagNumber(927)
  @$pb.TagNumber(928)
  @$pb.TagNumber(2015)
  @$pb.TagNumber(2017)
  @$pb.TagNumber(2019)
  void clearResult() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  Error get error => $_getN(1);
  @$pb.TagNumber(2)
  set error(Error value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => $_clearField(2);
  @$pb.TagNumber(2)
  Error ensureError() => $_ensure(1);

  /// Server Response that are public starts with 300
  @$pb.TagNumber(300)
  $1.ResponseServerTimeGet get responseServerTimeGet => $_getN(2);
  @$pb.TagNumber(300)
  set responseServerTimeGet($1.ResponseServerTimeGet value) =>
      $_setField(300, value);
  @$pb.TagNumber(300)
  $core.bool hasResponseServerTimeGet() => $_has(2);
  @$pb.TagNumber(300)
  void clearResponseServerTimeGet() => $_clearField(300);
  @$pb.TagNumber(300)
  $1.ResponseServerTimeGet ensureResponseServerTimeGet() => $_ensure(2);

  @$pb.TagNumber(301)
  $1.ResponseConnectedGet get responseConnectedGet => $_getN(3);
  @$pb.TagNumber(301)
  set responseConnectedGet($1.ResponseConnectedGet value) =>
      $_setField(301, value);
  @$pb.TagNumber(301)
  $core.bool hasResponseConnectedGet() => $_has(3);
  @$pb.TagNumber(301)
  void clearResponseConnectedGet() => $_clearField(301);
  @$pb.TagNumber(301)
  $1.ResponseConnectedGet ensureResponseConnectedGet() => $_ensure(3);

  @$pb.TagNumber(304)
  $1.ResponseFwStatusGet get responseFwStatusGet => $_getN(4);
  @$pb.TagNumber(304)
  set responseFwStatusGet($1.ResponseFwStatusGet value) =>
      $_setField(304, value);
  @$pb.TagNumber(304)
  $core.bool hasResponseFwStatusGet() => $_has(4);
  @$pb.TagNumber(304)
  void clearResponseFwStatusGet() => $_clearField(304);
  @$pb.TagNumber(304)
  $1.ResponseFwStatusGet ensureResponseFwStatusGet() => $_ensure(4);

  @$pb.TagNumber(606)
  $1.ResponseConnectionKeyGet get responseConnectionKeyGet => $_getN(5);
  @$pb.TagNumber(606)
  set responseConnectionKeyGet($1.ResponseConnectionKeyGet value) =>
      $_setField(606, value);
  @$pb.TagNumber(606)
  $core.bool hasResponseConnectionKeyGet() => $_has(5);
  @$pb.TagNumber(606)
  void clearResponseConnectionKeyGet() => $_clearField(606);
  @$pb.TagNumber(606)
  $1.ResponseConnectionKeyGet ensureResponseConnectionKeyGet() => $_ensure(5);

  @$pb.TagNumber(620)
  $1.ResponseWifiStatusGet get responseWifiStatusGet => $_getN(6);
  @$pb.TagNumber(620)
  set responseWifiStatusGet($1.ResponseWifiStatusGet value) =>
      $_setField(620, value);
  @$pb.TagNumber(620)
  $core.bool hasResponseWifiStatusGet() => $_has(6);
  @$pb.TagNumber(620)
  void clearResponseWifiStatusGet() => $_clearField(620);
  @$pb.TagNumber(620)
  $1.ResponseWifiStatusGet ensureResponseWifiStatusGet() => $_ensure(6);

  @$pb.TagNumber(624)
  $1.ResponseWifiScanResultsGet get responseWifiScanResultsGet => $_getN(7);
  @$pb.TagNumber(624)
  set responseWifiScanResultsGet($1.ResponseWifiScanResultsGet value) =>
      $_setField(624, value);
  @$pb.TagNumber(624)
  $core.bool hasResponseWifiScanResultsGet() => $_has(7);
  @$pb.TagNumber(624)
  void clearResponseWifiScanResultsGet() => $_clearField(624);
  @$pb.TagNumber(624)
  $1.ResponseWifiScanResultsGet ensureResponseWifiScanResultsGet() =>
      $_ensure(7);

  /// client public responses starts at 700 // [PRIVATE]
  @$pb.TagNumber(700)
  $1.ResponseModeGet get responseModeGet => $_getN(8);
  @$pb.TagNumber(700)
  set responseModeGet($1.ResponseModeGet value) => $_setField(700, value);
  @$pb.TagNumber(700)
  $core.bool hasResponseModeGet() => $_has(8);
  @$pb.TagNumber(700)
  void clearResponseModeGet() => $_clearField(700);
  @$pb.TagNumber(700)
  $1.ResponseModeGet ensureResponseModeGet() => $_ensure(8);

  @$pb.TagNumber(701)
  $1.ResponseModeSet get responseModeSet => $_getN(9);
  @$pb.TagNumber(701)
  set responseModeSet($1.ResponseModeSet value) => $_setField(701, value);
  @$pb.TagNumber(701)
  $core.bool hasResponseModeSet() => $_has(9);
  @$pb.TagNumber(701)
  void clearResponseModeSet() => $_clearField(701);
  @$pb.TagNumber(701)
  $1.ResponseModeSet ensureResponseModeSet() => $_ensure(9);

  @$pb.TagNumber(709)
  $1.ResponseClockOffsetSet get responseClockOffsetSet => $_getN(10);
  @$pb.TagNumber(709)
  set responseClockOffsetSet($1.ResponseClockOffsetSet value) =>
      $_setField(709, value);
  @$pb.TagNumber(709)
  $core.bool hasResponseClockOffsetSet() => $_has(10);
  @$pb.TagNumber(709)
  void clearResponseClockOffsetSet() => $_clearField(709);
  @$pb.TagNumber(709)
  $1.ResponseClockOffsetSet ensureResponseClockOffsetSet() => $_ensure(10);

  @$pb.TagNumber(710)
  $1.ResponseBatteryGet get responseBatteryGet => $_getN(11);
  @$pb.TagNumber(710)
  set responseBatteryGet($1.ResponseBatteryGet value) => $_setField(710, value);
  @$pb.TagNumber(710)
  $core.bool hasResponseBatteryGet() => $_has(11);
  @$pb.TagNumber(710)
  void clearResponseBatteryGet() => $_clearField(710);
  @$pb.TagNumber(710)
  $1.ResponseBatteryGet ensureResponseBatteryGet() => $_ensure(11);

  @$pb.TagNumber(712)
  $1.ResponseClockOffsetGet get responseClockOffsetGet => $_getN(12);
  @$pb.TagNumber(712)
  set responseClockOffsetGet($1.ResponseClockOffsetGet value) =>
      $_setField(712, value);
  @$pb.TagNumber(712)
  $core.bool hasResponseClockOffsetGet() => $_has(12);
  @$pb.TagNumber(712)
  void clearResponseClockOffsetGet() => $_clearField(712);
  @$pb.TagNumber(712)
  $1.ResponseClockOffsetGet ensureResponseClockOffsetGet() => $_ensure(12);

  @$pb.TagNumber(713)
  $1.ResponseCapabilitiesGet get responseCapabilitiesGet => $_getN(13);
  @$pb.TagNumber(713)
  set responseCapabilitiesGet($1.ResponseCapabilitiesGet value) =>
      $_setField(713, value);
  @$pb.TagNumber(713)
  $core.bool hasResponseCapabilitiesGet() => $_has(13);
  @$pb.TagNumber(713)
  void clearResponseCapabilitiesGet() => $_clearField(713);
  @$pb.TagNumber(713)
  $1.ResponseCapabilitiesGet ensureResponseCapabilitiesGet() => $_ensure(13);

  @$pb.TagNumber(714)
  $1.ResponseSessionIdsGet get responseSessionIdsGet => $_getN(14);
  @$pb.TagNumber(714)
  set responseSessionIdsGet($1.ResponseSessionIdsGet value) =>
      $_setField(714, value);
  @$pb.TagNumber(714)
  $core.bool hasResponseSessionIdsGet() => $_has(14);
  @$pb.TagNumber(714)
  void clearResponseSessionIdsGet() => $_clearField(714);
  @$pb.TagNumber(714)
  $1.ResponseSessionIdsGet ensureResponseSessionIdsGet() => $_ensure(14);

  @$pb.TagNumber(717)
  $1.ResponseConnectionModeGet get responseConnectionModeGet => $_getN(15);
  @$pb.TagNumber(717)
  set responseConnectionModeGet($1.ResponseConnectionModeGet value) =>
      $_setField(717, value);
  @$pb.TagNumber(717)
  $core.bool hasResponseConnectionModeGet() => $_has(15);
  @$pb.TagNumber(717)
  void clearResponseConnectionModeGet() => $_clearField(717);
  @$pb.TagNumber(717)
  $1.ResponseConnectionModeGet ensureResponseConnectionModeGet() =>
      $_ensure(15);

  @$pb.TagNumber(718)
  $1.ResponsePublicInfoGet get responsePublicInfoGet => $_getN(16);
  @$pb.TagNumber(718)
  set responsePublicInfoGet($1.ResponsePublicInfoGet value) =>
      $_setField(718, value);
  @$pb.TagNumber(718)
  $core.bool hasResponsePublicInfoGet() => $_has(16);
  @$pb.TagNumber(718)
  void clearResponsePublicInfoGet() => $_clearField(718);
  @$pb.TagNumber(718)
  $1.ResponsePublicInfoGet ensureResponsePublicInfoGet() => $_ensure(16);

  /// HAMP - 720
  @$pb.TagNumber(720)
  $1.ResponseHampStart get responseHampStart => $_getN(17);
  @$pb.TagNumber(720)
  set responseHampStart($1.ResponseHampStart value) => $_setField(720, value);
  @$pb.TagNumber(720)
  $core.bool hasResponseHampStart() => $_has(17);
  @$pb.TagNumber(720)
  void clearResponseHampStart() => $_clearField(720);
  @$pb.TagNumber(720)
  $1.ResponseHampStart ensureResponseHampStart() => $_ensure(17);

  @$pb.TagNumber(721)
  $1.ResponseHampStop get responseHampStop => $_getN(18);
  @$pb.TagNumber(721)
  set responseHampStop($1.ResponseHampStop value) => $_setField(721, value);
  @$pb.TagNumber(721)
  $core.bool hasResponseHampStop() => $_has(18);
  @$pb.TagNumber(721)
  void clearResponseHampStop() => $_clearField(721);
  @$pb.TagNumber(721)
  $1.ResponseHampStop ensureResponseHampStop() => $_ensure(18);

  @$pb.TagNumber(723)
  $1.ResponseHampVelocitySet get responseHampVelocitySet => $_getN(19);
  @$pb.TagNumber(723)
  set responseHampVelocitySet($1.ResponseHampVelocitySet value) =>
      $_setField(723, value);
  @$pb.TagNumber(723)
  $core.bool hasResponseHampVelocitySet() => $_has(19);
  @$pb.TagNumber(723)
  void clearResponseHampVelocitySet() => $_clearField(723);
  @$pb.TagNumber(723)
  $1.ResponseHampVelocitySet ensureResponseHampVelocitySet() => $_ensure(19);

  @$pb.TagNumber(724)
  $1.ResponseHampStateGet get responseHampStateGet => $_getN(20);
  @$pb.TagNumber(724)
  set responseHampStateGet($1.ResponseHampStateGet value) =>
      $_setField(724, value);
  @$pb.TagNumber(724)
  $core.bool hasResponseHampStateGet() => $_has(20);
  @$pb.TagNumber(724)
  void clearResponseHampStateGet() => $_clearField(724);
  @$pb.TagNumber(724)
  $1.ResponseHampStateGet ensureResponseHampStateGet() => $_ensure(20);

  @$pb.TagNumber(725)
  $1.ResponseHampZoneSet get responseHampZoneSet => $_getN(21);
  @$pb.TagNumber(725)
  set responseHampZoneSet($1.ResponseHampZoneSet value) =>
      $_setField(725, value);
  @$pb.TagNumber(725)
  $core.bool hasResponseHampZoneSet() => $_has(21);
  @$pb.TagNumber(725)
  void clearResponseHampZoneSet() => $_clearField(725);
  @$pb.TagNumber(725)
  $1.ResponseHampZoneSet ensureResponseHampZoneSet() => $_ensure(21);

  /// HDSP - 740
  /// Replies OK or ERROR only
  /// Sensor - 800
  @$pb.TagNumber(800)
  $1.ResponseSensorNotificationSet get responseSensorNotificationSet =>
      $_getN(22);
  @$pb.TagNumber(800)
  set responseSensorNotificationSet($1.ResponseSensorNotificationSet value) =>
      $_setField(800, value);
  @$pb.TagNumber(800)
  $core.bool hasResponseSensorNotificationSet() => $_has(22);
  @$pb.TagNumber(800)
  void clearResponseSensorNotificationSet() => $_clearField(800);
  @$pb.TagNumber(800)
  $1.ResponseSensorNotificationSet ensureResponseSensorNotificationSet() =>
      $_ensure(22);

  @$pb.TagNumber(801)
  $1.ResponseSensorStateGet get responseSensorStateGet => $_getN(23);
  @$pb.TagNumber(801)
  set responseSensorStateGet($1.ResponseSensorStateGet value) =>
      $_setField(801, value);
  @$pb.TagNumber(801)
  $core.bool hasResponseSensorStateGet() => $_has(23);
  @$pb.TagNumber(801)
  void clearResponseSensorStateGet() => $_clearField(801);
  @$pb.TagNumber(801)
  $1.ResponseSensorStateGet ensureResponseSensorStateGet() => $_ensure(23);

  @$pb.TagNumber(802)
  $1.ResponseSensorNotificationGet get responseSensorNotificationGet =>
      $_getN(24);
  @$pb.TagNumber(802)
  set responseSensorNotificationGet($1.ResponseSensorNotificationGet value) =>
      $_setField(802, value);
  @$pb.TagNumber(802)
  $core.bool hasResponseSensorNotificationGet() => $_has(24);
  @$pb.TagNumber(802)
  void clearResponseSensorNotificationGet() => $_clearField(802);
  @$pb.TagNumber(802)
  $1.ResponseSensorNotificationGet ensureResponseSensorNotificationGet() =>
      $_ensure(24);

  /// MEMS force strip 810-818 - WORK IN PROGRESS, NOT FINALIZED: may change or be removed (see messages.proto)
  @$pb.TagNumber(810)
  $1.ResponseMemsStatusGet get responseMemsStatusGet => $_getN(25);
  @$pb.TagNumber(810)
  set responseMemsStatusGet($1.ResponseMemsStatusGet value) =>
      $_setField(810, value);
  @$pb.TagNumber(810)
  $core.bool hasResponseMemsStatusGet() => $_has(25);
  @$pb.TagNumber(810)
  void clearResponseMemsStatusGet() => $_clearField(810);
  @$pb.TagNumber(810)
  $1.ResponseMemsStatusGet ensureResponseMemsStatusGet() => $_ensure(25);

  @$pb.TagNumber(811)
  $1.ResponseMemsRead get responseMemsRead => $_getN(26);
  @$pb.TagNumber(811)
  set responseMemsRead($1.ResponseMemsRead value) => $_setField(811, value);
  @$pb.TagNumber(811)
  $core.bool hasResponseMemsRead() => $_has(26);
  @$pb.TagNumber(811)
  void clearResponseMemsRead() => $_clearField(811);
  @$pb.TagNumber(811)
  $1.ResponseMemsRead ensureResponseMemsRead() => $_ensure(26);

  @$pb.TagNumber(812)
  $1.ResponseMemsTare get responseMemsTare => $_getN(27);
  @$pb.TagNumber(812)
  set responseMemsTare($1.ResponseMemsTare value) => $_setField(812, value);
  @$pb.TagNumber(812)
  $core.bool hasResponseMemsTare() => $_has(27);
  @$pb.TagNumber(812)
  void clearResponseMemsTare() => $_clearField(812);
  @$pb.TagNumber(812)
  $1.ResponseMemsTare ensureResponseMemsTare() => $_ensure(27);

  @$pb.TagNumber(813)
  $1.ResponseMemsTempGet get responseMemsTempGet => $_getN(28);
  @$pb.TagNumber(813)
  set responseMemsTempGet($1.ResponseMemsTempGet value) =>
      $_setField(813, value);
  @$pb.TagNumber(813)
  $core.bool hasResponseMemsTempGet() => $_has(28);
  @$pb.TagNumber(813)
  void clearResponseMemsTempGet() => $_clearField(813);
  @$pb.TagNumber(813)
  $1.ResponseMemsTempGet ensureResponseMemsTempGet() => $_ensure(28);

  @$pb.TagNumber(814)
  $1.ResponseMemsReset get responseMemsReset => $_getN(29);
  @$pb.TagNumber(814)
  set responseMemsReset($1.ResponseMemsReset value) => $_setField(814, value);
  @$pb.TagNumber(814)
  $core.bool hasResponseMemsReset() => $_has(29);
  @$pb.TagNumber(814)
  void clearResponseMemsReset() => $_clearField(814);
  @$pb.TagNumber(814)
  $1.ResponseMemsReset ensureResponseMemsReset() => $_ensure(29);

  @$pb.TagNumber(815)
  $1.ResponseMemsRegister get responseMemsRegister => $_getN(30);
  @$pb.TagNumber(815)
  set responseMemsRegister($1.ResponseMemsRegister value) =>
      $_setField(815, value);
  @$pb.TagNumber(815)
  $core.bool hasResponseMemsRegister() => $_has(30);
  @$pb.TagNumber(815)
  void clearResponseMemsRegister() => $_clearField(815);
  @$pb.TagNumber(815)
  $1.ResponseMemsRegister ensureResponseMemsRegister() => $_ensure(30);

  @$pb.TagNumber(816)
  $1.ResponseMemsConfigSet get responseMemsConfigSet => $_getN(31);
  @$pb.TagNumber(816)
  set responseMemsConfigSet($1.ResponseMemsConfigSet value) =>
      $_setField(816, value);
  @$pb.TagNumber(816)
  $core.bool hasResponseMemsConfigSet() => $_has(31);
  @$pb.TagNumber(816)
  void clearResponseMemsConfigSet() => $_clearField(816);
  @$pb.TagNumber(816)
  $1.ResponseMemsConfigSet ensureResponseMemsConfigSet() => $_ensure(31);

  @$pb.TagNumber(817)
  $1.ResponseMemsTestStart get responseMemsTestStart => $_getN(32);
  @$pb.TagNumber(817)
  set responseMemsTestStart($1.ResponseMemsTestStart value) =>
      $_setField(817, value);
  @$pb.TagNumber(817)
  $core.bool hasResponseMemsTestStart() => $_has(32);
  @$pb.TagNumber(817)
  void clearResponseMemsTestStart() => $_clearField(817);
  @$pb.TagNumber(817)
  $1.ResponseMemsTestStart ensureResponseMemsTestStart() => $_ensure(32);

  @$pb.TagNumber(818)
  $1.ResponseMemsTestResultGet get responseMemsTestResultGet => $_getN(33);
  @$pb.TagNumber(818)
  set responseMemsTestResultGet($1.ResponseMemsTestResultGet value) =>
      $_setField(818, value);
  @$pb.TagNumber(818)
  $core.bool hasResponseMemsTestResultGet() => $_has(33);
  @$pb.TagNumber(818)
  void clearResponseMemsTestResultGet() => $_clearField(818);
  @$pb.TagNumber(818)
  $1.ResponseMemsTestResultGet ensureResponseMemsTestResultGet() =>
      $_ensure(33);

  /// Slide - 840
  @$pb.TagNumber(840)
  $1.ResponseSliderStrokeGet get responseSliderStrokeGet => $_getN(34);
  @$pb.TagNumber(840)
  set responseSliderStrokeGet($1.ResponseSliderStrokeGet value) =>
      $_setField(840, value);
  @$pb.TagNumber(840)
  $core.bool hasResponseSliderStrokeGet() => $_has(34);
  @$pb.TagNumber(840)
  void clearResponseSliderStrokeGet() => $_clearField(840);
  @$pb.TagNumber(840)
  $1.ResponseSliderStrokeGet ensureResponseSliderStrokeGet() => $_ensure(34);

  @$pb.TagNumber(841)
  $1.ResponseSliderStrokeSet get responseSliderStrokeSet => $_getN(35);
  @$pb.TagNumber(841)
  set responseSliderStrokeSet($1.ResponseSliderStrokeSet value) =>
      $_setField(841, value);
  @$pb.TagNumber(841)
  $core.bool hasResponseSliderStrokeSet() => $_has(35);
  @$pb.TagNumber(841)
  void clearResponseSliderStrokeSet() => $_clearField(841);
  @$pb.TagNumber(841)
  $1.ResponseSliderStrokeSet ensureResponseSliderStrokeSet() => $_ensure(35);

  @$pb.TagNumber(842)
  $1.ResponseSliderStateGet get responseSliderStateGet => $_getN(36);
  @$pb.TagNumber(842)
  set responseSliderStateGet($1.ResponseSliderStateGet value) =>
      $_setField(842, value);
  @$pb.TagNumber(842)
  $core.bool hasResponseSliderStateGet() => $_has(36);
  @$pb.TagNumber(842)
  void clearResponseSliderStateGet() => $_clearField(842);
  @$pb.TagNumber(842)
  $1.ResponseSliderStateGet ensureResponseSliderStateGet() => $_ensure(36);

  @$pb.TagNumber(843)
  $1.ResponseSliderCalibrate get responseSliderCalibrate => $_getN(37);
  @$pb.TagNumber(843)
  set responseSliderCalibrate($1.ResponseSliderCalibrate value) =>
      $_setField(843, value);
  @$pb.TagNumber(843)
  $core.bool hasResponseSliderCalibrate() => $_has(37);
  @$pb.TagNumber(843)
  void clearResponseSliderCalibrate() => $_clearField(843);
  @$pb.TagNumber(843)
  $1.ResponseSliderCalibrate ensureResponseSliderCalibrate() => $_ensure(37);

  @$pb.TagNumber(844)
  $1.ResponseSlideDiagStart get responseSlideDiagStart => $_getN(38);
  @$pb.TagNumber(844)
  set responseSlideDiagStart($1.ResponseSlideDiagStart value) =>
      $_setField(844, value);
  @$pb.TagNumber(844)
  $core.bool hasResponseSlideDiagStart() => $_has(38);
  @$pb.TagNumber(844)
  void clearResponseSlideDiagStart() => $_clearField(844);
  @$pb.TagNumber(844)
  $1.ResponseSlideDiagStart ensureResponseSlideDiagStart() => $_ensure(38);

  @$pb.TagNumber(845)
  $1.ResponseSlideDiagStatus get responseSlideDiagStatus => $_getN(39);
  @$pb.TagNumber(845)
  set responseSlideDiagStatus($1.ResponseSlideDiagStatus value) =>
      $_setField(845, value);
  @$pb.TagNumber(845)
  $core.bool hasResponseSlideDiagStatus() => $_has(39);
  @$pb.TagNumber(845)
  void clearResponseSlideDiagStatus() => $_clearField(845);
  @$pb.TagNumber(845)
  $1.ResponseSlideDiagStatus ensureResponseSlideDiagStatus() => $_ensure(39);

  @$pb.TagNumber(846)
  $1.ResponseSlideDiagRead get responseSlideDiagRead => $_getN(40);
  @$pb.TagNumber(846)
  set responseSlideDiagRead($1.ResponseSlideDiagRead value) =>
      $_setField(846, value);
  @$pb.TagNumber(846)
  $core.bool hasResponseSlideDiagRead() => $_has(40);
  @$pb.TagNumber(846)
  void clearResponseSlideDiagRead() => $_clearField(846);
  @$pb.TagNumber(846)
  $1.ResponseSlideDiagRead ensureResponseSlideDiagRead() => $_ensure(40);

  @$pb.TagNumber(848)
  $1.ResponseHallCalibrationGet get responseHallCalibrationGet => $_getN(41);
  @$pb.TagNumber(848)
  set responseHallCalibrationGet($1.ResponseHallCalibrationGet value) =>
      $_setField(848, value);
  @$pb.TagNumber(848)
  $core.bool hasResponseHallCalibrationGet() => $_has(41);
  @$pb.TagNumber(848)
  void clearResponseHallCalibrationGet() => $_clearField(848);
  @$pb.TagNumber(848)
  $1.ResponseHallCalibrationGet ensureResponseHallCalibrationGet() =>
      $_ensure(41);

  @$pb.TagNumber(850)
  $1.ResponseSlideDiagStream get responseSlideDiagStream => $_getN(42);
  @$pb.TagNumber(850)
  set responseSlideDiagStream($1.ResponseSlideDiagStream value) =>
      $_setField(850, value);
  @$pb.TagNumber(850)
  $core.bool hasResponseSlideDiagStream() => $_has(42);
  @$pb.TagNumber(850)
  void clearResponseSlideDiagStream() => $_clearField(850);
  @$pb.TagNumber(850)
  $1.ResponseSlideDiagStream ensureResponseSlideDiagStream() => $_ensure(42);

  @$pb.TagNumber(851)
  $1.ResponseSpeedStatsGet get responseSpeedStatsGet => $_getN(43);
  @$pb.TagNumber(851)
  set responseSpeedStatsGet($1.ResponseSpeedStatsGet value) =>
      $_setField(851, value);
  @$pb.TagNumber(851)
  $core.bool hasResponseSpeedStatsGet() => $_has(43);
  @$pb.TagNumber(851)
  void clearResponseSpeedStatsGet() => $_clearField(851);
  @$pb.TagNumber(851)
  $1.ResponseSpeedStatsGet ensureResponseSpeedStatsGet() => $_ensure(43);

  @$pb.TagNumber(852)
  $1.ResponseSpeedStatsSet get responseSpeedStatsSet => $_getN(44);
  @$pb.TagNumber(852)
  set responseSpeedStatsSet($1.ResponseSpeedStatsSet value) =>
      $_setField(852, value);
  @$pb.TagNumber(852)
  $core.bool hasResponseSpeedStatsSet() => $_has(44);
  @$pb.TagNumber(852)
  void clearResponseSpeedStatsSet() => $_clearField(852);
  @$pb.TagNumber(852)
  $1.ResponseSpeedStatsSet ensureResponseSpeedStatsSet() => $_ensure(44);

  @$pb.TagNumber(853)
  $1.ResponseSlideSnapshotGet get responseSlideSnapshotGet => $_getN(45);
  @$pb.TagNumber(853)
  set responseSlideSnapshotGet($1.ResponseSlideSnapshotGet value) =>
      $_setField(853, value);
  @$pb.TagNumber(853)
  $core.bool hasResponseSlideSnapshotGet() => $_has(45);
  @$pb.TagNumber(853)
  void clearResponseSlideSnapshotGet() => $_clearField(853);
  @$pb.TagNumber(853)
  $1.ResponseSlideSnapshotGet ensureResponseSlideSnapshotGet() => $_ensure(45);

  @$pb.TagNumber(855)
  $1.ResponseSlideProfileTuningGet get responseSlideProfileTuningGet =>
      $_getN(46);
  @$pb.TagNumber(855)
  set responseSlideProfileTuningGet($1.ResponseSlideProfileTuningGet value) =>
      $_setField(855, value);
  @$pb.TagNumber(855)
  $core.bool hasResponseSlideProfileTuningGet() => $_has(46);
  @$pb.TagNumber(855)
  void clearResponseSlideProfileTuningGet() => $_clearField(855);
  @$pb.TagNumber(855)
  $1.ResponseSlideProfileTuningGet ensureResponseSlideProfileTuningGet() =>
      $_ensure(46);

  @$pb.TagNumber(856)
  $1.ResponseSlideMaintResultGet get responseSlideMaintResultGet => $_getN(47);
  @$pb.TagNumber(856)
  set responseSlideMaintResultGet($1.ResponseSlideMaintResultGet value) =>
      $_setField(856, value);
  @$pb.TagNumber(856)
  $core.bool hasResponseSlideMaintResultGet() => $_has(47);
  @$pb.TagNumber(856)
  void clearResponseSlideMaintResultGet() => $_clearField(856);
  @$pb.TagNumber(856)
  $1.ResponseSlideMaintResultGet ensureResponseSlideMaintResultGet() =>
      $_ensure(47);

  /// HSP - 860
  @$pb.TagNumber(860)
  $1.ResponseHspSetup get responseHspSetup => $_getN(48);
  @$pb.TagNumber(860)
  set responseHspSetup($1.ResponseHspSetup value) => $_setField(860, value);
  @$pb.TagNumber(860)
  $core.bool hasResponseHspSetup() => $_has(48);
  @$pb.TagNumber(860)
  void clearResponseHspSetup() => $_clearField(860);
  @$pb.TagNumber(860)
  $1.ResponseHspSetup ensureResponseHspSetup() => $_ensure(48);

  @$pb.TagNumber(861)
  $1.ResponseHspAdd get responseHspAdd => $_getN(49);
  @$pb.TagNumber(861)
  set responseHspAdd($1.ResponseHspAdd value) => $_setField(861, value);
  @$pb.TagNumber(861)
  $core.bool hasResponseHspAdd() => $_has(49);
  @$pb.TagNumber(861)
  void clearResponseHspAdd() => $_clearField(861);
  @$pb.TagNumber(861)
  $1.ResponseHspAdd ensureResponseHspAdd() => $_ensure(49);

  @$pb.TagNumber(862)
  $1.ResponseHspFlush get responseHspFlush => $_getN(50);
  @$pb.TagNumber(862)
  set responseHspFlush($1.ResponseHspFlush value) => $_setField(862, value);
  @$pb.TagNumber(862)
  $core.bool hasResponseHspFlush() => $_has(50);
  @$pb.TagNumber(862)
  void clearResponseHspFlush() => $_clearField(862);
  @$pb.TagNumber(862)
  $1.ResponseHspFlush ensureResponseHspFlush() => $_ensure(50);

  @$pb.TagNumber(863)
  $1.ResponseHspPlay get responseHspPlay => $_getN(51);
  @$pb.TagNumber(863)
  set responseHspPlay($1.ResponseHspPlay value) => $_setField(863, value);
  @$pb.TagNumber(863)
  $core.bool hasResponseHspPlay() => $_has(51);
  @$pb.TagNumber(863)
  void clearResponseHspPlay() => $_clearField(863);
  @$pb.TagNumber(863)
  $1.ResponseHspPlay ensureResponseHspPlay() => $_ensure(51);

  @$pb.TagNumber(864)
  $1.ResponseHspStop get responseHspStop => $_getN(52);
  @$pb.TagNumber(864)
  set responseHspStop($1.ResponseHspStop value) => $_setField(864, value);
  @$pb.TagNumber(864)
  $core.bool hasResponseHspStop() => $_has(52);
  @$pb.TagNumber(864)
  void clearResponseHspStop() => $_clearField(864);
  @$pb.TagNumber(864)
  $1.ResponseHspStop ensureResponseHspStop() => $_ensure(52);

  @$pb.TagNumber(865)
  $1.ResponseHspPause get responseHspPause => $_getN(53);
  @$pb.TagNumber(865)
  set responseHspPause($1.ResponseHspPause value) => $_setField(865, value);
  @$pb.TagNumber(865)
  $core.bool hasResponseHspPause() => $_has(53);
  @$pb.TagNumber(865)
  void clearResponseHspPause() => $_clearField(865);
  @$pb.TagNumber(865)
  $1.ResponseHspPause ensureResponseHspPause() => $_ensure(53);

  @$pb.TagNumber(866)
  $1.ResponseHspResume get responseHspResume => $_getN(54);
  @$pb.TagNumber(866)
  set responseHspResume($1.ResponseHspResume value) => $_setField(866, value);
  @$pb.TagNumber(866)
  $core.bool hasResponseHspResume() => $_has(54);
  @$pb.TagNumber(866)
  void clearResponseHspResume() => $_clearField(866);
  @$pb.TagNumber(866)
  $1.ResponseHspResume ensureResponseHspResume() => $_ensure(54);

  @$pb.TagNumber(867)
  $1.ResponseHspStateGet get responseHspStateGet => $_getN(55);
  @$pb.TagNumber(867)
  set responseHspStateGet($1.ResponseHspStateGet value) =>
      $_setField(867, value);
  @$pb.TagNumber(867)
  $core.bool hasResponseHspStateGet() => $_has(55);
  @$pb.TagNumber(867)
  void clearResponseHspStateGet() => $_clearField(867);
  @$pb.TagNumber(867)
  $1.ResponseHspStateGet ensureResponseHspStateGet() => $_ensure(55);

  @$pb.TagNumber(868)
  $1.ResponseHspCurrentTimeSet get responseHspCurrentTimeSet => $_getN(56);
  @$pb.TagNumber(868)
  set responseHspCurrentTimeSet($1.ResponseHspCurrentTimeSet value) =>
      $_setField(868, value);
  @$pb.TagNumber(868)
  $core.bool hasResponseHspCurrentTimeSet() => $_has(56);
  @$pb.TagNumber(868)
  void clearResponseHspCurrentTimeSet() => $_clearField(868);
  @$pb.TagNumber(868)
  $1.ResponseHspCurrentTimeSet ensureResponseHspCurrentTimeSet() =>
      $_ensure(56);

  @$pb.TagNumber(869)
  $1.ResponseHspThresholdSet get responseHspThresholdSet => $_getN(57);
  @$pb.TagNumber(869)
  set responseHspThresholdSet($1.ResponseHspThresholdSet value) =>
      $_setField(869, value);
  @$pb.TagNumber(869)
  $core.bool hasResponseHspThresholdSet() => $_has(57);
  @$pb.TagNumber(869)
  void clearResponseHspThresholdSet() => $_clearField(869);
  @$pb.TagNumber(869)
  $1.ResponseHspThresholdSet ensureResponseHspThresholdSet() => $_ensure(57);

  @$pb.TagNumber(870)
  $1.ResponseHspPauseOnStarvingSet get responseHspPauseOnStarvingSet =>
      $_getN(58);
  @$pb.TagNumber(870)
  set responseHspPauseOnStarvingSet($1.ResponseHspPauseOnStarvingSet value) =>
      $_setField(870, value);
  @$pb.TagNumber(870)
  $core.bool hasResponseHspPauseOnStarvingSet() => $_has(58);
  @$pb.TagNumber(870)
  void clearResponseHspPauseOnStarvingSet() => $_clearField(870);
  @$pb.TagNumber(870)
  $1.ResponseHspPauseOnStarvingSet ensureResponseHspPauseOnStarvingSet() =>
      $_ensure(58);

  @$pb.TagNumber(871)
  $1.ResponseHspPlaybackRateSet get responseHspPlaybackRateSet => $_getN(59);
  @$pb.TagNumber(871)
  set responseHspPlaybackRateSet($1.ResponseHspPlaybackRateSet value) =>
      $_setField(871, value);
  @$pb.TagNumber(871)
  $core.bool hasResponseHspPlaybackRateSet() => $_has(59);
  @$pb.TagNumber(871)
  void clearResponseHspPlaybackRateSet() => $_clearField(871);
  @$pb.TagNumber(871)
  $1.ResponseHspPlaybackRateSet ensureResponseHspPlaybackRateSet() =>
      $_ensure(59);

  @$pb.TagNumber(872)
  $1.ResponseHspLoopSet get responseHspLoopSet => $_getN(60);
  @$pb.TagNumber(872)
  set responseHspLoopSet($1.ResponseHspLoopSet value) => $_setField(872, value);
  @$pb.TagNumber(872)
  $core.bool hasResponseHspLoopSet() => $_has(60);
  @$pb.TagNumber(872)
  void clearResponseHspLoopSet() => $_clearField(872);
  @$pb.TagNumber(872)
  $1.ResponseHspLoopSet ensureResponseHspLoopSet() => $_ensure(60);

  @$pb.TagNumber(873)
  $1.ResponseHspJitterFilterSet get responseHspJitterFilterSet => $_getN(61);
  @$pb.TagNumber(873)
  set responseHspJitterFilterSet($1.ResponseHspJitterFilterSet value) =>
      $_setField(873, value);
  @$pb.TagNumber(873)
  $core.bool hasResponseHspJitterFilterSet() => $_has(61);
  @$pb.TagNumber(873)
  void clearResponseHspJitterFilterSet() => $_clearField(873);
  @$pb.TagNumber(873)
  $1.ResponseHspJitterFilterSet ensureResponseHspJitterFilterSet() =>
      $_ensure(61);

  @$pb.TagNumber(874)
  $1.ResponseHspScriptSpeedSet get responseHspScriptSpeedSet => $_getN(62);
  @$pb.TagNumber(874)
  set responseHspScriptSpeedSet($1.ResponseHspScriptSpeedSet value) =>
      $_setField(874, value);
  @$pb.TagNumber(874)
  $core.bool hasResponseHspScriptSpeedSet() => $_has(62);
  @$pb.TagNumber(874)
  void clearResponseHspScriptSpeedSet() => $_clearField(874);
  @$pb.TagNumber(874)
  $1.ResponseHspScriptSpeedSet ensureResponseHspScriptSpeedSet() =>
      $_ensure(62);

  /// HVP - 900 (Vibration)
  @$pb.TagNumber(900)
  $1.ResponseHvpSet get responseHvpSet => $_getN(63);
  @$pb.TagNumber(900)
  set responseHvpSet($1.ResponseHvpSet value) => $_setField(900, value);
  @$pb.TagNumber(900)
  $core.bool hasResponseHvpSet() => $_has(63);
  @$pb.TagNumber(900)
  void clearResponseHvpSet() => $_clearField(900);
  @$pb.TagNumber(900)
  $1.ResponseHvpSet ensureResponseHvpSet() => $_ensure(63);

  @$pb.TagNumber(901)
  $1.ResponseHvpStop get responseHvpStop => $_getN(64);
  @$pb.TagNumber(901)
  set responseHvpStop($1.ResponseHvpStop value) => $_setField(901, value);
  @$pb.TagNumber(901)
  $core.bool hasResponseHvpStop() => $_has(64);
  @$pb.TagNumber(901)
  void clearResponseHvpStop() => $_clearField(901);
  @$pb.TagNumber(901)
  $1.ResponseHvpStop ensureResponseHvpStop() => $_ensure(64);

  @$pb.TagNumber(902)
  $1.ResponseHvpStart get responseHvpStart => $_getN(65);
  @$pb.TagNumber(902)
  set responseHvpStart($1.ResponseHvpStart value) => $_setField(902, value);
  @$pb.TagNumber(902)
  $core.bool hasResponseHvpStart() => $_has(65);
  @$pb.TagNumber(902)
  void clearResponseHvpStart() => $_clearField(902);
  @$pb.TagNumber(902)
  $1.ResponseHvpStart ensureResponseHvpStart() => $_ensure(65);

  @$pb.TagNumber(903)
  $1.ResponseHvpStateGet get responseHvpStateGet => $_getN(66);
  @$pb.TagNumber(903)
  set responseHvpStateGet($1.ResponseHvpStateGet value) =>
      $_setField(903, value);
  @$pb.TagNumber(903)
  $core.bool hasResponseHvpStateGet() => $_has(66);
  @$pb.TagNumber(903)
  void clearResponseHvpStateGet() => $_clearField(903);
  @$pb.TagNumber(903)
  $1.ResponseHvpStateGet ensureResponseHvpStateGet() => $_ensure(66);

  /// HRPP - 920-960
  @$pb.TagNumber(920)
  $1.ResponseHrppStart get responseHrppStart => $_getN(67);
  @$pb.TagNumber(920)
  set responseHrppStart($1.ResponseHrppStart value) => $_setField(920, value);
  @$pb.TagNumber(920)
  $core.bool hasResponseHrppStart() => $_has(67);
  @$pb.TagNumber(920)
  void clearResponseHrppStart() => $_clearField(920);
  @$pb.TagNumber(920)
  $1.ResponseHrppStart ensureResponseHrppStart() => $_ensure(67);

  @$pb.TagNumber(921)
  $1.ResponseHrppStop get responseHrppStop => $_getN(68);
  @$pb.TagNumber(921)
  set responseHrppStop($1.ResponseHrppStop value) => $_setField(921, value);
  @$pb.TagNumber(921)
  $core.bool hasResponseHrppStop() => $_has(68);
  @$pb.TagNumber(921)
  void clearResponseHrppStop() => $_clearField(921);
  @$pb.TagNumber(921)
  $1.ResponseHrppStop ensureResponseHrppStop() => $_ensure(68);

  @$pb.TagNumber(922)
  $1.ResponseHrppAmplitudeSet get responseHrppAmplitudeSet => $_getN(69);
  @$pb.TagNumber(922)
  set responseHrppAmplitudeSet($1.ResponseHrppAmplitudeSet value) =>
      $_setField(922, value);
  @$pb.TagNumber(922)
  $core.bool hasResponseHrppAmplitudeSet() => $_has(69);
  @$pb.TagNumber(922)
  void clearResponseHrppAmplitudeSet() => $_clearField(922);
  @$pb.TagNumber(922)
  $1.ResponseHrppAmplitudeSet ensureResponseHrppAmplitudeSet() => $_ensure(69);

  /// ResponseHrppPlaybackSpeedSet response_hrpp_playback_speed_set = 923; //DEPRECATED in FW4.2 use ResponseHrppPlaybackRateSet instead
  @$pb.TagNumber(924)
  $1.ResponseHrppPatternSet get responseHrppPatternSet => $_getN(70);
  @$pb.TagNumber(924)
  set responseHrppPatternSet($1.ResponseHrppPatternSet value) =>
      $_setField(924, value);
  @$pb.TagNumber(924)
  $core.bool hasResponseHrppPatternSet() => $_has(70);
  @$pb.TagNumber(924)
  void clearResponseHrppPatternSet() => $_clearField(924);
  @$pb.TagNumber(924)
  $1.ResponseHrppPatternSet ensureResponseHrppPatternSet() => $_ensure(70);

  @$pb.TagNumber(925)
  $1.ResponseHrppStateGet get responseHrppStateGet => $_getN(71);
  @$pb.TagNumber(925)
  set responseHrppStateGet($1.ResponseHrppStateGet value) =>
      $_setField(925, value);
  @$pb.TagNumber(925)
  $core.bool hasResponseHrppStateGet() => $_has(71);
  @$pb.TagNumber(925)
  void clearResponseHrppStateGet() => $_clearField(925);
  @$pb.TagNumber(925)
  $1.ResponseHrppStateGet ensureResponseHrppStateGet() => $_ensure(71);

  @$pb.TagNumber(926)
  $1.ResponseHrppPatternsGet get responseHrppPatternsGet => $_getN(72);
  @$pb.TagNumber(926)
  set responseHrppPatternsGet($1.ResponseHrppPatternsGet value) =>
      $_setField(926, value);
  @$pb.TagNumber(926)
  $core.bool hasResponseHrppPatternsGet() => $_has(72);
  @$pb.TagNumber(926)
  void clearResponseHrppPatternsGet() => $_clearField(926);
  @$pb.TagNumber(926)
  $1.ResponseHrppPatternsGet ensureResponseHrppPatternsGet() => $_ensure(72);

  @$pb.TagNumber(927)
  $1.ResponseHrppPlaybackRateSet get responseHrppPlaybackRateSet => $_getN(73);
  @$pb.TagNumber(927)
  set responseHrppPlaybackRateSet($1.ResponseHrppPlaybackRateSet value) =>
      $_setField(927, value);
  @$pb.TagNumber(927)
  $core.bool hasResponseHrppPlaybackRateSet() => $_has(73);
  @$pb.TagNumber(927)
  void clearResponseHrppPlaybackRateSet() => $_clearField(927);
  @$pb.TagNumber(927)
  $1.ResponseHrppPlaybackRateSet ensureResponseHrppPlaybackRateSet() =>
      $_ensure(73);

  @$pb.TagNumber(928)
  $1.ResponseHrppPause get responseHrppPause => $_getN(74);
  @$pb.TagNumber(928)
  set responseHrppPause($1.ResponseHrppPause value) => $_setField(928, value);
  @$pb.TagNumber(928)
  $core.bool hasResponseHrppPause() => $_has(74);
  @$pb.TagNumber(928)
  void clearResponseHrppPause() => $_clearField(928);
  @$pb.TagNumber(928)
  $1.ResponseHrppPause ensureResponseHrppPause() => $_ensure(74);

  @$pb.TagNumber(2015)
  $1.ResponseSettingsRegulatorGet get responseSettingsRegulatorGet =>
      $_getN(75);
  @$pb.TagNumber(2015)
  set responseSettingsRegulatorGet($1.ResponseSettingsRegulatorGet value) =>
      $_setField(2015, value);
  @$pb.TagNumber(2015)
  $core.bool hasResponseSettingsRegulatorGet() => $_has(75);
  @$pb.TagNumber(2015)
  void clearResponseSettingsRegulatorGet() => $_clearField(2015);
  @$pb.TagNumber(2015)
  $1.ResponseSettingsRegulatorGet ensureResponseSettingsRegulatorGet() =>
      $_ensure(75);

  @$pb.TagNumber(2017)
  $1.ResponseSettingsHallGet get responseSettingsHallGet => $_getN(76);
  @$pb.TagNumber(2017)
  set responseSettingsHallGet($1.ResponseSettingsHallGet value) =>
      $_setField(2017, value);
  @$pb.TagNumber(2017)
  $core.bool hasResponseSettingsHallGet() => $_has(76);
  @$pb.TagNumber(2017)
  void clearResponseSettingsHallGet() => $_clearField(2017);
  @$pb.TagNumber(2017)
  $1.ResponseSettingsHallGet ensureResponseSettingsHallGet() => $_ensure(76);

  @$pb.TagNumber(2019)
  $1.ResponseSlideProfileGet get responseSlideProfileGet => $_getN(77);
  @$pb.TagNumber(2019)
  set responseSlideProfileGet($1.ResponseSlideProfileGet value) =>
      $_setField(2019, value);
  @$pb.TagNumber(2019)
  $core.bool hasResponseSlideProfileGet() => $_has(77);
  @$pb.TagNumber(2019)
  void clearResponseSlideProfileGet() => $_clearField(2019);
  @$pb.TagNumber(2019)
  $1.ResponseSlideProfileGet ensureResponseSlideProfileGet() => $_ensure(77);
}

class Error extends $pb.GeneratedMessage {
  factory Error({
    $core.int? code,
    $core.String? message,
    $core.String? data,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (message != null) result.message = message;
    if (data != null) result.data = data;
    return result;
  }

  Error._();

  factory Error.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Error.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Error',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOS(3, _omitFieldNames ? '' : 'data')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Error clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Error copyWith(void Function(Error) updates) =>
      super.copyWith((message) => updates(message as Error)) as Error;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Error create() => Error._();
  @$core.override
  Error createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Error getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Error>(create);
  static Error? _defaultInstance;

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

  @$pb.TagNumber(3)
  $core.String get data => $_getSZ(2);
  @$pb.TagNumber(3)
  set data($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasData() => $_has(2);
  @$pb.TagNumber(3)
  void clearData() => $_clearField(3);
}

enum RpcMessage_Message { request, requests, response, notification, notSet }

class RpcMessage extends $pb.GeneratedMessage {
  factory RpcMessage({
    MessageType? type,
    Request? request,
    Requests? requests,
    Response? response,
    Notification? notification,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (request != null) result.request = request;
    if (requests != null) result.requests = requests;
    if (response != null) result.response = response;
    if (notification != null) result.notification = notification;
    return result;
  }

  RpcMessage._();

  factory RpcMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RpcMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, RpcMessage_Message>
      _RpcMessage_MessageByTag = {
    2: RpcMessage_Message.request,
    3: RpcMessage_Message.requests,
    4: RpcMessage_Message.response,
    5: RpcMessage_Message.notification,
    0: RpcMessage_Message.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RpcMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'hdy_rpc'),
      createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5])
    ..aE<MessageType>(1, _omitFieldNames ? '' : 'type',
        enumValues: MessageType.values)
    ..aOM<Request>(2, _omitFieldNames ? '' : 'request',
        subBuilder: Request.create)
    ..aOM<Requests>(3, _omitFieldNames ? '' : 'requests',
        subBuilder: Requests.create)
    ..aOM<Response>(4, _omitFieldNames ? '' : 'response',
        subBuilder: Response.create)
    ..aOM<Notification>(5, _omitFieldNames ? '' : 'notification',
        subBuilder: Notification.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RpcMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RpcMessage copyWith(void Function(RpcMessage) updates) =>
      super.copyWith((message) => updates(message as RpcMessage)) as RpcMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RpcMessage create() => RpcMessage._();
  @$core.override
  RpcMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RpcMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RpcMessage>(create);
  static RpcMessage? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  RpcMessage_Message whichMessage() =>
      _RpcMessage_MessageByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  void clearMessage() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  MessageType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(MessageType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  Request get request => $_getN(1);
  @$pb.TagNumber(2)
  set request(Request value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRequest() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequest() => $_clearField(2);
  @$pb.TagNumber(2)
  Request ensureRequest() => $_ensure(1);

  @$pb.TagNumber(3)
  Requests get requests => $_getN(2);
  @$pb.TagNumber(3)
  set requests(Requests value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRequests() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequests() => $_clearField(3);
  @$pb.TagNumber(3)
  Requests ensureRequests() => $_ensure(2);

  @$pb.TagNumber(4)
  Response get response => $_getN(3);
  @$pb.TagNumber(4)
  set response(Response value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasResponse() => $_has(3);
  @$pb.TagNumber(4)
  void clearResponse() => $_clearField(4);
  @$pb.TagNumber(4)
  Response ensureResponse() => $_ensure(3);

  @$pb.TagNumber(5)
  Notification get notification => $_getN(4);
  @$pb.TagNumber(5)
  set notification(Notification value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasNotification() => $_has(4);
  @$pb.TagNumber(5)
  void clearNotification() => $_clearField(5);
  @$pb.TagNumber(5)
  Notification ensureNotification() => $_ensure(4);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
