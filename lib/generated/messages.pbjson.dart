// This is a generated file - do not edit.
//
// Generated from messages.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use slideMaintVerdictDescriptor instead')
const SlideMaintVerdict$json = {
  '1': 'SlideMaintVerdict',
  '2': [
    {'1': 'SLIDE_MAINT_OK', '2': 0},
    {'1': 'SLIDE_MAINT_CHECK', '2': 1},
    {'1': 'SLIDE_MAINT_FAIL', '2': 2},
  ],
};

/// Descriptor for `SlideMaintVerdict`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List slideMaintVerdictDescriptor = $convert.base64Decode(
    'ChFTbGlkZU1haW50VmVyZGljdBISCg5TTElERV9NQUlOVF9PSxAAEhUKEVNMSURFX01BSU5UX0'
    'NIRUNLEAESFAoQU0xJREVfTUFJTlRfRkFJTBAC');

@$core.Deprecated('Use requestServerTimeGetDescriptor instead')
const RequestServerTimeGet$json = {
  '1': 'RequestServerTimeGet',
};

/// Descriptor for `RequestServerTimeGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestServerTimeGetDescriptor =
    $convert.base64Decode('ChRSZXF1ZXN0U2VydmVyVGltZUdldA==');

@$core.Deprecated('Use responseServerTimeGetDescriptor instead')
const ResponseServerTimeGet$json = {
  '1': 'ResponseServerTimeGet',
  '2': [
    {'1': 'time', '3': 1, '4': 1, '5': 4, '10': 'time'},
  ],
};

/// Descriptor for `ResponseServerTimeGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseServerTimeGetDescriptor =
    $convert.base64Decode(
        'ChVSZXNwb25zZVNlcnZlclRpbWVHZXQSEgoEdGltZRgBIAEoBFIEdGltZQ==');

@$core.Deprecated('Use requestConnectedGetDescriptor instead')
const RequestConnectedGet$json = {
  '1': 'RequestConnectedGet',
};

/// Descriptor for `RequestConnectedGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestConnectedGetDescriptor =
    $convert.base64Decode('ChNSZXF1ZXN0Q29ubmVjdGVkR2V0');

@$core.Deprecated('Use responseConnectedGetDescriptor instead')
const ResponseConnectedGet$json = {
  '1': 'ResponseConnectedGet',
  '2': [
    {'1': 'connected', '3': 1, '4': 1, '5': 8, '10': 'connected'},
  ],
};

/// Descriptor for `ResponseConnectedGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseConnectedGetDescriptor = $convert.base64Decode(
    'ChRSZXNwb25zZUNvbm5lY3RlZEdldBIcCgljb25uZWN0ZWQYASABKAhSCWNvbm5lY3RlZA==');

@$core.Deprecated('Use requestFwStatusGetDescriptor instead')
const RequestFwStatusGet$json = {
  '1': 'RequestFwStatusGet',
};

/// Descriptor for `RequestFwStatusGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestFwStatusGetDescriptor =
    $convert.base64Decode('ChJSZXF1ZXN0RndTdGF0dXNHZXQ=');

@$core.Deprecated('Use responseFwStatusGetDescriptor instead')
const ResponseFwStatusGet$json = {
  '1': 'ResponseFwStatusGet',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.FirmwareStatus',
      '10': 'status'
    },
    {'1': 'latest_version', '3': 2, '4': 1, '5': 9, '10': 'latestVersion'},
  ],
};

/// Descriptor for `ResponseFwStatusGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseFwStatusGetDescriptor = $convert.base64Decode(
    'ChNSZXNwb25zZUZ3U3RhdHVzR2V0Ei8KBnN0YXR1cxgBIAEoDjIXLmhkeV9ycGMuRmlybXdhcm'
    'VTdGF0dXNSBnN0YXR1cxIlCg5sYXRlc3RfdmVyc2lvbhgCIAEoCVINbGF0ZXN0VmVyc2lvbg==');

@$core.Deprecated('Use requestTestUniformityDescriptor instead')
const RequestTestUniformity$json = {
  '1': 'RequestTestUniformity',
  '2': [
    {'1': 'duty', '3': 1, '4': 1, '5': 2, '10': 'duty'},
  ],
};

/// Descriptor for `RequestTestUniformity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestTestUniformityDescriptor =
    $convert.base64Decode(
        'ChVSZXF1ZXN0VGVzdFVuaWZvcm1pdHkSEgoEZHV0eRgBIAEoAlIEZHV0eQ==');

@$core.Deprecated('Use requestTestMaxSpeedDescriptor instead')
const RequestTestMaxSpeed$json = {
  '1': 'RequestTestMaxSpeed',
};

/// Descriptor for `RequestTestMaxSpeed`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestTestMaxSpeedDescriptor =
    $convert.base64Decode('ChNSZXF1ZXN0VGVzdE1heFNwZWVk');

@$core.Deprecated('Use requestConnectionKeyGetDescriptor instead')
const RequestConnectionKeyGet$json = {
  '1': 'RequestConnectionKeyGet',
};

/// Descriptor for `RequestConnectionKeyGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestConnectionKeyGetDescriptor =
    $convert.base64Decode('ChdSZXF1ZXN0Q29ubmVjdGlvbktleUdldA==');

@$core.Deprecated('Use responseConnectionKeyGetDescriptor instead')
const ResponseConnectionKeyGet$json = {
  '1': 'ResponseConnectionKeyGet',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
  ],
};

/// Descriptor for `ResponseConnectionKeyGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseConnectionKeyGetDescriptor =
    $convert.base64Decode(
        'ChhSZXNwb25zZUNvbm5lY3Rpb25LZXlHZXQSEAoDa2V5GAEgASgJUgNrZXk=');

@$core.Deprecated('Use requestWifiStatusGetDescriptor instead')
const RequestWifiStatusGet$json = {
  '1': 'RequestWifiStatusGet',
};

/// Descriptor for `RequestWifiStatusGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestWifiStatusGetDescriptor =
    $convert.base64Decode('ChRSZXF1ZXN0V2lmaVN0YXR1c0dldA==');

@$core.Deprecated('Use responseWifiStatusGetDescriptor instead')
const ResponseWifiStatusGet$json = {
  '1': 'ResponseWifiStatusGet',
  '2': [
    {
      '1': 'ap_info',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ApInfo',
      '10': 'apInfo'
    },
    {
      '1': 'state',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.WifiState',
      '10': 'state'
    },
    {
      '1': 'failed_reason',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.WifiFailedReason',
      '10': 'failedReason'
    },
    {'1': 'socket_connected', '3': 4, '4': 1, '5': 8, '10': 'socketConnected'},
    {'1': 'ssid', '3': 5, '4': 1, '5': 9, '10': 'ssid'},
  ],
};

/// Descriptor for `ResponseWifiStatusGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseWifiStatusGetDescriptor = $convert.base64Decode(
    'ChVSZXNwb25zZVdpZmlTdGF0dXNHZXQSKAoHYXBfaW5mbxgBIAEoCzIPLmhkeV9ycGMuQXBJbm'
    'ZvUgZhcEluZm8SKAoFc3RhdGUYAiABKA4yEi5oZHlfcnBjLldpZmlTdGF0ZVIFc3RhdGUSPgoN'
    'ZmFpbGVkX3JlYXNvbhgDIAEoDjIZLmhkeV9ycGMuV2lmaUZhaWxlZFJlYXNvblIMZmFpbGVkUm'
    'Vhc29uEikKEHNvY2tldF9jb25uZWN0ZWQYBCABKAhSD3NvY2tldENvbm5lY3RlZBISCgRzc2lk'
    'GAUgASgJUgRzc2lk');

@$core.Deprecated('Use requestWifiSetDescriptor instead')
const RequestWifiSet$json = {
  '1': 'RequestWifiSet',
  '2': [
    {'1': 'ssid', '3': 1, '4': 1, '5': 9, '10': 'ssid'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
    {'1': 'save', '3': 3, '4': 1, '5': 8, '10': 'save'},
  ],
};

/// Descriptor for `RequestWifiSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestWifiSetDescriptor = $convert.base64Decode(
    'Cg5SZXF1ZXN0V2lmaVNldBISCgRzc2lkGAEgASgJUgRzc2lkEhoKCHBhc3N3b3JkGAIgASgJUg'
    'hwYXNzd29yZBISCgRzYXZlGAMgASgIUgRzYXZl');

@$core.Deprecated('Use requestWifiScanStartDescriptor instead')
const RequestWifiScanStart$json = {
  '1': 'RequestWifiScanStart',
  '2': [
    {'1': 'blocking', '3': 1, '4': 1, '5': 8, '10': 'blocking'},
    {'1': 'passive', '3': 2, '4': 1, '5': 8, '10': 'passive'},
    {'1': 'channel', '3': 3, '4': 1, '5': 13, '10': 'channel'},
    {'1': 'show_hidden', '3': 4, '4': 1, '5': 8, '10': 'showHidden'},
    {
      '1': 'passive_scan_time',
      '3': 5,
      '4': 1,
      '5': 13,
      '10': 'passiveScanTime'
    },
    {
      '1': 'active_scan_time_min',
      '3': 6,
      '4': 1,
      '5': 13,
      '10': 'activeScanTimeMin'
    },
    {
      '1': 'active_scan_time_max',
      '3': 7,
      '4': 1,
      '5': 13,
      '10': 'activeScanTimeMax'
    },
  ],
};

/// Descriptor for `RequestWifiScanStart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestWifiScanStartDescriptor = $convert.base64Decode(
    'ChRSZXF1ZXN0V2lmaVNjYW5TdGFydBIaCghibG9ja2luZxgBIAEoCFIIYmxvY2tpbmcSGAoHcG'
    'Fzc2l2ZRgCIAEoCFIHcGFzc2l2ZRIYCgdjaGFubmVsGAMgASgNUgdjaGFubmVsEh8KC3Nob3df'
    'aGlkZGVuGAQgASgIUgpzaG93SGlkZGVuEioKEXBhc3NpdmVfc2Nhbl90aW1lGAUgASgNUg9wYX'
    'NzaXZlU2NhblRpbWUSLwoUYWN0aXZlX3NjYW5fdGltZV9taW4YBiABKA1SEWFjdGl2ZVNjYW5U'
    'aW1lTWluEi8KFGFjdGl2ZV9zY2FuX3RpbWVfbWF4GAcgASgNUhFhY3RpdmVTY2FuVGltZU1heA'
    '==');

@$core.Deprecated('Use requestWifiScanResultsGetDescriptor instead')
const RequestWifiScanResultsGet$json = {
  '1': 'RequestWifiScanResultsGet',
  '2': [
    {'1': 'max_results', '3': 1, '4': 1, '5': 13, '10': 'maxResults'},
    {'1': 'offset_index', '3': 2, '4': 1, '5': 13, '10': 'offsetIndex'},
  ],
};

/// Descriptor for `RequestWifiScanResultsGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestWifiScanResultsGetDescriptor =
    $convert.base64Decode(
        'ChlSZXF1ZXN0V2lmaVNjYW5SZXN1bHRzR2V0Eh8KC21heF9yZXN1bHRzGAEgASgNUgptYXhSZX'
        'N1bHRzEiEKDG9mZnNldF9pbmRleBgCIAEoDVILb2Zmc2V0SW5kZXg=');

@$core.Deprecated('Use responseWifiScanResultsGetDescriptor instead')
const ResponseWifiScanResultsGet$json = {
  '1': 'ResponseWifiScanResultsGet',
  '2': [
    {
      '1': 'ap_info',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.hdy_rpc.ApInfo',
      '10': 'apInfo'
    },
    {'1': 'total_results', '3': 2, '4': 1, '5': 13, '10': 'totalResults'},
  ],
};

/// Descriptor for `ResponseWifiScanResultsGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseWifiScanResultsGetDescriptor =
    $convert.base64Decode(
        'ChpSZXNwb25zZVdpZmlTY2FuUmVzdWx0c0dldBIoCgdhcF9pbmZvGAEgAygLMg8uaGR5X3JwYy'
        '5BcEluZm9SBmFwSW5mbxIjCg10b3RhbF9yZXN1bHRzGAIgASgNUgx0b3RhbFJlc3VsdHM=');

@$core.Deprecated('Use requestWifiScanStopDescriptor instead')
const RequestWifiScanStop$json = {
  '1': 'RequestWifiScanStop',
};

/// Descriptor for `RequestWifiScanStop`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestWifiScanStopDescriptor =
    $convert.base64Decode('ChNSZXF1ZXN0V2lmaVNjYW5TdG9w');

@$core.Deprecated('Use requestModeGetDescriptor instead')
const RequestModeGet$json = {
  '1': 'RequestModeGet',
};

/// Descriptor for `RequestModeGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestModeGetDescriptor =
    $convert.base64Decode('Cg5SZXF1ZXN0TW9kZUdldA==');

@$core.Deprecated('Use responseModeGetDescriptor instead')
const ResponseModeGet$json = {
  '1': 'ResponseModeGet',
  '2': [
    {'1': 'mode', '3': 1, '4': 1, '5': 14, '6': '.hdy_rpc.Mode', '10': 'mode'},
    {'1': 'mode_session_id', '3': 2, '4': 1, '5': 13, '10': 'modeSessionId'},
  ],
};

/// Descriptor for `ResponseModeGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseModeGetDescriptor = $convert.base64Decode(
    'Cg9SZXNwb25zZU1vZGVHZXQSIQoEbW9kZRgBIAEoDjINLmhkeV9ycGMuTW9kZVIEbW9kZRImCg'
    '9tb2RlX3Nlc3Npb25faWQYAiABKA1SDW1vZGVTZXNzaW9uSWQ=');

@$core.Deprecated('Use requestModeSetDescriptor instead')
const RequestModeSet$json = {
  '1': 'RequestModeSet',
  '2': [
    {'1': 'mode', '3': 1, '4': 1, '5': 14, '6': '.hdy_rpc.Mode', '10': 'mode'},
  ],
};

/// Descriptor for `RequestModeSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestModeSetDescriptor = $convert.base64Decode(
    'Cg5SZXF1ZXN0TW9kZVNldBIhCgRtb2RlGAEgASgOMg0uaGR5X3JwYy5Nb2RlUgRtb2Rl');

@$core.Deprecated('Use responseModeSetDescriptor instead')
const ResponseModeSet$json = {
  '1': 'ResponseModeSet',
  '2': [
    {'1': 'mode', '3': 1, '4': 1, '5': 14, '6': '.hdy_rpc.Mode', '10': 'mode'},
    {'1': 'mode_session_id', '3': 2, '4': 1, '5': 13, '10': 'modeSessionId'},
  ],
};

/// Descriptor for `ResponseModeSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseModeSetDescriptor = $convert.base64Decode(
    'Cg9SZXNwb25zZU1vZGVTZXQSIQoEbW9kZRgBIAEoDjINLmhkeV9ycGMuTW9kZVIEbW9kZRImCg'
    '9tb2RlX3Nlc3Npb25faWQYAiABKA1SDW1vZGVTZXNzaW9uSWQ=');

@$core.Deprecated('Use requestRebootDescriptor instead')
const RequestReboot$json = {
  '1': 'RequestReboot',
  '2': [
    {
      '1': 'connection_mode',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.ConnectionMode',
      '10': 'connectionMode'
    },
  ],
};

/// Descriptor for `RequestReboot`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestRebootDescriptor = $convert.base64Decode(
    'Cg1SZXF1ZXN0UmVib290EkAKD2Nvbm5lY3Rpb25fbW9kZRgDIAEoDjIXLmhkeV9ycGMuQ29ubm'
    'VjdGlvbk1vZGVSDmNvbm5lY3Rpb25Nb2Rl');

@$core.Deprecated('Use requestButtonPressDescriptor instead')
const RequestButtonPress$json = {
  '1': 'RequestButtonPress',
  '2': [
    {'1': 'button', '3': 1, '4': 1, '5': 13, '10': 'button'},
    {
      '1': 'event',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.ButtonEvent',
      '10': 'event'
    },
  ],
};

/// Descriptor for `RequestButtonPress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestButtonPressDescriptor = $convert.base64Decode(
    'ChJSZXF1ZXN0QnV0dG9uUHJlc3MSFgoGYnV0dG9uGAEgASgNUgZidXR0b24SKgoFZXZlbnQYAi'
    'ABKA4yFC5oZHlfcnBjLkJ1dHRvbkV2ZW50UgVldmVudA==');

@$core.Deprecated('Use requestClockOffsetSetDescriptor instead')
const RequestClockOffsetSet$json = {
  '1': 'RequestClockOffsetSet',
  '2': [
    {'1': 'clock_offset', '3': 1, '4': 1, '5': 18, '10': 'clockOffset'},
    {'1': 'rtd', '3': 2, '4': 1, '5': 5, '10': 'rtd'},
  ],
};

/// Descriptor for `RequestClockOffsetSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestClockOffsetSetDescriptor = $convert.base64Decode(
    'ChVSZXF1ZXN0Q2xvY2tPZmZzZXRTZXQSIQoMY2xvY2tfb2Zmc2V0GAEgASgSUgtjbG9ja09mZn'
    'NldBIQCgNydGQYAiABKAVSA3J0ZA==');

@$core.Deprecated('Use responseClockOffsetSetDescriptor instead')
const ResponseClockOffsetSet$json = {
  '1': 'ResponseClockOffsetSet',
  '2': [
    {'1': 'time', '3': 1, '4': 1, '5': 13, '10': 'time'},
    {'1': 'clock_offset', '3': 2, '4': 1, '5': 18, '10': 'clockOffset'},
    {'1': 'rtd', '3': 3, '4': 1, '5': 5, '10': 'rtd'},
  ],
};

/// Descriptor for `ResponseClockOffsetSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseClockOffsetSetDescriptor =
    $convert.base64Decode(
        'ChZSZXNwb25zZUNsb2NrT2Zmc2V0U2V0EhIKBHRpbWUYASABKA1SBHRpbWUSIQoMY2xvY2tfb2'
        'Zmc2V0GAIgASgSUgtjbG9ja09mZnNldBIQCgNydGQYAyABKAVSA3J0ZA==');

@$core.Deprecated('Use requestBatteryGetDescriptor instead')
const RequestBatteryGet$json = {
  '1': 'RequestBatteryGet',
  '2': [
    {'1': 'flush', '3': 1, '4': 1, '5': 8, '10': 'flush'},
  ],
};

/// Descriptor for `RequestBatteryGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestBatteryGetDescriptor = $convert
    .base64Decode('ChFSZXF1ZXN0QmF0dGVyeUdldBIUCgVmbHVzaBgBIAEoCFIFZmx1c2g=');

@$core.Deprecated('Use responseBatteryGetDescriptor instead')
const ResponseBatteryGet$json = {
  '1': 'ResponseBatteryGet',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.BatteryState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseBatteryGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseBatteryGetDescriptor = $convert.base64Decode(
    'ChJSZXNwb25zZUJhdHRlcnlHZXQSKwoFc3RhdGUYASABKAsyFS5oZHlfcnBjLkJhdHRlcnlTdG'
    'F0ZVIFc3RhdGU=');

@$core.Deprecated('Use requestClockOffsetGetDescriptor instead')
const RequestClockOffsetGet$json = {
  '1': 'RequestClockOffsetGet',
};

/// Descriptor for `RequestClockOffsetGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestClockOffsetGetDescriptor =
    $convert.base64Decode('ChVSZXF1ZXN0Q2xvY2tPZmZzZXRHZXQ=');

@$core.Deprecated('Use responseClockOffsetGetDescriptor instead')
const ResponseClockOffsetGet$json = {
  '1': 'ResponseClockOffsetGet',
  '2': [
    {'1': 'time', '3': 1, '4': 1, '5': 13, '10': 'time'},
    {'1': 'clock_offset', '3': 2, '4': 1, '5': 18, '10': 'clockOffset'},
    {'1': 'rtd', '3': 3, '4': 1, '5': 5, '10': 'rtd'},
  ],
};

/// Descriptor for `ResponseClockOffsetGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseClockOffsetGetDescriptor =
    $convert.base64Decode(
        'ChZSZXNwb25zZUNsb2NrT2Zmc2V0R2V0EhIKBHRpbWUYASABKA1SBHRpbWUSIQoMY2xvY2tfb2'
        'Zmc2V0GAIgASgSUgtjbG9ja09mZnNldBIQCgNydGQYAyABKAVSA3J0ZA==');

@$core.Deprecated('Use requestCapabilitiesGetDescriptor instead')
const RequestCapabilitiesGet$json = {
  '1': 'RequestCapabilitiesGet',
};

/// Descriptor for `RequestCapabilitiesGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestCapabilitiesGetDescriptor =
    $convert.base64Decode('ChZSZXF1ZXN0Q2FwYWJpbGl0aWVzR2V0');

@$core.Deprecated('Use responseCapabilitiesGetDescriptor instead')
const ResponseCapabilitiesGet$json = {
  '1': 'ResponseCapabilitiesGet',
  '2': [
    {'1': 'vulva_oriented', '3': 1, '4': 1, '5': 8, '10': 'vulvaOriented'},
    {'1': 'battery', '3': 2, '4': 1, '5': 8, '10': 'battery'},
    {'1': 'slider', '3': 3, '4': 1, '5': 13, '10': 'slider'},
    {'1': 'lra', '3': 4, '4': 1, '5': 13, '10': 'lra'},
    {'1': 'erm', '3': 5, '4': 1, '5': 13, '10': 'erm'},
    {'1': 'external_memory', '3': 6, '4': 1, '5': 8, '10': 'externalMemory'},
    {'1': 'rgb_led_indicator', '3': 7, '4': 1, '5': 8, '10': 'rgbLedIndicator'},
    {'1': 'led_matrix', '3': 8, '4': 1, '5': 8, '10': 'ledMatrix'},
    {'1': 'led_matrix_leds_x', '3': 9, '4': 1, '5': 13, '10': 'ledMatrixLedsX'},
    {
      '1': 'led_matrix_leds_y',
      '3': 10,
      '4': 1,
      '5': 13,
      '10': 'ledMatrixLedsY'
    },
    {'1': 'rgb_ring', '3': 11, '4': 1, '5': 8, '10': 'rgbRing'},
    {'1': 'rgb_ring_leds', '3': 12, '4': 1, '5': 13, '10': 'rgbRingLeds'},
    {
      '1': 'battery_capacity',
      '3': 13,
      '4': 1,
      '5': 13,
      '10': 'batteryCapacity'
    },
    {
      '1': 'battery_driver',
      '3': 14,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.BatteryDriver',
      '10': 'batteryDriver'
    },
    {'1': 'ble_mtu', '3': 15, '4': 1, '5': 13, '10': 'bleMtu'},
    {'1': 'ws_buffer_size', '3': 16, '4': 1, '5': 13, '10': 'wsBufferSize'},
    {'1': 'sensors', '3': 17, '4': 1, '5': 13, '10': 'sensors'},
    {
      '1': 'usb_voltage_measure',
      '3': 18,
      '4': 1,
      '5': 8,
      '10': 'usbVoltageMeasure'
    },
  ],
};

/// Descriptor for `ResponseCapabilitiesGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseCapabilitiesGetDescriptor = $convert.base64Decode(
    'ChdSZXNwb25zZUNhcGFiaWxpdGllc0dldBIlCg52dWx2YV9vcmllbnRlZBgBIAEoCFINdnVsdm'
    'FPcmllbnRlZBIYCgdiYXR0ZXJ5GAIgASgIUgdiYXR0ZXJ5EhYKBnNsaWRlchgDIAEoDVIGc2xp'
    'ZGVyEhAKA2xyYRgEIAEoDVIDbHJhEhAKA2VybRgFIAEoDVIDZXJtEicKD2V4dGVybmFsX21lbW'
    '9yeRgGIAEoCFIOZXh0ZXJuYWxNZW1vcnkSKgoRcmdiX2xlZF9pbmRpY2F0b3IYByABKAhSD3Jn'
    'YkxlZEluZGljYXRvchIdCgpsZWRfbWF0cml4GAggASgIUglsZWRNYXRyaXgSKQoRbGVkX21hdH'
    'JpeF9sZWRzX3gYCSABKA1SDmxlZE1hdHJpeExlZHNYEikKEWxlZF9tYXRyaXhfbGVkc195GAog'
    'ASgNUg5sZWRNYXRyaXhMZWRzWRIZCghyZ2JfcmluZxgLIAEoCFIHcmdiUmluZxIiCg1yZ2Jfcm'
    'luZ19sZWRzGAwgASgNUgtyZ2JSaW5nTGVkcxIpChBiYXR0ZXJ5X2NhcGFjaXR5GA0gASgNUg9i'
    'YXR0ZXJ5Q2FwYWNpdHkSPQoOYmF0dGVyeV9kcml2ZXIYDiABKA4yFi5oZHlfcnBjLkJhdHRlcn'
    'lEcml2ZXJSDWJhdHRlcnlEcml2ZXISFwoHYmxlX210dRgPIAEoDVIGYmxlTXR1EiQKDndzX2J1'
    'ZmZlcl9zaXplGBAgASgNUgx3c0J1ZmZlclNpemUSGAoHc2Vuc29ycxgRIAEoDVIHc2Vuc29ycx'
    'IuChN1c2Jfdm9sdGFnZV9tZWFzdXJlGBIgASgIUhF1c2JWb2x0YWdlTWVhc3VyZQ==');

@$core.Deprecated('Use requestSessionIdsGetDescriptor instead')
const RequestSessionIdsGet$json = {
  '1': 'RequestSessionIdsGet',
};

/// Descriptor for `RequestSessionIdsGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestSessionIdsGetDescriptor =
    $convert.base64Decode('ChRSZXF1ZXN0U2Vzc2lvbklkc0dldA==');

@$core.Deprecated('Use responseSessionIdsGetDescriptor instead')
const ResponseSessionIdsGet$json = {
  '1': 'ResponseSessionIdsGet',
  '2': [
    {'1': 'boot_session_id', '3': 1, '4': 1, '5': 13, '10': 'bootSessionId'},
    {
      '1': 'socket_session_id',
      '3': 2,
      '4': 1,
      '5': 13,
      '10': 'socketSessionId'
    },
    {'1': 'mode_session_id', '3': 3, '4': 1, '5': 13, '10': 'modeSessionId'},
  ],
};

/// Descriptor for `ResponseSessionIdsGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseSessionIdsGetDescriptor = $convert.base64Decode(
    'ChVSZXNwb25zZVNlc3Npb25JZHNHZXQSJgoPYm9vdF9zZXNzaW9uX2lkGAEgASgNUg1ib290U2'
    'Vzc2lvbklkEioKEXNvY2tldF9zZXNzaW9uX2lkGAIgASgNUg9zb2NrZXRTZXNzaW9uSWQSJgoP'
    'bW9kZV9zZXNzaW9uX2lkGAMgASgNUg1tb2RlU2Vzc2lvbklk');

@$core.Deprecated('Use requestStopCurrentModeDescriptor instead')
const RequestStopCurrentMode$json = {
  '1': 'RequestStopCurrentMode',
};

/// Descriptor for `RequestStopCurrentMode`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestStopCurrentModeDescriptor =
    $convert.base64Decode('ChZSZXF1ZXN0U3RvcEN1cnJlbnRNb2Rl');

@$core.Deprecated('Use requestConnectionModeSetDescriptor instead')
const RequestConnectionModeSet$json = {
  '1': 'RequestConnectionModeSet',
  '2': [
    {
      '1': 'mode',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.ConnectionMode',
      '10': 'mode'
    },
  ],
};

/// Descriptor for `RequestConnectionModeSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestConnectionModeSetDescriptor =
    $convert.base64Decode(
        'ChhSZXF1ZXN0Q29ubmVjdGlvbk1vZGVTZXQSKwoEbW9kZRgBIAEoDjIXLmhkeV9ycGMuQ29ubm'
        'VjdGlvbk1vZGVSBG1vZGU=');

@$core.Deprecated('Use requestConnectionModeGetDescriptor instead')
const RequestConnectionModeGet$json = {
  '1': 'RequestConnectionModeGet',
};

/// Descriptor for `RequestConnectionModeGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestConnectionModeGetDescriptor =
    $convert.base64Decode('ChhSZXF1ZXN0Q29ubmVjdGlvbk1vZGVHZXQ=');

@$core.Deprecated('Use responseConnectionModeGetDescriptor instead')
const ResponseConnectionModeGet$json = {
  '1': 'ResponseConnectionModeGet',
  '2': [
    {
      '1': 'mode',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.ConnectionMode',
      '10': 'mode'
    },
  ],
};

/// Descriptor for `ResponseConnectionModeGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseConnectionModeGetDescriptor =
    $convert.base64Decode(
        'ChlSZXNwb25zZUNvbm5lY3Rpb25Nb2RlR2V0EisKBG1vZGUYASABKA4yFy5oZHlfcnBjLkNvbm'
        '5lY3Rpb25Nb2RlUgRtb2Rl');

@$core.Deprecated('Use requestPublicInfoGetDescriptor instead')
const RequestPublicInfoGet$json = {
  '1': 'RequestPublicInfoGet',
};

/// Descriptor for `RequestPublicInfoGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestPublicInfoGetDescriptor =
    $convert.base64Decode('ChRSZXF1ZXN0UHVibGljSW5mb0dldA==');

@$core.Deprecated('Use responsePublicInfoGetDescriptor instead')
const ResponsePublicInfoGet$json = {
  '1': 'ResponsePublicInfoGet',
  '2': [
    {'1': 'hw_model_number', '3': 1, '4': 1, '5': 13, '10': 'hwModelNumber'},
    {
      '1': 'hw_model_variant_number',
      '3': 2,
      '4': 1,
      '5': 13,
      '10': 'hwModelVariantNumber'
    },
    {'1': 'fw_version', '3': 3, '4': 1, '5': 9, '10': 'fwVersion'},
    {'1': 'fw_feature_flags', '3': 4, '4': 1, '5': 9, '10': 'fwFeatureFlags'},
  ],
};

/// Descriptor for `ResponsePublicInfoGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responsePublicInfoGetDescriptor = $convert.base64Decode(
    'ChVSZXNwb25zZVB1YmxpY0luZm9HZXQSJgoPaHdfbW9kZWxfbnVtYmVyGAEgASgNUg1od01vZG'
    'VsTnVtYmVyEjUKF2h3X21vZGVsX3ZhcmlhbnRfbnVtYmVyGAIgASgNUhRod01vZGVsVmFyaWFu'
    'dE51bWJlchIdCgpmd192ZXJzaW9uGAMgASgJUglmd1ZlcnNpb24SKAoQZndfZmVhdHVyZV9mbG'
    'FncxgEIAEoCVIOZndGZWF0dXJlRmxhZ3M=');

@$core.Deprecated('Use requestHampStartDescriptor instead')
const RequestHampStart$json = {
  '1': 'RequestHampStart',
};

/// Descriptor for `RequestHampStart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHampStartDescriptor =
    $convert.base64Decode('ChBSZXF1ZXN0SGFtcFN0YXJ0');

@$core.Deprecated('Use responseHampStartDescriptor instead')
const ResponseHampStart$json = {
  '1': 'ResponseHampStart',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HampState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHampStart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHampStartDescriptor = $convert.base64Decode(
    'ChFSZXNwb25zZUhhbXBTdGFydBIoCgVzdGF0ZRgBIAEoCzISLmhkeV9ycGMuSGFtcFN0YXRlUg'
    'VzdGF0ZQ==');

@$core.Deprecated('Use requestHampStopDescriptor instead')
const RequestHampStop$json = {
  '1': 'RequestHampStop',
};

/// Descriptor for `RequestHampStop`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHampStopDescriptor =
    $convert.base64Decode('Cg9SZXF1ZXN0SGFtcFN0b3A=');

@$core.Deprecated('Use responseHampStopDescriptor instead')
const ResponseHampStop$json = {
  '1': 'ResponseHampStop',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HampState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHampStop`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHampStopDescriptor = $convert.base64Decode(
    'ChBSZXNwb25zZUhhbXBTdG9wEigKBXN0YXRlGAEgASgLMhIuaGR5X3JwYy5IYW1wU3RhdGVSBX'
    'N0YXRl');

@$core.Deprecated('Use requestHampVelocitySetDescriptor instead')
const RequestHampVelocitySet$json = {
  '1': 'RequestHampVelocitySet',
  '2': [
    {'1': 'velocity', '3': 1, '4': 1, '5': 2, '10': 'velocity'},
  ],
};

/// Descriptor for `RequestHampVelocitySet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHampVelocitySetDescriptor =
    $convert.base64Decode(
        'ChZSZXF1ZXN0SGFtcFZlbG9jaXR5U2V0EhoKCHZlbG9jaXR5GAEgASgCUgh2ZWxvY2l0eQ==');

@$core.Deprecated('Use responseHampVelocitySetDescriptor instead')
const ResponseHampVelocitySet$json = {
  '1': 'ResponseHampVelocitySet',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HampState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHampVelocitySet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHampVelocitySetDescriptor =
    $convert.base64Decode(
        'ChdSZXNwb25zZUhhbXBWZWxvY2l0eVNldBIoCgVzdGF0ZRgBIAEoCzISLmhkeV9ycGMuSGFtcF'
        'N0YXRlUgVzdGF0ZQ==');

@$core.Deprecated('Use requestHampStateGetDescriptor instead')
const RequestHampStateGet$json = {
  '1': 'RequestHampStateGet',
};

/// Descriptor for `RequestHampStateGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHampStateGetDescriptor =
    $convert.base64Decode('ChNSZXF1ZXN0SGFtcFN0YXRlR2V0');

@$core.Deprecated('Use responseHampStateGetDescriptor instead')
const ResponseHampStateGet$json = {
  '1': 'ResponseHampStateGet',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HampState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHampStateGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHampStateGetDescriptor = $convert.base64Decode(
    'ChRSZXNwb25zZUhhbXBTdGF0ZUdldBIoCgVzdGF0ZRgBIAEoCzISLmhkeV9ycGMuSGFtcFN0YX'
    'RlUgVzdGF0ZQ==');

@$core.Deprecated('Use requestHampZoneSetDescriptor instead')
const RequestHampZoneSet$json = {
  '1': 'RequestHampZoneSet',
  '2': [
    {'1': 'min', '3': 1, '4': 1, '5': 2, '10': 'min'},
    {'1': 'max', '3': 2, '4': 1, '5': 2, '10': 'max'},
  ],
};

/// Descriptor for `RequestHampZoneSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHampZoneSetDescriptor = $convert.base64Decode(
    'ChJSZXF1ZXN0SGFtcFpvbmVTZXQSEAoDbWluGAEgASgCUgNtaW4SEAoDbWF4GAIgASgCUgNtYX'
    'g=');

@$core.Deprecated('Use responseHampZoneSetDescriptor instead')
const ResponseHampZoneSet$json = {
  '1': 'ResponseHampZoneSet',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HampState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHampZoneSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHampZoneSetDescriptor = $convert.base64Decode(
    'ChNSZXNwb25zZUhhbXBab25lU2V0EigKBXN0YXRlGAEgASgLMhIuaGR5X3JwYy5IYW1wU3RhdG'
    'VSBXN0YXRl');

@$core.Deprecated('Use requestHdspXaVaSetDescriptor instead')
const RequestHdspXaVaSet$json = {
  '1': 'RequestHdspXaVaSet',
  '2': [
    {'1': 'xa', '3': 1, '4': 1, '5': 2, '10': 'xa'},
    {'1': 'va', '3': 2, '4': 1, '5': 2, '10': 'va'},
    {'1': 'stop_on_target', '3': 3, '4': 1, '5': 8, '10': 'stopOnTarget'},
  ],
};

/// Descriptor for `RequestHdspXaVaSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHdspXaVaSetDescriptor = $convert.base64Decode(
    'ChJSZXF1ZXN0SGRzcFhhVmFTZXQSDgoCeGEYASABKAJSAnhhEg4KAnZhGAIgASgCUgJ2YRIkCg'
    '5zdG9wX29uX3RhcmdldBgDIAEoCFIMc3RvcE9uVGFyZ2V0');

@$core.Deprecated('Use requestHdspXpVaSetDescriptor instead')
const RequestHdspXpVaSet$json = {
  '1': 'RequestHdspXpVaSet',
  '2': [
    {'1': 'xp', '3': 1, '4': 1, '5': 2, '10': 'xp'},
    {'1': 'va', '3': 2, '4': 1, '5': 2, '10': 'va'},
    {'1': 'stop_on_target', '3': 3, '4': 1, '5': 8, '10': 'stopOnTarget'},
  ],
};

/// Descriptor for `RequestHdspXpVaSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHdspXpVaSetDescriptor = $convert.base64Decode(
    'ChJSZXF1ZXN0SGRzcFhwVmFTZXQSDgoCeHAYASABKAJSAnhwEg4KAnZhGAIgASgCUgJ2YRIkCg'
    '5zdG9wX29uX3RhcmdldBgDIAEoCFIMc3RvcE9uVGFyZ2V0');

@$core.Deprecated('Use requestHdspXpVpSetDescriptor instead')
const RequestHdspXpVpSet$json = {
  '1': 'RequestHdspXpVpSet',
  '2': [
    {'1': 'xp', '3': 1, '4': 1, '5': 2, '10': 'xp'},
    {'1': 'vp', '3': 2, '4': 1, '5': 2, '10': 'vp'},
    {'1': 'stop_on_target', '3': 3, '4': 1, '5': 8, '10': 'stopOnTarget'},
  ],
};

/// Descriptor for `RequestHdspXpVpSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHdspXpVpSetDescriptor = $convert.base64Decode(
    'ChJSZXF1ZXN0SGRzcFhwVnBTZXQSDgoCeHAYASABKAJSAnhwEg4KAnZwGAIgASgCUgJ2cBIkCg'
    '5zdG9wX29uX3RhcmdldBgDIAEoCFIMc3RvcE9uVGFyZ2V0');

@$core.Deprecated('Use requestHdspXaTSetDescriptor instead')
const RequestHdspXaTSet$json = {
  '1': 'RequestHdspXaTSet',
  '2': [
    {'1': 'xa', '3': 1, '4': 1, '5': 2, '10': 'xa'},
    {'1': 't', '3': 2, '4': 1, '5': 13, '10': 't'},
    {'1': 'stop_on_target', '3': 3, '4': 1, '5': 8, '10': 'stopOnTarget'},
  ],
};

/// Descriptor for `RequestHdspXaTSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHdspXaTSetDescriptor = $convert.base64Decode(
    'ChFSZXF1ZXN0SGRzcFhhVFNldBIOCgJ4YRgBIAEoAlICeGESDAoBdBgCIAEoDVIBdBIkCg5zdG'
    '9wX29uX3RhcmdldBgDIAEoCFIMc3RvcE9uVGFyZ2V0');

@$core.Deprecated('Use requestHdspXpTSetDescriptor instead')
const RequestHdspXpTSet$json = {
  '1': 'RequestHdspXpTSet',
  '2': [
    {'1': 'xp', '3': 1, '4': 1, '5': 2, '10': 'xp'},
    {'1': 't', '3': 2, '4': 1, '5': 13, '10': 't'},
    {'1': 'stop_on_target', '3': 3, '4': 1, '5': 8, '10': 'stopOnTarget'},
  ],
};

/// Descriptor for `RequestHdspXpTSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHdspXpTSetDescriptor = $convert.base64Decode(
    'ChFSZXF1ZXN0SGRzcFhwVFNldBIOCgJ4cBgBIAEoAlICeHASDAoBdBgCIAEoDVIBdBIkCg5zdG'
    '9wX29uX3RhcmdldBgDIAEoCFIMc3RvcE9uVGFyZ2V0');

@$core.Deprecated('Use requestHdspXaVpSetDescriptor instead')
const RequestHdspXaVpSet$json = {
  '1': 'RequestHdspXaVpSet',
  '2': [
    {'1': 'xa', '3': 1, '4': 1, '5': 2, '10': 'xa'},
    {'1': 'vp', '3': 2, '4': 1, '5': 2, '10': 'vp'},
    {'1': 'stop_on_target', '3': 3, '4': 1, '5': 8, '10': 'stopOnTarget'},
  ],
};

/// Descriptor for `RequestHdspXaVpSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHdspXaVpSetDescriptor = $convert.base64Decode(
    'ChJSZXF1ZXN0SGRzcFhhVnBTZXQSDgoCeGEYASABKAJSAnhhEg4KAnZwGAIgASgCUgJ2cBIkCg'
    '5zdG9wX29uX3RhcmdldBgDIAEoCFIMc3RvcE9uVGFyZ2V0');

@$core.Deprecated('Use requestHdspStopDescriptor instead')
const RequestHdspStop$json = {
  '1': 'RequestHdspStop',
};

/// Descriptor for `RequestHdspStop`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHdspStopDescriptor =
    $convert.base64Decode('Cg9SZXF1ZXN0SGRzcFN0b3A=');

@$core.Deprecated('Use requestSensorNotificationSetDescriptor instead')
const RequestSensorNotificationSet$json = {
  '1': 'RequestSensorNotificationSet',
  '2': [
    {'1': 'enabled', '3': 1, '4': 1, '5': 8, '10': 'enabled'},
    {'1': 'raw', '3': 2, '4': 1, '5': 8, '10': 'raw'},
    {'1': 'bits', '3': 3, '4': 1, '5': 8, '10': 'bits'},
    {'1': 'position_abs', '3': 4, '4': 1, '5': 8, '10': 'positionAbs'},
    {'1': 'position_rel', '3': 5, '4': 1, '5': 8, '10': 'positionRel'},
    {'1': 'min_interval_ms', '3': 6, '4': 1, '5': 13, '10': 'minIntervalMs'},
    {
      '1': 'mode',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.SensorNotificationMode',
      '10': 'mode'
    },
  ],
};

/// Descriptor for `RequestSensorNotificationSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestSensorNotificationSetDescriptor = $convert.base64Decode(
    'ChxSZXF1ZXN0U2Vuc29yTm90aWZpY2F0aW9uU2V0EhgKB2VuYWJsZWQYASABKAhSB2VuYWJsZW'
    'QSEAoDcmF3GAIgASgIUgNyYXcSEgoEYml0cxgDIAEoCFIEYml0cxIhCgxwb3NpdGlvbl9hYnMY'
    'BCABKAhSC3Bvc2l0aW9uQWJzEiEKDHBvc2l0aW9uX3JlbBgFIAEoCFILcG9zaXRpb25SZWwSJg'
    'oPbWluX2ludGVydmFsX21zGAYgASgNUg1taW5JbnRlcnZhbE1zEjMKBG1vZGUYByABKA4yHy5o'
    'ZHlfcnBjLlNlbnNvck5vdGlmaWNhdGlvbk1vZGVSBG1vZGU=');

@$core.Deprecated('Use responseSensorNotificationSetDescriptor instead')
const ResponseSensorNotificationSet$json = {
  '1': 'ResponseSensorNotificationSet',
  '2': [
    {'1': 'enabled', '3': 1, '4': 1, '5': 8, '10': 'enabled'},
    {'1': 'raw', '3': 2, '4': 1, '5': 8, '10': 'raw'},
    {'1': 'bits', '3': 3, '4': 1, '5': 8, '10': 'bits'},
    {'1': 'position_abs', '3': 4, '4': 1, '5': 8, '10': 'positionAbs'},
    {'1': 'position_rel', '3': 5, '4': 1, '5': 8, '10': 'positionRel'},
    {'1': 'min_interval_ms', '3': 6, '4': 1, '5': 13, '10': 'minIntervalMs'},
    {
      '1': 'mode',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.SensorNotificationMode',
      '10': 'mode'
    },
  ],
};

/// Descriptor for `ResponseSensorNotificationSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseSensorNotificationSetDescriptor = $convert.base64Decode(
    'Ch1SZXNwb25zZVNlbnNvck5vdGlmaWNhdGlvblNldBIYCgdlbmFibGVkGAEgASgIUgdlbmFibG'
    'VkEhAKA3JhdxgCIAEoCFIDcmF3EhIKBGJpdHMYAyABKAhSBGJpdHMSIQoMcG9zaXRpb25fYWJz'
    'GAQgASgIUgtwb3NpdGlvbkFicxIhCgxwb3NpdGlvbl9yZWwYBSABKAhSC3Bvc2l0aW9uUmVsEi'
    'YKD21pbl9pbnRlcnZhbF9tcxgGIAEoDVINbWluSW50ZXJ2YWxNcxIzCgRtb2RlGAcgASgOMh8u'
    'aGR5X3JwYy5TZW5zb3JOb3RpZmljYXRpb25Nb2RlUgRtb2Rl');

@$core.Deprecated('Use requestSensorStateGetDescriptor instead')
const RequestSensorStateGet$json = {
  '1': 'RequestSensorStateGet',
};

/// Descriptor for `RequestSensorStateGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestSensorStateGetDescriptor =
    $convert.base64Decode('ChVSZXF1ZXN0U2Vuc29yU3RhdGVHZXQ=');

@$core.Deprecated('Use responseSensorStateGetDescriptor instead')
const ResponseSensorStateGet$json = {
  '1': 'ResponseSensorStateGet',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.SensorState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseSensorStateGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseSensorStateGetDescriptor =
    $convert.base64Decode(
        'ChZSZXNwb25zZVNlbnNvclN0YXRlR2V0EioKBXN0YXRlGAEgASgLMhQuaGR5X3JwYy5TZW5zb3'
        'JTdGF0ZVIFc3RhdGU=');

@$core.Deprecated('Use requestSensorNotificationGetDescriptor instead')
const RequestSensorNotificationGet$json = {
  '1': 'RequestSensorNotificationGet',
};

/// Descriptor for `RequestSensorNotificationGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestSensorNotificationGetDescriptor =
    $convert.base64Decode('ChxSZXF1ZXN0U2Vuc29yTm90aWZpY2F0aW9uR2V0');

@$core.Deprecated('Use responseSensorNotificationGetDescriptor instead')
const ResponseSensorNotificationGet$json = {
  '1': 'ResponseSensorNotificationGet',
  '2': [
    {'1': 'enabled', '3': 1, '4': 1, '5': 8, '10': 'enabled'},
    {'1': 'raw', '3': 2, '4': 1, '5': 8, '10': 'raw'},
    {'1': 'bits', '3': 3, '4': 1, '5': 8, '10': 'bits'},
    {'1': 'position_abs', '3': 4, '4': 1, '5': 8, '10': 'positionAbs'},
    {'1': 'position_rel', '3': 5, '4': 1, '5': 8, '10': 'positionRel'},
    {'1': 'min_interval_ms', '3': 6, '4': 1, '5': 13, '10': 'minIntervalMs'},
    {
      '1': 'mode',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.SensorNotificationMode',
      '10': 'mode'
    },
  ],
};

/// Descriptor for `ResponseSensorNotificationGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseSensorNotificationGetDescriptor = $convert.base64Decode(
    'Ch1SZXNwb25zZVNlbnNvck5vdGlmaWNhdGlvbkdldBIYCgdlbmFibGVkGAEgASgIUgdlbmFibG'
    'VkEhAKA3JhdxgCIAEoCFIDcmF3EhIKBGJpdHMYAyABKAhSBGJpdHMSIQoMcG9zaXRpb25fYWJz'
    'GAQgASgIUgtwb3NpdGlvbkFicxIhCgxwb3NpdGlvbl9yZWwYBSABKAhSC3Bvc2l0aW9uUmVsEi'
    'YKD21pbl9pbnRlcnZhbF9tcxgGIAEoDVINbWluSW50ZXJ2YWxNcxIzCgRtb2RlGAcgASgOMh8u'
    'aGR5X3JwYy5TZW5zb3JOb3RpZmljYXRpb25Nb2RlUgRtb2Rl');

@$core.Deprecated('Use requestSliderStrokeGetDescriptor instead')
const RequestSliderStrokeGet$json = {
  '1': 'RequestSliderStrokeGet',
};

/// Descriptor for `RequestSliderStrokeGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestSliderStrokeGetDescriptor =
    $convert.base64Decode('ChZSZXF1ZXN0U2xpZGVyU3Ryb2tlR2V0');

@$core.Deprecated('Use responseSliderStrokeGetDescriptor instead')
const ResponseSliderStrokeGet$json = {
  '1': 'ResponseSliderStrokeGet',
  '2': [
    {'1': 'min', '3': 1, '4': 1, '5': 2, '10': 'min'},
    {'1': 'max', '3': 2, '4': 1, '5': 2, '10': 'max'},
    {'1': 'min_absolute', '3': 3, '4': 1, '5': 2, '10': 'minAbsolute'},
    {'1': 'max_absolute', '3': 4, '4': 1, '5': 2, '10': 'maxAbsolute'},
  ],
};

/// Descriptor for `ResponseSliderStrokeGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseSliderStrokeGetDescriptor = $convert.base64Decode(
    'ChdSZXNwb25zZVNsaWRlclN0cm9rZUdldBIQCgNtaW4YASABKAJSA21pbhIQCgNtYXgYAiABKA'
    'JSA21heBIhCgxtaW5fYWJzb2x1dGUYAyABKAJSC21pbkFic29sdXRlEiEKDG1heF9hYnNvbHV0'
    'ZRgEIAEoAlILbWF4QWJzb2x1dGU=');

@$core.Deprecated('Use requestSliderStrokeSetDescriptor instead')
const RequestSliderStrokeSet$json = {
  '1': 'RequestSliderStrokeSet',
  '2': [
    {'1': 'min', '3': 1, '4': 1, '5': 2, '10': 'min'},
    {'1': 'max', '3': 2, '4': 1, '5': 2, '10': 'max'},
  ],
};

/// Descriptor for `RequestSliderStrokeSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestSliderStrokeSetDescriptor =
    $convert.base64Decode(
        'ChZSZXF1ZXN0U2xpZGVyU3Ryb2tlU2V0EhAKA21pbhgBIAEoAlIDbWluEhAKA21heBgCIAEoAl'
        'IDbWF4');

@$core.Deprecated('Use responseSliderStrokeSetDescriptor instead')
const ResponseSliderStrokeSet$json = {
  '1': 'ResponseSliderStrokeSet',
  '2': [
    {'1': 'min', '3': 1, '4': 1, '5': 2, '10': 'min'},
    {'1': 'max', '3': 2, '4': 1, '5': 2, '10': 'max'},
    {'1': 'min_absolute', '3': 3, '4': 1, '5': 2, '10': 'minAbsolute'},
    {'1': 'max_absolute', '3': 4, '4': 1, '5': 2, '10': 'maxAbsolute'},
  ],
};

/// Descriptor for `ResponseSliderStrokeSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseSliderStrokeSetDescriptor = $convert.base64Decode(
    'ChdSZXNwb25zZVNsaWRlclN0cm9rZVNldBIQCgNtaW4YASABKAJSA21pbhIQCgNtYXgYAiABKA'
    'JSA21heBIhCgxtaW5fYWJzb2x1dGUYAyABKAJSC21pbkFic29sdXRlEiEKDG1heF9hYnNvbHV0'
    'ZRgEIAEoAlILbWF4QWJzb2x1dGU=');

@$core.Deprecated('Use requestSliderStateGetDescriptor instead')
const RequestSliderStateGet$json = {
  '1': 'RequestSliderStateGet',
};

/// Descriptor for `RequestSliderStateGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestSliderStateGetDescriptor =
    $convert.base64Decode('ChVSZXF1ZXN0U2xpZGVyU3RhdGVHZXQ=');

@$core.Deprecated('Use responseSliderStateGetDescriptor instead')
const ResponseSliderStateGet$json = {
  '1': 'ResponseSliderStateGet',
  '2': [
    {'1': 'position', '3': 1, '4': 1, '5': 2, '10': 'position'},
    {
      '1': 'position_absolute',
      '3': 2,
      '4': 1,
      '5': 2,
      '10': 'positionAbsolute'
    },
    {'1': 'motor_temp', '3': 3, '4': 1, '5': 2, '10': 'motorTemp'},
    {'1': 'speed_absolute', '3': 4, '4': 1, '5': 2, '10': 'speedAbsolute'},
    {'1': 'dir', '3': 5, '4': 1, '5': 8, '10': 'dir'},
    {'1': 'motor_position', '3': 6, '4': 1, '5': 13, '10': 'motorPosition'},
    {
      '1': 'motor_temp_adc_value',
      '3': 7,
      '4': 1,
      '5': 13,
      '10': 'motorTempAdcValue'
    },
  ],
};

/// Descriptor for `ResponseSliderStateGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseSliderStateGetDescriptor = $convert.base64Decode(
    'ChZSZXNwb25zZVNsaWRlclN0YXRlR2V0EhoKCHBvc2l0aW9uGAEgASgCUghwb3NpdGlvbhIrCh'
    'Fwb3NpdGlvbl9hYnNvbHV0ZRgCIAEoAlIQcG9zaXRpb25BYnNvbHV0ZRIdCgptb3Rvcl90ZW1w'
    'GAMgASgCUgltb3RvclRlbXASJQoOc3BlZWRfYWJzb2x1dGUYBCABKAJSDXNwZWVkQWJzb2x1dG'
    'USEAoDZGlyGAUgASgIUgNkaXISJQoObW90b3JfcG9zaXRpb24YBiABKA1SDW1vdG9yUG9zaXRp'
    'b24SLwoUbW90b3JfdGVtcF9hZGNfdmFsdWUYByABKA1SEW1vdG9yVGVtcEFkY1ZhbHVl');

@$core.Deprecated('Use requestSliderCalibrateDescriptor instead')
const RequestSliderCalibrate$json = {
  '1': 'RequestSliderCalibrate',
  '2': [
    {'1': 'go_to_start', '3': 1, '4': 1, '5': 8, '10': 'goToStart'},
  ],
};

/// Descriptor for `RequestSliderCalibrate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestSliderCalibrateDescriptor =
    $convert.base64Decode(
        'ChZSZXF1ZXN0U2xpZGVyQ2FsaWJyYXRlEh4KC2dvX3RvX3N0YXJ0GAEgASgIUglnb1RvU3Rhcn'
        'Q=');

@$core.Deprecated('Use responseSliderCalibrateDescriptor instead')
const ResponseSliderCalibrate$json = {
  '1': 'ResponseSliderCalibrate',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `ResponseSliderCalibrate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseSliderCalibrateDescriptor =
    $convert.base64Decode(
        'ChdSZXNwb25zZVNsaWRlckNhbGlicmF0ZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNz');

@$core.Deprecated('Use requestSlideDiagStartDescriptor instead')
const RequestSlideDiagStart$json = {
  '1': 'RequestSlideDiagStart',
  '2': [
    {
      '1': 'channel',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.SlideDiagChannel',
      '10': 'channel'
    },
    {'1': 'max_records', '3': 2, '4': 1, '5': 13, '10': 'maxRecords'},
    {'1': 'wrap', '3': 3, '4': 1, '5': 8, '10': 'wrap'},
    {'1': 'field_mask', '3': 4, '4': 1, '5': 13, '10': 'fieldMask'},
  ],
};

/// Descriptor for `RequestSlideDiagStart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestSlideDiagStartDescriptor = $convert.base64Decode(
    'ChVSZXF1ZXN0U2xpZGVEaWFnU3RhcnQSMwoHY2hhbm5lbBgBIAEoDjIZLmhkeV9ycGMuU2xpZG'
    'VEaWFnQ2hhbm5lbFIHY2hhbm5lbBIfCgttYXhfcmVjb3JkcxgCIAEoDVIKbWF4UmVjb3JkcxIS'
    'CgR3cmFwGAMgASgIUgR3cmFwEh0KCmZpZWxkX21hc2sYBCABKA1SCWZpZWxkTWFzaw==');

@$core.Deprecated('Use responseSlideDiagStartDescriptor instead')
const ResponseSlideDiagStart$json = {
  '1': 'ResponseSlideDiagStart',
  '2': [
    {'1': 'capacity_records', '3': 1, '4': 1, '5': 13, '10': 'capacityRecords'},
    {'1': 'entry_size', '3': 2, '4': 1, '5': 13, '10': 'entrySize'},
    {'1': 'format_version', '3': 3, '4': 1, '5': 13, '10': 'formatVersion'},
    {'1': 'seq', '3': 4, '4': 1, '5': 13, '10': 'seq'},
    {'1': 'field_mask', '3': 5, '4': 1, '5': 13, '10': 'fieldMask'},
  ],
};

/// Descriptor for `ResponseSlideDiagStart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseSlideDiagStartDescriptor = $convert.base64Decode(
    'ChZSZXNwb25zZVNsaWRlRGlhZ1N0YXJ0EikKEGNhcGFjaXR5X3JlY29yZHMYASABKA1SD2NhcG'
    'FjaXR5UmVjb3JkcxIdCgplbnRyeV9zaXplGAIgASgNUgllbnRyeVNpemUSJQoOZm9ybWF0X3Zl'
    'cnNpb24YAyABKA1SDWZvcm1hdFZlcnNpb24SEAoDc2VxGAQgASgNUgNzZXESHQoKZmllbGRfbW'
    'FzaxgFIAEoDVIJZmllbGRNYXNr');

@$core.Deprecated('Use requestSlideDiagStatusDescriptor instead')
const RequestSlideDiagStatus$json = {
  '1': 'RequestSlideDiagStatus',
  '2': [
    {
      '1': 'channel',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.SlideDiagChannel',
      '10': 'channel'
    },
  ],
};

/// Descriptor for `RequestSlideDiagStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestSlideDiagStatusDescriptor =
    $convert.base64Decode(
        'ChZSZXF1ZXN0U2xpZGVEaWFnU3RhdHVzEjMKB2NoYW5uZWwYASABKA4yGS5oZHlfcnBjLlNsaW'
        'RlRGlhZ0NoYW5uZWxSB2NoYW5uZWw=');

@$core.Deprecated('Use responseSlideDiagStatusDescriptor instead')
const ResponseSlideDiagStatus$json = {
  '1': 'ResponseSlideDiagStatus',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.SlideDiagState',
      '10': 'state'
    },
    {'1': 'wrap', '3': 2, '4': 1, '5': 8, '10': 'wrap'},
    {'1': 'wrapped', '3': 3, '4': 1, '5': 8, '10': 'wrapped'},
    {'1': 'full', '3': 4, '4': 1, '5': 8, '10': 'full'},
    {'1': 'entry_size', '3': 5, '4': 1, '5': 13, '10': 'entrySize'},
    {'1': 'format_version', '3': 6, '4': 1, '5': 13, '10': 'formatVersion'},
    {'1': 'capacity_records', '3': 7, '4': 1, '5': 13, '10': 'capacityRecords'},
    {'1': 'used_records', '3': 8, '4': 1, '5': 13, '10': 'usedRecords'},
    {'1': 'total_records', '3': 9, '4': 1, '5': 13, '10': 'totalRecords'},
    {'1': 'seq', '3': 10, '4': 1, '5': 13, '10': 'seq'},
    {'1': 'field_mask', '3': 11, '4': 1, '5': 13, '10': 'fieldMask'},
  ],
};

/// Descriptor for `ResponseSlideDiagStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseSlideDiagStatusDescriptor = $convert.base64Decode(
    'ChdSZXNwb25zZVNsaWRlRGlhZ1N0YXR1cxItCgVzdGF0ZRgBIAEoDjIXLmhkeV9ycGMuU2xpZG'
    'VEaWFnU3RhdGVSBXN0YXRlEhIKBHdyYXAYAiABKAhSBHdyYXASGAoHd3JhcHBlZBgDIAEoCFIH'
    'd3JhcHBlZBISCgRmdWxsGAQgASgIUgRmdWxsEh0KCmVudHJ5X3NpemUYBSABKA1SCWVudHJ5U2'
    'l6ZRIlCg5mb3JtYXRfdmVyc2lvbhgGIAEoDVINZm9ybWF0VmVyc2lvbhIpChBjYXBhY2l0eV9y'
    'ZWNvcmRzGAcgASgNUg9jYXBhY2l0eVJlY29yZHMSIQoMdXNlZF9yZWNvcmRzGAggASgNUgt1c2'
    'VkUmVjb3JkcxIjCg10b3RhbF9yZWNvcmRzGAkgASgNUgx0b3RhbFJlY29yZHMSEAoDc2VxGAog'
    'ASgNUgNzZXESHQoKZmllbGRfbWFzaxgLIAEoDVIJZmllbGRNYXNr');

@$core.Deprecated('Use requestSlideDiagReadDescriptor instead')
const RequestSlideDiagRead$json = {
  '1': 'RequestSlideDiagRead',
  '2': [
    {
      '1': 'channel',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.SlideDiagChannel',
      '10': 'channel'
    },
    {'1': 'first_record', '3': 2, '4': 1, '5': 13, '10': 'firstRecord'},
    {'1': 'max_records', '3': 3, '4': 1, '5': 13, '10': 'maxRecords'},
  ],
};

/// Descriptor for `RequestSlideDiagRead`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestSlideDiagReadDescriptor = $convert.base64Decode(
    'ChRSZXF1ZXN0U2xpZGVEaWFnUmVhZBIzCgdjaGFubmVsGAEgASgOMhkuaGR5X3JwYy5TbGlkZU'
    'RpYWdDaGFubmVsUgdjaGFubmVsEiEKDGZpcnN0X3JlY29yZBgCIAEoDVILZmlyc3RSZWNvcmQS'
    'HwoLbWF4X3JlY29yZHMYAyABKA1SCm1heFJlY29yZHM=');

@$core.Deprecated('Use responseSlideDiagReadDescriptor instead')
const ResponseSlideDiagRead$json = {
  '1': 'ResponseSlideDiagRead',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
    {'1': 'record_count', '3': 2, '4': 1, '5': 13, '10': 'recordCount'},
    {'1': 'used_records', '3': 3, '4': 1, '5': 13, '10': 'usedRecords'},
    {'1': 'seq', '3': 4, '4': 1, '5': 13, '10': 'seq'},
  ],
};

/// Descriptor for `ResponseSlideDiagRead`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseSlideDiagReadDescriptor = $convert.base64Decode(
    'ChVSZXNwb25zZVNsaWRlRGlhZ1JlYWQSEgoEZGF0YRgBIAEoDFIEZGF0YRIhCgxyZWNvcmRfY2'
    '91bnQYAiABKA1SC3JlY29yZENvdW50EiEKDHVzZWRfcmVjb3JkcxgDIAEoDVILdXNlZFJlY29y'
    'ZHMSEAoDc2VxGAQgASgNUgNzZXE=');

@$core.Deprecated('Use requestSlideDiagStopDescriptor instead')
const RequestSlideDiagStop$json = {
  '1': 'RequestSlideDiagStop',
  '2': [
    {
      '1': 'channel',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.SlideDiagChannel',
      '10': 'channel'
    },
    {'1': 'free', '3': 2, '4': 1, '5': 8, '10': 'free'},
  ],
};

/// Descriptor for `RequestSlideDiagStop`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestSlideDiagStopDescriptor = $convert.base64Decode(
    'ChRSZXF1ZXN0U2xpZGVEaWFnU3RvcBIzCgdjaGFubmVsGAEgASgOMhkuaGR5X3JwYy5TbGlkZU'
    'RpYWdDaGFubmVsUgdjaGFubmVsEhIKBGZyZWUYAiABKAhSBGZyZWU=');

@$core.Deprecated('Use requestHallCalibrationGetDescriptor instead')
const RequestHallCalibrationGet$json = {
  '1': 'RequestHallCalibrationGet',
};

/// Descriptor for `RequestHallCalibrationGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHallCalibrationGetDescriptor =
    $convert.base64Decode('ChlSZXF1ZXN0SGFsbENhbGlicmF0aW9uR2V0');

@$core.Deprecated('Use responseHallCalibrationGetDescriptor instead')
const ResponseHallCalibrationGet$json = {
  '1': 'ResponseHallCalibrationGet',
  '2': [
    {'1': 'scale', '3': 1, '4': 3, '5': 2, '10': 'scale'},
    {'1': 'stored', '3': 2, '4': 1, '5': 8, '10': 'stored'},
  ],
};

/// Descriptor for `ResponseHallCalibrationGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHallCalibrationGetDescriptor =
    $convert.base64Decode(
        'ChpSZXNwb25zZUhhbGxDYWxpYnJhdGlvbkdldBIUCgVzY2FsZRgBIAMoAlIFc2NhbGUSFgoGc3'
        'RvcmVkGAIgASgIUgZzdG9yZWQ=');

@$core.Deprecated('Use requestSlideDiagStreamDescriptor instead')
const RequestSlideDiagStream$json = {
  '1': 'RequestSlideDiagStream',
  '2': [
    {
      '1': 'channel',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.SlideDiagChannel',
      '10': 'channel'
    },
    {'1': 'first_record', '3': 2, '4': 1, '5': 13, '10': 'firstRecord'},
    {'1': 'max_records', '3': 3, '4': 1, '5': 13, '10': 'maxRecords'},
    {'1': 'max_chunk_bytes', '3': 4, '4': 1, '5': 13, '10': 'maxChunkBytes'},
  ],
};

/// Descriptor for `RequestSlideDiagStream`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestSlideDiagStreamDescriptor = $convert.base64Decode(
    'ChZSZXF1ZXN0U2xpZGVEaWFnU3RyZWFtEjMKB2NoYW5uZWwYASABKA4yGS5oZHlfcnBjLlNsaW'
    'RlRGlhZ0NoYW5uZWxSB2NoYW5uZWwSIQoMZmlyc3RfcmVjb3JkGAIgASgNUgtmaXJzdFJlY29y'
    'ZBIfCgttYXhfcmVjb3JkcxgDIAEoDVIKbWF4UmVjb3JkcxImCg9tYXhfY2h1bmtfYnl0ZXMYBC'
    'ABKA1SDW1heENodW5rQnl0ZXM=');

@$core.Deprecated('Use responseSlideDiagStreamDescriptor instead')
const ResponseSlideDiagStream$json = {
  '1': 'ResponseSlideDiagStream',
  '2': [
    {'1': 'record_count', '3': 1, '4': 1, '5': 13, '10': 'recordCount'},
    {'1': 'chunks', '3': 2, '4': 1, '5': 13, '10': 'chunks'},
    {'1': 'entry_size', '3': 3, '4': 1, '5': 13, '10': 'entrySize'},
    {'1': 'format_version', '3': 4, '4': 1, '5': 13, '10': 'formatVersion'},
    {'1': 'seq', '3': 5, '4': 1, '5': 13, '10': 'seq'},
    {'1': 'field_mask', '3': 6, '4': 1, '5': 13, '10': 'fieldMask'},
  ],
};

/// Descriptor for `ResponseSlideDiagStream`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseSlideDiagStreamDescriptor = $convert.base64Decode(
    'ChdSZXNwb25zZVNsaWRlRGlhZ1N0cmVhbRIhCgxyZWNvcmRfY291bnQYASABKA1SC3JlY29yZE'
    'NvdW50EhYKBmNodW5rcxgCIAEoDVIGY2h1bmtzEh0KCmVudHJ5X3NpemUYAyABKA1SCWVudHJ5'
    'U2l6ZRIlCg5mb3JtYXRfdmVyc2lvbhgEIAEoDVINZm9ybWF0VmVyc2lvbhIQCgNzZXEYBSABKA'
    '1SA3NlcRIdCgpmaWVsZF9tYXNrGAYgASgNUglmaWVsZE1hc2s=');

@$core.Deprecated('Use requestSpeedStatsGetDescriptor instead')
const RequestSpeedStatsGet$json = {
  '1': 'RequestSpeedStatsGet',
};

/// Descriptor for `RequestSpeedStatsGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestSpeedStatsGetDescriptor =
    $convert.base64Decode('ChRSZXF1ZXN0U3BlZWRTdGF0c0dldA==');

@$core.Deprecated('Use responseSpeedStatsGetDescriptor instead')
const ResponseSpeedStatsGet$json = {
  '1': 'ResponseSpeedStatsGet',
  '2': [
    {
      '1': 'stats',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.SpeedStats',
      '10': 'stats'
    },
    {'1': 'notifications', '3': 2, '4': 1, '5': 8, '10': 'notifications'},
    {
      '1': 'notifications_mine',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'notificationsMine'
    },
  ],
};

/// Descriptor for `ResponseSpeedStatsGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseSpeedStatsGetDescriptor = $convert.base64Decode(
    'ChVSZXNwb25zZVNwZWVkU3RhdHNHZXQSKQoFc3RhdHMYASABKAsyEy5oZHlfcnBjLlNwZWVkU3'
    'RhdHNSBXN0YXRzEiQKDW5vdGlmaWNhdGlvbnMYAiABKAhSDW5vdGlmaWNhdGlvbnMSLQoSbm90'
    'aWZpY2F0aW9uc19taW5lGAMgASgIUhFub3RpZmljYXRpb25zTWluZQ==');

@$core.Deprecated('Use requestSpeedStatsSetDescriptor instead')
const RequestSpeedStatsSet$json = {
  '1': 'RequestSpeedStatsSet',
  '2': [
    {'1': 'window_ms', '3': 1, '4': 1, '5': 13, '10': 'windowMs'},
    {'1': 'notifications', '3': 2, '4': 1, '5': 8, '10': 'notifications'},
  ],
};

/// Descriptor for `RequestSpeedStatsSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestSpeedStatsSetDescriptor = $convert.base64Decode(
    'ChRSZXF1ZXN0U3BlZWRTdGF0c1NldBIbCgl3aW5kb3dfbXMYASABKA1SCHdpbmRvd01zEiQKDW'
    '5vdGlmaWNhdGlvbnMYAiABKAhSDW5vdGlmaWNhdGlvbnM=');

@$core.Deprecated('Use responseSpeedStatsSetDescriptor instead')
const ResponseSpeedStatsSet$json = {
  '1': 'ResponseSpeedStatsSet',
  '2': [
    {'1': 'window_ms', '3': 1, '4': 1, '5': 13, '10': 'windowMs'},
    {'1': 'notifications', '3': 2, '4': 1, '5': 8, '10': 'notifications'},
  ],
};

/// Descriptor for `ResponseSpeedStatsSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseSpeedStatsSetDescriptor = $convert.base64Decode(
    'ChVSZXNwb25zZVNwZWVkU3RhdHNTZXQSGwoJd2luZG93X21zGAEgASgNUgh3aW5kb3dNcxIkCg'
    '1ub3RpZmljYXRpb25zGAIgASgIUg1ub3RpZmljYXRpb25z');

@$core.Deprecated('Use requestSlideSnapshotGetDescriptor instead')
const RequestSlideSnapshotGet$json = {
  '1': 'RequestSlideSnapshotGet',
};

/// Descriptor for `RequestSlideSnapshotGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestSlideSnapshotGetDescriptor =
    $convert.base64Decode('ChdSZXF1ZXN0U2xpZGVTbmFwc2hvdEdldA==');

@$core.Deprecated('Use responseSlideSnapshotGetDescriptor instead')
const ResponseSlideSnapshotGet$json = {
  '1': 'ResponseSlideSnapshotGet',
  '2': [
    {'1': 'valid', '3': 1, '4': 1, '5': 8, '10': 'valid'},
    {'1': 'time_us', '3': 2, '4': 1, '5': 4, '10': 'timeUs'},
    {'1': 'position', '3': 3, '4': 1, '5': 2, '10': 'position'},
    {'1': 'speed', '3': 4, '4': 1, '5': 2, '10': 'speed'},
    {'1': 'target_speed', '3': 5, '4': 1, '5': 2, '10': 'targetSpeed'},
    {'1': 'trim', '3': 6, '4': 1, '5': 2, '10': 'trim'},
    {'1': 'output', '3': 7, '4': 1, '5': 2, '10': 'output'},
    {'1': 'motor', '3': 8, '4': 1, '5': 2, '10': 'motor'},
    {'1': 'phase', '3': 9, '4': 1, '5': 13, '10': 'phase'},
    {'1': 'dir', '3': 10, '4': 1, '5': 13, '10': 'dir'},
    {'1': 'target_dir', '3': 11, '4': 1, '5': 13, '10': 'targetDir'},
    {'1': 'target_pos', '3': 12, '4': 1, '5': 2, '10': 'targetPos'},
    {'1': 'current_time_ms', '3': 13, '4': 1, '5': 13, '10': 'currentTimeMs'},
    {'1': 'expected_pos', '3': 14, '4': 1, '5': 2, '10': 'expectedPos'},
    {'1': 'ff', '3': 15, '4': 1, '5': 2, '10': 'ff'},
    {'1': 'p_term', '3': 16, '4': 1, '5': 2, '10': 'pTerm'},
    {'1': 'd_term', '3': 17, '4': 1, '5': 2, '10': 'dTerm'},
    {'1': 'kick', '3': 18, '4': 1, '5': 2, '10': 'kick'},
    {'1': 'dt_us', '3': 19, '4': 1, '5': 13, '10': 'dtUs'},
    {'1': 'flags', '3': 20, '4': 1, '5': 13, '10': 'flags'},
  ],
};

/// Descriptor for `ResponseSlideSnapshotGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseSlideSnapshotGetDescriptor = $convert.base64Decode(
    'ChhSZXNwb25zZVNsaWRlU25hcHNob3RHZXQSFAoFdmFsaWQYASABKAhSBXZhbGlkEhcKB3RpbW'
    'VfdXMYAiABKARSBnRpbWVVcxIaCghwb3NpdGlvbhgDIAEoAlIIcG9zaXRpb24SFAoFc3BlZWQY'
    'BCABKAJSBXNwZWVkEiEKDHRhcmdldF9zcGVlZBgFIAEoAlILdGFyZ2V0U3BlZWQSEgoEdHJpbR'
    'gGIAEoAlIEdHJpbRIWCgZvdXRwdXQYByABKAJSBm91dHB1dBIUCgVtb3RvchgIIAEoAlIFbW90'
    'b3ISFAoFcGhhc2UYCSABKA1SBXBoYXNlEhAKA2RpchgKIAEoDVIDZGlyEh0KCnRhcmdldF9kaX'
    'IYCyABKA1SCXRhcmdldERpchIdCgp0YXJnZXRfcG9zGAwgASgCUgl0YXJnZXRQb3MSJgoPY3Vy'
    'cmVudF90aW1lX21zGA0gASgNUg1jdXJyZW50VGltZU1zEiEKDGV4cGVjdGVkX3BvcxgOIAEoAl'
    'ILZXhwZWN0ZWRQb3MSDgoCZmYYDyABKAJSAmZmEhUKBnBfdGVybRgQIAEoAlIFcFRlcm0SFQoG'
    'ZF90ZXJtGBEgASgCUgVkVGVybRISCgRraWNrGBIgASgCUgRraWNrEhMKBWR0X3VzGBMgASgNUg'
    'RkdFVzEhQKBWZsYWdzGBQgASgNUgVmbGFncw==');

@$core.Deprecated('Use requestHspSetupDescriptor instead')
const RequestHspSetup$json = {
  '1': 'RequestHspSetup',
  '2': [
    {'1': 'stream_id', '3': 1, '4': 1, '5': 13, '10': 'streamId'},
  ],
};

/// Descriptor for `RequestHspSetup`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHspSetupDescriptor = $convert.base64Decode(
    'Cg9SZXF1ZXN0SHNwU2V0dXASGwoJc3RyZWFtX2lkGAEgASgNUghzdHJlYW1JZA==');

@$core.Deprecated('Use responseHspSetupDescriptor instead')
const ResponseHspSetup$json = {
  '1': 'ResponseHspSetup',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HspState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHspSetup`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHspSetupDescriptor = $convert.base64Decode(
    'ChBSZXNwb25zZUhzcFNldHVwEicKBXN0YXRlGAEgASgLMhEuaGR5X3JwYy5Ic3BTdGF0ZVIFc3'
    'RhdGU=');

@$core.Deprecated('Use requestHspAddDescriptor instead')
const RequestHspAdd$json = {
  '1': 'RequestHspAdd',
  '2': [
    {
      '1': 'points',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.hdy_rpc.Point',
      '10': 'points'
    },
    {'1': 'flush', '3': 2, '4': 1, '5': 8, '10': 'flush'},
    {
      '1': 'tail_point_stream_index',
      '3': 3,
      '4': 1,
      '5': 13,
      '10': 'tailPointStreamIndex'
    },
    {
      '1': 'tail_point_threshold',
      '3': 5,
      '4': 1,
      '5': 13,
      '10': 'tailPointThreshold'
    },
  ],
};

/// Descriptor for `RequestHspAdd`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHspAddDescriptor = $convert.base64Decode(
    'Cg1SZXF1ZXN0SHNwQWRkEiYKBnBvaW50cxgBIAMoCzIOLmhkeV9ycGMuUG9pbnRSBnBvaW50cx'
    'IUCgVmbHVzaBgCIAEoCFIFZmx1c2gSNQoXdGFpbF9wb2ludF9zdHJlYW1faW5kZXgYAyABKA1S'
    'FHRhaWxQb2ludFN0cmVhbUluZGV4EjAKFHRhaWxfcG9pbnRfdGhyZXNob2xkGAUgASgNUhJ0YW'
    'lsUG9pbnRUaHJlc2hvbGQ=');

@$core.Deprecated('Use responseHspAddDescriptor instead')
const ResponseHspAdd$json = {
  '1': 'ResponseHspAdd',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HspState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHspAdd`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHspAddDescriptor = $convert.base64Decode(
    'Cg5SZXNwb25zZUhzcEFkZBInCgVzdGF0ZRgBIAEoCzIRLmhkeV9ycGMuSHNwU3RhdGVSBXN0YX'
    'Rl');

@$core.Deprecated('Use requestHspFlushDescriptor instead')
const RequestHspFlush$json = {
  '1': 'RequestHspFlush',
};

/// Descriptor for `RequestHspFlush`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHspFlushDescriptor =
    $convert.base64Decode('Cg9SZXF1ZXN0SHNwRmx1c2g=');

@$core.Deprecated('Use responseHspFlushDescriptor instead')
const ResponseHspFlush$json = {
  '1': 'ResponseHspFlush',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HspState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHspFlush`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHspFlushDescriptor = $convert.base64Decode(
    'ChBSZXNwb25zZUhzcEZsdXNoEicKBXN0YXRlGAEgASgLMhEuaGR5X3JwYy5Ic3BTdGF0ZVIFc3'
    'RhdGU=');

@$core.Deprecated('Use requestHspPlayDescriptor instead')
const RequestHspPlay$json = {
  '1': 'RequestHspPlay',
  '2': [
    {'1': 'start_time', '3': 1, '4': 1, '5': 5, '10': 'startTime'},
    {'1': 'server_time', '3': 2, '4': 1, '5': 4, '10': 'serverTime'},
    {'1': 'playback_rate', '3': 3, '4': 1, '5': 2, '10': 'playbackRate'},
    {'1': 'loop', '3': 4, '4': 1, '5': 8, '10': 'loop'},
    {'1': 'pause_on_starving', '3': 5, '4': 1, '5': 8, '10': 'pauseOnStarving'},
  ],
};

/// Descriptor for `RequestHspPlay`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHspPlayDescriptor = $convert.base64Decode(
    'Cg5SZXF1ZXN0SHNwUGxheRIdCgpzdGFydF90aW1lGAEgASgFUglzdGFydFRpbWUSHwoLc2Vydm'
    'VyX3RpbWUYAiABKARSCnNlcnZlclRpbWUSIwoNcGxheWJhY2tfcmF0ZRgDIAEoAlIMcGxheWJh'
    'Y2tSYXRlEhIKBGxvb3AYBCABKAhSBGxvb3ASKgoRcGF1c2Vfb25fc3RhcnZpbmcYBSABKAhSD3'
    'BhdXNlT25TdGFydmluZw==');

@$core.Deprecated('Use responseHspPlayDescriptor instead')
const ResponseHspPlay$json = {
  '1': 'ResponseHspPlay',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HspState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHspPlay`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHspPlayDescriptor = $convert.base64Decode(
    'Cg9SZXNwb25zZUhzcFBsYXkSJwoFc3RhdGUYASABKAsyES5oZHlfcnBjLkhzcFN0YXRlUgVzdG'
    'F0ZQ==');

@$core.Deprecated('Use requestHspStopDescriptor instead')
const RequestHspStop$json = {
  '1': 'RequestHspStop',
};

/// Descriptor for `RequestHspStop`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHspStopDescriptor =
    $convert.base64Decode('Cg5SZXF1ZXN0SHNwU3RvcA==');

@$core.Deprecated('Use responseHspStopDescriptor instead')
const ResponseHspStop$json = {
  '1': 'ResponseHspStop',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HspState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHspStop`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHspStopDescriptor = $convert.base64Decode(
    'Cg9SZXNwb25zZUhzcFN0b3ASJwoFc3RhdGUYASABKAsyES5oZHlfcnBjLkhzcFN0YXRlUgVzdG'
    'F0ZQ==');

@$core.Deprecated('Use requestHspPauseDescriptor instead')
const RequestHspPause$json = {
  '1': 'RequestHspPause',
};

/// Descriptor for `RequestHspPause`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHspPauseDescriptor =
    $convert.base64Decode('Cg9SZXF1ZXN0SHNwUGF1c2U=');

@$core.Deprecated('Use responseHspPauseDescriptor instead')
const ResponseHspPause$json = {
  '1': 'ResponseHspPause',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HspState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHspPause`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHspPauseDescriptor = $convert.base64Decode(
    'ChBSZXNwb25zZUhzcFBhdXNlEicKBXN0YXRlGAEgASgLMhEuaGR5X3JwYy5Ic3BTdGF0ZVIFc3'
    'RhdGU=');

@$core.Deprecated('Use requestHspResumeDescriptor instead')
const RequestHspResume$json = {
  '1': 'RequestHspResume',
  '2': [
    {'1': 'pick_up', '3': 1, '4': 1, '5': 8, '10': 'pickUp'},
  ],
};

/// Descriptor for `RequestHspResume`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHspResumeDescriptor = $convert.base64Decode(
    'ChBSZXF1ZXN0SHNwUmVzdW1lEhcKB3BpY2tfdXAYASABKAhSBnBpY2tVcA==');

@$core.Deprecated('Use responseHspResumeDescriptor instead')
const ResponseHspResume$json = {
  '1': 'ResponseHspResume',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HspState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHspResume`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHspResumeDescriptor = $convert.base64Decode(
    'ChFSZXNwb25zZUhzcFJlc3VtZRInCgVzdGF0ZRgBIAEoCzIRLmhkeV9ycGMuSHNwU3RhdGVSBX'
    'N0YXRl');

@$core.Deprecated('Use requestHspStateGetDescriptor instead')
const RequestHspStateGet$json = {
  '1': 'RequestHspStateGet',
};

/// Descriptor for `RequestHspStateGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHspStateGetDescriptor =
    $convert.base64Decode('ChJSZXF1ZXN0SHNwU3RhdGVHZXQ=');

@$core.Deprecated('Use responseHspStateGetDescriptor instead')
const ResponseHspStateGet$json = {
  '1': 'ResponseHspStateGet',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HspState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHspStateGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHspStateGetDescriptor = $convert.base64Decode(
    'ChNSZXNwb25zZUhzcFN0YXRlR2V0EicKBXN0YXRlGAEgASgLMhEuaGR5X3JwYy5Ic3BTdGF0ZV'
    'IFc3RhdGU=');

@$core.Deprecated('Use requestHspCurrentTimeSetDescriptor instead')
const RequestHspCurrentTimeSet$json = {
  '1': 'RequestHspCurrentTimeSet',
  '2': [
    {'1': 'current_time', '3': 1, '4': 1, '5': 5, '10': 'currentTime'},
    {'1': 'server_time', '3': 2, '4': 1, '5': 4, '10': 'serverTime'},
    {'1': 'filter', '3': 3, '4': 1, '5': 2, '10': 'filter'},
  ],
};

/// Descriptor for `RequestHspCurrentTimeSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHspCurrentTimeSetDescriptor = $convert.base64Decode(
    'ChhSZXF1ZXN0SHNwQ3VycmVudFRpbWVTZXQSIQoMY3VycmVudF90aW1lGAEgASgFUgtjdXJyZW'
    '50VGltZRIfCgtzZXJ2ZXJfdGltZRgCIAEoBFIKc2VydmVyVGltZRIWCgZmaWx0ZXIYAyABKAJS'
    'BmZpbHRlcg==');

@$core.Deprecated('Use responseHspCurrentTimeSetDescriptor instead')
const ResponseHspCurrentTimeSet$json = {
  '1': 'ResponseHspCurrentTimeSet',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HspState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHspCurrentTimeSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHspCurrentTimeSetDescriptor =
    $convert.base64Decode(
        'ChlSZXNwb25zZUhzcEN1cnJlbnRUaW1lU2V0EicKBXN0YXRlGAEgASgLMhEuaGR5X3JwYy5Ic3'
        'BTdGF0ZVIFc3RhdGU=');

@$core.Deprecated('Use requestHspThresholdSetDescriptor instead')
const RequestHspThresholdSet$json = {
  '1': 'RequestHspThresholdSet',
  '2': [
    {
      '1': 'tail_point_threshold',
      '3': 1,
      '4': 1,
      '5': 13,
      '10': 'tailPointThreshold'
    },
  ],
};

/// Descriptor for `RequestHspThresholdSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHspThresholdSetDescriptor =
    $convert.base64Decode(
        'ChZSZXF1ZXN0SHNwVGhyZXNob2xkU2V0EjAKFHRhaWxfcG9pbnRfdGhyZXNob2xkGAEgASgNUh'
        'J0YWlsUG9pbnRUaHJlc2hvbGQ=');

@$core.Deprecated('Use responseHspThresholdSetDescriptor instead')
const ResponseHspThresholdSet$json = {
  '1': 'ResponseHspThresholdSet',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HspState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHspThresholdSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHspThresholdSetDescriptor =
    $convert.base64Decode(
        'ChdSZXNwb25zZUhzcFRocmVzaG9sZFNldBInCgVzdGF0ZRgBIAEoCzIRLmhkeV9ycGMuSHNwU3'
        'RhdGVSBXN0YXRl');

@$core.Deprecated('Use requestHspPauseOnStarvingSetDescriptor instead')
const RequestHspPauseOnStarvingSet$json = {
  '1': 'RequestHspPauseOnStarvingSet',
  '2': [
    {'1': 'pause_on_starving', '3': 1, '4': 1, '5': 8, '10': 'pauseOnStarving'},
  ],
};

/// Descriptor for `RequestHspPauseOnStarvingSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHspPauseOnStarvingSetDescriptor =
    $convert.base64Decode(
        'ChxSZXF1ZXN0SHNwUGF1c2VPblN0YXJ2aW5nU2V0EioKEXBhdXNlX29uX3N0YXJ2aW5nGAEgAS'
        'gIUg9wYXVzZU9uU3RhcnZpbmc=');

@$core.Deprecated('Use responseHspPauseOnStarvingSetDescriptor instead')
const ResponseHspPauseOnStarvingSet$json = {
  '1': 'ResponseHspPauseOnStarvingSet',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HspState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHspPauseOnStarvingSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHspPauseOnStarvingSetDescriptor =
    $convert.base64Decode(
        'Ch1SZXNwb25zZUhzcFBhdXNlT25TdGFydmluZ1NldBInCgVzdGF0ZRgBIAEoCzIRLmhkeV9ycG'
        'MuSHNwU3RhdGVSBXN0YXRl');

@$core.Deprecated('Use requestHspPlaybackRateSetDescriptor instead')
const RequestHspPlaybackRateSet$json = {
  '1': 'RequestHspPlaybackRateSet',
  '2': [
    {'1': 'playback_rate', '3': 1, '4': 1, '5': 2, '10': 'playbackRate'},
  ],
};

/// Descriptor for `RequestHspPlaybackRateSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHspPlaybackRateSetDescriptor =
    $convert.base64Decode(
        'ChlSZXF1ZXN0SHNwUGxheWJhY2tSYXRlU2V0EiMKDXBsYXliYWNrX3JhdGUYASABKAJSDHBsYX'
        'liYWNrUmF0ZQ==');

@$core.Deprecated('Use responseHspPlaybackRateSetDescriptor instead')
const ResponseHspPlaybackRateSet$json = {
  '1': 'ResponseHspPlaybackRateSet',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HspState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHspPlaybackRateSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHspPlaybackRateSetDescriptor =
    $convert.base64Decode(
        'ChpSZXNwb25zZUhzcFBsYXliYWNrUmF0ZVNldBInCgVzdGF0ZRgBIAEoCzIRLmhkeV9ycGMuSH'
        'NwU3RhdGVSBXN0YXRl');

@$core.Deprecated('Use requestHspLoopSetDescriptor instead')
const RequestHspLoopSet$json = {
  '1': 'RequestHspLoopSet',
  '2': [
    {'1': 'loop', '3': 1, '4': 1, '5': 8, '10': 'loop'},
  ],
};

/// Descriptor for `RequestHspLoopSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHspLoopSetDescriptor = $convert
    .base64Decode('ChFSZXF1ZXN0SHNwTG9vcFNldBISCgRsb29wGAEgASgIUgRsb29w');

@$core.Deprecated('Use responseHspLoopSetDescriptor instead')
const ResponseHspLoopSet$json = {
  '1': 'ResponseHspLoopSet',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HspState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHspLoopSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHspLoopSetDescriptor = $convert.base64Decode(
    'ChJSZXNwb25zZUhzcExvb3BTZXQSJwoFc3RhdGUYASABKAsyES5oZHlfcnBjLkhzcFN0YXRlUg'
    'VzdGF0ZQ==');

@$core.Deprecated('Use requestHspJitterFilterSetDescriptor instead')
const RequestHspJitterFilterSet$json = {
  '1': 'RequestHspJitterFilterSet',
  '2': [
    {'1': 'jitter_filter', '3': 1, '4': 1, '5': 8, '10': 'jitterFilter'},
    {'1': 'threshold_mm', '3': 2, '4': 1, '5': 2, '10': 'thresholdMm'},
  ],
};

/// Descriptor for `RequestHspJitterFilterSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHspJitterFilterSetDescriptor =
    $convert.base64Decode(
        'ChlSZXF1ZXN0SHNwSml0dGVyRmlsdGVyU2V0EiMKDWppdHRlcl9maWx0ZXIYASABKAhSDGppdH'
        'RlckZpbHRlchIhCgx0aHJlc2hvbGRfbW0YAiABKAJSC3RocmVzaG9sZE1t');

@$core.Deprecated('Use responseHspJitterFilterSetDescriptor instead')
const ResponseHspJitterFilterSet$json = {
  '1': 'ResponseHspJitterFilterSet',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HspState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHspJitterFilterSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHspJitterFilterSetDescriptor =
    $convert.base64Decode(
        'ChpSZXNwb25zZUhzcEppdHRlckZpbHRlclNldBInCgVzdGF0ZRgBIAEoCzIRLmhkeV9ycGMuSH'
        'NwU3RhdGVSBXN0YXRl');

@$core.Deprecated('Use requestHspScriptSpeedSetDescriptor instead')
const RequestHspScriptSpeedSet$json = {
  '1': 'RequestHspScriptSpeedSet',
  '2': [
    {'1': 'script_speed', '3': 1, '4': 1, '5': 8, '10': 'scriptSpeed'},
  ],
};

/// Descriptor for `RequestHspScriptSpeedSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHspScriptSpeedSetDescriptor =
    $convert.base64Decode(
        'ChhSZXF1ZXN0SHNwU2NyaXB0U3BlZWRTZXQSIQoMc2NyaXB0X3NwZWVkGAEgASgIUgtzY3JpcH'
        'RTcGVlZA==');

@$core.Deprecated('Use responseHspScriptSpeedSetDescriptor instead')
const ResponseHspScriptSpeedSet$json = {
  '1': 'ResponseHspScriptSpeedSet',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HspState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHspScriptSpeedSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHspScriptSpeedSetDescriptor =
    $convert.base64Decode(
        'ChlSZXNwb25zZUhzcFNjcmlwdFNwZWVkU2V0EicKBXN0YXRlGAEgASgLMhEuaGR5X3JwYy5Ic3'
        'BTdGF0ZVIFc3RhdGU=');

@$core.Deprecated('Use requestLedOverrideDescriptor instead')
const RequestLedOverride$json = {
  '1': 'RequestLedOverride',
  '2': [
    {'1': 'override', '3': 1, '4': 1, '5': 8, '10': 'override'},
    {'1': 'r', '3': 2, '4': 1, '5': 13, '10': 'r'},
    {'1': 'g', '3': 3, '4': 1, '5': 13, '10': 'g'},
    {'1': 'b', '3': 4, '4': 1, '5': 13, '10': 'b'},
    {'1': 'intensity', '3': 5, '4': 1, '5': 13, '10': 'intensity'},
  ],
};

/// Descriptor for `RequestLedOverride`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestLedOverrideDescriptor = $convert.base64Decode(
    'ChJSZXF1ZXN0TGVkT3ZlcnJpZGUSGgoIb3ZlcnJpZGUYASABKAhSCG92ZXJyaWRlEgwKAXIYAi'
    'ABKA1SAXISDAoBZxgDIAEoDVIBZxIMCgFiGAQgASgNUgFiEhwKCWludGVuc2l0eRgFIAEoDVIJ'
    'aW50ZW5zaXR5');

@$core.Deprecated('Use requestHvpSetDescriptor instead')
const RequestHvpSet$json = {
  '1': 'RequestHvpSet',
  '2': [
    {'1': 'amplitude', '3': 1, '4': 1, '5': 2, '10': 'amplitude'},
    {'1': 'frequency', '3': 2, '4': 1, '5': 13, '10': 'frequency'},
    {'1': 'position', '3': 3, '4': 1, '5': 2, '10': 'position'},
  ],
};

/// Descriptor for `RequestHvpSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHvpSetDescriptor = $convert.base64Decode(
    'Cg1SZXF1ZXN0SHZwU2V0EhwKCWFtcGxpdHVkZRgBIAEoAlIJYW1wbGl0dWRlEhwKCWZyZXF1ZW'
    '5jeRgCIAEoDVIJZnJlcXVlbmN5EhoKCHBvc2l0aW9uGAMgASgCUghwb3NpdGlvbg==');

@$core.Deprecated('Use responseHvpSetDescriptor instead')
const ResponseHvpSet$json = {
  '1': 'ResponseHvpSet',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HvpState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHvpSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHvpSetDescriptor = $convert.base64Decode(
    'Cg5SZXNwb25zZUh2cFNldBInCgVzdGF0ZRgBIAEoCzIRLmhkeV9ycGMuSHZwU3RhdGVSBXN0YX'
    'Rl');

@$core.Deprecated('Use requestHvpStopDescriptor instead')
const RequestHvpStop$json = {
  '1': 'RequestHvpStop',
};

/// Descriptor for `RequestHvpStop`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHvpStopDescriptor =
    $convert.base64Decode('Cg5SZXF1ZXN0SHZwU3RvcA==');

@$core.Deprecated('Use responseHvpStopDescriptor instead')
const ResponseHvpStop$json = {
  '1': 'ResponseHvpStop',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HvpState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHvpStop`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHvpStopDescriptor = $convert.base64Decode(
    'Cg9SZXNwb25zZUh2cFN0b3ASJwoFc3RhdGUYASABKAsyES5oZHlfcnBjLkh2cFN0YXRlUgVzdG'
    'F0ZQ==');

@$core.Deprecated('Use requestHvpStartDescriptor instead')
const RequestHvpStart$json = {
  '1': 'RequestHvpStart',
};

/// Descriptor for `RequestHvpStart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHvpStartDescriptor =
    $convert.base64Decode('Cg9SZXF1ZXN0SHZwU3RhcnQ=');

@$core.Deprecated('Use responseHvpStartDescriptor instead')
const ResponseHvpStart$json = {
  '1': 'ResponseHvpStart',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HvpState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHvpStart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHvpStartDescriptor = $convert.base64Decode(
    'ChBSZXNwb25zZUh2cFN0YXJ0EicKBXN0YXRlGAEgASgLMhEuaGR5X3JwYy5IdnBTdGF0ZVIFc3'
    'RhdGU=');

@$core.Deprecated('Use requestHvpStateGetDescriptor instead')
const RequestHvpStateGet$json = {
  '1': 'RequestHvpStateGet',
};

/// Descriptor for `RequestHvpStateGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHvpStateGetDescriptor =
    $convert.base64Decode('ChJSZXF1ZXN0SHZwU3RhdGVHZXQ=');

@$core.Deprecated('Use responseHvpStateGetDescriptor instead')
const ResponseHvpStateGet$json = {
  '1': 'ResponseHvpStateGet',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HvpState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHvpStateGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHvpStateGetDescriptor = $convert.base64Decode(
    'ChNSZXNwb25zZUh2cFN0YXRlR2V0EicKBXN0YXRlGAEgASgLMhEuaGR5X3JwYy5IdnBTdGF0ZV'
    'IFc3RhdGU=');

@$core.Deprecated('Use requestHrppStartDescriptor instead')
const RequestHrppStart$json = {
  '1': 'RequestHrppStart',
};

/// Descriptor for `RequestHrppStart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHrppStartDescriptor =
    $convert.base64Decode('ChBSZXF1ZXN0SHJwcFN0YXJ0');

@$core.Deprecated('Use responseHrppStartDescriptor instead')
const ResponseHrppStart$json = {
  '1': 'ResponseHrppStart',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HrppState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHrppStart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHrppStartDescriptor = $convert.base64Decode(
    'ChFSZXNwb25zZUhycHBTdGFydBIoCgVzdGF0ZRgBIAEoCzISLmhkeV9ycGMuSHJwcFN0YXRlUg'
    'VzdGF0ZQ==');

@$core.Deprecated('Use requestHrppStopDescriptor instead')
const RequestHrppStop$json = {
  '1': 'RequestHrppStop',
};

/// Descriptor for `RequestHrppStop`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHrppStopDescriptor =
    $convert.base64Decode('Cg9SZXF1ZXN0SHJwcFN0b3A=');

@$core.Deprecated('Use responseHrppStopDescriptor instead')
const ResponseHrppStop$json = {
  '1': 'ResponseHrppStop',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HrppState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHrppStop`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHrppStopDescriptor = $convert.base64Decode(
    'ChBSZXNwb25zZUhycHBTdG9wEigKBXN0YXRlGAEgASgLMhIuaGR5X3JwYy5IcnBwU3RhdGVSBX'
    'N0YXRl');

@$core.Deprecated('Use requestHrppAmplitudeSetDescriptor instead')
const RequestHrppAmplitudeSet$json = {
  '1': 'RequestHrppAmplitudeSet',
  '2': [
    {'1': 'amplitude', '3': 1, '4': 1, '5': 2, '10': 'amplitude'},
  ],
};

/// Descriptor for `RequestHrppAmplitudeSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHrppAmplitudeSetDescriptor =
    $convert.base64Decode(
        'ChdSZXF1ZXN0SHJwcEFtcGxpdHVkZVNldBIcCglhbXBsaXR1ZGUYASABKAJSCWFtcGxpdHVkZQ'
        '==');

@$core.Deprecated('Use responseHrppAmplitudeSetDescriptor instead')
const ResponseHrppAmplitudeSet$json = {
  '1': 'ResponseHrppAmplitudeSet',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HrppState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHrppAmplitudeSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHrppAmplitudeSetDescriptor =
    $convert.base64Decode(
        'ChhSZXNwb25zZUhycHBBbXBsaXR1ZGVTZXQSKAoFc3RhdGUYASABKAsyEi5oZHlfcnBjLkhycH'
        'BTdGF0ZVIFc3RhdGU=');

@$core.Deprecated('Use requestHrppPatternSetDescriptor instead')
const RequestHrppPatternSet$json = {
  '1': 'RequestHrppPatternSet',
  '2': [
    {'1': 'pattern_nr', '3': 1, '4': 1, '5': 13, '10': 'patternNr'},
  ],
};

/// Descriptor for `RequestHrppPatternSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHrppPatternSetDescriptor = $convert.base64Decode(
    'ChVSZXF1ZXN0SHJwcFBhdHRlcm5TZXQSHQoKcGF0dGVybl9uchgBIAEoDVIJcGF0dGVybk5y');

@$core.Deprecated('Use responseHrppPatternSetDescriptor instead')
const ResponseHrppPatternSet$json = {
  '1': 'ResponseHrppPatternSet',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HrppState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHrppPatternSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHrppPatternSetDescriptor =
    $convert.base64Decode(
        'ChZSZXNwb25zZUhycHBQYXR0ZXJuU2V0EigKBXN0YXRlGAEgASgLMhIuaGR5X3JwYy5IcnBwU3'
        'RhdGVSBXN0YXRl');

@$core.Deprecated('Use requestHrppStateGetDescriptor instead')
const RequestHrppStateGet$json = {
  '1': 'RequestHrppStateGet',
};

/// Descriptor for `RequestHrppStateGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHrppStateGetDescriptor =
    $convert.base64Decode('ChNSZXF1ZXN0SHJwcFN0YXRlR2V0');

@$core.Deprecated('Use responseHrppStateGetDescriptor instead')
const ResponseHrppStateGet$json = {
  '1': 'ResponseHrppStateGet',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HrppState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHrppStateGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHrppStateGetDescriptor = $convert.base64Decode(
    'ChRSZXNwb25zZUhycHBTdGF0ZUdldBIoCgVzdGF0ZRgBIAEoCzISLmhkeV9ycGMuSHJwcFN0YX'
    'RlUgVzdGF0ZQ==');

@$core.Deprecated('Use requestHrppPatternsGetDescriptor instead')
const RequestHrppPatternsGet$json = {
  '1': 'RequestHrppPatternsGet',
};

/// Descriptor for `RequestHrppPatternsGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHrppPatternsGetDescriptor =
    $convert.base64Decode('ChZSZXF1ZXN0SHJwcFBhdHRlcm5zR2V0');

@$core.Deprecated('Use responseHrppPatternsGetDescriptor instead')
const ResponseHrppPatternsGet$json = {
  '1': 'ResponseHrppPatternsGet',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HrppState',
      '10': 'state'
    },
    {
      '1': 'patterns',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.hdy_rpc.HrppPattern',
      '10': 'patterns'
    },
  ],
};

/// Descriptor for `ResponseHrppPatternsGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHrppPatternsGetDescriptor = $convert.base64Decode(
    'ChdSZXNwb25zZUhycHBQYXR0ZXJuc0dldBIoCgVzdGF0ZRgBIAEoCzISLmhkeV9ycGMuSHJwcF'
    'N0YXRlUgVzdGF0ZRIwCghwYXR0ZXJucxgCIAMoCzIULmhkeV9ycGMuSHJwcFBhdHRlcm5SCHBh'
    'dHRlcm5z');

@$core.Deprecated('Use requestHrppPlaybackRateSetDescriptor instead')
const RequestHrppPlaybackRateSet$json = {
  '1': 'RequestHrppPlaybackRateSet',
  '2': [
    {'1': 'playback_rate', '3': 1, '4': 1, '5': 2, '10': 'playbackRate'},
  ],
};

/// Descriptor for `RequestHrppPlaybackRateSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHrppPlaybackRateSetDescriptor =
    $convert.base64Decode(
        'ChpSZXF1ZXN0SHJwcFBsYXliYWNrUmF0ZVNldBIjCg1wbGF5YmFja19yYXRlGAEgASgCUgxwbG'
        'F5YmFja1JhdGU=');

@$core.Deprecated('Use responseHrppPlaybackRateSetDescriptor instead')
const ResponseHrppPlaybackRateSet$json = {
  '1': 'ResponseHrppPlaybackRateSet',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HrppState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHrppPlaybackRateSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHrppPlaybackRateSetDescriptor =
    $convert.base64Decode(
        'ChtSZXNwb25zZUhycHBQbGF5YmFja1JhdGVTZXQSKAoFc3RhdGUYASABKAsyEi5oZHlfcnBjLk'
        'hycHBTdGF0ZVIFc3RhdGU=');

@$core.Deprecated('Use requestHrppPauseDescriptor instead')
const RequestHrppPause$json = {
  '1': 'RequestHrppPause',
};

/// Descriptor for `RequestHrppPause`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHrppPauseDescriptor =
    $convert.base64Decode('ChBSZXF1ZXN0SHJwcFBhdXNl');

@$core.Deprecated('Use responseHrppPauseDescriptor instead')
const ResponseHrppPause$json = {
  '1': 'ResponseHrppPause',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HrppState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `ResponseHrppPause`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHrppPauseDescriptor = $convert.base64Decode(
    'ChFSZXNwb25zZUhycHBQYXVzZRIoCgVzdGF0ZRgBIAEoCzISLmhkeV9ycGMuSHJwcFN0YXRlUg'
    'VzdGF0ZQ==');

@$core.Deprecated('Use requestSettingsRegulatorGetDescriptor instead')
const RequestSettingsRegulatorGet$json = {
  '1': 'RequestSettingsRegulatorGet',
};

/// Descriptor for `RequestSettingsRegulatorGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestSettingsRegulatorGetDescriptor =
    $convert.base64Decode('ChtSZXF1ZXN0U2V0dGluZ3NSZWd1bGF0b3JHZXQ=');

@$core.Deprecated('Use responseSettingsRegulatorGetDescriptor instead')
const ResponseSettingsRegulatorGet$json = {
  '1': 'ResponseSettingsRegulatorGet',
  '2': [
    {'1': 'profile_id', '3': 1, '4': 1, '5': 13, '10': 'profileId'},
    {'1': 'design_id', '3': 2, '4': 1, '5': 13, '10': 'designId'},
    {'1': 'kp', '3': 3, '4': 1, '5': 2, '10': 'kp'},
    {'1': 'ki', '3': 4, '4': 1, '5': 2, '10': 'ki'},
    {'1': 'kd', '3': 5, '4': 1, '5': 2, '10': 'kd'},
    {'1': 'feedforward_gain', '3': 6, '4': 1, '5': 2, '10': 'feedforwardGain'},
    {
      '1': 'feedforward_offset',
      '3': 7,
      '4': 1,
      '5': 2,
      '10': 'feedforwardOffset'
    },
    {'1': 'trim_limit', '3': 8, '4': 1, '5': 2, '10': 'trimLimit'},
    {'1': 'overspeed_margin', '3': 9, '4': 1, '5': 2, '10': 'overspeedMargin'},
    {
      '1': 'overspeed_output_brake',
      '3': 10,
      '4': 1,
      '5': 2,
      '10': 'overspeedOutputBrake'
    },
    {
      '1': 'overspeed_trim_brake',
      '3': 11,
      '4': 1,
      '5': 2,
      '10': 'overspeedTrimBrake'
    },
    {'1': 'error_deadband', '3': 12, '4': 1, '5': 2, '10': 'errorDeadband'},
    {'1': 'derivative_alpha', '3': 13, '4': 1, '5': 2, '10': 'derivativeAlpha'},
    {'1': 'target_kick_gain', '3': 14, '4': 1, '5': 2, '10': 'targetKickGain'},
    {
      '1': 'target_kick_decay',
      '3': 15,
      '4': 1,
      '5': 2,
      '10': 'targetKickDecay'
    },
    {'1': 'anti_windup', '3': 16, '4': 1, '5': 2, '10': 'antiWindup'},
    {'1': 'output_rise_rate', '3': 17, '4': 1, '5': 2, '10': 'outputRiseRate'},
    {'1': 'output_fall_rate', '3': 18, '4': 1, '5': 2, '10': 'outputFallRate'},
    {'1': 'turn_brake_scale', '3': 19, '4': 1, '5': 2, '10': 'turnBrakeScale'},
    {'1': 'turn_min_power', '3': 20, '4': 1, '5': 2, '10': 'turnMinPower'},
    {'1': 'turn_power_scale', '3': 21, '4': 1, '5': 2, '10': 'turnPowerScale'},
    {
      '1': 'turn_soft_start_scale',
      '3': 22,
      '4': 1,
      '5': 2,
      '10': 'turnSoftStartScale'
    },
    {
      '1': 'turn_reverse_power',
      '3': 23,
      '4': 1,
      '5': 2,
      '10': 'turnReversePower'
    },
    {
      '1': 'turn_reverse_speed_threshold',
      '3': 24,
      '4': 1,
      '5': 2,
      '10': 'turnReverseSpeedThreshold'
    },
    {
      '1': 'turn_reverse_min_ms',
      '3': 25,
      '4': 1,
      '5': 2,
      '10': 'turnReverseMinMs'
    },
    {
      '1': 'turn_reverse_hard_max_ms',
      '3': 26,
      '4': 1,
      '5': 2,
      '10': 'turnReverseHardMaxMs'
    },
    {
      '1': 'turn_reverse_backtrack_mm',
      '3': 27,
      '4': 1,
      '5': 2,
      '10': 'turnReverseBacktrackMm'
    },
    {
      '1': 'turn_post_reverse_brake_ms',
      '3': 28,
      '4': 1,
      '5': 2,
      '10': 'turnPostReverseBrakeMs'
    },
    {'1': 'modified', '3': 29, '4': 1, '5': 8, '10': 'modified'},
    {
      '1': 'feedforward_gain_back',
      '3': 30,
      '4': 1,
      '5': 2,
      '10': 'feedforwardGainBack'
    },
    {
      '1': 'feedforward_offset_back',
      '3': 31,
      '4': 1,
      '5': 2,
      '10': 'feedforwardOffsetBack'
    },
    {
      '1': 'turn_power_scale_back',
      '3': 32,
      '4': 1,
      '5': 2,
      '10': 'turnPowerScaleBack'
    },
    {'1': 'backlash_mm', '3': 33, '4': 1, '5': 2, '10': 'backlashMm'},
    {'1': 'backlash_power', '3': 34, '4': 1, '5': 2, '10': 'backlashPower'},
    {'1': 'backlash_max_ms', '3': 35, '4': 1, '5': 2, '10': 'backlashMaxMs'},
    {'1': 'trim_handover', '3': 38, '4': 1, '5': 13, '10': 'trimHandover'},
    {'1': 'trim_speed_scale', '3': 39, '4': 1, '5': 2, '10': 'trimSpeedScale'},
    {'1': 'trim_neg_limit', '3': 40, '4': 1, '5': 2, '10': 'trimNegLimit'},
    {
      '1': 'defaults',
      '3': 36,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseSettingsRegulatorGet',
      '10': 'defaults'
    },
    {
      '1': 'effective',
      '3': 37,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RegulatorEffective',
      '10': 'effective'
    },
  ],
};

/// Descriptor for `ResponseSettingsRegulatorGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseSettingsRegulatorGetDescriptor = $convert.base64Decode(
    'ChxSZXNwb25zZVNldHRpbmdzUmVndWxhdG9yR2V0Eh0KCnByb2ZpbGVfaWQYASABKA1SCXByb2'
    'ZpbGVJZBIbCglkZXNpZ25faWQYAiABKA1SCGRlc2lnbklkEg4KAmtwGAMgASgCUgJrcBIOCgJr'
    'aRgEIAEoAlICa2kSDgoCa2QYBSABKAJSAmtkEikKEGZlZWRmb3J3YXJkX2dhaW4YBiABKAJSD2'
    'ZlZWRmb3J3YXJkR2FpbhItChJmZWVkZm9yd2FyZF9vZmZzZXQYByABKAJSEWZlZWRmb3J3YXJk'
    'T2Zmc2V0Eh0KCnRyaW1fbGltaXQYCCABKAJSCXRyaW1MaW1pdBIpChBvdmVyc3BlZWRfbWFyZ2'
    'luGAkgASgCUg9vdmVyc3BlZWRNYXJnaW4SNAoWb3ZlcnNwZWVkX291dHB1dF9icmFrZRgKIAEo'
    'AlIUb3ZlcnNwZWVkT3V0cHV0QnJha2USMAoUb3ZlcnNwZWVkX3RyaW1fYnJha2UYCyABKAJSEm'
    '92ZXJzcGVlZFRyaW1CcmFrZRIlCg5lcnJvcl9kZWFkYmFuZBgMIAEoAlINZXJyb3JEZWFkYmFu'
    'ZBIpChBkZXJpdmF0aXZlX2FscGhhGA0gASgCUg9kZXJpdmF0aXZlQWxwaGESKAoQdGFyZ2V0X2'
    'tpY2tfZ2FpbhgOIAEoAlIOdGFyZ2V0S2lja0dhaW4SKgoRdGFyZ2V0X2tpY2tfZGVjYXkYDyAB'
    'KAJSD3RhcmdldEtpY2tEZWNheRIfCgthbnRpX3dpbmR1cBgQIAEoAlIKYW50aVdpbmR1cBIoCh'
    'BvdXRwdXRfcmlzZV9yYXRlGBEgASgCUg5vdXRwdXRSaXNlUmF0ZRIoChBvdXRwdXRfZmFsbF9y'
    'YXRlGBIgASgCUg5vdXRwdXRGYWxsUmF0ZRIoChB0dXJuX2JyYWtlX3NjYWxlGBMgASgCUg50dX'
    'JuQnJha2VTY2FsZRIkCg50dXJuX21pbl9wb3dlchgUIAEoAlIMdHVybk1pblBvd2VyEigKEHR1'
    'cm5fcG93ZXJfc2NhbGUYFSABKAJSDnR1cm5Qb3dlclNjYWxlEjEKFXR1cm5fc29mdF9zdGFydF'
    '9zY2FsZRgWIAEoAlISdHVyblNvZnRTdGFydFNjYWxlEiwKEnR1cm5fcmV2ZXJzZV9wb3dlchgX'
    'IAEoAlIQdHVyblJldmVyc2VQb3dlchI/Chx0dXJuX3JldmVyc2Vfc3BlZWRfdGhyZXNob2xkGB'
    'ggASgCUhl0dXJuUmV2ZXJzZVNwZWVkVGhyZXNob2xkEi0KE3R1cm5fcmV2ZXJzZV9taW5fbXMY'
    'GSABKAJSEHR1cm5SZXZlcnNlTWluTXMSNgoYdHVybl9yZXZlcnNlX2hhcmRfbWF4X21zGBogAS'
    'gCUhR0dXJuUmV2ZXJzZUhhcmRNYXhNcxI5Chl0dXJuX3JldmVyc2VfYmFja3RyYWNrX21tGBsg'
    'ASgCUhZ0dXJuUmV2ZXJzZUJhY2t0cmFja01tEjoKGnR1cm5fcG9zdF9yZXZlcnNlX2JyYWtlX2'
    '1zGBwgASgCUhZ0dXJuUG9zdFJldmVyc2VCcmFrZU1zEhoKCG1vZGlmaWVkGB0gASgIUghtb2Rp'
    'ZmllZBIyChVmZWVkZm9yd2FyZF9nYWluX2JhY2sYHiABKAJSE2ZlZWRmb3J3YXJkR2FpbkJhY2'
    'sSNgoXZmVlZGZvcndhcmRfb2Zmc2V0X2JhY2sYHyABKAJSFWZlZWRmb3J3YXJkT2Zmc2V0QmFj'
    'axIxChV0dXJuX3Bvd2VyX3NjYWxlX2JhY2sYICABKAJSEnR1cm5Qb3dlclNjYWxlQmFjaxIfCg'
    'tiYWNrbGFzaF9tbRghIAEoAlIKYmFja2xhc2hNbRIlCg5iYWNrbGFzaF9wb3dlchgiIAEoAlIN'
    'YmFja2xhc2hQb3dlchImCg9iYWNrbGFzaF9tYXhfbXMYIyABKAJSDWJhY2tsYXNoTWF4TXMSIw'
    'oNdHJpbV9oYW5kb3ZlchgmIAEoDVIMdHJpbUhhbmRvdmVyEigKEHRyaW1fc3BlZWRfc2NhbGUY'
    'JyABKAJSDnRyaW1TcGVlZFNjYWxlEiQKDnRyaW1fbmVnX2xpbWl0GCggASgCUgx0cmltTmVnTG'
    'ltaXQSQQoIZGVmYXVsdHMYJCABKAsyJS5oZHlfcnBjLlJlc3BvbnNlU2V0dGluZ3NSZWd1bGF0'
    'b3JHZXRSCGRlZmF1bHRzEjkKCWVmZmVjdGl2ZRglIAEoCzIbLmhkeV9ycGMuUmVndWxhdG9yRW'
    'ZmZWN0aXZlUgllZmZlY3RpdmU=');

@$core.Deprecated('Use regulatorEffectiveDescriptor instead')
const RegulatorEffective$json = {
  '1': 'RegulatorEffective',
  '2': [
    {'1': 'trim_limit_output', '3': 1, '4': 1, '5': 2, '10': 'trimLimitOutput'},
    {
      '1': 'derivative_output_limit',
      '3': 2,
      '4': 1,
      '5': 2,
      '10': 'derivativeOutputLimit'
    },
    {
      '1': 'effective_max_output',
      '3': 3,
      '4': 1,
      '5': 2,
      '10': 'effectiveMaxOutput'
    },
    {
      '1': 'overspeed_stop_margin',
      '3': 4,
      '4': 1,
      '5': 2,
      '10': 'overspeedStopMargin'
    },
    {'1': 'tick_period_ms', '3': 5, '4': 1, '5': 13, '10': 'tickPeriodMs'},
    {
      '1': 'turn_speed_reference',
      '3': 6,
      '4': 1,
      '5': 2,
      '10': 'turnSpeedReference'
    },
    {'1': 'motor_max_power', '3': 7, '4': 1, '5': 2, '10': 'motorMaxPower'},
    {'1': 'pwm_freq_hz', '3': 8, '4': 1, '5': 13, '10': 'pwmFreqHz'},
    {
      '1': 'pwm_resolution_bits',
      '3': 9,
      '4': 1,
      '5': 13,
      '10': 'pwmResolutionBits'
    },
    {'1': 'x_max_speed', '3': 10, '4': 1, '5': 13, '10': 'xMaxSpeed'},
    {
      '1': 'x_max_speed_theoretical',
      '3': 11,
      '4': 1,
      '5': 13,
      '10': 'xMaxSpeedTheoretical'
    },
    {
      '1': 'x_min_speed_theoretical',
      '3': 12,
      '4': 1,
      '5': 13,
      '10': 'xMinSpeedTheoretical'
    },
    {'1': 'turn_speed', '3': 13, '4': 1, '5': 2, '10': 'turnSpeed'},
    {
      '1': 'turn_stop_max_time_ms',
      '3': 14,
      '4': 1,
      '5': 13,
      '10': 'turnStopMaxTimeMs'
    },
    {
      '1': 'turn_stop_speed_threshold',
      '3': 15,
      '4': 1,
      '5': 13,
      '10': 'turnStopSpeedThreshold'
    },
    {
      '1': 'trim_bank_forward',
      '3': 16,
      '4': 1,
      '5': 2,
      '10': 'trimBankForward'
    },
    {
      '1': 'trim_bank_forward_speed',
      '3': 17,
      '4': 1,
      '5': 2,
      '10': 'trimBankForwardSpeed'
    },
    {
      '1': 'trim_bank_forward_confidence',
      '3': 18,
      '4': 1,
      '5': 2,
      '10': 'trimBankForwardConfidence'
    },
    {
      '1': 'trim_bank_backward',
      '3': 19,
      '4': 1,
      '5': 2,
      '10': 'trimBankBackward'
    },
    {
      '1': 'trim_bank_backward_speed',
      '3': 20,
      '4': 1,
      '5': 2,
      '10': 'trimBankBackwardSpeed'
    },
    {
      '1': 'trim_bank_backward_confidence',
      '3': 21,
      '4': 1,
      '5': 2,
      '10': 'trimBankBackwardConfidence'
    },
    {
      '1': 'trim_neg_limit_output',
      '3': 22,
      '4': 1,
      '5': 2,
      '10': 'trimNegLimitOutput'
    },
  ],
};

/// Descriptor for `RegulatorEffective`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List regulatorEffectiveDescriptor = $convert.base64Decode(
    'ChJSZWd1bGF0b3JFZmZlY3RpdmUSKgoRdHJpbV9saW1pdF9vdXRwdXQYASABKAJSD3RyaW1MaW'
    '1pdE91dHB1dBI2ChdkZXJpdmF0aXZlX291dHB1dF9saW1pdBgCIAEoAlIVZGVyaXZhdGl2ZU91'
    'dHB1dExpbWl0EjAKFGVmZmVjdGl2ZV9tYXhfb3V0cHV0GAMgASgCUhJlZmZlY3RpdmVNYXhPdX'
    'RwdXQSMgoVb3ZlcnNwZWVkX3N0b3BfbWFyZ2luGAQgASgCUhNvdmVyc3BlZWRTdG9wTWFyZ2lu'
    'EiQKDnRpY2tfcGVyaW9kX21zGAUgASgNUgx0aWNrUGVyaW9kTXMSMAoUdHVybl9zcGVlZF9yZW'
    'ZlcmVuY2UYBiABKAJSEnR1cm5TcGVlZFJlZmVyZW5jZRImCg9tb3Rvcl9tYXhfcG93ZXIYByAB'
    'KAJSDW1vdG9yTWF4UG93ZXISHgoLcHdtX2ZyZXFfaHoYCCABKA1SCXB3bUZyZXFIehIuChNwd2'
    '1fcmVzb2x1dGlvbl9iaXRzGAkgASgNUhFwd21SZXNvbHV0aW9uQml0cxIeCgt4X21heF9zcGVl'
    'ZBgKIAEoDVIJeE1heFNwZWVkEjUKF3hfbWF4X3NwZWVkX3RoZW9yZXRpY2FsGAsgASgNUhR4TW'
    'F4U3BlZWRUaGVvcmV0aWNhbBI1Chd4X21pbl9zcGVlZF90aGVvcmV0aWNhbBgMIAEoDVIUeE1p'
    'blNwZWVkVGhlb3JldGljYWwSHQoKdHVybl9zcGVlZBgNIAEoAlIJdHVyblNwZWVkEjAKFXR1cm'
    '5fc3RvcF9tYXhfdGltZV9tcxgOIAEoDVIRdHVyblN0b3BNYXhUaW1lTXMSOQoZdHVybl9zdG9w'
    'X3NwZWVkX3RocmVzaG9sZBgPIAEoDVIWdHVyblN0b3BTcGVlZFRocmVzaG9sZBIqChF0cmltX2'
    'JhbmtfZm9yd2FyZBgQIAEoAlIPdHJpbUJhbmtGb3J3YXJkEjUKF3RyaW1fYmFua19mb3J3YXJk'
    'X3NwZWVkGBEgASgCUhR0cmltQmFua0ZvcndhcmRTcGVlZBI/Chx0cmltX2JhbmtfZm9yd2FyZF'
    '9jb25maWRlbmNlGBIgASgCUhl0cmltQmFua0ZvcndhcmRDb25maWRlbmNlEiwKEnRyaW1fYmFu'
    'a19iYWNrd2FyZBgTIAEoAlIQdHJpbUJhbmtCYWNrd2FyZBI3Chh0cmltX2JhbmtfYmFja3dhcm'
    'Rfc3BlZWQYFCABKAJSFXRyaW1CYW5rQmFja3dhcmRTcGVlZBJBCh10cmltX2JhbmtfYmFja3dh'
    'cmRfY29uZmlkZW5jZRgVIAEoAlIadHJpbUJhbmtCYWNrd2FyZENvbmZpZGVuY2USMQoVdHJpbV'
    '9uZWdfbGltaXRfb3V0cHV0GBYgASgCUhJ0cmltTmVnTGltaXRPdXRwdXQ=');

@$core.Deprecated('Use requestSettingsHallGetDescriptor instead')
const RequestSettingsHallGet$json = {
  '1': 'RequestSettingsHallGet',
};

/// Descriptor for `RequestSettingsHallGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestSettingsHallGetDescriptor =
    $convert.base64Decode('ChZSZXF1ZXN0U2V0dGluZ3NIYWxsR2V0');

@$core.Deprecated('Use responseSettingsHallGetDescriptor instead')
const ResponseSettingsHallGet$json = {
  '1': 'ResponseSettingsHallGet',
  '2': [
    {'1': 'profile_id', '3': 1, '4': 1, '5': 13, '10': 'profileId'},
    {
      '1': 'speed_filter_alpha',
      '3': 2,
      '4': 1,
      '5': 2,
      '10': 'speedFilterAlpha'
    },
    {
      '1': 'reversal_filter_us',
      '3': 3,
      '4': 1,
      '5': 13,
      '10': 'reversalFilterUs'
    },
    {
      '1': 'zero_timeout_tick_mult',
      '3': 4,
      '4': 1,
      '5': 13,
      '10': 'zeroTimeoutTickMult'
    },
    {
      '1': 'zero_timeout_max_ms',
      '3': 5,
      '4': 1,
      '5': 13,
      '10': 'zeroTimeoutMaxMs'
    },
    {'1': 'min_dt_us', '3': 6, '4': 1, '5': 13, '10': 'minDtUs'},
    {'1': 'max_dt_us', '3': 7, '4': 1, '5': 13, '10': 'maxDtUs'},
    {'1': 'persisted', '3': 8, '4': 1, '5': 8, '10': 'persisted'},
  ],
};

/// Descriptor for `ResponseSettingsHallGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseSettingsHallGetDescriptor = $convert.base64Decode(
    'ChdSZXNwb25zZVNldHRpbmdzSGFsbEdldBIdCgpwcm9maWxlX2lkGAEgASgNUglwcm9maWxlSW'
    'QSLAoSc3BlZWRfZmlsdGVyX2FscGhhGAIgASgCUhBzcGVlZEZpbHRlckFscGhhEiwKEnJldmVy'
    'c2FsX2ZpbHRlcl91cxgDIAEoDVIQcmV2ZXJzYWxGaWx0ZXJVcxIzChZ6ZXJvX3RpbWVvdXRfdG'
    'lja19tdWx0GAQgASgNUhN6ZXJvVGltZW91dFRpY2tNdWx0Ei0KE3plcm9fdGltZW91dF9tYXhf'
    'bXMYBSABKA1SEHplcm9UaW1lb3V0TWF4TXMSGgoJbWluX2R0X3VzGAYgASgNUgdtaW5EdFVzEh'
    'oKCW1heF9kdF91cxgHIAEoDVIHbWF4RHRVcxIcCglwZXJzaXN0ZWQYCCABKAhSCXBlcnNpc3Rl'
    'ZA==');

@$core.Deprecated('Use requestSlideProfileGetDescriptor instead')
const RequestSlideProfileGet$json = {
  '1': 'RequestSlideProfileGet',
};

/// Descriptor for `RequestSlideProfileGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestSlideProfileGetDescriptor =
    $convert.base64Decode('ChZSZXF1ZXN0U2xpZGVQcm9maWxlR2V0');

@$core.Deprecated('Use responseSlideProfileGetDescriptor instead')
const ResponseSlideProfileGet$json = {
  '1': 'ResponseSlideProfileGet',
  '2': [
    {
      '1': 'profile',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.SlideProfile',
      '10': 'profile'
    },
    {'1': 'modified', '3': 2, '4': 1, '5': 8, '10': 'modified'},
    {'1': 'custom1_stored', '3': 3, '4': 1, '5': 8, '10': 'custom1Stored'},
    {'1': 'custom2_stored', '3': 4, '4': 1, '5': 8, '10': 'custom2Stored'},
    {
      '1': 'boot_profile',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.SlideProfile',
      '10': 'bootProfile'
    },
  ],
};

/// Descriptor for `ResponseSlideProfileGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseSlideProfileGetDescriptor = $convert.base64Decode(
    'ChdSZXNwb25zZVNsaWRlUHJvZmlsZUdldBIvCgdwcm9maWxlGAEgASgOMhUuaGR5X3JwYy5TbG'
    'lkZVByb2ZpbGVSB3Byb2ZpbGUSGgoIbW9kaWZpZWQYAiABKAhSCG1vZGlmaWVkEiUKDmN1c3Rv'
    'bTFfc3RvcmVkGAMgASgIUg1jdXN0b20xU3RvcmVkEiUKDmN1c3RvbTJfc3RvcmVkGAQgASgIUg'
    '1jdXN0b20yU3RvcmVkEjgKDGJvb3RfcHJvZmlsZRgFIAEoDjIVLmhkeV9ycGMuU2xpZGVQcm9m'
    'aWxlUgtib290UHJvZmlsZQ==');

@$core.Deprecated('Use requestSlideProfileTuningGetDescriptor instead')
const RequestSlideProfileTuningGet$json = {
  '1': 'RequestSlideProfileTuningGet',
  '2': [
    {
      '1': 'profile',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.SlideProfile',
      '10': 'profile'
    },
  ],
};

/// Descriptor for `RequestSlideProfileTuningGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestSlideProfileTuningGetDescriptor =
    $convert.base64Decode(
        'ChxSZXF1ZXN0U2xpZGVQcm9maWxlVHVuaW5nR2V0Ei8KB3Byb2ZpbGUYASABKA4yFS5oZHlfcn'
        'BjLlNsaWRlUHJvZmlsZVIHcHJvZmlsZQ==');

@$core.Deprecated('Use responseSlideProfileTuningGetDescriptor instead')
const ResponseSlideProfileTuningGet$json = {
  '1': 'ResponseSlideProfileTuningGet',
  '2': [
    {
      '1': 'profile',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.SlideProfile',
      '10': 'profile'
    },
    {
      '1': 'tuning',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseSettingsRegulatorGet',
      '10': 'tuning'
    },
    {'1': 'stored', '3': 3, '4': 1, '5': 8, '10': 'stored'},
  ],
};

/// Descriptor for `ResponseSlideProfileTuningGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseSlideProfileTuningGetDescriptor = $convert.base64Decode(
    'Ch1SZXNwb25zZVNsaWRlUHJvZmlsZVR1bmluZ0dldBIvCgdwcm9maWxlGAEgASgOMhUuaGR5X3'
    'JwYy5TbGlkZVByb2ZpbGVSB3Byb2ZpbGUSPQoGdHVuaW5nGAIgASgLMiUuaGR5X3JwYy5SZXNw'
    'b25zZVNldHRpbmdzUmVndWxhdG9yR2V0UgZ0dW5pbmcSFgoGc3RvcmVkGAMgASgIUgZzdG9yZW'
    'Q=');

@$core.Deprecated('Use requestSlideMaintResultGetDescriptor instead')
const RequestSlideMaintResultGet$json = {
  '1': 'RequestSlideMaintResultGet',
};

/// Descriptor for `RequestSlideMaintResultGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestSlideMaintResultGetDescriptor =
    $convert.base64Decode('ChpSZXF1ZXN0U2xpZGVNYWludFJlc3VsdEdldA==');

@$core.Deprecated('Use slideMaintDirResultDescriptor instead')
const SlideMaintDirResult$json = {
  '1': 'SlideMaintDirResult',
  '2': [
    {'1': 'speed', '3': 1, '4': 3, '5': 2, '10': 'speed'},
    {'1': 'plateau', '3': 2, '4': 1, '5': 2, '10': 'plateau'},
    {'1': 'rise_ms', '3': 3, '4': 1, '5': 2, '10': 'riseMs'},
    {'1': 'worst_dip_pct', '3': 4, '4': 1, '5': 2, '10': 'worstDipPct'},
    {'1': 'worst_dip_bin', '3': 5, '4': 1, '5': 13, '10': 'worstDipBin'},
    {'1': 'passes', '3': 6, '4': 1, '5': 13, '10': 'passes'},
    {'1': 'mid', '3': 7, '4': 1, '5': 2, '10': 'mid'},
    {'1': 'gradient_pct', '3': 8, '4': 1, '5': 2, '10': 'gradientPct'},
  ],
};

/// Descriptor for `SlideMaintDirResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List slideMaintDirResultDescriptor = $convert.base64Decode(
    'ChNTbGlkZU1haW50RGlyUmVzdWx0EhQKBXNwZWVkGAEgAygCUgVzcGVlZBIYCgdwbGF0ZWF1GA'
    'IgASgCUgdwbGF0ZWF1EhcKB3Jpc2VfbXMYAyABKAJSBnJpc2VNcxIiCg13b3JzdF9kaXBfcGN0'
    'GAQgASgCUgt3b3JzdERpcFBjdBIiCg13b3JzdF9kaXBfYmluGAUgASgNUgt3b3JzdERpcEJpbh'
    'IWCgZwYXNzZXMYBiABKA1SBnBhc3NlcxIQCgNtaWQYByABKAJSA21pZBIhCgxncmFkaWVudF9w'
    'Y3QYCCABKAJSC2dyYWRpZW50UGN0');

@$core.Deprecated('Use slideMaintUniformityResultDescriptor instead')
const SlideMaintUniformityResult$json = {
  '1': 'SlideMaintUniformityResult',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 5, '10': 'result'},
    {'1': 'duty', '3': 2, '4': 1, '5': 2, '10': 'duty'},
    {'1': 'bin_mm', '3': 3, '4': 1, '5': 2, '10': 'binMm'},
    {'1': 'lo', '3': 4, '4': 1, '5': 2, '10': 'lo'},
    {'1': 'hi', '3': 5, '4': 1, '5': 2, '10': 'hi'},
    {
      '1': 'forward',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.SlideMaintDirResult',
      '10': 'forward'
    },
    {
      '1': 'backward',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.SlideMaintDirResult',
      '10': 'backward'
    },
    {'1': 'asymmetry', '3': 8, '4': 1, '5': 2, '10': 'asymmetry'},
    {
      '1': 'verdict',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.SlideMaintVerdict',
      '10': 'verdict'
    },
    {'1': 'temp_c', '3': 10, '4': 1, '5': 2, '10': 'tempC'},
    {'1': 'timestamp_ms', '3': 11, '4': 1, '5': 13, '10': 'timestampMs'},
  ],
};

/// Descriptor for `SlideMaintUniformityResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List slideMaintUniformityResultDescriptor = $convert.base64Decode(
    'ChpTbGlkZU1haW50VW5pZm9ybWl0eVJlc3VsdBIWCgZyZXN1bHQYASABKAVSBnJlc3VsdBISCg'
    'RkdXR5GAIgASgCUgRkdXR5EhUKBmJpbl9tbRgDIAEoAlIFYmluTW0SDgoCbG8YBCABKAJSAmxv'
    'Eg4KAmhpGAUgASgCUgJoaRI2Cgdmb3J3YXJkGAYgASgLMhwuaGR5X3JwYy5TbGlkZU1haW50RG'
    'lyUmVzdWx0Ugdmb3J3YXJkEjgKCGJhY2t3YXJkGAcgASgLMhwuaGR5X3JwYy5TbGlkZU1haW50'
    'RGlyUmVzdWx0UghiYWNrd2FyZBIcCglhc3ltbWV0cnkYCCABKAJSCWFzeW1tZXRyeRI0Cgd2ZX'
    'JkaWN0GAkgASgOMhouaGR5X3JwYy5TbGlkZU1haW50VmVyZGljdFIHdmVyZGljdBIVCgZ0ZW1w'
    'X2MYCiABKAJSBXRlbXBDEiEKDHRpbWVzdGFtcF9tcxgLIAEoDVILdGltZXN0YW1wTXM=');

@$core.Deprecated('Use slideMaintMaxSpeedResultDescriptor instead')
const SlideMaintMaxSpeedResult$json = {
  '1': 'SlideMaintMaxSpeedResult',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 5, '10': 'result'},
    {'1': 'peak_forward', '3': 2, '4': 1, '5': 2, '10': 'peakForward'},
    {'1': 'peak_backward', '3': 3, '4': 1, '5': 2, '10': 'peakBackward'},
    {'1': 'duty', '3': 4, '4': 1, '5': 2, '10': 'duty'},
    {'1': 'margin_forward', '3': 5, '4': 1, '5': 2, '10': 'marginForward'},
    {'1': 'margin_backward', '3': 6, '4': 1, '5': 2, '10': 'marginBackward'},
    {
      '1': 'buffer_hit_forward',
      '3': 7,
      '4': 1,
      '5': 8,
      '10': 'bufferHitForward'
    },
    {
      '1': 'buffer_hit_backward',
      '3': 8,
      '4': 1,
      '5': 8,
      '10': 'bufferHitBackward'
    },
    {'1': 'brake_k', '3': 9, '4': 1, '5': 2, '10': 'brakeK'},
    {'1': 'brake_cal_speed', '3': 10, '4': 1, '5': 2, '10': 'brakeCalSpeed'},
    {'1': 'brake_cal_dist', '3': 11, '4': 1, '5': 2, '10': 'brakeCalDist'},
    {'1': 'passes', '3': 12, '4': 1, '5': 13, '10': 'passes'},
    {
      '1': 'verdict',
      '3': 13,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.SlideMaintVerdict',
      '10': 'verdict'
    },
    {'1': 'temp_c', '3': 14, '4': 1, '5': 2, '10': 'tempC'},
    {'1': 'timestamp_ms', '3': 15, '4': 1, '5': 13, '10': 'timestampMs'},
  ],
};

/// Descriptor for `SlideMaintMaxSpeedResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List slideMaintMaxSpeedResultDescriptor = $convert.base64Decode(
    'ChhTbGlkZU1haW50TWF4U3BlZWRSZXN1bHQSFgoGcmVzdWx0GAEgASgFUgZyZXN1bHQSIQoMcG'
    'Vha19mb3J3YXJkGAIgASgCUgtwZWFrRm9yd2FyZBIjCg1wZWFrX2JhY2t3YXJkGAMgASgCUgxw'
    'ZWFrQmFja3dhcmQSEgoEZHV0eRgEIAEoAlIEZHV0eRIlCg5tYXJnaW5fZm9yd2FyZBgFIAEoAl'
    'INbWFyZ2luRm9yd2FyZBInCg9tYXJnaW5fYmFja3dhcmQYBiABKAJSDm1hcmdpbkJhY2t3YXJk'
    'EiwKEmJ1ZmZlcl9oaXRfZm9yd2FyZBgHIAEoCFIQYnVmZmVySGl0Rm9yd2FyZBIuChNidWZmZX'
    'JfaGl0X2JhY2t3YXJkGAggASgIUhFidWZmZXJIaXRCYWNrd2FyZBIXCgdicmFrZV9rGAkgASgC'
    'UgZicmFrZUsSJgoPYnJha2VfY2FsX3NwZWVkGAogASgCUg1icmFrZUNhbFNwZWVkEiQKDmJyYW'
    'tlX2NhbF9kaXN0GAsgASgCUgxicmFrZUNhbERpc3QSFgoGcGFzc2VzGAwgASgNUgZwYXNzZXMS'
    'NAoHdmVyZGljdBgNIAEoDjIaLmhkeV9ycGMuU2xpZGVNYWludFZlcmRpY3RSB3ZlcmRpY3QSFQ'
    'oGdGVtcF9jGA4gASgCUgV0ZW1wQxIhCgx0aW1lc3RhbXBfbXMYDyABKA1SC3RpbWVzdGFtcE1z');

@$core.Deprecated('Use responseSlideMaintResultGetDescriptor instead')
const ResponseSlideMaintResultGet$json = {
  '1': 'ResponseSlideMaintResultGet',
  '2': [
    {
      '1': 'uniformity',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.SlideMaintUniformityResult',
      '10': 'uniformity'
    },
    {
      '1': 'max_speed',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.SlideMaintMaxSpeedResult',
      '10': 'maxSpeed'
    },
    {'1': 'running', '3': 3, '4': 1, '5': 8, '10': 'running'},
  ],
};

/// Descriptor for `ResponseSlideMaintResultGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseSlideMaintResultGetDescriptor = $convert.base64Decode(
    'ChtSZXNwb25zZVNsaWRlTWFpbnRSZXN1bHRHZXQSQwoKdW5pZm9ybWl0eRgBIAEoCzIjLmhkeV'
    '9ycGMuU2xpZGVNYWludFVuaWZvcm1pdHlSZXN1bHRSCnVuaWZvcm1pdHkSPgoJbWF4X3NwZWVk'
    'GAIgASgLMiEuaGR5X3JwYy5TbGlkZU1haW50TWF4U3BlZWRSZXN1bHRSCG1heFNwZWVkEhgKB3'
    'J1bm5pbmcYAyABKAhSB3J1bm5pbmc=');
