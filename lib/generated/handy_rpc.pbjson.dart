// This is a generated file - do not edit.
//
// Generated from handy_rpc.proto.

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
      '1': 'notification_connected_changed',
      '3': 300,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationConnectedChanged',
      '9': 0,
      '10': 'notificationConnectedChanged'
    },
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
    {
      '1': 'notification_settings_changed',
      '3': 2000,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationSettingsChanged',
      '9': 0,
      '10': 'notificationSettingsChanged'
    },
    {'1': 'id', '3': 2, '4': 1, '5': 13, '10': 'id'},
  ],
  '8': [
    {'1': 'notification'},
  ],
};

/// Descriptor for `Notification`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationDescriptor = $convert.base64Decode(
    'CgxOb3RpZmljYXRpb24Sbgoebm90aWZpY2F0aW9uX2Nvbm5lY3RlZF9jaGFuZ2VkGKwCIAEoCz'
    'IlLmhkeV9ycGMuTm90aWZpY2F0aW9uQ29ubmVjdGVkQ2hhbmdlZEgAUhxub3RpZmljYXRpb25D'
    'b25uZWN0ZWRDaGFuZ2VkEm8KH25vdGlmaWNhdGlvbl93aWZpX3NjYW5fY29tcGxldGUY2AQgAS'
    'gLMiUuaGR5X3JwYy5Ob3RpZmljYXRpb25XaWZpU2NhbkNvbXBsZXRlSABSHG5vdGlmaWNhdGlv'
    'bldpZmlTY2FuQ29tcGxldGUScgogbm90aWZpY2F0aW9uX3dpZmlfc3RhdHVzX2NoYW5nZWQY2Q'
    'QgASgLMiYuaGR5X3JwYy5Ob3RpZmljYXRpb25XaWZpU3RhdHVzQ2hhbmdlZEgAUh1ub3RpZmlj'
    'YXRpb25XaWZpU3RhdHVzQ2hhbmdlZBJvCh9ub3RpZmljYXRpb25fYmxlX3N0YXR1c19jaGFuZ2'
    'VkGNoEIAEoCzIlLmhkeV9ycGMuTm90aWZpY2F0aW9uQmxlU3RhdHVzQ2hhbmdlZEgAUhxub3Rp'
    'ZmljYXRpb25CbGVTdGF0dXNDaGFuZ2VkEl8KGW5vdGlmaWNhdGlvbl9vdGFfY29tcGxldGUY2w'
    'QgASgLMiAuaGR5X3JwYy5Ob3RpZmljYXRpb25PdGFDb21wbGV0ZUgAUhdub3RpZmljYXRpb25P'
    'dGFDb21wbGV0ZRJfChlub3RpZmljYXRpb25fbW9kZV9jaGFuZ2VkGLwFIAEoCzIgLmhkeV9ycG'
    'MuTm90aWZpY2F0aW9uTW9kZUNoYW5nZWRIAFIXbm90aWZpY2F0aW9uTW9kZUNoYW5nZWQSZQob'
    'bm90aWZpY2F0aW9uX3N0cm9rZV9jaGFuZ2VkGL0FIAEoCzIiLmhkeV9ycGMuTm90aWZpY2F0aW'
    '9uU3Ryb2tlQ2hhbmdlZEgAUhlub3RpZmljYXRpb25TdHJva2VDaGFuZ2VkEl8KGW5vdGlmaWNh'
    'dGlvbl9idXR0b25fZXZlbnQYvwUgASgLMiAuaGR5X3JwYy5Ob3RpZmljYXRpb25CdXR0b25Fdm'
    'VudEgAUhdub3RpZmljYXRpb25CdXR0b25FdmVudBJoChxub3RpZmljYXRpb25fYmF0dGVyeV9j'
    'aGFuZ2VkGMEFIAEoCzIjLmhkeV9ycGMuTm90aWZpY2F0aW9uQmF0dGVyeUNoYW5nZWRIAFIabm'
    '90aWZpY2F0aW9uQmF0dGVyeUNoYW5nZWQSTAoSbm90aWZpY2F0aW9uX2Vycm9yGMIFIAEoCzIa'
    'LmhkeV9ycGMuTm90aWZpY2F0aW9uRXJyb3JIAFIRbm90aWZpY2F0aW9uRXJyb3ISXwoZbm90aW'
    'ZpY2F0aW9uX2lkbGVfdGltZW91dBjDBSABKAsyIC5oZHlfcnBjLk5vdGlmaWNhdGlvbklkbGVU'
    'aW1lb3V0SABSF25vdGlmaWNhdGlvbklkbGVUaW1lb3V0El8KGW5vdGlmaWNhdGlvbl9oYW1wX2'
    'NoYW5nZWQY0AUgASgLMiAuaGR5X3JwYy5Ob3RpZmljYXRpb25IYW1wQ2hhbmdlZEgAUhdub3Rp'
    'ZmljYXRpb25IYW1wQ2hhbmdlZBJfChlub3RpZmljYXRpb25faGRzcF9jaGFuZ2VkGOQFIAEoCz'
    'IgLmhkeV9ycGMuTm90aWZpY2F0aW9uSGRzcENoYW5nZWRIAFIXbm90aWZpY2F0aW9uSGRzcENo'
    'YW5nZWQSeAoibm90aWZpY2F0aW9uX2hzcF90aHJlc2hvbGRfcmVhY2hlZBjcBiABKAsyKC5oZH'
    'lfcnBjLk5vdGlmaWNhdGlvbkhzcFRocmVzaG9sZFJlYWNoZWRIAFIfbm90aWZpY2F0aW9uSHNw'
    'VGhyZXNob2xkUmVhY2hlZBJsCh5ub3RpZmljYXRpb25faHNwX3N0YXRlX2NoYW5nZWQY3QYgAS'
    'gLMiQuaGR5X3JwYy5Ob3RpZmljYXRpb25Ic3BTdGF0ZUNoYW5nZWRIAFIbbm90aWZpY2F0aW9u'
    'SHNwU3RhdGVDaGFuZ2VkElwKGG5vdGlmaWNhdGlvbl9oc3BfbG9vcGluZxjeBiABKAsyHy5oZH'
    'lfcnBjLk5vdGlmaWNhdGlvbkhzcExvb3BpbmdIAFIWbm90aWZpY2F0aW9uSHNwTG9vcGluZxJf'
    'Chlub3RpZmljYXRpb25faHNwX3N0YXJ2aW5nGN8GIAEoCzIgLmhkeV9ycGMuTm90aWZpY2F0aW'
    '9uSHNwU3RhcnZpbmdIAFIXbm90aWZpY2F0aW9uSHNwU3RhcnZpbmcShgEKKG5vdGlmaWNhdGlv'
    'bl9oc3BfcmVzdW1lZF9vbl9ub25fc3RhcnZpbmcY4AYgASgLMiwuaGR5X3JwYy5Ob3RpZmljYX'
    'Rpb25Ic3BSZXN1bWVkT25Ob25TdGFydmluZ0gAUiNub3RpZmljYXRpb25Ic3BSZXN1bWVkT25O'
    'b25TdGFydmluZxJ5CiNub3RpZmljYXRpb25faHNwX3BhdXNlZF9vbl9zdGFydmluZxjhBiABKA'
    'syKC5oZHlfcnBjLk5vdGlmaWNhdGlvbkhzcFBhdXNlZE9uU3RhcnZpbmdIAFIfbm90aWZpY2F0'
    'aW9uSHNwUGF1c2VkT25TdGFydmluZxJcChhub3RpZmljYXRpb25faHZwX2NoYW5nZWQYhAcgAS'
    'gLMh8uaGR5X3JwYy5Ob3RpZmljYXRpb25IdnBDaGFuZ2VkSABSFm5vdGlmaWNhdGlvbkh2cENo'
    'YW5nZWQSXwoZbm90aWZpY2F0aW9uX2hycHBfY2hhbmdlZBiYByABKAsyIC5oZHlfcnBjLk5vdG'
    'lmaWNhdGlvbkhycHBDaGFuZ2VkSABSF25vdGlmaWNhdGlvbkhycHBDaGFuZ2VkElYKFm5vdGlm'
    'aWNhdGlvbl90ZW1wX2hpZ2gY6AcgASgLMh0uaGR5X3JwYy5Ob3RpZmljYXRpb25UZW1wSGlnaE'
    'gAUhRub3RpZmljYXRpb25UZW1wSGlnaBJQChRub3RpZmljYXRpb25fdGVtcF9vaxjpByABKAsy'
    'Gy5oZHlfcnBjLk5vdGlmaWNhdGlvblRlbXBPa0gAUhJub3RpZmljYXRpb25UZW1wT2sSZQobbm'
    '90aWZpY2F0aW9uX3NsaWRlcl9ibG9ja2VkGOoHIAEoCzIiLmhkeV9ycGMuTm90aWZpY2F0aW9u'
    'U2xpZGVyQmxvY2tlZEgAUhlub3RpZmljYXRpb25TbGlkZXJCbG9ja2VkEmsKHW5vdGlmaWNhdG'
    'lvbl9zbGlkZXJfdW5ibG9ja2VkGOsHIAEoCzIkLmhkeV9ycGMuTm90aWZpY2F0aW9uU2xpZGVy'
    'VW5ibG9ja2VkSABSG25vdGlmaWNhdGlvblNsaWRlclVuYmxvY2tlZBJpCh1ub3RpZmljYXRpb2'
    '5fbG93X21lbW9yeV9lcnJvchjsByABKAsyIy5oZHlfcnBjLk5vdGlmaWNhdGlvbkxvd01lbW9y'
    'eUVycm9ySABSGm5vdGlmaWNhdGlvbkxvd01lbW9yeUVycm9yEm8KH25vdGlmaWNhdGlvbl9sb3'
    'dfbWVtb3J5X3dhcm5pbmcY7QcgASgLMiUuaGR5X3JwYy5Ob3RpZmljYXRpb25Mb3dNZW1vcnlX'
    'YXJuaW5nSABSHG5vdGlmaWNhdGlvbkxvd01lbW9yeVdhcm5pbmcSawodbm90aWZpY2F0aW9uX3'
    'NldHRpbmdzX2NoYW5nZWQY0A8gASgLMiQuaGR5X3JwYy5Ob3RpZmljYXRpb25TZXR0aW5nc0No'
    'YW5nZWRIAFIbbm90aWZpY2F0aW9uU2V0dGluZ3NDaGFuZ2VkEg4KAmlkGAIgASgNUgJpZEIOCg'
    'xub3RpZmljYXRpb24=');

@$core.Deprecated('Use requestDescriptor instead')
const Request$json = {
  '1': 'Request',
  '2': [
    {
      '1': 'request_server_time_get',
      '3': 300,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestServerTimeGet',
      '9': 0,
      '10': 'requestServerTimeGet'
    },
    {
      '1': 'request_connected_get',
      '3': 301,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestConnectedGet',
      '9': 0,
      '10': 'requestConnectedGet'
    },
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
      '1': 'request_hsp_playback_rate_set',
      '3': 871,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHspPlaybackRateSet',
      '9': 0,
      '10': 'requestHspPlaybackRateSet'
    },
    {
      '1': 'request_hsp_loop_set',
      '3': 872,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHspLoopSet',
      '9': 0,
      '10': 'requestHspLoopSet'
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
    {
      '1': 'request_hrpp_playback_rate_set',
      '3': 927,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHrppPlaybackRateSet',
      '9': 0,
      '10': 'requestHrppPlaybackRateSet'
    },
    {
      '1': 'request_hrpp_pause',
      '3': 928,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHrppPause',
      '9': 0,
      '10': 'requestHrppPause'
    },
    {'1': 'id', '3': 2, '4': 1, '5': 13, '10': 'id'},
  ],
  '8': [
    {'1': 'params'},
  ],
};

/// Descriptor for `Request`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestDescriptor = $convert.base64Decode(
    'CgdSZXF1ZXN0ElcKF3JlcXVlc3Rfc2VydmVyX3RpbWVfZ2V0GKwCIAEoCzIdLmhkeV9ycGMuUm'
    'VxdWVzdFNlcnZlclRpbWVHZXRIAFIUcmVxdWVzdFNlcnZlclRpbWVHZXQSUwoVcmVxdWVzdF9j'
    'b25uZWN0ZWRfZ2V0GK0CIAEoCzIcLmhkeV9ycGMuUmVxdWVzdENvbm5lY3RlZEdldEgAUhNyZX'
    'F1ZXN0Q29ubmVjdGVkR2V0EmAKGnJlcXVlc3RfY29ubmVjdGlvbl9rZXlfZ2V0GN4EIAEoCzIg'
    'LmhkeV9ycGMuUmVxdWVzdENvbm5lY3Rpb25LZXlHZXRIAFIXcmVxdWVzdENvbm5lY3Rpb25LZX'
    'lHZXQSVwoXcmVxdWVzdF93aWZpX3N0YXR1c19nZXQY7AQgASgLMh0uaGR5X3JwYy5SZXF1ZXN0'
    'V2lmaVN0YXR1c0dldEgAUhRyZXF1ZXN0V2lmaVN0YXR1c0dldBJEChByZXF1ZXN0X3dpZmlfc2'
    'V0GO0EIAEoCzIXLmhkeV9ycGMuUmVxdWVzdFdpZmlTZXRIAFIOcmVxdWVzdFdpZmlTZXQSVwoX'
    'cmVxdWVzdF93aWZpX3NjYW5fc3RhcnQY7wQgASgLMh0uaGR5X3JwYy5SZXF1ZXN0V2lmaVNjYW'
    '5TdGFydEgAUhRyZXF1ZXN0V2lmaVNjYW5TdGFydBJnCh1yZXF1ZXN0X3dpZmlfc2Nhbl9yZXN1'
    'bHRzX2dldBjwBCABKAsyIi5oZHlfcnBjLlJlcXVlc3RXaWZpU2NhblJlc3VsdHNHZXRIAFIZcm'
    'VxdWVzdFdpZmlTY2FuUmVzdWx0c0dldBJUChZyZXF1ZXN0X3dpZmlfc2Nhbl9zdG9wGPEEIAEo'
    'CzIcLmhkeV9ycGMuUmVxdWVzdFdpZmlTY2FuU3RvcEgAUhNyZXF1ZXN0V2lmaVNjYW5TdG9wEk'
    'QKEHJlcXVlc3RfbW9kZV9nZXQYvAUgASgLMhcuaGR5X3JwYy5SZXF1ZXN0TW9kZUdldEgAUg5y'
    'ZXF1ZXN0TW9kZUdldBJEChByZXF1ZXN0X21vZGVfc2V0GL0FIAEoCzIXLmhkeV9ycGMuUmVxdW'
    'VzdE1vZGVTZXRIAFIOcmVxdWVzdE1vZGVTZXQSQAoOcmVxdWVzdF9yZWJvb3QYwwUgASgLMhYu'
    'aGR5X3JwYy5SZXF1ZXN0UmVib290SABSDXJlcXVlc3RSZWJvb3QSUAoUcmVxdWVzdF9idXR0b2'
    '5fcHJlc3MYxAUgASgLMhsuaGR5X3JwYy5SZXF1ZXN0QnV0dG9uUHJlc3NIAFIScmVxdWVzdEJ1'
    'dHRvblByZXNzEloKGHJlcXVlc3RfY2xvY2tfb2Zmc2V0X3NldBjFBSABKAsyHi5oZHlfcnBjLl'
    'JlcXVlc3RDbG9ja09mZnNldFNldEgAUhVyZXF1ZXN0Q2xvY2tPZmZzZXRTZXQSTQoTcmVxdWVz'
    'dF9iYXR0ZXJ5X2dldBjGBSABKAsyGi5oZHlfcnBjLlJlcXVlc3RCYXR0ZXJ5R2V0SABSEXJlcX'
    'Vlc3RCYXR0ZXJ5R2V0EloKGHJlcXVlc3RfY2xvY2tfb2Zmc2V0X2dldBjIBSABKAsyHi5oZHlf'
    'cnBjLlJlcXVlc3RDbG9ja09mZnNldEdldEgAUhVyZXF1ZXN0Q2xvY2tPZmZzZXRHZXQSXAoYcm'
    'VxdWVzdF9jYXBhYmlsaXRpZXNfZ2V0GMkFIAEoCzIfLmhkeV9ycGMuUmVxdWVzdENhcGFiaWxp'
    'dGllc0dldEgAUhZyZXF1ZXN0Q2FwYWJpbGl0aWVzR2V0ElcKF3JlcXVlc3Rfc2Vzc2lvbl9pZH'
    'NfZ2V0GMoFIAEoCzIdLmhkeV9ycGMuUmVxdWVzdFNlc3Npb25JZHNHZXRIAFIUcmVxdWVzdFNl'
    'c3Npb25JZHNHZXQSXQoZcmVxdWVzdF9zdG9wX2N1cnJlbnRfbW9kZRjLBSABKAsyHy5oZHlfcn'
    'BjLlJlcXVlc3RTdG9wQ3VycmVudE1vZGVIAFIWcmVxdWVzdFN0b3BDdXJyZW50TW9kZRJjChty'
    'ZXF1ZXN0X2Nvbm5lY3Rpb25fbW9kZV9zZXQYzAUgASgLMiEuaGR5X3JwYy5SZXF1ZXN0Q29ubm'
    'VjdGlvbk1vZGVTZXRIAFIYcmVxdWVzdENvbm5lY3Rpb25Nb2RlU2V0EmMKG3JlcXVlc3RfY29u'
    'bmVjdGlvbl9tb2RlX2dldBjNBSABKAsyIS5oZHlfcnBjLlJlcXVlc3RDb25uZWN0aW9uTW9kZU'
    'dldEgAUhhyZXF1ZXN0Q29ubmVjdGlvbk1vZGVHZXQSSgoScmVxdWVzdF9oYW1wX3N0YXJ0GNAF'
    'IAEoCzIZLmhkeV9ycGMuUmVxdWVzdEhhbXBTdGFydEgAUhByZXF1ZXN0SGFtcFN0YXJ0EkcKEX'
    'JlcXVlc3RfaGFtcF9zdG9wGNEFIAEoCzIYLmhkeV9ycGMuUmVxdWVzdEhhbXBTdG9wSABSD3Jl'
    'cXVlc3RIYW1wU3RvcBJdChlyZXF1ZXN0X2hhbXBfdmVsb2NpdHlfc2V0GNMFIAEoCzIfLmhkeV'
    '9ycGMuUmVxdWVzdEhhbXBWZWxvY2l0eVNldEgAUhZyZXF1ZXN0SGFtcFZlbG9jaXR5U2V0ElQK'
    'FnJlcXVlc3RfaGFtcF9zdGF0ZV9nZXQY1AUgASgLMhwuaGR5X3JwYy5SZXF1ZXN0SGFtcFN0YX'
    'RlR2V0SABSE3JlcXVlc3RIYW1wU3RhdGVHZXQSUQoVcmVxdWVzdF9oYW1wX3pvbmVfc2V0GNUF'
    'IAEoCzIbLmhkeV9ycGMuUmVxdWVzdEhhbXBab25lU2V0SABSEnJlcXVlc3RIYW1wWm9uZVNldB'
    'JSChZyZXF1ZXN0X2hkc3BfeGFfdmFfc2V0GOQFIAEoCzIbLmhkeV9ycGMuUmVxdWVzdEhkc3BY'
    'YVZhU2V0SABSEnJlcXVlc3RIZHNwWGFWYVNldBJSChZyZXF1ZXN0X2hkc3BfeHBfdmFfc2V0GO'
    'UFIAEoCzIbLmhkeV9ycGMuUmVxdWVzdEhkc3BYcFZhU2V0SABSEnJlcXVlc3RIZHNwWHBWYVNl'
    'dBJSChZyZXF1ZXN0X2hkc3BfeHBfdnBfc2V0GOYFIAEoCzIbLmhkeV9ycGMuUmVxdWVzdEhkc3'
    'BYcFZwU2V0SABSEnJlcXVlc3RIZHNwWHBWcFNldBJPChVyZXF1ZXN0X2hkc3BfeGFfdF9zZXQY'
    '5wUgASgLMhouaGR5X3JwYy5SZXF1ZXN0SGRzcFhhVFNldEgAUhFyZXF1ZXN0SGRzcFhhVFNldB'
    'JPChVyZXF1ZXN0X2hkc3BfeHBfdF9zZXQY6AUgASgLMhouaGR5X3JwYy5SZXF1ZXN0SGRzcFhw'
    'VFNldEgAUhFyZXF1ZXN0SGRzcFhwVFNldBJSChZyZXF1ZXN0X2hkc3BfeGFfdnBfc2V0GOkFIA'
    'EoCzIbLmhkeV9ycGMuUmVxdWVzdEhkc3BYYVZwU2V0SABSEnJlcXVlc3RIZHNwWGFWcFNldBJH'
    'ChFyZXF1ZXN0X2hkc3Bfc3RvcBjqBSABKAsyGC5oZHlfcnBjLlJlcXVlc3RIZHNwU3RvcEgAUg'
    '9yZXF1ZXN0SGRzcFN0b3ASXQoZcmVxdWVzdF9zbGlkZXJfc3Ryb2tlX2dldBjIBiABKAsyHy5o'
    'ZHlfcnBjLlJlcXVlc3RTbGlkZXJTdHJva2VHZXRIAFIWcmVxdWVzdFNsaWRlclN0cm9rZUdldB'
    'JdChlyZXF1ZXN0X3NsaWRlcl9zdHJva2Vfc2V0GMkGIAEoCzIfLmhkeV9ycGMuUmVxdWVzdFNs'
    'aWRlclN0cm9rZVNldEgAUhZyZXF1ZXN0U2xpZGVyU3Ryb2tlU2V0EloKGHJlcXVlc3Rfc2xpZG'
    'VyX3N0YXRlX2dldBjKBiABKAsyHi5oZHlfcnBjLlJlcXVlc3RTbGlkZXJTdGF0ZUdldEgAUhVy'
    'ZXF1ZXN0U2xpZGVyU3RhdGVHZXQSXAoYcmVxdWVzdF9zbGlkZXJfY2FsaWJyYXRlGMsGIAEoCz'
    'IfLmhkeV9ycGMuUmVxdWVzdFNsaWRlckNhbGlicmF0ZUgAUhZyZXF1ZXN0U2xpZGVyQ2FsaWJy'
    'YXRlEkcKEXJlcXVlc3RfaHNwX3NldHVwGNwGIAEoCzIYLmhkeV9ycGMuUmVxdWVzdEhzcFNldH'
    'VwSABSD3JlcXVlc3RIc3BTZXR1cBJBCg9yZXF1ZXN0X2hzcF9hZGQY3QYgASgLMhYuaGR5X3Jw'
    'Yy5SZXF1ZXN0SHNwQWRkSABSDXJlcXVlc3RIc3BBZGQSRwoRcmVxdWVzdF9oc3BfZmx1c2gY3g'
    'YgASgLMhguaGR5X3JwYy5SZXF1ZXN0SHNwRmx1c2hIAFIPcmVxdWVzdEhzcEZsdXNoEkQKEHJl'
    'cXVlc3RfaHNwX3BsYXkY3wYgASgLMhcuaGR5X3JwYy5SZXF1ZXN0SHNwUGxheUgAUg5yZXF1ZX'
    'N0SHNwUGxheRJEChByZXF1ZXN0X2hzcF9zdG9wGOAGIAEoCzIXLmhkeV9ycGMuUmVxdWVzdEhz'
    'cFN0b3BIAFIOcmVxdWVzdEhzcFN0b3ASRwoRcmVxdWVzdF9oc3BfcGF1c2UY4QYgASgLMhguaG'
    'R5X3JwYy5SZXF1ZXN0SHNwUGF1c2VIAFIPcmVxdWVzdEhzcFBhdXNlEkoKEnJlcXVlc3RfaHNw'
    'X3Jlc3VtZRjiBiABKAsyGS5oZHlfcnBjLlJlcXVlc3RIc3BSZXN1bWVIAFIQcmVxdWVzdEhzcF'
    'Jlc3VtZRJRChVyZXF1ZXN0X2hzcF9zdGF0ZV9nZXQY4wYgASgLMhsuaGR5X3JwYy5SZXF1ZXN0'
    'SHNwU3RhdGVHZXRIAFIScmVxdWVzdEhzcFN0YXRlR2V0EmQKHHJlcXVlc3RfaHNwX2N1cnJlbn'
    'RfdGltZV9zZXQY5AYgASgLMiEuaGR5X3JwYy5SZXF1ZXN0SHNwQ3VycmVudFRpbWVTZXRIAFIY'
    'cmVxdWVzdEhzcEN1cnJlbnRUaW1lU2V0El0KGXJlcXVlc3RfaHNwX3RocmVzaG9sZF9zZXQY5Q'
    'YgASgLMh8uaGR5X3JwYy5SZXF1ZXN0SHNwVGhyZXNob2xkU2V0SABSFnJlcXVlc3RIc3BUaHJl'
    'c2hvbGRTZXQScQohcmVxdWVzdF9oc3BfcGF1c2Vfb25fc3RhcnZpbmdfc2V0GOYGIAEoCzIlLm'
    'hkeV9ycGMuUmVxdWVzdEhzcFBhdXNlT25TdGFydmluZ1NldEgAUhxyZXF1ZXN0SHNwUGF1c2VP'
    'blN0YXJ2aW5nU2V0EmcKHXJlcXVlc3RfaHNwX3BsYXliYWNrX3JhdGVfc2V0GOcGIAEoCzIiLm'
    'hkeV9ycGMuUmVxdWVzdEhzcFBsYXliYWNrUmF0ZVNldEgAUhlyZXF1ZXN0SHNwUGxheWJhY2tS'
    'YXRlU2V0Ek4KFHJlcXVlc3RfaHNwX2xvb3Bfc2V0GOgGIAEoCzIaLmhkeV9ycGMuUmVxdWVzdE'
    'hzcExvb3BTZXRIAFIRcmVxdWVzdEhzcExvb3BTZXQSUAoUcmVxdWVzdF9sZWRfb3ZlcnJpZGUY'
    '8AYgASgLMhsuaGR5X3JwYy5SZXF1ZXN0TGVkT3ZlcnJpZGVIAFIScmVxdWVzdExlZE92ZXJyaW'
    'RlEkEKD3JlcXVlc3RfaHZwX3NldBiEByABKAsyFi5oZHlfcnBjLlJlcXVlc3RIdnBTZXRIAFIN'
    'cmVxdWVzdEh2cFNldBJEChByZXF1ZXN0X2h2cF9zdG9wGIUHIAEoCzIXLmhkeV9ycGMuUmVxdW'
    'VzdEh2cFN0b3BIAFIOcmVxdWVzdEh2cFN0b3ASRwoRcmVxdWVzdF9odnBfc3RhcnQYhgcgASgL'
    'MhguaGR5X3JwYy5SZXF1ZXN0SHZwU3RhcnRIAFIPcmVxdWVzdEh2cFN0YXJ0ElEKFXJlcXVlc3'
    'RfaHZwX3N0YXRlX2dldBiHByABKAsyGy5oZHlfcnBjLlJlcXVlc3RIdnBTdGF0ZUdldEgAUhJy'
    'ZXF1ZXN0SHZwU3RhdGVHZXQSSgoScmVxdWVzdF9ocnBwX3N0YXJ0GJgHIAEoCzIZLmhkeV9ycG'
    'MuUmVxdWVzdEhycHBTdGFydEgAUhByZXF1ZXN0SHJwcFN0YXJ0EkcKEXJlcXVlc3RfaHJwcF9z'
    'dG9wGJkHIAEoCzIYLmhkeV9ycGMuUmVxdWVzdEhycHBTdG9wSABSD3JlcXVlc3RIcnBwU3RvcB'
    'JgChpyZXF1ZXN0X2hycHBfYW1wbGl0dWRlX3NldBiaByABKAsyIC5oZHlfcnBjLlJlcXVlc3RI'
    'cnBwQW1wbGl0dWRlU2V0SABSF3JlcXVlc3RIcnBwQW1wbGl0dWRlU2V0EloKGHJlcXVlc3RfaH'
    'JwcF9wYXR0ZXJuX3NldBicByABKAsyHi5oZHlfcnBjLlJlcXVlc3RIcnBwUGF0dGVyblNldEgA'
    'UhVyZXF1ZXN0SHJwcFBhdHRlcm5TZXQSVAoWcmVxdWVzdF9ocnBwX3N0YXRlX2dldBidByABKA'
    'syHC5oZHlfcnBjLlJlcXVlc3RIcnBwU3RhdGVHZXRIAFITcmVxdWVzdEhycHBTdGF0ZUdldBJd'
    'ChlyZXF1ZXN0X2hycHBfcGF0dGVybnNfZ2V0GJ4HIAEoCzIfLmhkeV9ycGMuUmVxdWVzdEhycH'
    'BQYXR0ZXJuc0dldEgAUhZyZXF1ZXN0SHJwcFBhdHRlcm5zR2V0EmoKHnJlcXVlc3RfaHJwcF9w'
    'bGF5YmFja19yYXRlX3NldBifByABKAsyIy5oZHlfcnBjLlJlcXVlc3RIcnBwUGxheWJhY2tSYX'
    'RlU2V0SABSGnJlcXVlc3RIcnBwUGxheWJhY2tSYXRlU2V0EkoKEnJlcXVlc3RfaHJwcF9wYXVz'
    'ZRigByABKAsyGS5oZHlfcnBjLlJlcXVlc3RIcnBwUGF1c2VIAFIQcmVxdWVzdEhycHBQYXVzZR'
    'IOCgJpZBgCIAEoDVICaWRCCAoGcGFyYW1z');

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
      '1': 'response_server_time_get',
      '3': 300,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseServerTimeGet',
      '9': 0,
      '10': 'responseServerTimeGet'
    },
    {
      '1': 'response_connected_get',
      '3': 301,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseConnectedGet',
      '9': 0,
      '10': 'responseConnectedGet'
    },
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
      '1': 'response_hsp_playback_rate_set',
      '3': 871,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHspPlaybackRateSet',
      '9': 0,
      '10': 'responseHspPlaybackRateSet'
    },
    {
      '1': 'response_hsp_loop_set',
      '3': 872,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHspLoopSet',
      '9': 0,
      '10': 'responseHspLoopSet'
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
      '1': 'response_hrpp_playback_rate_set',
      '3': 927,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHrppPlaybackRateSet',
      '9': 0,
      '10': 'responseHrppPlaybackRateSet'
    },
    {
      '1': 'response_hrpp_pause',
      '3': 928,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHrppPause',
      '9': 0,
      '10': 'responseHrppPause'
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
    'CghSZXNwb25zZRIOCgJpZBgBIAEoDVICaWQSWgoYcmVzcG9uc2Vfc2VydmVyX3RpbWVfZ2V0GK'
    'wCIAEoCzIeLmhkeV9ycGMuUmVzcG9uc2VTZXJ2ZXJUaW1lR2V0SABSFXJlc3BvbnNlU2VydmVy'
    'VGltZUdldBJWChZyZXNwb25zZV9jb25uZWN0ZWRfZ2V0GK0CIAEoCzIdLmhkeV9ycGMuUmVzcG'
    '9uc2VDb25uZWN0ZWRHZXRIAFIUcmVzcG9uc2VDb25uZWN0ZWRHZXQSYwobcmVzcG9uc2VfY29u'
    'bmVjdGlvbl9rZXlfZ2V0GN4EIAEoCzIhLmhkeV9ycGMuUmVzcG9uc2VDb25uZWN0aW9uS2V5R2'
    'V0SABSGHJlc3BvbnNlQ29ubmVjdGlvbktleUdldBJaChhyZXNwb25zZV93aWZpX3N0YXR1c19n'
    'ZXQY7AQgASgLMh4uaGR5X3JwYy5SZXNwb25zZVdpZmlTdGF0dXNHZXRIAFIVcmVzcG9uc2VXaW'
    'ZpU3RhdHVzR2V0EmoKHnJlc3BvbnNlX3dpZmlfc2Nhbl9yZXN1bHRzX2dldBjwBCABKAsyIy5o'
    'ZHlfcnBjLlJlc3BvbnNlV2lmaVNjYW5SZXN1bHRzR2V0SABSGnJlc3BvbnNlV2lmaVNjYW5SZX'
    'N1bHRzR2V0EkcKEXJlc3BvbnNlX21vZGVfZ2V0GLwFIAEoCzIYLmhkeV9ycGMuUmVzcG9uc2VN'
    'b2RlR2V0SABSD3Jlc3BvbnNlTW9kZUdldBJHChFyZXNwb25zZV9tb2RlX3NldBi9BSABKAsyGC'
    '5oZHlfcnBjLlJlc3BvbnNlTW9kZVNldEgAUg9yZXNwb25zZU1vZGVTZXQSXQoZcmVzcG9uc2Vf'
    'Y2xvY2tfb2Zmc2V0X3NldBjFBSABKAsyHy5oZHlfcnBjLlJlc3BvbnNlQ2xvY2tPZmZzZXRTZX'
    'RIAFIWcmVzcG9uc2VDbG9ja09mZnNldFNldBJQChRyZXNwb25zZV9iYXR0ZXJ5X2dldBjGBSAB'
    'KAsyGy5oZHlfcnBjLlJlc3BvbnNlQmF0dGVyeUdldEgAUhJyZXNwb25zZUJhdHRlcnlHZXQSXQ'
    'oZcmVzcG9uc2VfY2xvY2tfb2Zmc2V0X2dldBjIBSABKAsyHy5oZHlfcnBjLlJlc3BvbnNlQ2xv'
    'Y2tPZmZzZXRHZXRIAFIWcmVzcG9uc2VDbG9ja09mZnNldEdldBJfChlyZXNwb25zZV9jYXBhYm'
    'lsaXRpZXNfZ2V0GMkFIAEoCzIgLmhkeV9ycGMuUmVzcG9uc2VDYXBhYmlsaXRpZXNHZXRIAFIX'
    'cmVzcG9uc2VDYXBhYmlsaXRpZXNHZXQSWgoYcmVzcG9uc2Vfc2Vzc2lvbl9pZHNfZ2V0GMoFIA'
    'EoCzIeLmhkeV9ycGMuUmVzcG9uc2VTZXNzaW9uSWRzR2V0SABSFXJlc3BvbnNlU2Vzc2lvbklk'
    'c0dldBJmChxyZXNwb25zZV9jb25uZWN0aW9uX21vZGVfZ2V0GM0FIAEoCzIiLmhkeV9ycGMuUm'
    'VzcG9uc2VDb25uZWN0aW9uTW9kZUdldEgAUhlyZXNwb25zZUNvbm5lY3Rpb25Nb2RlR2V0Ek0K'
    'E3Jlc3BvbnNlX2hhbXBfc3RhcnQY0AUgASgLMhouaGR5X3JwYy5SZXNwb25zZUhhbXBTdGFydE'
    'gAUhFyZXNwb25zZUhhbXBTdGFydBJKChJyZXNwb25zZV9oYW1wX3N0b3AY0QUgASgLMhkuaGR5'
    'X3JwYy5SZXNwb25zZUhhbXBTdG9wSABSEHJlc3BvbnNlSGFtcFN0b3ASYAoacmVzcG9uc2VfaG'
    'FtcF92ZWxvY2l0eV9zZXQY0wUgASgLMiAuaGR5X3JwYy5SZXNwb25zZUhhbXBWZWxvY2l0eVNl'
    'dEgAUhdyZXNwb25zZUhhbXBWZWxvY2l0eVNldBJXChdyZXNwb25zZV9oYW1wX3N0YXRlX2dldB'
    'jUBSABKAsyHS5oZHlfcnBjLlJlc3BvbnNlSGFtcFN0YXRlR2V0SABSFHJlc3BvbnNlSGFtcFN0'
    'YXRlR2V0ElQKFnJlc3BvbnNlX2hhbXBfem9uZV9zZXQY1QUgASgLMhwuaGR5X3JwYy5SZXNwb2'
    '5zZUhhbXBab25lU2V0SABSE3Jlc3BvbnNlSGFtcFpvbmVTZXQSYAoacmVzcG9uc2Vfc2xpZGVy'
    'X3N0cm9rZV9nZXQYyAYgASgLMiAuaGR5X3JwYy5SZXNwb25zZVNsaWRlclN0cm9rZUdldEgAUh'
    'dyZXNwb25zZVNsaWRlclN0cm9rZUdldBJgChpyZXNwb25zZV9zbGlkZXJfc3Ryb2tlX3NldBjJ'
    'BiABKAsyIC5oZHlfcnBjLlJlc3BvbnNlU2xpZGVyU3Ryb2tlU2V0SABSF3Jlc3BvbnNlU2xpZG'
    'VyU3Ryb2tlU2V0El0KGXJlc3BvbnNlX3NsaWRlcl9zdGF0ZV9nZXQYygYgASgLMh8uaGR5X3Jw'
    'Yy5SZXNwb25zZVNsaWRlclN0YXRlR2V0SABSFnJlc3BvbnNlU2xpZGVyU3RhdGVHZXQSXwoZcm'
    'VzcG9uc2Vfc2xpZGVyX2NhbGlicmF0ZRjLBiABKAsyIC5oZHlfcnBjLlJlc3BvbnNlU2xpZGVy'
    'Q2FsaWJyYXRlSABSF3Jlc3BvbnNlU2xpZGVyQ2FsaWJyYXRlEkoKEnJlc3BvbnNlX2hzcF9zZX'
    'R1cBjcBiABKAsyGS5oZHlfcnBjLlJlc3BvbnNlSHNwU2V0dXBIAFIQcmVzcG9uc2VIc3BTZXR1'
    'cBJEChByZXNwb25zZV9oc3BfYWRkGN0GIAEoCzIXLmhkeV9ycGMuUmVzcG9uc2VIc3BBZGRIAF'
    'IOcmVzcG9uc2VIc3BBZGQSSgoScmVzcG9uc2VfaHNwX2ZsdXNoGN4GIAEoCzIZLmhkeV9ycGMu'
    'UmVzcG9uc2VIc3BGbHVzaEgAUhByZXNwb25zZUhzcEZsdXNoEkcKEXJlc3BvbnNlX2hzcF9wbG'
    'F5GN8GIAEoCzIYLmhkeV9ycGMuUmVzcG9uc2VIc3BQbGF5SABSD3Jlc3BvbnNlSHNwUGxheRJH'
    'ChFyZXNwb25zZV9oc3Bfc3RvcBjgBiABKAsyGC5oZHlfcnBjLlJlc3BvbnNlSHNwU3RvcEgAUg'
    '9yZXNwb25zZUhzcFN0b3ASSgoScmVzcG9uc2VfaHNwX3BhdXNlGOEGIAEoCzIZLmhkeV9ycGMu'
    'UmVzcG9uc2VIc3BQYXVzZUgAUhByZXNwb25zZUhzcFBhdXNlEk0KE3Jlc3BvbnNlX2hzcF9yZX'
    'N1bWUY4gYgASgLMhouaGR5X3JwYy5SZXNwb25zZUhzcFJlc3VtZUgAUhFyZXNwb25zZUhzcFJl'
    'c3VtZRJUChZyZXNwb25zZV9oc3Bfc3RhdGVfZ2V0GOMGIAEoCzIcLmhkeV9ycGMuUmVzcG9uc2'
    'VIc3BTdGF0ZUdldEgAUhNyZXNwb25zZUhzcFN0YXRlR2V0EmcKHXJlc3BvbnNlX2hzcF9jdXJy'
    'ZW50X3RpbWVfc2V0GOQGIAEoCzIiLmhkeV9ycGMuUmVzcG9uc2VIc3BDdXJyZW50VGltZVNldE'
    'gAUhlyZXNwb25zZUhzcEN1cnJlbnRUaW1lU2V0EmAKGnJlc3BvbnNlX2hzcF90aHJlc2hvbGRf'
    'c2V0GOUGIAEoCzIgLmhkeV9ycGMuUmVzcG9uc2VIc3BUaHJlc2hvbGRTZXRIAFIXcmVzcG9uc2'
    'VIc3BUaHJlc2hvbGRTZXQSdAoicmVzcG9uc2VfaHNwX3BhdXNlX29uX3N0YXJ2aW5nX3NldBjm'
    'BiABKAsyJi5oZHlfcnBjLlJlc3BvbnNlSHNwUGF1c2VPblN0YXJ2aW5nU2V0SABSHXJlc3Bvbn'
    'NlSHNwUGF1c2VPblN0YXJ2aW5nU2V0EmoKHnJlc3BvbnNlX2hzcF9wbGF5YmFja19yYXRlX3Nl'
    'dBjnBiABKAsyIy5oZHlfcnBjLlJlc3BvbnNlSHNwUGxheWJhY2tSYXRlU2V0SABSGnJlc3Bvbn'
    'NlSHNwUGxheWJhY2tSYXRlU2V0ElEKFXJlc3BvbnNlX2hzcF9sb29wX3NldBjoBiABKAsyGy5o'
    'ZHlfcnBjLlJlc3BvbnNlSHNwTG9vcFNldEgAUhJyZXNwb25zZUhzcExvb3BTZXQSRAoQcmVzcG'
    '9uc2VfaHZwX3NldBiEByABKAsyFy5oZHlfcnBjLlJlc3BvbnNlSHZwU2V0SABSDnJlc3BvbnNl'
    'SHZwU2V0EkcKEXJlc3BvbnNlX2h2cF9zdG9wGIUHIAEoCzIYLmhkeV9ycGMuUmVzcG9uc2VIdn'
    'BTdG9wSABSD3Jlc3BvbnNlSHZwU3RvcBJKChJyZXNwb25zZV9odnBfc3RhcnQYhgcgASgLMhku'
    'aGR5X3JwYy5SZXNwb25zZUh2cFN0YXJ0SABSEHJlc3BvbnNlSHZwU3RhcnQSVAoWcmVzcG9uc2'
    'VfaHZwX3N0YXRlX2dldBiHByABKAsyHC5oZHlfcnBjLlJlc3BvbnNlSHZwU3RhdGVHZXRIAFIT'
    'cmVzcG9uc2VIdnBTdGF0ZUdldBJNChNyZXNwb25zZV9ocnBwX3N0YXJ0GJgHIAEoCzIaLmhkeV'
    '9ycGMuUmVzcG9uc2VIcnBwU3RhcnRIAFIRcmVzcG9uc2VIcnBwU3RhcnQSSgoScmVzcG9uc2Vf'
    'aHJwcF9zdG9wGJkHIAEoCzIZLmhkeV9ycGMuUmVzcG9uc2VIcnBwU3RvcEgAUhByZXNwb25zZU'
    'hycHBTdG9wEmMKG3Jlc3BvbnNlX2hycHBfYW1wbGl0dWRlX3NldBiaByABKAsyIS5oZHlfcnBj'
    'LlJlc3BvbnNlSHJwcEFtcGxpdHVkZVNldEgAUhhyZXNwb25zZUhycHBBbXBsaXR1ZGVTZXQSXQ'
    'oZcmVzcG9uc2VfaHJwcF9wYXR0ZXJuX3NldBicByABKAsyHy5oZHlfcnBjLlJlc3BvbnNlSHJw'
    'cFBhdHRlcm5TZXRIAFIWcmVzcG9uc2VIcnBwUGF0dGVyblNldBJXChdyZXNwb25zZV9ocnBwX3'
    'N0YXRlX2dldBidByABKAsyHS5oZHlfcnBjLlJlc3BvbnNlSHJwcFN0YXRlR2V0SABSFHJlc3Bv'
    'bnNlSHJwcFN0YXRlR2V0EmAKGnJlc3BvbnNlX2hycHBfcGF0dGVybnNfZ2V0GJ4HIAEoCzIgLm'
    'hkeV9ycGMuUmVzcG9uc2VIcnBwUGF0dGVybnNHZXRIAFIXcmVzcG9uc2VIcnBwUGF0dGVybnNH'
    'ZXQSbQofcmVzcG9uc2VfaHJwcF9wbGF5YmFja19yYXRlX3NldBifByABKAsyJC5oZHlfcnBjLl'
    'Jlc3BvbnNlSHJwcFBsYXliYWNrUmF0ZVNldEgAUhtyZXNwb25zZUhycHBQbGF5YmFja1JhdGVT'
    'ZXQSTQoTcmVzcG9uc2VfaHJwcF9wYXVzZRigByABKAsyGi5oZHlfcnBjLlJlc3BvbnNlSHJwcF'
    'BhdXNlSABSEXJlc3BvbnNlSHJwcFBhdXNlEiQKBWVycm9yGAIgASgLMg4uaGR5X3JwYy5FcnJv'
    'clIFZXJyb3JCCAoGcmVzdWx0');

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
