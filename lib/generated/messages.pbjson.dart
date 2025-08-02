// This is a generated file - do not edit.
//
// Generated from messages.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

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
};

/// Descriptor for `RequestBatteryGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestBatteryGetDescriptor =
    $convert.base64Decode('ChFSZXF1ZXN0QmF0dGVyeUdldA==');

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
    'YXR0ZXJ5Q2FwYWNpdHk=');

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

@$core.Deprecated('Use requestHrppPlaybackSpeedSetDescriptor instead')
const RequestHrppPlaybackSpeedSet$json = {
  '1': 'RequestHrppPlaybackSpeedSet',
  '2': [
    {'1': 'speed', '3': 1, '4': 1, '5': 2, '10': 'speed'},
  ],
};

/// Descriptor for `RequestHrppPlaybackSpeedSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHrppPlaybackSpeedSetDescriptor =
    $convert.base64Decode(
        'ChtSZXF1ZXN0SHJwcFBsYXliYWNrU3BlZWRTZXQSFAoFc3BlZWQYASABKAJSBXNwZWVk');

@$core.Deprecated('Use responseHrppPlaybackSpeedSetDescriptor instead')
const ResponseHrppPlaybackSpeedSet$json = {
  '1': 'ResponseHrppPlaybackSpeedSet',
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

/// Descriptor for `ResponseHrppPlaybackSpeedSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseHrppPlaybackSpeedSetDescriptor =
    $convert.base64Decode(
        'ChxSZXNwb25zZUhycHBQbGF5YmFja1NwZWVkU2V0EigKBXN0YXRlGAEgASgLMhIuaGR5X3JwYy'
        '5IcnBwU3RhdGVSBXN0YXRl');

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
