// This is a generated file - do not edit.
//
// Generated from notifications.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use notificationWifiStatusChangedDescriptor instead')
const NotificationWifiStatusChanged$json = {
  '1': 'NotificationWifiStatusChanged',
  '2': [
    {'1': 'state', '3': 2, '4': 1, '5': 14, '6': '.hdy_rpc.WifiState', '10': 'state'},
    {'1': 'socket_connected', '3': 4, '4': 1, '5': 8, '10': 'socketConnected'},
    {'1': 'socket_session_id', '3': 5, '4': 1, '5': 13, '10': 'socketSessionId'},
  ],
};

/// Descriptor for `NotificationWifiStatusChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationWifiStatusChangedDescriptor = $convert.base64Decode(
    'Ch1Ob3RpZmljYXRpb25XaWZpU3RhdHVzQ2hhbmdlZBIoCgVzdGF0ZRgCIAEoDjISLmhkeV9ycG'
    'MuV2lmaVN0YXRlUgVzdGF0ZRIpChBzb2NrZXRfY29ubmVjdGVkGAQgASgIUg9zb2NrZXRDb25u'
    'ZWN0ZWQSKgoRc29ja2V0X3Nlc3Npb25faWQYBSABKA1SD3NvY2tldFNlc3Npb25JZA==');

@$core.Deprecated('Use notificationBleStatusChangedDescriptor instead')
const NotificationBleStatusChanged$json = {
  '1': 'NotificationBleStatusChanged',
  '2': [
    {'1': 'state', '3': 1, '4': 1, '5': 14, '6': '.hdy_rpc.BleState', '10': 'state'},
  ],
};

/// Descriptor for `NotificationBleStatusChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationBleStatusChangedDescriptor = $convert.base64Decode(
    'ChxOb3RpZmljYXRpb25CbGVTdGF0dXNDaGFuZ2VkEicKBXN0YXRlGAEgASgOMhEuaGR5X3JwYy'
    '5CbGVTdGF0ZVIFc3RhdGU=');

@$core.Deprecated('Use notificationOtaCompleteDescriptor instead')
const NotificationOtaComplete$json = {
  '1': 'NotificationOtaComplete',
};

/// Descriptor for `NotificationOtaComplete`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationOtaCompleteDescriptor = $convert.base64Decode(
    'ChdOb3RpZmljYXRpb25PdGFDb21wbGV0ZQ==');

@$core.Deprecated('Use notificationModeChangedDescriptor instead')
const NotificationModeChanged$json = {
  '1': 'NotificationModeChanged',
  '2': [
    {'1': 'mode', '3': 1, '4': 1, '5': 14, '6': '.hdy_rpc.Mode', '10': 'mode'},
    {'1': 'mode_session_id', '3': 2, '4': 1, '5': 13, '10': 'modeSessionId'},
  ],
};

/// Descriptor for `NotificationModeChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationModeChangedDescriptor = $convert.base64Decode(
    'ChdOb3RpZmljYXRpb25Nb2RlQ2hhbmdlZBIhCgRtb2RlGAEgASgOMg0uaGR5X3JwYy5Nb2RlUg'
    'Rtb2RlEiYKD21vZGVfc2Vzc2lvbl9pZBgCIAEoDVINbW9kZVNlc3Npb25JZA==');

@$core.Deprecated('Use notificationStrokeChangedDescriptor instead')
const NotificationStrokeChanged$json = {
  '1': 'NotificationStrokeChanged',
  '2': [
    {'1': 'min', '3': 1, '4': 1, '5': 2, '10': 'min'},
    {'1': 'max', '3': 2, '4': 1, '5': 2, '10': 'max'},
    {'1': 'min_absolute', '3': 3, '4': 1, '5': 2, '10': 'minAbsolute'},
    {'1': 'max_absolute', '3': 4, '4': 1, '5': 2, '10': 'maxAbsolute'},
  ],
};

/// Descriptor for `NotificationStrokeChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationStrokeChangedDescriptor = $convert.base64Decode(
    'ChlOb3RpZmljYXRpb25TdHJva2VDaGFuZ2VkEhAKA21pbhgBIAEoAlIDbWluEhAKA21heBgCIA'
    'EoAlIDbWF4EiEKDG1pbl9hYnNvbHV0ZRgDIAEoAlILbWluQWJzb2x1dGUSIQoMbWF4X2Fic29s'
    'dXRlGAQgASgCUgttYXhBYnNvbHV0ZQ==');

@$core.Deprecated('Use notificationButtonEventDescriptor instead')
const NotificationButtonEvent$json = {
  '1': 'NotificationButtonEvent',
  '2': [
    {'1': 'button', '3': 1, '4': 1, '5': 14, '6': '.hdy_rpc.Button', '10': 'button'},
    {'1': 'event', '3': 2, '4': 1, '5': 14, '6': '.hdy_rpc.ButtonEvent', '10': 'event'},
  ],
};

/// Descriptor for `NotificationButtonEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationButtonEventDescriptor = $convert.base64Decode(
    'ChdOb3RpZmljYXRpb25CdXR0b25FdmVudBInCgZidXR0b24YASABKA4yDy5oZHlfcnBjLkJ1dH'
    'RvblIGYnV0dG9uEioKBWV2ZW50GAIgASgOMhQuaGR5X3JwYy5CdXR0b25FdmVudFIFZXZlbnQ=');

@$core.Deprecated('Use notificationBatteryChangedDescriptor instead')
const NotificationBatteryChanged$json = {
  '1': 'NotificationBatteryChanged',
  '2': [
    {'1': 'state', '3': 1, '4': 1, '5': 11, '6': '.hdy_rpc.BatteryState', '10': 'state'},
  ],
};

/// Descriptor for `NotificationBatteryChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationBatteryChangedDescriptor = $convert.base64Decode(
    'ChpOb3RpZmljYXRpb25CYXR0ZXJ5Q2hhbmdlZBIrCgVzdGF0ZRgBIAEoCzIVLmhkeV9ycGMuQm'
    'F0dGVyeVN0YXRlUgVzdGF0ZQ==');

@$core.Deprecated('Use notificationHampChangedDescriptor instead')
const NotificationHampChanged$json = {
  '1': 'NotificationHampChanged',
  '2': [
    {'1': 'state', '3': 1, '4': 1, '5': 11, '6': '.hdy_rpc.HampState', '10': 'state'},
  ],
};

/// Descriptor for `NotificationHampChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationHampChangedDescriptor = $convert.base64Decode(
    'ChdOb3RpZmljYXRpb25IYW1wQ2hhbmdlZBIoCgVzdGF0ZRgBIAEoCzISLmhkeV9ycGMuSGFtcF'
    'N0YXRlUgVzdGF0ZQ==');

@$core.Deprecated('Use notificationHdspChangedDescriptor instead')
const NotificationHdspChanged$json = {
  '1': 'NotificationHdspChanged',
  '2': [
    {'1': 'state', '3': 1, '4': 1, '5': 14, '6': '.hdy_rpc.HdspPlayState', '10': 'state'},
  ],
};

/// Descriptor for `NotificationHdspChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationHdspChangedDescriptor = $convert.base64Decode(
    'ChdOb3RpZmljYXRpb25IZHNwQ2hhbmdlZBIsCgVzdGF0ZRgBIAEoDjIWLmhkeV9ycGMuSGRzcF'
    'BsYXlTdGF0ZVIFc3RhdGU=');

@$core.Deprecated('Use notificationHspThresholdReachedDescriptor instead')
const NotificationHspThresholdReached$json = {
  '1': 'NotificationHspThresholdReached',
  '2': [
    {'1': 'state', '3': 1, '4': 1, '5': 11, '6': '.hdy_rpc.HspState', '10': 'state'},
  ],
};

/// Descriptor for `NotificationHspThresholdReached`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationHspThresholdReachedDescriptor = $convert.base64Decode(
    'Ch9Ob3RpZmljYXRpb25Ic3BUaHJlc2hvbGRSZWFjaGVkEicKBXN0YXRlGAEgASgLMhEuaGR5X3'
    'JwYy5Ic3BTdGF0ZVIFc3RhdGU=');

@$core.Deprecated('Use notificationHspStateChangedDescriptor instead')
const NotificationHspStateChanged$json = {
  '1': 'NotificationHspStateChanged',
  '2': [
    {'1': 'state', '3': 1, '4': 1, '5': 11, '6': '.hdy_rpc.HspState', '10': 'state'},
  ],
};

/// Descriptor for `NotificationHspStateChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationHspStateChangedDescriptor = $convert.base64Decode(
    'ChtOb3RpZmljYXRpb25Ic3BTdGF0ZUNoYW5nZWQSJwoFc3RhdGUYASABKAsyES5oZHlfcnBjLk'
    'hzcFN0YXRlUgVzdGF0ZQ==');

@$core.Deprecated('Use notificationHspLoopingDescriptor instead')
const NotificationHspLooping$json = {
  '1': 'NotificationHspLooping',
  '2': [
    {'1': 'state', '3': 1, '4': 1, '5': 11, '6': '.hdy_rpc.HspState', '10': 'state'},
  ],
};

/// Descriptor for `NotificationHspLooping`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationHspLoopingDescriptor = $convert.base64Decode(
    'ChZOb3RpZmljYXRpb25Ic3BMb29waW5nEicKBXN0YXRlGAEgASgLMhEuaGR5X3JwYy5Ic3BTdG'
    'F0ZVIFc3RhdGU=');

@$core.Deprecated('Use notificationHspStarvingDescriptor instead')
const NotificationHspStarving$json = {
  '1': 'NotificationHspStarving',
  '2': [
    {'1': 'state', '3': 1, '4': 1, '5': 11, '6': '.hdy_rpc.HspState', '10': 'state'},
  ],
};

/// Descriptor for `NotificationHspStarving`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationHspStarvingDescriptor = $convert.base64Decode(
    'ChdOb3RpZmljYXRpb25Ic3BTdGFydmluZxInCgVzdGF0ZRgBIAEoCzIRLmhkeV9ycGMuSHNwU3'
    'RhdGVSBXN0YXRl');

@$core.Deprecated('Use notificationHspResumedOnNonStarvingDescriptor instead')
const NotificationHspResumedOnNonStarving$json = {
  '1': 'NotificationHspResumedOnNonStarving',
  '2': [
    {'1': 'state', '3': 1, '4': 1, '5': 11, '6': '.hdy_rpc.HspState', '10': 'state'},
  ],
};

/// Descriptor for `NotificationHspResumedOnNonStarving`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationHspResumedOnNonStarvingDescriptor = $convert.base64Decode(
    'CiNOb3RpZmljYXRpb25Ic3BSZXN1bWVkT25Ob25TdGFydmluZxInCgVzdGF0ZRgBIAEoCzIRLm'
    'hkeV9ycGMuSHNwU3RhdGVSBXN0YXRl');

@$core.Deprecated('Use notificationHspPausedOnStarvingDescriptor instead')
const NotificationHspPausedOnStarving$json = {
  '1': 'NotificationHspPausedOnStarving',
  '2': [
    {'1': 'state', '3': 1, '4': 1, '5': 11, '6': '.hdy_rpc.HspState', '10': 'state'},
  ],
};

/// Descriptor for `NotificationHspPausedOnStarving`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationHspPausedOnStarvingDescriptor = $convert.base64Decode(
    'Ch9Ob3RpZmljYXRpb25Ic3BQYXVzZWRPblN0YXJ2aW5nEicKBXN0YXRlGAEgASgLMhEuaGR5X3'
    'JwYy5Ic3BTdGF0ZVIFc3RhdGU=');

@$core.Deprecated('Use notificationHvpChangedDescriptor instead')
const NotificationHvpChanged$json = {
  '1': 'NotificationHvpChanged',
  '2': [
    {'1': 'state', '3': 1, '4': 1, '5': 11, '6': '.hdy_rpc.HvpState', '10': 'state'},
  ],
};

/// Descriptor for `NotificationHvpChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationHvpChangedDescriptor = $convert.base64Decode(
    'ChZOb3RpZmljYXRpb25IdnBDaGFuZ2VkEicKBXN0YXRlGAEgASgLMhEuaGR5X3JwYy5IdnBTdG'
    'F0ZVIFc3RhdGU=');

@$core.Deprecated('Use notificationHrppChangedDescriptor instead')
const NotificationHrppChanged$json = {
  '1': 'NotificationHrppChanged',
  '2': [
    {'1': 'state', '3': 1, '4': 1, '5': 11, '6': '.hdy_rpc.HrppState', '10': 'state'},
  ],
};

/// Descriptor for `NotificationHrppChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationHrppChangedDescriptor = $convert.base64Decode(
    'ChdOb3RpZmljYXRpb25IcnBwQ2hhbmdlZBIoCgVzdGF0ZRgBIAEoCzISLmhkeV9ycGMuSHJwcF'
    'N0YXRlUgVzdGF0ZQ==');

@$core.Deprecated('Use notificationTempHighDescriptor instead')
const NotificationTempHigh$json = {
  '1': 'NotificationTempHigh',
};

/// Descriptor for `NotificationTempHigh`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationTempHighDescriptor = $convert.base64Decode(
    'ChROb3RpZmljYXRpb25UZW1wSGlnaA==');

@$core.Deprecated('Use notificationTempOkDescriptor instead')
const NotificationTempOk$json = {
  '1': 'NotificationTempOk',
};

/// Descriptor for `NotificationTempOk`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationTempOkDescriptor = $convert.base64Decode(
    'ChJOb3RpZmljYXRpb25UZW1wT2s=');

@$core.Deprecated('Use notificationSliderBlockedDescriptor instead')
const NotificationSliderBlocked$json = {
  '1': 'NotificationSliderBlocked',
};

/// Descriptor for `NotificationSliderBlocked`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationSliderBlockedDescriptor = $convert.base64Decode(
    'ChlOb3RpZmljYXRpb25TbGlkZXJCbG9ja2Vk');

@$core.Deprecated('Use notificationSliderUnblockedDescriptor instead')
const NotificationSliderUnblocked$json = {
  '1': 'NotificationSliderUnblocked',
};

/// Descriptor for `NotificationSliderUnblocked`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationSliderUnblockedDescriptor = $convert.base64Decode(
    'ChtOb3RpZmljYXRpb25TbGlkZXJVbmJsb2NrZWQ=');

@$core.Deprecated('Use notificationLowMemoryErrorDescriptor instead')
const NotificationLowMemoryError$json = {
  '1': 'NotificationLowMemoryError',
  '2': [
    {'1': 'available_heap', '3': 1, '4': 1, '5': 13, '10': 'availableHeap'},
    {'1': 'largest_free_block', '3': 2, '4': 1, '5': 13, '10': 'largestFreeBlock'},
    {'1': 'discarded_msg_size', '3': 3, '4': 1, '5': 13, '10': 'discardedMsgSize'},
  ],
};

/// Descriptor for `NotificationLowMemoryError`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationLowMemoryErrorDescriptor = $convert.base64Decode(
    'ChpOb3RpZmljYXRpb25Mb3dNZW1vcnlFcnJvchIlCg5hdmFpbGFibGVfaGVhcBgBIAEoDVINYX'
    'ZhaWxhYmxlSGVhcBIsChJsYXJnZXN0X2ZyZWVfYmxvY2sYAiABKA1SEGxhcmdlc3RGcmVlQmxv'
    'Y2sSLAoSZGlzY2FyZGVkX21zZ19zaXplGAMgASgNUhBkaXNjYXJkZWRNc2dTaXpl');

@$core.Deprecated('Use notificationLowMemoryWarningDescriptor instead')
const NotificationLowMemoryWarning$json = {
  '1': 'NotificationLowMemoryWarning',
  '2': [
    {'1': 'available_heap', '3': 1, '4': 1, '5': 13, '10': 'availableHeap'},
    {'1': 'largest_free_block', '3': 2, '4': 1, '5': 13, '10': 'largestFreeBlock'},
  ],
};

/// Descriptor for `NotificationLowMemoryWarning`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationLowMemoryWarningDescriptor = $convert.base64Decode(
    'ChxOb3RpZmljYXRpb25Mb3dNZW1vcnlXYXJuaW5nEiUKDmF2YWlsYWJsZV9oZWFwGAEgASgNUg'
    '1hdmFpbGFibGVIZWFwEiwKEmxhcmdlc3RfZnJlZV9ibG9jaxgCIAEoDVIQbGFyZ2VzdEZyZWVC'
    'bG9jaw==');

@$core.Deprecated('Use notificationErrorDescriptor instead')
const NotificationError$json = {
  '1': 'NotificationError',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `NotificationError`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationErrorDescriptor = $convert.base64Decode(
    'ChFOb3RpZmljYXRpb25FcnJvchISCgRjb2RlGAEgASgFUgRjb2RlEhgKB21lc3NhZ2UYAiABKA'
    'lSB21lc3NhZ2U=');

@$core.Deprecated('Use notificationWifiScanCompleteDescriptor instead')
const NotificationWifiScanComplete$json = {
  '1': 'NotificationWifiScanComplete',
  '2': [
    {'1': 'nr_of_networks', '3': 1, '4': 1, '5': 13, '10': 'nrOfNetworks'},
  ],
};

/// Descriptor for `NotificationWifiScanComplete`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationWifiScanCompleteDescriptor = $convert.base64Decode(
    'ChxOb3RpZmljYXRpb25XaWZpU2NhbkNvbXBsZXRlEiQKDm5yX29mX25ldHdvcmtzGAEgASgNUg'
    'xuck9mTmV0d29ya3M=');

