// This is a generated file - do not edit.
//
// Generated from handy_rpc.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use messageTypeDescriptor instead')
const MessageType$json = {
  '1': 'MessageType',
  '2': [
    {'1': 'MESSAGE_TYPE_UNKNOWN', '2': 0},
    {'1': 'MESSAGE_TYPE_REQUEST', '2': 1},
    {'1': 'MESSAGE_TYPE_REQUESTS', '2': 2},
    {'1': 'MESSAGE_TYPE_RESPONSE', '2': 3},
    {'1': 'MESSAGE_TYPE_NOTIFICATION', '2': 4},
  ],
};

/// Descriptor for `MessageType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List messageTypeDescriptor = $convert.base64Decode(
    'CgtNZXNzYWdlVHlwZRIYChRNRVNTQUdFX1RZUEVfVU5LTk9XThAAEhgKFE1FU1NBR0VfVFlQRV'
    '9SRVFVRVNUEAESGQoVTUVTU0FHRV9UWVBFX1JFUVVFU1RTEAISGQoVTUVTU0FHRV9UWVBFX1JF'
    'U1BPTlNFEAMSHQoZTUVTU0FHRV9UWVBFX05PVElGSUNBVElPThAE');

@$core.Deprecated('Use notificationDescriptor instead')
const Notification$json = {
  '1': 'Notification',
  '2': [
    {
      '1': 'notification_wifi_scan_complete',
      '3': 600,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationWifiScanComplete',
      '9': 0,
      '10': 'notificationWifiScanComplete'
    },
    {
      '1': 'notification_wifi_status_changed',
      '3': 601,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationWifiStatusChanged',
      '9': 0,
      '10': 'notificationWifiStatusChanged'
    },
    {
      '1': 'notification_ble_status_changed',
      '3': 602,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationBleStatusChanged',
      '9': 0,
      '10': 'notificationBleStatusChanged'
    },
    {
      '1': 'notification_ota_complete',
      '3': 603,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationOtaComplete',
      '9': 0,
      '10': 'notificationOtaComplete'
    },
    {
      '1': 'notification_mode_changed',
      '3': 700,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationModeChanged',
      '9': 0,
      '10': 'notificationModeChanged'
    },
    {
      '1': 'notification_stroke_changed',
      '3': 701,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationStrokeChanged',
      '9': 0,
      '10': 'notificationStrokeChanged'
    },
    {
      '1': 'notification_button_event',
      '3': 703,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationButtonEvent',
      '9': 0,
      '10': 'notificationButtonEvent'
    },
    {
      '1': 'notification_battery_changed',
      '3': 705,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationBatteryChanged',
      '9': 0,
      '10': 'notificationBatteryChanged'
    },
    {
      '1': 'notification_error',
      '3': 706,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationError',
      '9': 0,
      '10': 'notificationError'
    },
    {
      '1': 'notification_idle_timeout',
      '3': 707,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationIdleTimeout',
      '9': 0,
      '10': 'notificationIdleTimeout'
    },
    {
      '1': 'notification_hamp_changed',
      '3': 720,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationHampChanged',
      '9': 0,
      '10': 'notificationHampChanged'
    },
    {
      '1': 'notification_hdsp_changed',
      '3': 740,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationHdspChanged',
      '9': 0,
      '10': 'notificationHdspChanged'
    },
    {
      '1': 'notification_hsp_threshold_reached',
      '3': 860,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationHspThresholdReached',
      '9': 0,
      '10': 'notificationHspThresholdReached'
    },
    {
      '1': 'notification_hsp_state_changed',
      '3': 861,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationHspStateChanged',
      '9': 0,
      '10': 'notificationHspStateChanged'
    },
    {
      '1': 'notification_hsp_looping',
      '3': 862,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationHspLooping',
      '9': 0,
      '10': 'notificationHspLooping'
    },
    {
      '1': 'notification_hsp_starving',
      '3': 863,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationHspStarving',
      '9': 0,
      '10': 'notificationHspStarving'
    },
    {
      '1': 'notification_hsp_resumed_on_non_starving',
      '3': 864,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationHspResumedOnNonStarving',
      '9': 0,
      '10': 'notificationHspResumedOnNonStarving'
    },
    {
      '1': 'notification_hsp_paused_on_starving',
      '3': 865,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationHspPausedOnStarving',
      '9': 0,
      '10': 'notificationHspPausedOnStarving'
    },
    {
      '1': 'notification_hvp_changed',
      '3': 900,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationHvpChanged',
      '9': 0,
      '10': 'notificationHvpChanged'
    },
    {
      '1': 'notification_hrpp_changed',
      '3': 920,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationHrppChanged',
      '9': 0,
      '10': 'notificationHrppChanged'
    },
    {
      '1': 'notification_temp_high',
      '3': 1000,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationTempHigh',
      '9': 0,
      '10': 'notificationTempHigh'
    },
    {
      '1': 'notification_temp_ok',
      '3': 1001,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationTempOk',
      '9': 0,
      '10': 'notificationTempOk'
    },
    {
      '1': 'notification_slider_blocked',
      '3': 1002,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationSliderBlocked',
      '9': 0,
      '10': 'notificationSliderBlocked'
    },
    {
      '1': 'notification_slider_unblocked',
      '3': 1003,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationSliderUnblocked',
      '9': 0,
      '10': 'notificationSliderUnblocked'
    },
    {
      '1': 'notification_low_memory_error',
      '3': 1004,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationLowMemoryError',
      '9': 0,
      '10': 'notificationLowMemoryError'
    },
    {
      '1': 'notification_low_memory_warning',
      '3': 1005,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationLowMemoryWarning',
      '9': 0,
      '10': 'notificationLowMemoryWarning'
    },
    {'1': 'id', '3': 2, '4': 1, '5': 13, '10': 'id'},
  ],
  '8': [
    {'1': 'notification'},
  ],
};

/// Descriptor for `Notification`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationDescriptor = $convert.base64Decode(
    'CgxOb3RpZmljYXRpb24Sbwofbm90aWZpY2F0aW9uX3dpZmlfc2Nhbl9jb21wbGV0ZRjYBCABKA'
    'syJS5oZHlfcnBjLk5vdGlmaWNhdGlvbldpZmlTY2FuQ29tcGxldGVIAFIcbm90aWZpY2F0aW9u'
    'V2lmaVNjYW5Db21wbGV0ZRJyCiBub3RpZmljYXRpb25fd2lmaV9zdGF0dXNfY2hhbmdlZBjZBC'
    'ABKAsyJi5oZHlfcnBjLk5vdGlmaWNhdGlvbldpZmlTdGF0dXNDaGFuZ2VkSABSHW5vdGlmaWNh'
    'dGlvbldpZmlTdGF0dXNDaGFuZ2VkEm8KH25vdGlmaWNhdGlvbl9ibGVfc3RhdHVzX2NoYW5nZW'
    'QY2gQgASgLMiUuaGR5X3JwYy5Ob3RpZmljYXRpb25CbGVTdGF0dXNDaGFuZ2VkSABSHG5vdGlm'
    'aWNhdGlvbkJsZVN0YXR1c0NoYW5nZWQSXwoZbm90aWZpY2F0aW9uX290YV9jb21wbGV0ZRjbBC'
    'ABKAsyIC5oZHlfcnBjLk5vdGlmaWNhdGlvbk90YUNvbXBsZXRlSABSF25vdGlmaWNhdGlvbk90'
    'YUNvbXBsZXRlEl8KGW5vdGlmaWNhdGlvbl9tb2RlX2NoYW5nZWQYvAUgASgLMiAuaGR5X3JwYy'
    '5Ob3RpZmljYXRpb25Nb2RlQ2hhbmdlZEgAUhdub3RpZmljYXRpb25Nb2RlQ2hhbmdlZBJlChtu'
    'b3RpZmljYXRpb25fc3Ryb2tlX2NoYW5nZWQYvQUgASgLMiIuaGR5X3JwYy5Ob3RpZmljYXRpb2'
    '5TdHJva2VDaGFuZ2VkSABSGW5vdGlmaWNhdGlvblN0cm9rZUNoYW5nZWQSXwoZbm90aWZpY2F0'
    'aW9uX2J1dHRvbl9ldmVudBi/BSABKAsyIC5oZHlfcnBjLk5vdGlmaWNhdGlvbkJ1dHRvbkV2ZW'
    '50SABSF25vdGlmaWNhdGlvbkJ1dHRvbkV2ZW50EmgKHG5vdGlmaWNhdGlvbl9iYXR0ZXJ5X2No'
    'YW5nZWQYwQUgASgLMiMuaGR5X3JwYy5Ob3RpZmljYXRpb25CYXR0ZXJ5Q2hhbmdlZEgAUhpub3'
    'RpZmljYXRpb25CYXR0ZXJ5Q2hhbmdlZBJMChJub3RpZmljYXRpb25fZXJyb3IYwgUgASgLMhou'
    'aGR5X3JwYy5Ob3RpZmljYXRpb25FcnJvckgAUhFub3RpZmljYXRpb25FcnJvchJfChlub3RpZm'
    'ljYXRpb25faWRsZV90aW1lb3V0GMMFIAEoCzIgLmhkeV9ycGMuTm90aWZpY2F0aW9uSWRsZVRp'
    'bWVvdXRIAFIXbm90aWZpY2F0aW9uSWRsZVRpbWVvdXQSXwoZbm90aWZpY2F0aW9uX2hhbXBfY2'
    'hhbmdlZBjQBSABKAsyIC5oZHlfcnBjLk5vdGlmaWNhdGlvbkhhbXBDaGFuZ2VkSABSF25vdGlm'
    'aWNhdGlvbkhhbXBDaGFuZ2VkEl8KGW5vdGlmaWNhdGlvbl9oZHNwX2NoYW5nZWQY5AUgASgLMi'
    'AuaGR5X3JwYy5Ob3RpZmljYXRpb25IZHNwQ2hhbmdlZEgAUhdub3RpZmljYXRpb25IZHNwQ2hh'
    'bmdlZBJ4CiJub3RpZmljYXRpb25faHNwX3RocmVzaG9sZF9yZWFjaGVkGNwGIAEoCzIoLmhkeV'
    '9ycGMuTm90aWZpY2F0aW9uSHNwVGhyZXNob2xkUmVhY2hlZEgAUh9ub3RpZmljYXRpb25Ic3BU'
    'aHJlc2hvbGRSZWFjaGVkEmwKHm5vdGlmaWNhdGlvbl9oc3Bfc3RhdGVfY2hhbmdlZBjdBiABKA'
    'syJC5oZHlfcnBjLk5vdGlmaWNhdGlvbkhzcFN0YXRlQ2hhbmdlZEgAUhtub3RpZmljYXRpb25I'
    'c3BTdGF0ZUNoYW5nZWQSXAoYbm90aWZpY2F0aW9uX2hzcF9sb29waW5nGN4GIAEoCzIfLmhkeV'
    '9ycGMuTm90aWZpY2F0aW9uSHNwTG9vcGluZ0gAUhZub3RpZmljYXRpb25Ic3BMb29waW5nEl8K'
    'GW5vdGlmaWNhdGlvbl9oc3Bfc3RhcnZpbmcY3wYgASgLMiAuaGR5X3JwYy5Ob3RpZmljYXRpb2'
    '5Ic3BTdGFydmluZ0gAUhdub3RpZmljYXRpb25Ic3BTdGFydmluZxKGAQoobm90aWZpY2F0aW9u'
    'X2hzcF9yZXN1bWVkX29uX25vbl9zdGFydmluZxjgBiABKAsyLC5oZHlfcnBjLk5vdGlmaWNhdG'
    'lvbkhzcFJlc3VtZWRPbk5vblN0YXJ2aW5nSABSI25vdGlmaWNhdGlvbkhzcFJlc3VtZWRPbk5v'
    'blN0YXJ2aW5nEnkKI25vdGlmaWNhdGlvbl9oc3BfcGF1c2VkX29uX3N0YXJ2aW5nGOEGIAEoCz'
    'IoLmhkeV9ycGMuTm90aWZpY2F0aW9uSHNwUGF1c2VkT25TdGFydmluZ0gAUh9ub3RpZmljYXRp'
    'b25Ic3BQYXVzZWRPblN0YXJ2aW5nElwKGG5vdGlmaWNhdGlvbl9odnBfY2hhbmdlZBiEByABKA'
    'syHy5oZHlfcnBjLk5vdGlmaWNhdGlvbkh2cENoYW5nZWRIAFIWbm90aWZpY2F0aW9uSHZwQ2hh'
    'bmdlZBJfChlub3RpZmljYXRpb25faHJwcF9jaGFuZ2VkGJgHIAEoCzIgLmhkeV9ycGMuTm90aW'
    'ZpY2F0aW9uSHJwcENoYW5nZWRIAFIXbm90aWZpY2F0aW9uSHJwcENoYW5nZWQSVgoWbm90aWZp'
    'Y2F0aW9uX3RlbXBfaGlnaBjoByABKAsyHS5oZHlfcnBjLk5vdGlmaWNhdGlvblRlbXBIaWdoSA'
    'BSFG5vdGlmaWNhdGlvblRlbXBIaWdoElAKFG5vdGlmaWNhdGlvbl90ZW1wX29rGOkHIAEoCzIb'
    'LmhkeV9ycGMuTm90aWZpY2F0aW9uVGVtcE9rSABSEm5vdGlmaWNhdGlvblRlbXBPaxJlChtub3'
    'RpZmljYXRpb25fc2xpZGVyX2Jsb2NrZWQY6gcgASgLMiIuaGR5X3JwYy5Ob3RpZmljYXRpb25T'
    'bGlkZXJCbG9ja2VkSABSGW5vdGlmaWNhdGlvblNsaWRlckJsb2NrZWQSawodbm90aWZpY2F0aW'
    '9uX3NsaWRlcl91bmJsb2NrZWQY6wcgASgLMiQuaGR5X3JwYy5Ob3RpZmljYXRpb25TbGlkZXJV'
    'bmJsb2NrZWRIAFIbbm90aWZpY2F0aW9uU2xpZGVyVW5ibG9ja2VkEmkKHW5vdGlmaWNhdGlvbl'
    '9sb3dfbWVtb3J5X2Vycm9yGOwHIAEoCzIjLmhkeV9ycGMuTm90aWZpY2F0aW9uTG93TWVtb3J5'
    'RXJyb3JIAFIabm90aWZpY2F0aW9uTG93TWVtb3J5RXJyb3ISbwofbm90aWZpY2F0aW9uX2xvd1'
    '9tZW1vcnlfd2FybmluZxjtByABKAsyJS5oZHlfcnBjLk5vdGlmaWNhdGlvbkxvd01lbW9yeVdh'
    'cm5pbmdIAFIcbm90aWZpY2F0aW9uTG93TWVtb3J5V2FybmluZxIOCgJpZBgCIAEoDVICaWRCDg'
    'oMbm90aWZpY2F0aW9u');

@$core.Deprecated('Use requestDescriptor instead')
const Request$json = {
  '1': 'Request',
  '2': [
    {
      '1': 'request_connection_key_get',
      '3': 606,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestConnectionKeyGet',
      '9': 0,
      '10': 'requestConnectionKeyGet'
    },
    {
      '1': 'request_wifi_status_get',
      '3': 620,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestWifiStatusGet',
      '9': 0,
      '10': 'requestWifiStatusGet'
    },
    {
      '1': 'request_wifi_set',
      '3': 621,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestWifiSet',
      '9': 0,
      '10': 'requestWifiSet'
    },
    {
      '1': 'request_wifi_scan_start',
      '3': 623,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestWifiScanStart',
      '9': 0,
      '10': 'requestWifiScanStart'
    },
    {
      '1': 'request_wifi_scan_results_get',
      '3': 624,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestWifiScanResultsGet',
      '9': 0,
      '10': 'requestWifiScanResultsGet'
    },
    {
      '1': 'request_wifi_scan_stop',
      '3': 625,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestWifiScanStop',
      '9': 0,
      '10': 'requestWifiScanStop'
    },
    {
      '1': 'request_mode_get',
      '3': 700,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestModeGet',
      '9': 0,
      '10': 'requestModeGet'
    },
    {
      '1': 'request_mode_set',
      '3': 701,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestModeSet',
      '9': 0,
      '10': 'requestModeSet'
    },
    {
      '1': 'request_reboot',
      '3': 707,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestReboot',
      '9': 0,
      '10': 'requestReboot'
    },
    {
      '1': 'request_button_press',
      '3': 708,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestButtonPress',
      '9': 0,
      '10': 'requestButtonPress'
    },
    {
      '1': 'request_clock_offset_set',
      '3': 709,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestClockOffsetSet',
      '9': 0,
      '10': 'requestClockOffsetSet'
    },
    {
      '1': 'request_battery_get',
      '3': 710,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestBatteryGet',
      '9': 0,
      '10': 'requestBatteryGet'
    },
    {
      '1': 'request_clock_offset_get',
      '3': 712,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestClockOffsetGet',
      '9': 0,
      '10': 'requestClockOffsetGet'
    },
    {
      '1': 'request_capabilities_get',
      '3': 713,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestCapabilitiesGet',
      '9': 0,
      '10': 'requestCapabilitiesGet'
    },
    {
      '1': 'request_session_ids_get',
      '3': 714,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestSessionIdsGet',
      '9': 0,
      '10': 'requestSessionIdsGet'
    },
    {
      '1': 'request_stop_current_mode',
      '3': 715,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestStopCurrentMode',
      '9': 0,
      '10': 'requestStopCurrentMode'
    },
    {
      '1': 'request_connection_mode_set',
      '3': 716,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestConnectionModeSet',
      '9': 0,
      '10': 'requestConnectionModeSet'
    },
    {
      '1': 'request_connection_mode_get',
      '3': 717,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestConnectionModeGet',
      '9': 0,
      '10': 'requestConnectionModeGet'
    },
    {
      '1': 'request_hamp_start',
      '3': 720,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHampStart',
      '9': 0,
      '10': 'requestHampStart'
    },
    {
      '1': 'request_hamp_stop',
      '3': 721,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHampStop',
      '9': 0,
      '10': 'requestHampStop'
    },
    {
      '1': 'request_hamp_velocity_set',
      '3': 723,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHampVelocitySet',
      '9': 0,
      '10': 'requestHampVelocitySet'
    },
    {
      '1': 'request_hamp_state_get',
      '3': 724,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHampStateGet',
      '9': 0,
      '10': 'requestHampStateGet'
    },
    {
      '1': 'request_hamp_zone_set',
      '3': 725,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHampZoneSet',
      '9': 0,
      '10': 'requestHampZoneSet'
    },
    {
      '1': 'request_hdsp_xa_va_set',
      '3': 740,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHdspXaVaSet',
      '9': 0,
      '10': 'requestHdspXaVaSet'
    },
    {
      '1': 'request_hdsp_xp_va_set',
      '3': 741,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHdspXpVaSet',
      '9': 0,
      '10': 'requestHdspXpVaSet'
    },
    {
      '1': 'request_hdsp_xp_vp_set',
      '3': 742,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHdspXpVpSet',
      '9': 0,
      '10': 'requestHdspXpVpSet'
    },
    {
      '1': 'request_hdsp_xa_t_set',
      '3': 743,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHdspXaTSet',
      '9': 0,
      '10': 'requestHdspXaTSet'
    },
    {
      '1': 'request_hdsp_xp_t_set',
      '3': 744,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHdspXpTSet',
      '9': 0,
      '10': 'requestHdspXpTSet'
    },
    {
      '1': 'request_hdsp_xa_vp_set',
      '3': 745,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHdspXaVpSet',
      '9': 0,
      '10': 'requestHdspXaVpSet'
    },
    {
      '1': 'request_hdsp_stop',
      '3': 746,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHdspStop',
      '9': 0,
      '10': 'requestHdspStop'
    },
    {
      '1': 'request_slider_stroke_get',
      '3': 840,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestSliderStrokeGet',
      '9': 0,
      '10': 'requestSliderStrokeGet'
    },
    {
      '1': 'request_slider_stroke_set',
      '3': 841,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestSliderStrokeSet',
      '9': 0,
      '10': 'requestSliderStrokeSet'
    },
    {
      '1': 'request_slider_state_get',
      '3': 842,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestSliderStateGet',
      '9': 0,
      '10': 'requestSliderStateGet'
    },
    {
      '1': 'request_slider_calibrate',
      '3': 843,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestSliderCalibrate',
      '9': 0,
      '10': 'requestSliderCalibrate'
    },
    {
      '1': 'request_hsp_setup',
      '3': 860,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHspSetup',
      '9': 0,
      '10': 'requestHspSetup'
    },
    {
      '1': 'request_hsp_add',
      '3': 861,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHspAdd',
      '9': 0,
      '10': 'requestHspAdd'
    },
    {
      '1': 'request_hsp_flush',
      '3': 862,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHspFlush',
      '9': 0,
      '10': 'requestHspFlush'
    },
    {
      '1': 'request_hsp_play',
      '3': 863,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHspPlay',
      '9': 0,
      '10': 'requestHspPlay'
    },
    {
      '1': 'request_hsp_stop',
      '3': 864,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHspStop',
      '9': 0,
      '10': 'requestHspStop'
    },
    {
      '1': 'request_hsp_pause',
      '3': 865,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHspPause',
      '9': 0,
      '10': 'requestHspPause'
    },
    {
      '1': 'request_hsp_resume',
      '3': 866,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHspResume',
      '9': 0,
      '10': 'requestHspResume'
    },
    {
      '1': 'request_hsp_state_get',
      '3': 867,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHspStateGet',
      '9': 0,
      '10': 'requestHspStateGet'
    },
    {
      '1': 'request_hsp_current_time_set',
      '3': 868,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHspCurrentTimeSet',
      '9': 0,
      '10': 'requestHspCurrentTimeSet'
    },
    {
      '1': 'request_hsp_threshold_set',
      '3': 869,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHspThresholdSet',
      '9': 0,
      '10': 'requestHspThresholdSet'
    },
    {
      '1': 'request_hsp_pause_on_starving_set',
      '3': 870,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHspPauseOnStarvingSet',
      '9': 0,
      '10': 'requestHspPauseOnStarvingSet'
    },
    {
      '1': 'request_led_override',
      '3': 880,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestLedOverride',
      '9': 0,
      '10': 'requestLedOverride'
    },
    {
      '1': 'request_hvp_set',
      '3': 900,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHvpSet',
      '9': 0,
      '10': 'requestHvpSet'
    },
    {
      '1': 'request_hvp_stop',
      '3': 901,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHvpStop',
      '9': 0,
      '10': 'requestHvpStop'
    },
    {
      '1': 'request_hvp_start',
      '3': 902,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHvpStart',
      '9': 0,
      '10': 'requestHvpStart'
    },
    {
      '1': 'request_hvp_state_get',
      '3': 903,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHvpStateGet',
      '9': 0,
      '10': 'requestHvpStateGet'
    },
    {
      '1': 'request_hrpp_start',
      '3': 920,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHrppStart',
      '9': 0,
      '10': 'requestHrppStart'
    },
    {
      '1': 'request_hrpp_stop',
      '3': 921,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHrppStop',
      '9': 0,
      '10': 'requestHrppStop'
    },
    {
      '1': 'request_hrpp_amplitude_set',
      '3': 922,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHrppAmplitudeSet',
      '9': 0,
      '10': 'requestHrppAmplitudeSet'
    },
    {
      '1': 'request_hrpp_playback_speed_set',
      '3': 923,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHrppPlaybackSpeedSet',
      '9': 0,
      '10': 'requestHrppPlaybackSpeedSet'
    },
    {
      '1': 'request_hrpp_pattern_set',
      '3': 924,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHrppPatternSet',
      '9': 0,
      '10': 'requestHrppPatternSet'
    },
    {
      '1': 'request_hrpp_state_get',
      '3': 925,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHrppStateGet',
      '9': 0,
      '10': 'requestHrppStateGet'
    },
    {
      '1': 'request_hrpp_patterns_get',
      '3': 926,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHrppPatternsGet',
      '9': 0,
      '10': 'requestHrppPatternsGet'
    },
    {'1': 'id', '3': 2, '4': 1, '5': 13, '10': 'id'},
  ],
  '8': [
    {'1': 'params'},
  ],
};

/// Descriptor for `Request`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestDescriptor = $convert.base64Decode(
    'CgdSZXF1ZXN0EmAKGnJlcXVlc3RfY29ubmVjdGlvbl9rZXlfZ2V0GN4EIAEoCzIgLmhkeV9ycG'
    'MuUmVxdWVzdENvbm5lY3Rpb25LZXlHZXRIAFIXcmVxdWVzdENvbm5lY3Rpb25LZXlHZXQSVwoX'
    'cmVxdWVzdF93aWZpX3N0YXR1c19nZXQY7AQgASgLMh0uaGR5X3JwYy5SZXF1ZXN0V2lmaVN0YX'
    'R1c0dldEgAUhRyZXF1ZXN0V2lmaVN0YXR1c0dldBJEChByZXF1ZXN0X3dpZmlfc2V0GO0EIAEo'
    'CzIXLmhkeV9ycGMuUmVxdWVzdFdpZmlTZXRIAFIOcmVxdWVzdFdpZmlTZXQSVwoXcmVxdWVzdF'
    '93aWZpX3NjYW5fc3RhcnQY7wQgASgLMh0uaGR5X3JwYy5SZXF1ZXN0V2lmaVNjYW5TdGFydEgA'
    'UhRyZXF1ZXN0V2lmaVNjYW5TdGFydBJnCh1yZXF1ZXN0X3dpZmlfc2Nhbl9yZXN1bHRzX2dldB'
    'jwBCABKAsyIi5oZHlfcnBjLlJlcXVlc3RXaWZpU2NhblJlc3VsdHNHZXRIAFIZcmVxdWVzdFdp'
    'ZmlTY2FuUmVzdWx0c0dldBJUChZyZXF1ZXN0X3dpZmlfc2Nhbl9zdG9wGPEEIAEoCzIcLmhkeV'
    '9ycGMuUmVxdWVzdFdpZmlTY2FuU3RvcEgAUhNyZXF1ZXN0V2lmaVNjYW5TdG9wEkQKEHJlcXVl'
    'c3RfbW9kZV9nZXQYvAUgASgLMhcuaGR5X3JwYy5SZXF1ZXN0TW9kZUdldEgAUg5yZXF1ZXN0TW'
    '9kZUdldBJEChByZXF1ZXN0X21vZGVfc2V0GL0FIAEoCzIXLmhkeV9ycGMuUmVxdWVzdE1vZGVT'
    'ZXRIAFIOcmVxdWVzdE1vZGVTZXQSQAoOcmVxdWVzdF9yZWJvb3QYwwUgASgLMhYuaGR5X3JwYy'
    '5SZXF1ZXN0UmVib290SABSDXJlcXVlc3RSZWJvb3QSUAoUcmVxdWVzdF9idXR0b25fcHJlc3MY'
    'xAUgASgLMhsuaGR5X3JwYy5SZXF1ZXN0QnV0dG9uUHJlc3NIAFIScmVxdWVzdEJ1dHRvblByZX'
    'NzEloKGHJlcXVlc3RfY2xvY2tfb2Zmc2V0X3NldBjFBSABKAsyHi5oZHlfcnBjLlJlcXVlc3RD'
    'bG9ja09mZnNldFNldEgAUhVyZXF1ZXN0Q2xvY2tPZmZzZXRTZXQSTQoTcmVxdWVzdF9iYXR0ZX'
    'J5X2dldBjGBSABKAsyGi5oZHlfcnBjLlJlcXVlc3RCYXR0ZXJ5R2V0SABSEXJlcXVlc3RCYXR0'
    'ZXJ5R2V0EloKGHJlcXVlc3RfY2xvY2tfb2Zmc2V0X2dldBjIBSABKAsyHi5oZHlfcnBjLlJlcX'
    'Vlc3RDbG9ja09mZnNldEdldEgAUhVyZXF1ZXN0Q2xvY2tPZmZzZXRHZXQSXAoYcmVxdWVzdF9j'
    'YXBhYmlsaXRpZXNfZ2V0GMkFIAEoCzIfLmhkeV9ycGMuUmVxdWVzdENhcGFiaWxpdGllc0dldE'
    'gAUhZyZXF1ZXN0Q2FwYWJpbGl0aWVzR2V0ElcKF3JlcXVlc3Rfc2Vzc2lvbl9pZHNfZ2V0GMoF'
    'IAEoCzIdLmhkeV9ycGMuUmVxdWVzdFNlc3Npb25JZHNHZXRIAFIUcmVxdWVzdFNlc3Npb25JZH'
    'NHZXQSXQoZcmVxdWVzdF9zdG9wX2N1cnJlbnRfbW9kZRjLBSABKAsyHy5oZHlfcnBjLlJlcXVl'
    'c3RTdG9wQ3VycmVudE1vZGVIAFIWcmVxdWVzdFN0b3BDdXJyZW50TW9kZRJjChtyZXF1ZXN0X2'
    'Nvbm5lY3Rpb25fbW9kZV9zZXQYzAUgASgLMiEuaGR5X3JwYy5SZXF1ZXN0Q29ubmVjdGlvbk1v'
    'ZGVTZXRIAFIYcmVxdWVzdENvbm5lY3Rpb25Nb2RlU2V0EmMKG3JlcXVlc3RfY29ubmVjdGlvbl'
    '9tb2RlX2dldBjNBSABKAsyIS5oZHlfcnBjLlJlcXVlc3RDb25uZWN0aW9uTW9kZUdldEgAUhhy'
    'ZXF1ZXN0Q29ubmVjdGlvbk1vZGVHZXQSSgoScmVxdWVzdF9oYW1wX3N0YXJ0GNAFIAEoCzIZLm'
    'hkeV9ycGMuUmVxdWVzdEhhbXBTdGFydEgAUhByZXF1ZXN0SGFtcFN0YXJ0EkcKEXJlcXVlc3Rf'
    'aGFtcF9zdG9wGNEFIAEoCzIYLmhkeV9ycGMuUmVxdWVzdEhhbXBTdG9wSABSD3JlcXVlc3RIYW'
    '1wU3RvcBJdChlyZXF1ZXN0X2hhbXBfdmVsb2NpdHlfc2V0GNMFIAEoCzIfLmhkeV9ycGMuUmVx'
    'dWVzdEhhbXBWZWxvY2l0eVNldEgAUhZyZXF1ZXN0SGFtcFZlbG9jaXR5U2V0ElQKFnJlcXVlc3'
    'RfaGFtcF9zdGF0ZV9nZXQY1AUgASgLMhwuaGR5X3JwYy5SZXF1ZXN0SGFtcFN0YXRlR2V0SABS'
    'E3JlcXVlc3RIYW1wU3RhdGVHZXQSUQoVcmVxdWVzdF9oYW1wX3pvbmVfc2V0GNUFIAEoCzIbLm'
    'hkeV9ycGMuUmVxdWVzdEhhbXBab25lU2V0SABSEnJlcXVlc3RIYW1wWm9uZVNldBJSChZyZXF1'
    'ZXN0X2hkc3BfeGFfdmFfc2V0GOQFIAEoCzIbLmhkeV9ycGMuUmVxdWVzdEhkc3BYYVZhU2V0SA'
    'BSEnJlcXVlc3RIZHNwWGFWYVNldBJSChZyZXF1ZXN0X2hkc3BfeHBfdmFfc2V0GOUFIAEoCzIb'
    'LmhkeV9ycGMuUmVxdWVzdEhkc3BYcFZhU2V0SABSEnJlcXVlc3RIZHNwWHBWYVNldBJSChZyZX'
    'F1ZXN0X2hkc3BfeHBfdnBfc2V0GOYFIAEoCzIbLmhkeV9ycGMuUmVxdWVzdEhkc3BYcFZwU2V0'
    'SABSEnJlcXVlc3RIZHNwWHBWcFNldBJPChVyZXF1ZXN0X2hkc3BfeGFfdF9zZXQY5wUgASgLMh'
    'ouaGR5X3JwYy5SZXF1ZXN0SGRzcFhhVFNldEgAUhFyZXF1ZXN0SGRzcFhhVFNldBJPChVyZXF1'
    'ZXN0X2hkc3BfeHBfdF9zZXQY6AUgASgLMhouaGR5X3JwYy5SZXF1ZXN0SGRzcFhwVFNldEgAUh'
    'FyZXF1ZXN0SGRzcFhwVFNldBJSChZyZXF1ZXN0X2hkc3BfeGFfdnBfc2V0GOkFIAEoCzIbLmhk'
    'eV9ycGMuUmVxdWVzdEhkc3BYYVZwU2V0SABSEnJlcXVlc3RIZHNwWGFWcFNldBJHChFyZXF1ZX'
    'N0X2hkc3Bfc3RvcBjqBSABKAsyGC5oZHlfcnBjLlJlcXVlc3RIZHNwU3RvcEgAUg9yZXF1ZXN0'
    'SGRzcFN0b3ASXQoZcmVxdWVzdF9zbGlkZXJfc3Ryb2tlX2dldBjIBiABKAsyHy5oZHlfcnBjLl'
    'JlcXVlc3RTbGlkZXJTdHJva2VHZXRIAFIWcmVxdWVzdFNsaWRlclN0cm9rZUdldBJdChlyZXF1'
    'ZXN0X3NsaWRlcl9zdHJva2Vfc2V0GMkGIAEoCzIfLmhkeV9ycGMuUmVxdWVzdFNsaWRlclN0cm'
    '9rZVNldEgAUhZyZXF1ZXN0U2xpZGVyU3Ryb2tlU2V0EloKGHJlcXVlc3Rfc2xpZGVyX3N0YXRl'
    'X2dldBjKBiABKAsyHi5oZHlfcnBjLlJlcXVlc3RTbGlkZXJTdGF0ZUdldEgAUhVyZXF1ZXN0U2'
    'xpZGVyU3RhdGVHZXQSXAoYcmVxdWVzdF9zbGlkZXJfY2FsaWJyYXRlGMsGIAEoCzIfLmhkeV9y'
    'cGMuUmVxdWVzdFNsaWRlckNhbGlicmF0ZUgAUhZyZXF1ZXN0U2xpZGVyQ2FsaWJyYXRlEkcKEX'
    'JlcXVlc3RfaHNwX3NldHVwGNwGIAEoCzIYLmhkeV9ycGMuUmVxdWVzdEhzcFNldHVwSABSD3Jl'
    'cXVlc3RIc3BTZXR1cBJBCg9yZXF1ZXN0X2hzcF9hZGQY3QYgASgLMhYuaGR5X3JwYy5SZXF1ZX'
    'N0SHNwQWRkSABSDXJlcXVlc3RIc3BBZGQSRwoRcmVxdWVzdF9oc3BfZmx1c2gY3gYgASgLMhgu'
    'aGR5X3JwYy5SZXF1ZXN0SHNwRmx1c2hIAFIPcmVxdWVzdEhzcEZsdXNoEkQKEHJlcXVlc3RfaH'
    'NwX3BsYXkY3wYgASgLMhcuaGR5X3JwYy5SZXF1ZXN0SHNwUGxheUgAUg5yZXF1ZXN0SHNwUGxh'
    'eRJEChByZXF1ZXN0X2hzcF9zdG9wGOAGIAEoCzIXLmhkeV9ycGMuUmVxdWVzdEhzcFN0b3BIAF'
    'IOcmVxdWVzdEhzcFN0b3ASRwoRcmVxdWVzdF9oc3BfcGF1c2UY4QYgASgLMhguaGR5X3JwYy5S'
    'ZXF1ZXN0SHNwUGF1c2VIAFIPcmVxdWVzdEhzcFBhdXNlEkoKEnJlcXVlc3RfaHNwX3Jlc3VtZR'
    'jiBiABKAsyGS5oZHlfcnBjLlJlcXVlc3RIc3BSZXN1bWVIAFIQcmVxdWVzdEhzcFJlc3VtZRJR'
    'ChVyZXF1ZXN0X2hzcF9zdGF0ZV9nZXQY4wYgASgLMhsuaGR5X3JwYy5SZXF1ZXN0SHNwU3RhdG'
    'VHZXRIAFIScmVxdWVzdEhzcFN0YXRlR2V0EmQKHHJlcXVlc3RfaHNwX2N1cnJlbnRfdGltZV9z'
    'ZXQY5AYgASgLMiEuaGR5X3JwYy5SZXF1ZXN0SHNwQ3VycmVudFRpbWVTZXRIAFIYcmVxdWVzdE'
    'hzcEN1cnJlbnRUaW1lU2V0El0KGXJlcXVlc3RfaHNwX3RocmVzaG9sZF9zZXQY5QYgASgLMh8u'
    'aGR5X3JwYy5SZXF1ZXN0SHNwVGhyZXNob2xkU2V0SABSFnJlcXVlc3RIc3BUaHJlc2hvbGRTZX'
    'QScQohcmVxdWVzdF9oc3BfcGF1c2Vfb25fc3RhcnZpbmdfc2V0GOYGIAEoCzIlLmhkeV9ycGMu'
    'UmVxdWVzdEhzcFBhdXNlT25TdGFydmluZ1NldEgAUhxyZXF1ZXN0SHNwUGF1c2VPblN0YXJ2aW'
    '5nU2V0ElAKFHJlcXVlc3RfbGVkX292ZXJyaWRlGPAGIAEoCzIbLmhkeV9ycGMuUmVxdWVzdExl'
    'ZE92ZXJyaWRlSABSEnJlcXVlc3RMZWRPdmVycmlkZRJBCg9yZXF1ZXN0X2h2cF9zZXQYhAcgAS'
    'gLMhYuaGR5X3JwYy5SZXF1ZXN0SHZwU2V0SABSDXJlcXVlc3RIdnBTZXQSRAoQcmVxdWVzdF9o'
    'dnBfc3RvcBiFByABKAsyFy5oZHlfcnBjLlJlcXVlc3RIdnBTdG9wSABSDnJlcXVlc3RIdnBTdG'
    '9wEkcKEXJlcXVlc3RfaHZwX3N0YXJ0GIYHIAEoCzIYLmhkeV9ycGMuUmVxdWVzdEh2cFN0YXJ0'
    'SABSD3JlcXVlc3RIdnBTdGFydBJRChVyZXF1ZXN0X2h2cF9zdGF0ZV9nZXQYhwcgASgLMhsuaG'
    'R5X3JwYy5SZXF1ZXN0SHZwU3RhdGVHZXRIAFIScmVxdWVzdEh2cFN0YXRlR2V0EkoKEnJlcXVl'
    'c3RfaHJwcF9zdGFydBiYByABKAsyGS5oZHlfcnBjLlJlcXVlc3RIcnBwU3RhcnRIAFIQcmVxdW'
    'VzdEhycHBTdGFydBJHChFyZXF1ZXN0X2hycHBfc3RvcBiZByABKAsyGC5oZHlfcnBjLlJlcXVl'
    'c3RIcnBwU3RvcEgAUg9yZXF1ZXN0SHJwcFN0b3ASYAoacmVxdWVzdF9ocnBwX2FtcGxpdHVkZV'
    '9zZXQYmgcgASgLMiAuaGR5X3JwYy5SZXF1ZXN0SHJwcEFtcGxpdHVkZVNldEgAUhdyZXF1ZXN0'
    'SHJwcEFtcGxpdHVkZVNldBJtCh9yZXF1ZXN0X2hycHBfcGxheWJhY2tfc3BlZWRfc2V0GJsHIA'
    'EoCzIkLmhkeV9ycGMuUmVxdWVzdEhycHBQbGF5YmFja1NwZWVkU2V0SABSG3JlcXVlc3RIcnBw'
    'UGxheWJhY2tTcGVlZFNldBJaChhyZXF1ZXN0X2hycHBfcGF0dGVybl9zZXQYnAcgASgLMh4uaG'
    'R5X3JwYy5SZXF1ZXN0SHJwcFBhdHRlcm5TZXRIAFIVcmVxdWVzdEhycHBQYXR0ZXJuU2V0ElQK'
    'FnJlcXVlc3RfaHJwcF9zdGF0ZV9nZXQYnQcgASgLMhwuaGR5X3JwYy5SZXF1ZXN0SHJwcFN0YX'
    'RlR2V0SABSE3JlcXVlc3RIcnBwU3RhdGVHZXQSXQoZcmVxdWVzdF9ocnBwX3BhdHRlcm5zX2dl'
    'dBieByABKAsyHy5oZHlfcnBjLlJlcXVlc3RIcnBwUGF0dGVybnNHZXRIAFIWcmVxdWVzdEhycH'
    'BQYXR0ZXJuc0dldBIOCgJpZBgCIAEoDVICaWRCCAoGcGFyYW1z');

@$core.Deprecated('Use requestsDescriptor instead')
const Requests$json = {
  '1': 'Requests',
  '2': [
    {
      '1': 'requests',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.hdy_rpc.Request',
      '10': 'requests'
    },
  ],
};

/// Descriptor for `Requests`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestsDescriptor = $convert.base64Decode(
    'CghSZXF1ZXN0cxIsCghyZXF1ZXN0cxgBIAMoCzIQLmhkeV9ycGMuUmVxdWVzdFIIcmVxdWVzdH'
    'M=');

@$core.Deprecated('Use responseDescriptor instead')
const Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    {
      '1': 'response_connection_key_get',
      '3': 606,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseConnectionKeyGet',
      '9': 0,
      '10': 'responseConnectionKeyGet'
    },
    {
      '1': 'response_wifi_status_get',
      '3': 620,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseWifiStatusGet',
      '9': 0,
      '10': 'responseWifiStatusGet'
    },
    {
      '1': 'response_wifi_scan_results_get',
      '3': 624,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseWifiScanResultsGet',
      '9': 0,
      '10': 'responseWifiScanResultsGet'
    },
    {
      '1': 'response_mode_get',
      '3': 700,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseModeGet',
      '9': 0,
      '10': 'responseModeGet'
    },
    {
      '1': 'response_mode_set',
      '3': 701,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseModeSet',
      '9': 0,
      '10': 'responseModeSet'
    },
    {
      '1': 'response_clock_offset_set',
      '3': 709,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseClockOffsetSet',
      '9': 0,
      '10': 'responseClockOffsetSet'
    },
    {
      '1': 'response_battery_get',
      '3': 710,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseBatteryGet',
      '9': 0,
      '10': 'responseBatteryGet'
    },
    {
      '1': 'response_clock_offset_get',
      '3': 712,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseClockOffsetGet',
      '9': 0,
      '10': 'responseClockOffsetGet'
    },
    {
      '1': 'response_capabilities_get',
      '3': 713,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseCapabilitiesGet',
      '9': 0,
      '10': 'responseCapabilitiesGet'
    },
    {
      '1': 'response_session_ids_get',
      '3': 714,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseSessionIdsGet',
      '9': 0,
      '10': 'responseSessionIdsGet'
    },
    {
      '1': 'response_connection_mode_get',
      '3': 717,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseConnectionModeGet',
      '9': 0,
      '10': 'responseConnectionModeGet'
    },
    {
      '1': 'response_hamp_start',
      '3': 720,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHampStart',
      '9': 0,
      '10': 'responseHampStart'
    },
    {
      '1': 'response_hamp_stop',
      '3': 721,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHampStop',
      '9': 0,
      '10': 'responseHampStop'
    },
    {
      '1': 'response_hamp_velocity_set',
      '3': 723,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHampVelocitySet',
      '9': 0,
      '10': 'responseHampVelocitySet'
    },
    {
      '1': 'response_hamp_state_get',
      '3': 724,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHampStateGet',
      '9': 0,
      '10': 'responseHampStateGet'
    },
    {
      '1': 'response_hamp_zone_set',
      '3': 725,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHampZoneSet',
      '9': 0,
      '10': 'responseHampZoneSet'
    },
    {
      '1': 'response_slider_stroke_get',
      '3': 840,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseSliderStrokeGet',
      '9': 0,
      '10': 'responseSliderStrokeGet'
    },
    {
      '1': 'response_slider_stroke_set',
      '3': 841,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseSliderStrokeSet',
      '9': 0,
      '10': 'responseSliderStrokeSet'
    },
    {
      '1': 'response_slider_state_get',
      '3': 842,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseSliderStateGet',
      '9': 0,
      '10': 'responseSliderStateGet'
    },
    {
      '1': 'response_slider_calibrate',
      '3': 843,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseSliderCalibrate',
      '9': 0,
      '10': 'responseSliderCalibrate'
    },
    {
      '1': 'response_hsp_setup',
      '3': 860,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHspSetup',
      '9': 0,
      '10': 'responseHspSetup'
    },
    {
      '1': 'response_hsp_add',
      '3': 861,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHspAdd',
      '9': 0,
      '10': 'responseHspAdd'
    },
    {
      '1': 'response_hsp_flush',
      '3': 862,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHspFlush',
      '9': 0,
      '10': 'responseHspFlush'
    },
    {
      '1': 'response_hsp_play',
      '3': 863,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHspPlay',
      '9': 0,
      '10': 'responseHspPlay'
    },
    {
      '1': 'response_hsp_stop',
      '3': 864,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHspStop',
      '9': 0,
      '10': 'responseHspStop'
    },
    {
      '1': 'response_hsp_pause',
      '3': 865,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHspPause',
      '9': 0,
      '10': 'responseHspPause'
    },
    {
      '1': 'response_hsp_resume',
      '3': 866,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHspResume',
      '9': 0,
      '10': 'responseHspResume'
    },
    {
      '1': 'response_hsp_state_get',
      '3': 867,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHspStateGet',
      '9': 0,
      '10': 'responseHspStateGet'
    },
    {
      '1': 'response_hsp_current_time_set',
      '3': 868,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHspCurrentTimeSet',
      '9': 0,
      '10': 'responseHspCurrentTimeSet'
    },
    {
      '1': 'response_hsp_threshold_set',
      '3': 869,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHspThresholdSet',
      '9': 0,
      '10': 'responseHspThresholdSet'
    },
    {
      '1': 'response_hsp_pause_on_starving_set',
      '3': 870,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHspPauseOnStarvingSet',
      '9': 0,
      '10': 'responseHspPauseOnStarvingSet'
    },
    {
      '1': 'response_hvp_set',
      '3': 900,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHvpSet',
      '9': 0,
      '10': 'responseHvpSet'
    },
    {
      '1': 'response_hvp_stop',
      '3': 901,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHvpStop',
      '9': 0,
      '10': 'responseHvpStop'
    },
    {
      '1': 'response_hvp_start',
      '3': 902,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHvpStart',
      '9': 0,
      '10': 'responseHvpStart'
    },
    {
      '1': 'response_hvp_state_get',
      '3': 903,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHvpStateGet',
      '9': 0,
      '10': 'responseHvpStateGet'
    },
    {
      '1': 'response_hrpp_start',
      '3': 920,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHrppStart',
      '9': 0,
      '10': 'responseHrppStart'
    },
    {
      '1': 'response_hrpp_stop',
      '3': 921,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHrppStop',
      '9': 0,
      '10': 'responseHrppStop'
    },
    {
      '1': 'response_hrpp_amplitude_set',
      '3': 922,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHrppAmplitudeSet',
      '9': 0,
      '10': 'responseHrppAmplitudeSet'
    },
    {
      '1': 'response_hrpp_playback_speed_set',
      '3': 923,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHrppPlaybackSpeedSet',
      '9': 0,
      '10': 'responseHrppPlaybackSpeedSet'
    },
    {
      '1': 'response_hrpp_pattern_set',
      '3': 924,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHrppPatternSet',
      '9': 0,
      '10': 'responseHrppPatternSet'
    },
    {
      '1': 'response_hrpp_state_get',
      '3': 925,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHrppStateGet',
      '9': 0,
      '10': 'responseHrppStateGet'
    },
    {
      '1': 'response_hrpp_patterns_get',
      '3': 926,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHrppPatternsGet',
      '9': 0,
      '10': 'responseHrppPatternsGet'
    },
    {
      '1': 'error',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.Error',
      '10': 'error'
    },
  ],
  '8': [
    {'1': 'result'},
  ],
};

/// Descriptor for `Response`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseDescriptor = $convert.base64Decode(
    'CghSZXNwb25zZRIOCgJpZBgBIAEoDVICaWQSYwobcmVzcG9uc2VfY29ubmVjdGlvbl9rZXlfZ2'
    'V0GN4EIAEoCzIhLmhkeV9ycGMuUmVzcG9uc2VDb25uZWN0aW9uS2V5R2V0SABSGHJlc3BvbnNl'
    'Q29ubmVjdGlvbktleUdldBJaChhyZXNwb25zZV93aWZpX3N0YXR1c19nZXQY7AQgASgLMh4uaG'
    'R5X3JwYy5SZXNwb25zZVdpZmlTdGF0dXNHZXRIAFIVcmVzcG9uc2VXaWZpU3RhdHVzR2V0EmoK'
    'HnJlc3BvbnNlX3dpZmlfc2Nhbl9yZXN1bHRzX2dldBjwBCABKAsyIy5oZHlfcnBjLlJlc3Bvbn'
    'NlV2lmaVNjYW5SZXN1bHRzR2V0SABSGnJlc3BvbnNlV2lmaVNjYW5SZXN1bHRzR2V0EkcKEXJl'
    'c3BvbnNlX21vZGVfZ2V0GLwFIAEoCzIYLmhkeV9ycGMuUmVzcG9uc2VNb2RlR2V0SABSD3Jlc3'
    'BvbnNlTW9kZUdldBJHChFyZXNwb25zZV9tb2RlX3NldBi9BSABKAsyGC5oZHlfcnBjLlJlc3Bv'
    'bnNlTW9kZVNldEgAUg9yZXNwb25zZU1vZGVTZXQSXQoZcmVzcG9uc2VfY2xvY2tfb2Zmc2V0X3'
    'NldBjFBSABKAsyHy5oZHlfcnBjLlJlc3BvbnNlQ2xvY2tPZmZzZXRTZXRIAFIWcmVzcG9uc2VD'
    'bG9ja09mZnNldFNldBJQChRyZXNwb25zZV9iYXR0ZXJ5X2dldBjGBSABKAsyGy5oZHlfcnBjLl'
    'Jlc3BvbnNlQmF0dGVyeUdldEgAUhJyZXNwb25zZUJhdHRlcnlHZXQSXQoZcmVzcG9uc2VfY2xv'
    'Y2tfb2Zmc2V0X2dldBjIBSABKAsyHy5oZHlfcnBjLlJlc3BvbnNlQ2xvY2tPZmZzZXRHZXRIAF'
    'IWcmVzcG9uc2VDbG9ja09mZnNldEdldBJfChlyZXNwb25zZV9jYXBhYmlsaXRpZXNfZ2V0GMkF'
    'IAEoCzIgLmhkeV9ycGMuUmVzcG9uc2VDYXBhYmlsaXRpZXNHZXRIAFIXcmVzcG9uc2VDYXBhYm'
    'lsaXRpZXNHZXQSWgoYcmVzcG9uc2Vfc2Vzc2lvbl9pZHNfZ2V0GMoFIAEoCzIeLmhkeV9ycGMu'
    'UmVzcG9uc2VTZXNzaW9uSWRzR2V0SABSFXJlc3BvbnNlU2Vzc2lvbklkc0dldBJmChxyZXNwb2'
    '5zZV9jb25uZWN0aW9uX21vZGVfZ2V0GM0FIAEoCzIiLmhkeV9ycGMuUmVzcG9uc2VDb25uZWN0'
    'aW9uTW9kZUdldEgAUhlyZXNwb25zZUNvbm5lY3Rpb25Nb2RlR2V0Ek0KE3Jlc3BvbnNlX2hhbX'
    'Bfc3RhcnQY0AUgASgLMhouaGR5X3JwYy5SZXNwb25zZUhhbXBTdGFydEgAUhFyZXNwb25zZUhh'
    'bXBTdGFydBJKChJyZXNwb25zZV9oYW1wX3N0b3AY0QUgASgLMhkuaGR5X3JwYy5SZXNwb25zZU'
    'hhbXBTdG9wSABSEHJlc3BvbnNlSGFtcFN0b3ASYAoacmVzcG9uc2VfaGFtcF92ZWxvY2l0eV9z'
    'ZXQY0wUgASgLMiAuaGR5X3JwYy5SZXNwb25zZUhhbXBWZWxvY2l0eVNldEgAUhdyZXNwb25zZU'
    'hhbXBWZWxvY2l0eVNldBJXChdyZXNwb25zZV9oYW1wX3N0YXRlX2dldBjUBSABKAsyHS5oZHlf'
    'cnBjLlJlc3BvbnNlSGFtcFN0YXRlR2V0SABSFHJlc3BvbnNlSGFtcFN0YXRlR2V0ElQKFnJlc3'
    'BvbnNlX2hhbXBfem9uZV9zZXQY1QUgASgLMhwuaGR5X3JwYy5SZXNwb25zZUhhbXBab25lU2V0'
    'SABSE3Jlc3BvbnNlSGFtcFpvbmVTZXQSYAoacmVzcG9uc2Vfc2xpZGVyX3N0cm9rZV9nZXQYyA'
    'YgASgLMiAuaGR5X3JwYy5SZXNwb25zZVNsaWRlclN0cm9rZUdldEgAUhdyZXNwb25zZVNsaWRl'
    'clN0cm9rZUdldBJgChpyZXNwb25zZV9zbGlkZXJfc3Ryb2tlX3NldBjJBiABKAsyIC5oZHlfcn'
    'BjLlJlc3BvbnNlU2xpZGVyU3Ryb2tlU2V0SABSF3Jlc3BvbnNlU2xpZGVyU3Ryb2tlU2V0El0K'
    'GXJlc3BvbnNlX3NsaWRlcl9zdGF0ZV9nZXQYygYgASgLMh8uaGR5X3JwYy5SZXNwb25zZVNsaW'
    'RlclN0YXRlR2V0SABSFnJlc3BvbnNlU2xpZGVyU3RhdGVHZXQSXwoZcmVzcG9uc2Vfc2xpZGVy'
    'X2NhbGlicmF0ZRjLBiABKAsyIC5oZHlfcnBjLlJlc3BvbnNlU2xpZGVyQ2FsaWJyYXRlSABSF3'
    'Jlc3BvbnNlU2xpZGVyQ2FsaWJyYXRlEkoKEnJlc3BvbnNlX2hzcF9zZXR1cBjcBiABKAsyGS5o'
    'ZHlfcnBjLlJlc3BvbnNlSHNwU2V0dXBIAFIQcmVzcG9uc2VIc3BTZXR1cBJEChByZXNwb25zZV'
    '9oc3BfYWRkGN0GIAEoCzIXLmhkeV9ycGMuUmVzcG9uc2VIc3BBZGRIAFIOcmVzcG9uc2VIc3BB'
    'ZGQSSgoScmVzcG9uc2VfaHNwX2ZsdXNoGN4GIAEoCzIZLmhkeV9ycGMuUmVzcG9uc2VIc3BGbH'
    'VzaEgAUhByZXNwb25zZUhzcEZsdXNoEkcKEXJlc3BvbnNlX2hzcF9wbGF5GN8GIAEoCzIYLmhk'
    'eV9ycGMuUmVzcG9uc2VIc3BQbGF5SABSD3Jlc3BvbnNlSHNwUGxheRJHChFyZXNwb25zZV9oc3'
    'Bfc3RvcBjgBiABKAsyGC5oZHlfcnBjLlJlc3BvbnNlSHNwU3RvcEgAUg9yZXNwb25zZUhzcFN0'
    'b3ASSgoScmVzcG9uc2VfaHNwX3BhdXNlGOEGIAEoCzIZLmhkeV9ycGMuUmVzcG9uc2VIc3BQYX'
    'VzZUgAUhByZXNwb25zZUhzcFBhdXNlEk0KE3Jlc3BvbnNlX2hzcF9yZXN1bWUY4gYgASgLMhou'
    'aGR5X3JwYy5SZXNwb25zZUhzcFJlc3VtZUgAUhFyZXNwb25zZUhzcFJlc3VtZRJUChZyZXNwb2'
    '5zZV9oc3Bfc3RhdGVfZ2V0GOMGIAEoCzIcLmhkeV9ycGMuUmVzcG9uc2VIc3BTdGF0ZUdldEgA'
    'UhNyZXNwb25zZUhzcFN0YXRlR2V0EmcKHXJlc3BvbnNlX2hzcF9jdXJyZW50X3RpbWVfc2V0GO'
    'QGIAEoCzIiLmhkeV9ycGMuUmVzcG9uc2VIc3BDdXJyZW50VGltZVNldEgAUhlyZXNwb25zZUhz'
    'cEN1cnJlbnRUaW1lU2V0EmAKGnJlc3BvbnNlX2hzcF90aHJlc2hvbGRfc2V0GOUGIAEoCzIgLm'
    'hkeV9ycGMuUmVzcG9uc2VIc3BUaHJlc2hvbGRTZXRIAFIXcmVzcG9uc2VIc3BUaHJlc2hvbGRT'
    'ZXQSdAoicmVzcG9uc2VfaHNwX3BhdXNlX29uX3N0YXJ2aW5nX3NldBjmBiABKAsyJi5oZHlfcn'
    'BjLlJlc3BvbnNlSHNwUGF1c2VPblN0YXJ2aW5nU2V0SABSHXJlc3BvbnNlSHNwUGF1c2VPblN0'
    'YXJ2aW5nU2V0EkQKEHJlc3BvbnNlX2h2cF9zZXQYhAcgASgLMhcuaGR5X3JwYy5SZXNwb25zZU'
    'h2cFNldEgAUg5yZXNwb25zZUh2cFNldBJHChFyZXNwb25zZV9odnBfc3RvcBiFByABKAsyGC5o'
    'ZHlfcnBjLlJlc3BvbnNlSHZwU3RvcEgAUg9yZXNwb25zZUh2cFN0b3ASSgoScmVzcG9uc2VfaH'
    'ZwX3N0YXJ0GIYHIAEoCzIZLmhkeV9ycGMuUmVzcG9uc2VIdnBTdGFydEgAUhByZXNwb25zZUh2'
    'cFN0YXJ0ElQKFnJlc3BvbnNlX2h2cF9zdGF0ZV9nZXQYhwcgASgLMhwuaGR5X3JwYy5SZXNwb2'
    '5zZUh2cFN0YXRlR2V0SABSE3Jlc3BvbnNlSHZwU3RhdGVHZXQSTQoTcmVzcG9uc2VfaHJwcF9z'
    'dGFydBiYByABKAsyGi5oZHlfcnBjLlJlc3BvbnNlSHJwcFN0YXJ0SABSEXJlc3BvbnNlSHJwcF'
    'N0YXJ0EkoKEnJlc3BvbnNlX2hycHBfc3RvcBiZByABKAsyGS5oZHlfcnBjLlJlc3BvbnNlSHJw'
    'cFN0b3BIAFIQcmVzcG9uc2VIcnBwU3RvcBJjChtyZXNwb25zZV9ocnBwX2FtcGxpdHVkZV9zZX'
    'QYmgcgASgLMiEuaGR5X3JwYy5SZXNwb25zZUhycHBBbXBsaXR1ZGVTZXRIAFIYcmVzcG9uc2VI'
    'cnBwQW1wbGl0dWRlU2V0EnAKIHJlc3BvbnNlX2hycHBfcGxheWJhY2tfc3BlZWRfc2V0GJsHIA'
    'EoCzIlLmhkeV9ycGMuUmVzcG9uc2VIcnBwUGxheWJhY2tTcGVlZFNldEgAUhxyZXNwb25zZUhy'
    'cHBQbGF5YmFja1NwZWVkU2V0El0KGXJlc3BvbnNlX2hycHBfcGF0dGVybl9zZXQYnAcgASgLMh'
    '8uaGR5X3JwYy5SZXNwb25zZUhycHBQYXR0ZXJuU2V0SABSFnJlc3BvbnNlSHJwcFBhdHRlcm5T'
    'ZXQSVwoXcmVzcG9uc2VfaHJwcF9zdGF0ZV9nZXQYnQcgASgLMh0uaGR5X3JwYy5SZXNwb25zZU'
    'hycHBTdGF0ZUdldEgAUhRyZXNwb25zZUhycHBTdGF0ZUdldBJgChpyZXNwb25zZV9ocnBwX3Bh'
    'dHRlcm5zX2dldBieByABKAsyIC5oZHlfcnBjLlJlc3BvbnNlSHJwcFBhdHRlcm5zR2V0SABSF3'
    'Jlc3BvbnNlSHJwcFBhdHRlcm5zR2V0EiQKBWVycm9yGAIgASgLMg4uaGR5X3JwYy5FcnJvclIF'
    'ZXJyb3JCCAoGcmVzdWx0');

@$core.Deprecated('Use errorDescriptor instead')
const Error$json = {
  '1': 'Error',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'data', '3': 3, '4': 1, '5': 9, '10': 'data'},
  ],
};

/// Descriptor for `Error`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List errorDescriptor = $convert.base64Decode(
    'CgVFcnJvchISCgRjb2RlGAEgASgFUgRjb2RlEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2USEg'
    'oEZGF0YRgDIAEoCVIEZGF0YQ==');

@$core.Deprecated('Use rpcMessageDescriptor instead')
const RpcMessage$json = {
  '1': 'RpcMessage',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.MessageType',
      '10': 'type'
    },
    {
      '1': 'request',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.Request',
      '9': 0,
      '10': 'request'
    },
    {
      '1': 'requests',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.Requests',
      '9': 0,
      '10': 'requests'
    },
    {
      '1': 'response',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.Response',
      '9': 0,
      '10': 'response'
    },
    {
      '1': 'notification',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.Notification',
      '9': 0,
      '10': 'notification'
    },
  ],
  '8': [
    {'1': 'message'},
  ],
};

/// Descriptor for `RpcMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rpcMessageDescriptor = $convert.base64Decode(
    'CgpScGNNZXNzYWdlEigKBHR5cGUYASABKA4yFC5oZHlfcnBjLk1lc3NhZ2VUeXBlUgR0eXBlEi'
    'wKB3JlcXVlc3QYAiABKAsyEC5oZHlfcnBjLlJlcXVlc3RIAFIHcmVxdWVzdBIvCghyZXF1ZXN0'
    'cxgDIAEoCzIRLmhkeV9ycGMuUmVxdWVzdHNIAFIIcmVxdWVzdHMSLwoIcmVzcG9uc2UYBCABKA'
    'syES5oZHlfcnBjLlJlc3BvbnNlSABSCHJlc3BvbnNlEjsKDG5vdGlmaWNhdGlvbhgFIAEoCzIV'
    'LmhkeV9ycGMuTm90aWZpY2F0aW9uSABSDG5vdGlmaWNhdGlvbkIJCgdtZXNzYWdl');
