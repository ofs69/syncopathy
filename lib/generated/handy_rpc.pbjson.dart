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
      '1': 'notification_sensor_update',
      '3': 800,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationSensorUpdate',
      '9': 0,
      '10': 'notificationSensorUpdate'
    },
    {
      '1': 'notification_slide_diag_data',
      '3': 844,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationSlideDiagData',
      '9': 0,
      '10': 'notificationSlideDiagData'
    },
    {
      '1': 'notification_speed_stats',
      '3': 851,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationSpeedStats',
      '9': 0,
      '10': 'notificationSpeedStats'
    },
    {
      '1': 'notification_slider_end_reached',
      '3': 857,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.NotificationSliderEndReached',
      '9': 0,
      '10': 'notificationSliderEndReached'
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
    'YW5nZWQSYgoabm90aWZpY2F0aW9uX3NlbnNvcl91cGRhdGUYoAYgASgLMiEuaGR5X3JwYy5Ob3'
    'RpZmljYXRpb25TZW5zb3JVcGRhdGVIAFIYbm90aWZpY2F0aW9uU2Vuc29yVXBkYXRlEmYKHG5v'
    'dGlmaWNhdGlvbl9zbGlkZV9kaWFnX2RhdGEYzAYgASgLMiIuaGR5X3JwYy5Ob3RpZmljYXRpb2'
    '5TbGlkZURpYWdEYXRhSABSGW5vdGlmaWNhdGlvblNsaWRlRGlhZ0RhdGESXAoYbm90aWZpY2F0'
    'aW9uX3NwZWVkX3N0YXRzGNMGIAEoCzIfLmhkeV9ycGMuTm90aWZpY2F0aW9uU3BlZWRTdGF0c0'
    'gAUhZub3RpZmljYXRpb25TcGVlZFN0YXRzEm8KH25vdGlmaWNhdGlvbl9zbGlkZXJfZW5kX3Jl'
    'YWNoZWQY2QYgASgLMiUuaGR5X3JwYy5Ob3RpZmljYXRpb25TbGlkZXJFbmRSZWFjaGVkSABSHG'
    '5vdGlmaWNhdGlvblNsaWRlckVuZFJlYWNoZWQSeAoibm90aWZpY2F0aW9uX2hzcF90aHJlc2hv'
    'bGRfcmVhY2hlZBjcBiABKAsyKC5oZHlfcnBjLk5vdGlmaWNhdGlvbkhzcFRocmVzaG9sZFJlYW'
    'NoZWRIAFIfbm90aWZpY2F0aW9uSHNwVGhyZXNob2xkUmVhY2hlZBJsCh5ub3RpZmljYXRpb25f'
    'aHNwX3N0YXRlX2NoYW5nZWQY3QYgASgLMiQuaGR5X3JwYy5Ob3RpZmljYXRpb25Ic3BTdGF0ZU'
    'NoYW5nZWRIAFIbbm90aWZpY2F0aW9uSHNwU3RhdGVDaGFuZ2VkElwKGG5vdGlmaWNhdGlvbl9o'
    'c3BfbG9vcGluZxjeBiABKAsyHy5oZHlfcnBjLk5vdGlmaWNhdGlvbkhzcExvb3BpbmdIAFIWbm'
    '90aWZpY2F0aW9uSHNwTG9vcGluZxJfChlub3RpZmljYXRpb25faHNwX3N0YXJ2aW5nGN8GIAEo'
    'CzIgLmhkeV9ycGMuTm90aWZpY2F0aW9uSHNwU3RhcnZpbmdIAFIXbm90aWZpY2F0aW9uSHNwU3'
    'RhcnZpbmcShgEKKG5vdGlmaWNhdGlvbl9oc3BfcmVzdW1lZF9vbl9ub25fc3RhcnZpbmcY4AYg'
    'ASgLMiwuaGR5X3JwYy5Ob3RpZmljYXRpb25Ic3BSZXN1bWVkT25Ob25TdGFydmluZ0gAUiNub3'
    'RpZmljYXRpb25Ic3BSZXN1bWVkT25Ob25TdGFydmluZxJ5CiNub3RpZmljYXRpb25faHNwX3Bh'
    'dXNlZF9vbl9zdGFydmluZxjhBiABKAsyKC5oZHlfcnBjLk5vdGlmaWNhdGlvbkhzcFBhdXNlZE'
    '9uU3RhcnZpbmdIAFIfbm90aWZpY2F0aW9uSHNwUGF1c2VkT25TdGFydmluZxJcChhub3RpZmlj'
    'YXRpb25faHZwX2NoYW5nZWQYhAcgASgLMh8uaGR5X3JwYy5Ob3RpZmljYXRpb25IdnBDaGFuZ2'
    'VkSABSFm5vdGlmaWNhdGlvbkh2cENoYW5nZWQSXwoZbm90aWZpY2F0aW9uX2hycHBfY2hhbmdl'
    'ZBiYByABKAsyIC5oZHlfcnBjLk5vdGlmaWNhdGlvbkhycHBDaGFuZ2VkSABSF25vdGlmaWNhdG'
    'lvbkhycHBDaGFuZ2VkElYKFm5vdGlmaWNhdGlvbl90ZW1wX2hpZ2gY6AcgASgLMh0uaGR5X3Jw'
    'Yy5Ob3RpZmljYXRpb25UZW1wSGlnaEgAUhRub3RpZmljYXRpb25UZW1wSGlnaBJQChRub3RpZm'
    'ljYXRpb25fdGVtcF9vaxjpByABKAsyGy5oZHlfcnBjLk5vdGlmaWNhdGlvblRlbXBPa0gAUhJu'
    'b3RpZmljYXRpb25UZW1wT2sSZQobbm90aWZpY2F0aW9uX3NsaWRlcl9ibG9ja2VkGOoHIAEoCz'
    'IiLmhkeV9ycGMuTm90aWZpY2F0aW9uU2xpZGVyQmxvY2tlZEgAUhlub3RpZmljYXRpb25TbGlk'
    'ZXJCbG9ja2VkEmsKHW5vdGlmaWNhdGlvbl9zbGlkZXJfdW5ibG9ja2VkGOsHIAEoCzIkLmhkeV'
    '9ycGMuTm90aWZpY2F0aW9uU2xpZGVyVW5ibG9ja2VkSABSG25vdGlmaWNhdGlvblNsaWRlclVu'
    'YmxvY2tlZBJpCh1ub3RpZmljYXRpb25fbG93X21lbW9yeV9lcnJvchjsByABKAsyIy5oZHlfcn'
    'BjLk5vdGlmaWNhdGlvbkxvd01lbW9yeUVycm9ySABSGm5vdGlmaWNhdGlvbkxvd01lbW9yeUVy'
    'cm9yEm8KH25vdGlmaWNhdGlvbl9sb3dfbWVtb3J5X3dhcm5pbmcY7QcgASgLMiUuaGR5X3JwYy'
    '5Ob3RpZmljYXRpb25Mb3dNZW1vcnlXYXJuaW5nSABSHG5vdGlmaWNhdGlvbkxvd01lbW9yeVdh'
    'cm5pbmcSawodbm90aWZpY2F0aW9uX3NldHRpbmdzX2NoYW5nZWQY0A8gASgLMiQuaGR5X3JwYy'
    '5Ob3RpZmljYXRpb25TZXR0aW5nc0NoYW5nZWRIAFIbbm90aWZpY2F0aW9uU2V0dGluZ3NDaGFu'
    'Z2VkEg4KAmlkGAIgASgNUgJpZEIOCgxub3RpZmljYXRpb24=');

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
      '1': 'request_fw_status_get',
      '3': 304,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestFwStatusGet',
      '9': 0,
      '10': 'requestFwStatusGet'
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
      '1': 'request_public_info_get',
      '3': 718,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestPublicInfoGet',
      '9': 0,
      '10': 'requestPublicInfoGet'
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
      '1': 'request_sensor_notification_set',
      '3': 800,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestSensorNotificationSet',
      '9': 0,
      '10': 'requestSensorNotificationSet'
    },
    {
      '1': 'request_sensor_state_get',
      '3': 801,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestSensorStateGet',
      '9': 0,
      '10': 'requestSensorStateGet'
    },
    {
      '1': 'request_sensor_notification_get',
      '3': 802,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestSensorNotificationGet',
      '9': 0,
      '10': 'requestSensorNotificationGet'
    },
    {
      '1': 'request_mems_status_get',
      '3': 810,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestMemsStatusGet',
      '9': 0,
      '10': 'requestMemsStatusGet'
    },
    {
      '1': 'request_mems_read',
      '3': 811,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestMemsRead',
      '9': 0,
      '10': 'requestMemsRead'
    },
    {
      '1': 'request_mems_tare',
      '3': 812,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestMemsTare',
      '9': 0,
      '10': 'requestMemsTare'
    },
    {
      '1': 'request_mems_temp_get',
      '3': 813,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestMemsTempGet',
      '9': 0,
      '10': 'requestMemsTempGet'
    },
    {
      '1': 'request_mems_reset',
      '3': 814,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestMemsReset',
      '9': 0,
      '10': 'requestMemsReset'
    },
    {
      '1': 'request_mems_register',
      '3': 815,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestMemsRegister',
      '9': 0,
      '10': 'requestMemsRegister'
    },
    {
      '1': 'request_mems_config_set',
      '3': 816,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestMemsConfigSet',
      '9': 0,
      '10': 'requestMemsConfigSet'
    },
    {
      '1': 'request_mems_test_start',
      '3': 817,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestMemsTestStart',
      '9': 0,
      '10': 'requestMemsTestStart'
    },
    {
      '1': 'request_mems_test_result_get',
      '3': 818,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestMemsTestResultGet',
      '9': 0,
      '10': 'requestMemsTestResultGet'
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
      '1': 'request_slide_diag_start',
      '3': 844,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestSlideDiagStart',
      '9': 0,
      '10': 'requestSlideDiagStart'
    },
    {
      '1': 'request_slide_diag_status',
      '3': 845,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestSlideDiagStatus',
      '9': 0,
      '10': 'requestSlideDiagStatus'
    },
    {
      '1': 'request_slide_diag_read',
      '3': 846,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestSlideDiagRead',
      '9': 0,
      '10': 'requestSlideDiagRead'
    },
    {
      '1': 'request_slide_diag_stop',
      '3': 847,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestSlideDiagStop',
      '9': 0,
      '10': 'requestSlideDiagStop'
    },
    {
      '1': 'request_hall_calibration_get',
      '3': 848,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHallCalibrationGet',
      '9': 0,
      '10': 'requestHallCalibrationGet'
    },
    {
      '1': 'request_slide_diag_stream',
      '3': 850,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestSlideDiagStream',
      '9': 0,
      '10': 'requestSlideDiagStream'
    },
    {
      '1': 'request_speed_stats_get',
      '3': 851,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestSpeedStatsGet',
      '9': 0,
      '10': 'requestSpeedStatsGet'
    },
    {
      '1': 'request_speed_stats_set',
      '3': 852,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestSpeedStatsSet',
      '9': 0,
      '10': 'requestSpeedStatsSet'
    },
    {
      '1': 'request_slide_snapshot_get',
      '3': 853,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestSlideSnapshotGet',
      '9': 0,
      '10': 'requestSlideSnapshotGet'
    },
    {
      '1': 'request_slide_profile_tuning_get',
      '3': 855,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestSlideProfileTuningGet',
      '9': 0,
      '10': 'requestSlideProfileTuningGet'
    },
    {
      '1': 'request_slide_maint_result_get',
      '3': 856,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestSlideMaintResultGet',
      '9': 0,
      '10': 'requestSlideMaintResultGet'
    },
    {
      '1': 'request_slider_end_move',
      '3': 857,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestSliderEndMove',
      '9': 0,
      '10': 'requestSliderEndMove'
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
      '1': 'request_hsp_jitter_filter_set',
      '3': 873,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHspJitterFilterSet',
      '9': 0,
      '10': 'requestHspJitterFilterSet'
    },
    {
      '1': 'request_hsp_script_speed_set',
      '3': 874,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestHspScriptSpeedSet',
      '9': 0,
      '10': 'requestHspScriptSpeedSet'
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
    {
      '1': 'request_settings_regulator_get',
      '3': 2015,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestSettingsRegulatorGet',
      '9': 0,
      '10': 'requestSettingsRegulatorGet'
    },
    {
      '1': 'request_settings_hall_get',
      '3': 2017,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestSettingsHallGet',
      '9': 0,
      '10': 'requestSettingsHallGet'
    },
    {
      '1': 'request_slide_profile_get',
      '3': 2019,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.RequestSlideProfileGet',
      '9': 0,
      '10': 'requestSlideProfileGet'
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
    'F1ZXN0Q29ubmVjdGVkR2V0ElEKFXJlcXVlc3RfZndfc3RhdHVzX2dldBiwAiABKAsyGy5oZHlf'
    'cnBjLlJlcXVlc3RGd1N0YXR1c0dldEgAUhJyZXF1ZXN0RndTdGF0dXNHZXQSYAoacmVxdWVzdF'
    '9jb25uZWN0aW9uX2tleV9nZXQY3gQgASgLMiAuaGR5X3JwYy5SZXF1ZXN0Q29ubmVjdGlvbktl'
    'eUdldEgAUhdyZXF1ZXN0Q29ubmVjdGlvbktleUdldBJXChdyZXF1ZXN0X3dpZmlfc3RhdHVzX2'
    'dldBjsBCABKAsyHS5oZHlfcnBjLlJlcXVlc3RXaWZpU3RhdHVzR2V0SABSFHJlcXVlc3RXaWZp'
    'U3RhdHVzR2V0EkQKEHJlcXVlc3Rfd2lmaV9zZXQY7QQgASgLMhcuaGR5X3JwYy5SZXF1ZXN0V2'
    'lmaVNldEgAUg5yZXF1ZXN0V2lmaVNldBJXChdyZXF1ZXN0X3dpZmlfc2Nhbl9zdGFydBjvBCAB'
    'KAsyHS5oZHlfcnBjLlJlcXVlc3RXaWZpU2NhblN0YXJ0SABSFHJlcXVlc3RXaWZpU2NhblN0YX'
    'J0EmcKHXJlcXVlc3Rfd2lmaV9zY2FuX3Jlc3VsdHNfZ2V0GPAEIAEoCzIiLmhkeV9ycGMuUmVx'
    'dWVzdFdpZmlTY2FuUmVzdWx0c0dldEgAUhlyZXF1ZXN0V2lmaVNjYW5SZXN1bHRzR2V0ElQKFn'
    'JlcXVlc3Rfd2lmaV9zY2FuX3N0b3AY8QQgASgLMhwuaGR5X3JwYy5SZXF1ZXN0V2lmaVNjYW5T'
    'dG9wSABSE3JlcXVlc3RXaWZpU2NhblN0b3ASRAoQcmVxdWVzdF9tb2RlX2dldBi8BSABKAsyFy'
    '5oZHlfcnBjLlJlcXVlc3RNb2RlR2V0SABSDnJlcXVlc3RNb2RlR2V0EkQKEHJlcXVlc3RfbW9k'
    'ZV9zZXQYvQUgASgLMhcuaGR5X3JwYy5SZXF1ZXN0TW9kZVNldEgAUg5yZXF1ZXN0TW9kZVNldB'
    'JACg5yZXF1ZXN0X3JlYm9vdBjDBSABKAsyFi5oZHlfcnBjLlJlcXVlc3RSZWJvb3RIAFINcmVx'
    'dWVzdFJlYm9vdBJQChRyZXF1ZXN0X2J1dHRvbl9wcmVzcxjEBSABKAsyGy5oZHlfcnBjLlJlcX'
    'Vlc3RCdXR0b25QcmVzc0gAUhJyZXF1ZXN0QnV0dG9uUHJlc3MSWgoYcmVxdWVzdF9jbG9ja19v'
    'ZmZzZXRfc2V0GMUFIAEoCzIeLmhkeV9ycGMuUmVxdWVzdENsb2NrT2Zmc2V0U2V0SABSFXJlcX'
    'Vlc3RDbG9ja09mZnNldFNldBJNChNyZXF1ZXN0X2JhdHRlcnlfZ2V0GMYFIAEoCzIaLmhkeV9y'
    'cGMuUmVxdWVzdEJhdHRlcnlHZXRIAFIRcmVxdWVzdEJhdHRlcnlHZXQSWgoYcmVxdWVzdF9jbG'
    '9ja19vZmZzZXRfZ2V0GMgFIAEoCzIeLmhkeV9ycGMuUmVxdWVzdENsb2NrT2Zmc2V0R2V0SABS'
    'FXJlcXVlc3RDbG9ja09mZnNldEdldBJcChhyZXF1ZXN0X2NhcGFiaWxpdGllc19nZXQYyQUgAS'
    'gLMh8uaGR5X3JwYy5SZXF1ZXN0Q2FwYWJpbGl0aWVzR2V0SABSFnJlcXVlc3RDYXBhYmlsaXRp'
    'ZXNHZXQSVwoXcmVxdWVzdF9zZXNzaW9uX2lkc19nZXQYygUgASgLMh0uaGR5X3JwYy5SZXF1ZX'
    'N0U2Vzc2lvbklkc0dldEgAUhRyZXF1ZXN0U2Vzc2lvbklkc0dldBJdChlyZXF1ZXN0X3N0b3Bf'
    'Y3VycmVudF9tb2RlGMsFIAEoCzIfLmhkeV9ycGMuUmVxdWVzdFN0b3BDdXJyZW50TW9kZUgAUh'
    'ZyZXF1ZXN0U3RvcEN1cnJlbnRNb2RlEmMKG3JlcXVlc3RfY29ubmVjdGlvbl9tb2RlX3NldBjM'
    'BSABKAsyIS5oZHlfcnBjLlJlcXVlc3RDb25uZWN0aW9uTW9kZVNldEgAUhhyZXF1ZXN0Q29ubm'
    'VjdGlvbk1vZGVTZXQSYwobcmVxdWVzdF9jb25uZWN0aW9uX21vZGVfZ2V0GM0FIAEoCzIhLmhk'
    'eV9ycGMuUmVxdWVzdENvbm5lY3Rpb25Nb2RlR2V0SABSGHJlcXVlc3RDb25uZWN0aW9uTW9kZU'
    'dldBJXChdyZXF1ZXN0X3B1YmxpY19pbmZvX2dldBjOBSABKAsyHS5oZHlfcnBjLlJlcXVlc3RQ'
    'dWJsaWNJbmZvR2V0SABSFHJlcXVlc3RQdWJsaWNJbmZvR2V0EkoKEnJlcXVlc3RfaGFtcF9zdG'
    'FydBjQBSABKAsyGS5oZHlfcnBjLlJlcXVlc3RIYW1wU3RhcnRIAFIQcmVxdWVzdEhhbXBTdGFy'
    'dBJHChFyZXF1ZXN0X2hhbXBfc3RvcBjRBSABKAsyGC5oZHlfcnBjLlJlcXVlc3RIYW1wU3RvcE'
    'gAUg9yZXF1ZXN0SGFtcFN0b3ASXQoZcmVxdWVzdF9oYW1wX3ZlbG9jaXR5X3NldBjTBSABKAsy'
    'Hy5oZHlfcnBjLlJlcXVlc3RIYW1wVmVsb2NpdHlTZXRIAFIWcmVxdWVzdEhhbXBWZWxvY2l0eV'
    'NldBJUChZyZXF1ZXN0X2hhbXBfc3RhdGVfZ2V0GNQFIAEoCzIcLmhkeV9ycGMuUmVxdWVzdEhh'
    'bXBTdGF0ZUdldEgAUhNyZXF1ZXN0SGFtcFN0YXRlR2V0ElEKFXJlcXVlc3RfaGFtcF96b25lX3'
    'NldBjVBSABKAsyGy5oZHlfcnBjLlJlcXVlc3RIYW1wWm9uZVNldEgAUhJyZXF1ZXN0SGFtcFpv'
    'bmVTZXQSUgoWcmVxdWVzdF9oZHNwX3hhX3ZhX3NldBjkBSABKAsyGy5oZHlfcnBjLlJlcXVlc3'
    'RIZHNwWGFWYVNldEgAUhJyZXF1ZXN0SGRzcFhhVmFTZXQSUgoWcmVxdWVzdF9oZHNwX3hwX3Zh'
    'X3NldBjlBSABKAsyGy5oZHlfcnBjLlJlcXVlc3RIZHNwWHBWYVNldEgAUhJyZXF1ZXN0SGRzcF'
    'hwVmFTZXQSUgoWcmVxdWVzdF9oZHNwX3hwX3ZwX3NldBjmBSABKAsyGy5oZHlfcnBjLlJlcXVl'
    'c3RIZHNwWHBWcFNldEgAUhJyZXF1ZXN0SGRzcFhwVnBTZXQSTwoVcmVxdWVzdF9oZHNwX3hhX3'
    'Rfc2V0GOcFIAEoCzIaLmhkeV9ycGMuUmVxdWVzdEhkc3BYYVRTZXRIAFIRcmVxdWVzdEhkc3BY'
    'YVRTZXQSTwoVcmVxdWVzdF9oZHNwX3hwX3Rfc2V0GOgFIAEoCzIaLmhkeV9ycGMuUmVxdWVzdE'
    'hkc3BYcFRTZXRIAFIRcmVxdWVzdEhkc3BYcFRTZXQSUgoWcmVxdWVzdF9oZHNwX3hhX3ZwX3Nl'
    'dBjpBSABKAsyGy5oZHlfcnBjLlJlcXVlc3RIZHNwWGFWcFNldEgAUhJyZXF1ZXN0SGRzcFhhVn'
    'BTZXQSRwoRcmVxdWVzdF9oZHNwX3N0b3AY6gUgASgLMhguaGR5X3JwYy5SZXF1ZXN0SGRzcFN0'
    'b3BIAFIPcmVxdWVzdEhkc3BTdG9wEm8KH3JlcXVlc3Rfc2Vuc29yX25vdGlmaWNhdGlvbl9zZX'
    'QYoAYgASgLMiUuaGR5X3JwYy5SZXF1ZXN0U2Vuc29yTm90aWZpY2F0aW9uU2V0SABSHHJlcXVl'
    'c3RTZW5zb3JOb3RpZmljYXRpb25TZXQSWgoYcmVxdWVzdF9zZW5zb3Jfc3RhdGVfZ2V0GKEGIA'
    'EoCzIeLmhkeV9ycGMuUmVxdWVzdFNlbnNvclN0YXRlR2V0SABSFXJlcXVlc3RTZW5zb3JTdGF0'
    'ZUdldBJvCh9yZXF1ZXN0X3NlbnNvcl9ub3RpZmljYXRpb25fZ2V0GKIGIAEoCzIlLmhkeV9ycG'
    'MuUmVxdWVzdFNlbnNvck5vdGlmaWNhdGlvbkdldEgAUhxyZXF1ZXN0U2Vuc29yTm90aWZpY2F0'
    'aW9uR2V0ElcKF3JlcXVlc3RfbWVtc19zdGF0dXNfZ2V0GKoGIAEoCzIdLmhkeV9ycGMuUmVxdW'
    'VzdE1lbXNTdGF0dXNHZXRIAFIUcmVxdWVzdE1lbXNTdGF0dXNHZXQSRwoRcmVxdWVzdF9tZW1z'
    'X3JlYWQYqwYgASgLMhguaGR5X3JwYy5SZXF1ZXN0TWVtc1JlYWRIAFIPcmVxdWVzdE1lbXNSZW'
    'FkEkcKEXJlcXVlc3RfbWVtc190YXJlGKwGIAEoCzIYLmhkeV9ycGMuUmVxdWVzdE1lbXNUYXJl'
    'SABSD3JlcXVlc3RNZW1zVGFyZRJRChVyZXF1ZXN0X21lbXNfdGVtcF9nZXQYrQYgASgLMhsuaG'
    'R5X3JwYy5SZXF1ZXN0TWVtc1RlbXBHZXRIAFIScmVxdWVzdE1lbXNUZW1wR2V0EkoKEnJlcXVl'
    'c3RfbWVtc19yZXNldBiuBiABKAsyGS5oZHlfcnBjLlJlcXVlc3RNZW1zUmVzZXRIAFIQcmVxdW'
    'VzdE1lbXNSZXNldBJTChVyZXF1ZXN0X21lbXNfcmVnaXN0ZXIYrwYgASgLMhwuaGR5X3JwYy5S'
    'ZXF1ZXN0TWVtc1JlZ2lzdGVySABSE3JlcXVlc3RNZW1zUmVnaXN0ZXISVwoXcmVxdWVzdF9tZW'
    '1zX2NvbmZpZ19zZXQYsAYgASgLMh0uaGR5X3JwYy5SZXF1ZXN0TWVtc0NvbmZpZ1NldEgAUhRy'
    'ZXF1ZXN0TWVtc0NvbmZpZ1NldBJXChdyZXF1ZXN0X21lbXNfdGVzdF9zdGFydBixBiABKAsyHS'
    '5oZHlfcnBjLlJlcXVlc3RNZW1zVGVzdFN0YXJ0SABSFHJlcXVlc3RNZW1zVGVzdFN0YXJ0EmQK'
    'HHJlcXVlc3RfbWVtc190ZXN0X3Jlc3VsdF9nZXQYsgYgASgLMiEuaGR5X3JwYy5SZXF1ZXN0TW'
    'Vtc1Rlc3RSZXN1bHRHZXRIAFIYcmVxdWVzdE1lbXNUZXN0UmVzdWx0R2V0El0KGXJlcXVlc3Rf'
    'c2xpZGVyX3N0cm9rZV9nZXQYyAYgASgLMh8uaGR5X3JwYy5SZXF1ZXN0U2xpZGVyU3Ryb2tlR2'
    'V0SABSFnJlcXVlc3RTbGlkZXJTdHJva2VHZXQSXQoZcmVxdWVzdF9zbGlkZXJfc3Ryb2tlX3Nl'
    'dBjJBiABKAsyHy5oZHlfcnBjLlJlcXVlc3RTbGlkZXJTdHJva2VTZXRIAFIWcmVxdWVzdFNsaW'
    'RlclN0cm9rZVNldBJaChhyZXF1ZXN0X3NsaWRlcl9zdGF0ZV9nZXQYygYgASgLMh4uaGR5X3Jw'
    'Yy5SZXF1ZXN0U2xpZGVyU3RhdGVHZXRIAFIVcmVxdWVzdFNsaWRlclN0YXRlR2V0ElwKGHJlcX'
    'Vlc3Rfc2xpZGVyX2NhbGlicmF0ZRjLBiABKAsyHy5oZHlfcnBjLlJlcXVlc3RTbGlkZXJDYWxp'
    'YnJhdGVIAFIWcmVxdWVzdFNsaWRlckNhbGlicmF0ZRJaChhyZXF1ZXN0X3NsaWRlX2RpYWdfc3'
    'RhcnQYzAYgASgLMh4uaGR5X3JwYy5SZXF1ZXN0U2xpZGVEaWFnU3RhcnRIAFIVcmVxdWVzdFNs'
    'aWRlRGlhZ1N0YXJ0El0KGXJlcXVlc3Rfc2xpZGVfZGlhZ19zdGF0dXMYzQYgASgLMh8uaGR5X3'
    'JwYy5SZXF1ZXN0U2xpZGVEaWFnU3RhdHVzSABSFnJlcXVlc3RTbGlkZURpYWdTdGF0dXMSVwoX'
    'cmVxdWVzdF9zbGlkZV9kaWFnX3JlYWQYzgYgASgLMh0uaGR5X3JwYy5SZXF1ZXN0U2xpZGVEaW'
    'FnUmVhZEgAUhRyZXF1ZXN0U2xpZGVEaWFnUmVhZBJXChdyZXF1ZXN0X3NsaWRlX2RpYWdfc3Rv'
    'cBjPBiABKAsyHS5oZHlfcnBjLlJlcXVlc3RTbGlkZURpYWdTdG9wSABSFHJlcXVlc3RTbGlkZU'
    'RpYWdTdG9wEmYKHHJlcXVlc3RfaGFsbF9jYWxpYnJhdGlvbl9nZXQY0AYgASgLMiIuaGR5X3Jw'
    'Yy5SZXF1ZXN0SGFsbENhbGlicmF0aW9uR2V0SABSGXJlcXVlc3RIYWxsQ2FsaWJyYXRpb25HZX'
    'QSXQoZcmVxdWVzdF9zbGlkZV9kaWFnX3N0cmVhbRjSBiABKAsyHy5oZHlfcnBjLlJlcXVlc3RT'
    'bGlkZURpYWdTdHJlYW1IAFIWcmVxdWVzdFNsaWRlRGlhZ1N0cmVhbRJXChdyZXF1ZXN0X3NwZW'
    'VkX3N0YXRzX2dldBjTBiABKAsyHS5oZHlfcnBjLlJlcXVlc3RTcGVlZFN0YXRzR2V0SABSFHJl'
    'cXVlc3RTcGVlZFN0YXRzR2V0ElcKF3JlcXVlc3Rfc3BlZWRfc3RhdHNfc2V0GNQGIAEoCzIdLm'
    'hkeV9ycGMuUmVxdWVzdFNwZWVkU3RhdHNTZXRIAFIUcmVxdWVzdFNwZWVkU3RhdHNTZXQSYAoa'
    'cmVxdWVzdF9zbGlkZV9zbmFwc2hvdF9nZXQY1QYgASgLMiAuaGR5X3JwYy5SZXF1ZXN0U2xpZG'
    'VTbmFwc2hvdEdldEgAUhdyZXF1ZXN0U2xpZGVTbmFwc2hvdEdldBJwCiByZXF1ZXN0X3NsaWRl'
    'X3Byb2ZpbGVfdHVuaW5nX2dldBjXBiABKAsyJS5oZHlfcnBjLlJlcXVlc3RTbGlkZVByb2ZpbG'
    'VUdW5pbmdHZXRIAFIccmVxdWVzdFNsaWRlUHJvZmlsZVR1bmluZ0dldBJqCh5yZXF1ZXN0X3Ns'
    'aWRlX21haW50X3Jlc3VsdF9nZXQY2AYgASgLMiMuaGR5X3JwYy5SZXF1ZXN0U2xpZGVNYWludF'
    'Jlc3VsdEdldEgAUhpyZXF1ZXN0U2xpZGVNYWludFJlc3VsdEdldBJXChdyZXF1ZXN0X3NsaWRl'
    'cl9lbmRfbW92ZRjZBiABKAsyHS5oZHlfcnBjLlJlcXVlc3RTbGlkZXJFbmRNb3ZlSABSFHJlcX'
    'Vlc3RTbGlkZXJFbmRNb3ZlEkcKEXJlcXVlc3RfaHNwX3NldHVwGNwGIAEoCzIYLmhkeV9ycGMu'
    'UmVxdWVzdEhzcFNldHVwSABSD3JlcXVlc3RIc3BTZXR1cBJBCg9yZXF1ZXN0X2hzcF9hZGQY3Q'
    'YgASgLMhYuaGR5X3JwYy5SZXF1ZXN0SHNwQWRkSABSDXJlcXVlc3RIc3BBZGQSRwoRcmVxdWVz'
    'dF9oc3BfZmx1c2gY3gYgASgLMhguaGR5X3JwYy5SZXF1ZXN0SHNwRmx1c2hIAFIPcmVxdWVzdE'
    'hzcEZsdXNoEkQKEHJlcXVlc3RfaHNwX3BsYXkY3wYgASgLMhcuaGR5X3JwYy5SZXF1ZXN0SHNw'
    'UGxheUgAUg5yZXF1ZXN0SHNwUGxheRJEChByZXF1ZXN0X2hzcF9zdG9wGOAGIAEoCzIXLmhkeV'
    '9ycGMuUmVxdWVzdEhzcFN0b3BIAFIOcmVxdWVzdEhzcFN0b3ASRwoRcmVxdWVzdF9oc3BfcGF1'
    'c2UY4QYgASgLMhguaGR5X3JwYy5SZXF1ZXN0SHNwUGF1c2VIAFIPcmVxdWVzdEhzcFBhdXNlEk'
    'oKEnJlcXVlc3RfaHNwX3Jlc3VtZRjiBiABKAsyGS5oZHlfcnBjLlJlcXVlc3RIc3BSZXN1bWVI'
    'AFIQcmVxdWVzdEhzcFJlc3VtZRJRChVyZXF1ZXN0X2hzcF9zdGF0ZV9nZXQY4wYgASgLMhsuaG'
    'R5X3JwYy5SZXF1ZXN0SHNwU3RhdGVHZXRIAFIScmVxdWVzdEhzcFN0YXRlR2V0EmQKHHJlcXVl'
    'c3RfaHNwX2N1cnJlbnRfdGltZV9zZXQY5AYgASgLMiEuaGR5X3JwYy5SZXF1ZXN0SHNwQ3Vycm'
    'VudFRpbWVTZXRIAFIYcmVxdWVzdEhzcEN1cnJlbnRUaW1lU2V0El0KGXJlcXVlc3RfaHNwX3Ro'
    'cmVzaG9sZF9zZXQY5QYgASgLMh8uaGR5X3JwYy5SZXF1ZXN0SHNwVGhyZXNob2xkU2V0SABSFn'
    'JlcXVlc3RIc3BUaHJlc2hvbGRTZXQScQohcmVxdWVzdF9oc3BfcGF1c2Vfb25fc3RhcnZpbmdf'
    'c2V0GOYGIAEoCzIlLmhkeV9ycGMuUmVxdWVzdEhzcFBhdXNlT25TdGFydmluZ1NldEgAUhxyZX'
    'F1ZXN0SHNwUGF1c2VPblN0YXJ2aW5nU2V0EmcKHXJlcXVlc3RfaHNwX3BsYXliYWNrX3JhdGVf'
    'c2V0GOcGIAEoCzIiLmhkeV9ycGMuUmVxdWVzdEhzcFBsYXliYWNrUmF0ZVNldEgAUhlyZXF1ZX'
    'N0SHNwUGxheWJhY2tSYXRlU2V0Ek4KFHJlcXVlc3RfaHNwX2xvb3Bfc2V0GOgGIAEoCzIaLmhk'
    'eV9ycGMuUmVxdWVzdEhzcExvb3BTZXRIAFIRcmVxdWVzdEhzcExvb3BTZXQSZwodcmVxdWVzdF'
    '9oc3Bfaml0dGVyX2ZpbHRlcl9zZXQY6QYgASgLMiIuaGR5X3JwYy5SZXF1ZXN0SHNwSml0dGVy'
    'RmlsdGVyU2V0SABSGXJlcXVlc3RIc3BKaXR0ZXJGaWx0ZXJTZXQSZAoccmVxdWVzdF9oc3Bfc2'
    'NyaXB0X3NwZWVkX3NldBjqBiABKAsyIS5oZHlfcnBjLlJlcXVlc3RIc3BTY3JpcHRTcGVlZFNl'
    'dEgAUhhyZXF1ZXN0SHNwU2NyaXB0U3BlZWRTZXQSUAoUcmVxdWVzdF9sZWRfb3ZlcnJpZGUY8A'
    'YgASgLMhsuaGR5X3JwYy5SZXF1ZXN0TGVkT3ZlcnJpZGVIAFIScmVxdWVzdExlZE92ZXJyaWRl'
    'EkEKD3JlcXVlc3RfaHZwX3NldBiEByABKAsyFi5oZHlfcnBjLlJlcXVlc3RIdnBTZXRIAFINcm'
    'VxdWVzdEh2cFNldBJEChByZXF1ZXN0X2h2cF9zdG9wGIUHIAEoCzIXLmhkeV9ycGMuUmVxdWVz'
    'dEh2cFN0b3BIAFIOcmVxdWVzdEh2cFN0b3ASRwoRcmVxdWVzdF9odnBfc3RhcnQYhgcgASgLMh'
    'guaGR5X3JwYy5SZXF1ZXN0SHZwU3RhcnRIAFIPcmVxdWVzdEh2cFN0YXJ0ElEKFXJlcXVlc3Rf'
    'aHZwX3N0YXRlX2dldBiHByABKAsyGy5oZHlfcnBjLlJlcXVlc3RIdnBTdGF0ZUdldEgAUhJyZX'
    'F1ZXN0SHZwU3RhdGVHZXQSSgoScmVxdWVzdF9ocnBwX3N0YXJ0GJgHIAEoCzIZLmhkeV9ycGMu'
    'UmVxdWVzdEhycHBTdGFydEgAUhByZXF1ZXN0SHJwcFN0YXJ0EkcKEXJlcXVlc3RfaHJwcF9zdG'
    '9wGJkHIAEoCzIYLmhkeV9ycGMuUmVxdWVzdEhycHBTdG9wSABSD3JlcXVlc3RIcnBwU3RvcBJg'
    'ChpyZXF1ZXN0X2hycHBfYW1wbGl0dWRlX3NldBiaByABKAsyIC5oZHlfcnBjLlJlcXVlc3RIcn'
    'BwQW1wbGl0dWRlU2V0SABSF3JlcXVlc3RIcnBwQW1wbGl0dWRlU2V0EloKGHJlcXVlc3RfaHJw'
    'cF9wYXR0ZXJuX3NldBicByABKAsyHi5oZHlfcnBjLlJlcXVlc3RIcnBwUGF0dGVyblNldEgAUh'
    'VyZXF1ZXN0SHJwcFBhdHRlcm5TZXQSVAoWcmVxdWVzdF9ocnBwX3N0YXRlX2dldBidByABKAsy'
    'HC5oZHlfcnBjLlJlcXVlc3RIcnBwU3RhdGVHZXRIAFITcmVxdWVzdEhycHBTdGF0ZUdldBJdCh'
    'lyZXF1ZXN0X2hycHBfcGF0dGVybnNfZ2V0GJ4HIAEoCzIfLmhkeV9ycGMuUmVxdWVzdEhycHBQ'
    'YXR0ZXJuc0dldEgAUhZyZXF1ZXN0SHJwcFBhdHRlcm5zR2V0EmoKHnJlcXVlc3RfaHJwcF9wbG'
    'F5YmFja19yYXRlX3NldBifByABKAsyIy5oZHlfcnBjLlJlcXVlc3RIcnBwUGxheWJhY2tSYXRl'
    'U2V0SABSGnJlcXVlc3RIcnBwUGxheWJhY2tSYXRlU2V0EkoKEnJlcXVlc3RfaHJwcF9wYXVzZR'
    'igByABKAsyGS5oZHlfcnBjLlJlcXVlc3RIcnBwUGF1c2VIAFIQcmVxdWVzdEhycHBQYXVzZRJs'
    'Ch5yZXF1ZXN0X3NldHRpbmdzX3JlZ3VsYXRvcl9nZXQY3w8gASgLMiQuaGR5X3JwYy5SZXF1ZX'
    'N0U2V0dGluZ3NSZWd1bGF0b3JHZXRIAFIbcmVxdWVzdFNldHRpbmdzUmVndWxhdG9yR2V0El0K'
    'GXJlcXVlc3Rfc2V0dGluZ3NfaGFsbF9nZXQY4Q8gASgLMh8uaGR5X3JwYy5SZXF1ZXN0U2V0dG'
    'luZ3NIYWxsR2V0SABSFnJlcXVlc3RTZXR0aW5nc0hhbGxHZXQSXQoZcmVxdWVzdF9zbGlkZV9w'
    'cm9maWxlX2dldBjjDyABKAsyHy5oZHlfcnBjLlJlcXVlc3RTbGlkZVByb2ZpbGVHZXRIAFIWcm'
    'VxdWVzdFNsaWRlUHJvZmlsZUdldBIOCgJpZBgCIAEoDVICaWRCCAoGcGFyYW1z');

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
      '1': 'response_fw_status_get',
      '3': 304,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseFwStatusGet',
      '9': 0,
      '10': 'responseFwStatusGet'
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
      '1': 'response_public_info_get',
      '3': 718,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponsePublicInfoGet',
      '9': 0,
      '10': 'responsePublicInfoGet'
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
      '1': 'response_sensor_notification_set',
      '3': 800,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseSensorNotificationSet',
      '9': 0,
      '10': 'responseSensorNotificationSet'
    },
    {
      '1': 'response_sensor_state_get',
      '3': 801,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseSensorStateGet',
      '9': 0,
      '10': 'responseSensorStateGet'
    },
    {
      '1': 'response_sensor_notification_get',
      '3': 802,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseSensorNotificationGet',
      '9': 0,
      '10': 'responseSensorNotificationGet'
    },
    {
      '1': 'response_mems_status_get',
      '3': 810,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseMemsStatusGet',
      '9': 0,
      '10': 'responseMemsStatusGet'
    },
    {
      '1': 'response_mems_read',
      '3': 811,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseMemsRead',
      '9': 0,
      '10': 'responseMemsRead'
    },
    {
      '1': 'response_mems_tare',
      '3': 812,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseMemsTare',
      '9': 0,
      '10': 'responseMemsTare'
    },
    {
      '1': 'response_mems_temp_get',
      '3': 813,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseMemsTempGet',
      '9': 0,
      '10': 'responseMemsTempGet'
    },
    {
      '1': 'response_mems_reset',
      '3': 814,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseMemsReset',
      '9': 0,
      '10': 'responseMemsReset'
    },
    {
      '1': 'response_mems_register',
      '3': 815,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseMemsRegister',
      '9': 0,
      '10': 'responseMemsRegister'
    },
    {
      '1': 'response_mems_config_set',
      '3': 816,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseMemsConfigSet',
      '9': 0,
      '10': 'responseMemsConfigSet'
    },
    {
      '1': 'response_mems_test_start',
      '3': 817,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseMemsTestStart',
      '9': 0,
      '10': 'responseMemsTestStart'
    },
    {
      '1': 'response_mems_test_result_get',
      '3': 818,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseMemsTestResultGet',
      '9': 0,
      '10': 'responseMemsTestResultGet'
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
      '1': 'response_slide_diag_start',
      '3': 844,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseSlideDiagStart',
      '9': 0,
      '10': 'responseSlideDiagStart'
    },
    {
      '1': 'response_slide_diag_status',
      '3': 845,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseSlideDiagStatus',
      '9': 0,
      '10': 'responseSlideDiagStatus'
    },
    {
      '1': 'response_slide_diag_read',
      '3': 846,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseSlideDiagRead',
      '9': 0,
      '10': 'responseSlideDiagRead'
    },
    {
      '1': 'response_hall_calibration_get',
      '3': 848,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHallCalibrationGet',
      '9': 0,
      '10': 'responseHallCalibrationGet'
    },
    {
      '1': 'response_slide_diag_stream',
      '3': 850,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseSlideDiagStream',
      '9': 0,
      '10': 'responseSlideDiagStream'
    },
    {
      '1': 'response_speed_stats_get',
      '3': 851,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseSpeedStatsGet',
      '9': 0,
      '10': 'responseSpeedStatsGet'
    },
    {
      '1': 'response_speed_stats_set',
      '3': 852,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseSpeedStatsSet',
      '9': 0,
      '10': 'responseSpeedStatsSet'
    },
    {
      '1': 'response_slide_snapshot_get',
      '3': 853,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseSlideSnapshotGet',
      '9': 0,
      '10': 'responseSlideSnapshotGet'
    },
    {
      '1': 'response_slide_profile_tuning_get',
      '3': 855,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseSlideProfileTuningGet',
      '9': 0,
      '10': 'responseSlideProfileTuningGet'
    },
    {
      '1': 'response_slide_maint_result_get',
      '3': 856,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseSlideMaintResultGet',
      '9': 0,
      '10': 'responseSlideMaintResultGet'
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
      '1': 'response_hsp_jitter_filter_set',
      '3': 873,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHspJitterFilterSet',
      '9': 0,
      '10': 'responseHspJitterFilterSet'
    },
    {
      '1': 'response_hsp_script_speed_set',
      '3': 874,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseHspScriptSpeedSet',
      '9': 0,
      '10': 'responseHspScriptSpeedSet'
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
      '1': 'response_settings_regulator_get',
      '3': 2015,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseSettingsRegulatorGet',
      '9': 0,
      '10': 'responseSettingsRegulatorGet'
    },
    {
      '1': 'response_settings_hall_get',
      '3': 2017,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseSettingsHallGet',
      '9': 0,
      '10': 'responseSettingsHallGet'
    },
    {
      '1': 'response_slide_profile_get',
      '3': 2019,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.ResponseSlideProfileGet',
      '9': 0,
      '10': 'responseSlideProfileGet'
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
    '9uc2VDb25uZWN0ZWRHZXRIAFIUcmVzcG9uc2VDb25uZWN0ZWRHZXQSVAoWcmVzcG9uc2VfZndf'
    'c3RhdHVzX2dldBiwAiABKAsyHC5oZHlfcnBjLlJlc3BvbnNlRndTdGF0dXNHZXRIAFITcmVzcG'
    '9uc2VGd1N0YXR1c0dldBJjChtyZXNwb25zZV9jb25uZWN0aW9uX2tleV9nZXQY3gQgASgLMiEu'
    'aGR5X3JwYy5SZXNwb25zZUNvbm5lY3Rpb25LZXlHZXRIAFIYcmVzcG9uc2VDb25uZWN0aW9uS2'
    'V5R2V0EloKGHJlc3BvbnNlX3dpZmlfc3RhdHVzX2dldBjsBCABKAsyHi5oZHlfcnBjLlJlc3Bv'
    'bnNlV2lmaVN0YXR1c0dldEgAUhVyZXNwb25zZVdpZmlTdGF0dXNHZXQSagoecmVzcG9uc2Vfd2'
    'lmaV9zY2FuX3Jlc3VsdHNfZ2V0GPAEIAEoCzIjLmhkeV9ycGMuUmVzcG9uc2VXaWZpU2NhblJl'
    'c3VsdHNHZXRIAFIacmVzcG9uc2VXaWZpU2NhblJlc3VsdHNHZXQSRwoRcmVzcG9uc2VfbW9kZV'
    '9nZXQYvAUgASgLMhguaGR5X3JwYy5SZXNwb25zZU1vZGVHZXRIAFIPcmVzcG9uc2VNb2RlR2V0'
    'EkcKEXJlc3BvbnNlX21vZGVfc2V0GL0FIAEoCzIYLmhkeV9ycGMuUmVzcG9uc2VNb2RlU2V0SA'
    'BSD3Jlc3BvbnNlTW9kZVNldBJdChlyZXNwb25zZV9jbG9ja19vZmZzZXRfc2V0GMUFIAEoCzIf'
    'LmhkeV9ycGMuUmVzcG9uc2VDbG9ja09mZnNldFNldEgAUhZyZXNwb25zZUNsb2NrT2Zmc2V0U2'
    'V0ElAKFHJlc3BvbnNlX2JhdHRlcnlfZ2V0GMYFIAEoCzIbLmhkeV9ycGMuUmVzcG9uc2VCYXR0'
    'ZXJ5R2V0SABSEnJlc3BvbnNlQmF0dGVyeUdldBJdChlyZXNwb25zZV9jbG9ja19vZmZzZXRfZ2'
    'V0GMgFIAEoCzIfLmhkeV9ycGMuUmVzcG9uc2VDbG9ja09mZnNldEdldEgAUhZyZXNwb25zZUNs'
    'b2NrT2Zmc2V0R2V0El8KGXJlc3BvbnNlX2NhcGFiaWxpdGllc19nZXQYyQUgASgLMiAuaGR5X3'
    'JwYy5SZXNwb25zZUNhcGFiaWxpdGllc0dldEgAUhdyZXNwb25zZUNhcGFiaWxpdGllc0dldBJa'
    'ChhyZXNwb25zZV9zZXNzaW9uX2lkc19nZXQYygUgASgLMh4uaGR5X3JwYy5SZXNwb25zZVNlc3'
    'Npb25JZHNHZXRIAFIVcmVzcG9uc2VTZXNzaW9uSWRzR2V0EmYKHHJlc3BvbnNlX2Nvbm5lY3Rp'
    'b25fbW9kZV9nZXQYzQUgASgLMiIuaGR5X3JwYy5SZXNwb25zZUNvbm5lY3Rpb25Nb2RlR2V0SA'
    'BSGXJlc3BvbnNlQ29ubmVjdGlvbk1vZGVHZXQSWgoYcmVzcG9uc2VfcHVibGljX2luZm9fZ2V0'
    'GM4FIAEoCzIeLmhkeV9ycGMuUmVzcG9uc2VQdWJsaWNJbmZvR2V0SABSFXJlc3BvbnNlUHVibG'
    'ljSW5mb0dldBJNChNyZXNwb25zZV9oYW1wX3N0YXJ0GNAFIAEoCzIaLmhkeV9ycGMuUmVzcG9u'
    'c2VIYW1wU3RhcnRIAFIRcmVzcG9uc2VIYW1wU3RhcnQSSgoScmVzcG9uc2VfaGFtcF9zdG9wGN'
    'EFIAEoCzIZLmhkeV9ycGMuUmVzcG9uc2VIYW1wU3RvcEgAUhByZXNwb25zZUhhbXBTdG9wEmAK'
    'GnJlc3BvbnNlX2hhbXBfdmVsb2NpdHlfc2V0GNMFIAEoCzIgLmhkeV9ycGMuUmVzcG9uc2VIYW'
    '1wVmVsb2NpdHlTZXRIAFIXcmVzcG9uc2VIYW1wVmVsb2NpdHlTZXQSVwoXcmVzcG9uc2VfaGFt'
    'cF9zdGF0ZV9nZXQY1AUgASgLMh0uaGR5X3JwYy5SZXNwb25zZUhhbXBTdGF0ZUdldEgAUhRyZX'
    'Nwb25zZUhhbXBTdGF0ZUdldBJUChZyZXNwb25zZV9oYW1wX3pvbmVfc2V0GNUFIAEoCzIcLmhk'
    'eV9ycGMuUmVzcG9uc2VIYW1wWm9uZVNldEgAUhNyZXNwb25zZUhhbXBab25lU2V0EnIKIHJlc3'
    'BvbnNlX3NlbnNvcl9ub3RpZmljYXRpb25fc2V0GKAGIAEoCzImLmhkeV9ycGMuUmVzcG9uc2VT'
    'ZW5zb3JOb3RpZmljYXRpb25TZXRIAFIdcmVzcG9uc2VTZW5zb3JOb3RpZmljYXRpb25TZXQSXQ'
    'oZcmVzcG9uc2Vfc2Vuc29yX3N0YXRlX2dldBihBiABKAsyHy5oZHlfcnBjLlJlc3BvbnNlU2Vu'
    'c29yU3RhdGVHZXRIAFIWcmVzcG9uc2VTZW5zb3JTdGF0ZUdldBJyCiByZXNwb25zZV9zZW5zb3'
    'Jfbm90aWZpY2F0aW9uX2dldBiiBiABKAsyJi5oZHlfcnBjLlJlc3BvbnNlU2Vuc29yTm90aWZp'
    'Y2F0aW9uR2V0SABSHXJlc3BvbnNlU2Vuc29yTm90aWZpY2F0aW9uR2V0EloKGHJlc3BvbnNlX2'
    '1lbXNfc3RhdHVzX2dldBiqBiABKAsyHi5oZHlfcnBjLlJlc3BvbnNlTWVtc1N0YXR1c0dldEgA'
    'UhVyZXNwb25zZU1lbXNTdGF0dXNHZXQSSgoScmVzcG9uc2VfbWVtc19yZWFkGKsGIAEoCzIZLm'
    'hkeV9ycGMuUmVzcG9uc2VNZW1zUmVhZEgAUhByZXNwb25zZU1lbXNSZWFkEkoKEnJlc3BvbnNl'
    'X21lbXNfdGFyZRisBiABKAsyGS5oZHlfcnBjLlJlc3BvbnNlTWVtc1RhcmVIAFIQcmVzcG9uc2'
    'VNZW1zVGFyZRJUChZyZXNwb25zZV9tZW1zX3RlbXBfZ2V0GK0GIAEoCzIcLmhkeV9ycGMuUmVz'
    'cG9uc2VNZW1zVGVtcEdldEgAUhNyZXNwb25zZU1lbXNUZW1wR2V0Ek0KE3Jlc3BvbnNlX21lbX'
    'NfcmVzZXQYrgYgASgLMhouaGR5X3JwYy5SZXNwb25zZU1lbXNSZXNldEgAUhFyZXNwb25zZU1l'
    'bXNSZXNldBJWChZyZXNwb25zZV9tZW1zX3JlZ2lzdGVyGK8GIAEoCzIdLmhkeV9ycGMuUmVzcG'
    '9uc2VNZW1zUmVnaXN0ZXJIAFIUcmVzcG9uc2VNZW1zUmVnaXN0ZXISWgoYcmVzcG9uc2VfbWVt'
    'c19jb25maWdfc2V0GLAGIAEoCzIeLmhkeV9ycGMuUmVzcG9uc2VNZW1zQ29uZmlnU2V0SABSFX'
    'Jlc3BvbnNlTWVtc0NvbmZpZ1NldBJaChhyZXNwb25zZV9tZW1zX3Rlc3Rfc3RhcnQYsQYgASgL'
    'Mh4uaGR5X3JwYy5SZXNwb25zZU1lbXNUZXN0U3RhcnRIAFIVcmVzcG9uc2VNZW1zVGVzdFN0YX'
    'J0EmcKHXJlc3BvbnNlX21lbXNfdGVzdF9yZXN1bHRfZ2V0GLIGIAEoCzIiLmhkeV9ycGMuUmVz'
    'cG9uc2VNZW1zVGVzdFJlc3VsdEdldEgAUhlyZXNwb25zZU1lbXNUZXN0UmVzdWx0R2V0EmAKGn'
    'Jlc3BvbnNlX3NsaWRlcl9zdHJva2VfZ2V0GMgGIAEoCzIgLmhkeV9ycGMuUmVzcG9uc2VTbGlk'
    'ZXJTdHJva2VHZXRIAFIXcmVzcG9uc2VTbGlkZXJTdHJva2VHZXQSYAoacmVzcG9uc2Vfc2xpZG'
    'VyX3N0cm9rZV9zZXQYyQYgASgLMiAuaGR5X3JwYy5SZXNwb25zZVNsaWRlclN0cm9rZVNldEgA'
    'UhdyZXNwb25zZVNsaWRlclN0cm9rZVNldBJdChlyZXNwb25zZV9zbGlkZXJfc3RhdGVfZ2V0GM'
    'oGIAEoCzIfLmhkeV9ycGMuUmVzcG9uc2VTbGlkZXJTdGF0ZUdldEgAUhZyZXNwb25zZVNsaWRl'
    'clN0YXRlR2V0El8KGXJlc3BvbnNlX3NsaWRlcl9jYWxpYnJhdGUYywYgASgLMiAuaGR5X3JwYy'
    '5SZXNwb25zZVNsaWRlckNhbGlicmF0ZUgAUhdyZXNwb25zZVNsaWRlckNhbGlicmF0ZRJdChly'
    'ZXNwb25zZV9zbGlkZV9kaWFnX3N0YXJ0GMwGIAEoCzIfLmhkeV9ycGMuUmVzcG9uc2VTbGlkZU'
    'RpYWdTdGFydEgAUhZyZXNwb25zZVNsaWRlRGlhZ1N0YXJ0EmAKGnJlc3BvbnNlX3NsaWRlX2Rp'
    'YWdfc3RhdHVzGM0GIAEoCzIgLmhkeV9ycGMuUmVzcG9uc2VTbGlkZURpYWdTdGF0dXNIAFIXcm'
    'VzcG9uc2VTbGlkZURpYWdTdGF0dXMSWgoYcmVzcG9uc2Vfc2xpZGVfZGlhZ19yZWFkGM4GIAEo'
    'CzIeLmhkeV9ycGMuUmVzcG9uc2VTbGlkZURpYWdSZWFkSABSFXJlc3BvbnNlU2xpZGVEaWFnUm'
    'VhZBJpCh1yZXNwb25zZV9oYWxsX2NhbGlicmF0aW9uX2dldBjQBiABKAsyIy5oZHlfcnBjLlJl'
    'c3BvbnNlSGFsbENhbGlicmF0aW9uR2V0SABSGnJlc3BvbnNlSGFsbENhbGlicmF0aW9uR2V0Em'
    'AKGnJlc3BvbnNlX3NsaWRlX2RpYWdfc3RyZWFtGNIGIAEoCzIgLmhkeV9ycGMuUmVzcG9uc2VT'
    'bGlkZURpYWdTdHJlYW1IAFIXcmVzcG9uc2VTbGlkZURpYWdTdHJlYW0SWgoYcmVzcG9uc2Vfc3'
    'BlZWRfc3RhdHNfZ2V0GNMGIAEoCzIeLmhkeV9ycGMuUmVzcG9uc2VTcGVlZFN0YXRzR2V0SABS'
    'FXJlc3BvbnNlU3BlZWRTdGF0c0dldBJaChhyZXNwb25zZV9zcGVlZF9zdGF0c19zZXQY1AYgAS'
    'gLMh4uaGR5X3JwYy5SZXNwb25zZVNwZWVkU3RhdHNTZXRIAFIVcmVzcG9uc2VTcGVlZFN0YXRz'
    'U2V0EmMKG3Jlc3BvbnNlX3NsaWRlX3NuYXBzaG90X2dldBjVBiABKAsyIS5oZHlfcnBjLlJlc3'
    'BvbnNlU2xpZGVTbmFwc2hvdEdldEgAUhhyZXNwb25zZVNsaWRlU25hcHNob3RHZXQScwohcmVz'
    'cG9uc2Vfc2xpZGVfcHJvZmlsZV90dW5pbmdfZ2V0GNcGIAEoCzImLmhkeV9ycGMuUmVzcG9uc2'
    'VTbGlkZVByb2ZpbGVUdW5pbmdHZXRIAFIdcmVzcG9uc2VTbGlkZVByb2ZpbGVUdW5pbmdHZXQS'
    'bQofcmVzcG9uc2Vfc2xpZGVfbWFpbnRfcmVzdWx0X2dldBjYBiABKAsyJC5oZHlfcnBjLlJlc3'
    'BvbnNlU2xpZGVNYWludFJlc3VsdEdldEgAUhtyZXNwb25zZVNsaWRlTWFpbnRSZXN1bHRHZXQS'
    'SgoScmVzcG9uc2VfaHNwX3NldHVwGNwGIAEoCzIZLmhkeV9ycGMuUmVzcG9uc2VIc3BTZXR1cE'
    'gAUhByZXNwb25zZUhzcFNldHVwEkQKEHJlc3BvbnNlX2hzcF9hZGQY3QYgASgLMhcuaGR5X3Jw'
    'Yy5SZXNwb25zZUhzcEFkZEgAUg5yZXNwb25zZUhzcEFkZBJKChJyZXNwb25zZV9oc3BfZmx1c2'
    'gY3gYgASgLMhkuaGR5X3JwYy5SZXNwb25zZUhzcEZsdXNoSABSEHJlc3BvbnNlSHNwRmx1c2gS'
    'RwoRcmVzcG9uc2VfaHNwX3BsYXkY3wYgASgLMhguaGR5X3JwYy5SZXNwb25zZUhzcFBsYXlIAF'
    'IPcmVzcG9uc2VIc3BQbGF5EkcKEXJlc3BvbnNlX2hzcF9zdG9wGOAGIAEoCzIYLmhkeV9ycGMu'
    'UmVzcG9uc2VIc3BTdG9wSABSD3Jlc3BvbnNlSHNwU3RvcBJKChJyZXNwb25zZV9oc3BfcGF1c2'
    'UY4QYgASgLMhkuaGR5X3JwYy5SZXNwb25zZUhzcFBhdXNlSABSEHJlc3BvbnNlSHNwUGF1c2US'
    'TQoTcmVzcG9uc2VfaHNwX3Jlc3VtZRjiBiABKAsyGi5oZHlfcnBjLlJlc3BvbnNlSHNwUmVzdW'
    '1lSABSEXJlc3BvbnNlSHNwUmVzdW1lElQKFnJlc3BvbnNlX2hzcF9zdGF0ZV9nZXQY4wYgASgL'
    'MhwuaGR5X3JwYy5SZXNwb25zZUhzcFN0YXRlR2V0SABSE3Jlc3BvbnNlSHNwU3RhdGVHZXQSZw'
    'odcmVzcG9uc2VfaHNwX2N1cnJlbnRfdGltZV9zZXQY5AYgASgLMiIuaGR5X3JwYy5SZXNwb25z'
    'ZUhzcEN1cnJlbnRUaW1lU2V0SABSGXJlc3BvbnNlSHNwQ3VycmVudFRpbWVTZXQSYAoacmVzcG'
    '9uc2VfaHNwX3RocmVzaG9sZF9zZXQY5QYgASgLMiAuaGR5X3JwYy5SZXNwb25zZUhzcFRocmVz'
    'aG9sZFNldEgAUhdyZXNwb25zZUhzcFRocmVzaG9sZFNldBJ0CiJyZXNwb25zZV9oc3BfcGF1c2'
    'Vfb25fc3RhcnZpbmdfc2V0GOYGIAEoCzImLmhkeV9ycGMuUmVzcG9uc2VIc3BQYXVzZU9uU3Rh'
    'cnZpbmdTZXRIAFIdcmVzcG9uc2VIc3BQYXVzZU9uU3RhcnZpbmdTZXQSagoecmVzcG9uc2VfaH'
    'NwX3BsYXliYWNrX3JhdGVfc2V0GOcGIAEoCzIjLmhkeV9ycGMuUmVzcG9uc2VIc3BQbGF5YmFj'
    'a1JhdGVTZXRIAFIacmVzcG9uc2VIc3BQbGF5YmFja1JhdGVTZXQSUQoVcmVzcG9uc2VfaHNwX2'
    'xvb3Bfc2V0GOgGIAEoCzIbLmhkeV9ycGMuUmVzcG9uc2VIc3BMb29wU2V0SABSEnJlc3BvbnNl'
    'SHNwTG9vcFNldBJqCh5yZXNwb25zZV9oc3Bfaml0dGVyX2ZpbHRlcl9zZXQY6QYgASgLMiMuaG'
    'R5X3JwYy5SZXNwb25zZUhzcEppdHRlckZpbHRlclNldEgAUhpyZXNwb25zZUhzcEppdHRlckZp'
    'bHRlclNldBJnCh1yZXNwb25zZV9oc3Bfc2NyaXB0X3NwZWVkX3NldBjqBiABKAsyIi5oZHlfcn'
    'BjLlJlc3BvbnNlSHNwU2NyaXB0U3BlZWRTZXRIAFIZcmVzcG9uc2VIc3BTY3JpcHRTcGVlZFNl'
    'dBJEChByZXNwb25zZV9odnBfc2V0GIQHIAEoCzIXLmhkeV9ycGMuUmVzcG9uc2VIdnBTZXRIAF'
    'IOcmVzcG9uc2VIdnBTZXQSRwoRcmVzcG9uc2VfaHZwX3N0b3AYhQcgASgLMhguaGR5X3JwYy5S'
    'ZXNwb25zZUh2cFN0b3BIAFIPcmVzcG9uc2VIdnBTdG9wEkoKEnJlc3BvbnNlX2h2cF9zdGFydB'
    'iGByABKAsyGS5oZHlfcnBjLlJlc3BvbnNlSHZwU3RhcnRIAFIQcmVzcG9uc2VIdnBTdGFydBJU'
    'ChZyZXNwb25zZV9odnBfc3RhdGVfZ2V0GIcHIAEoCzIcLmhkeV9ycGMuUmVzcG9uc2VIdnBTdG'
    'F0ZUdldEgAUhNyZXNwb25zZUh2cFN0YXRlR2V0Ek0KE3Jlc3BvbnNlX2hycHBfc3RhcnQYmAcg'
    'ASgLMhouaGR5X3JwYy5SZXNwb25zZUhycHBTdGFydEgAUhFyZXNwb25zZUhycHBTdGFydBJKCh'
    'JyZXNwb25zZV9ocnBwX3N0b3AYmQcgASgLMhkuaGR5X3JwYy5SZXNwb25zZUhycHBTdG9wSABS'
    'EHJlc3BvbnNlSHJwcFN0b3ASYwobcmVzcG9uc2VfaHJwcF9hbXBsaXR1ZGVfc2V0GJoHIAEoCz'
    'IhLmhkeV9ycGMuUmVzcG9uc2VIcnBwQW1wbGl0dWRlU2V0SABSGHJlc3BvbnNlSHJwcEFtcGxp'
    'dHVkZVNldBJdChlyZXNwb25zZV9ocnBwX3BhdHRlcm5fc2V0GJwHIAEoCzIfLmhkeV9ycGMuUm'
    'VzcG9uc2VIcnBwUGF0dGVyblNldEgAUhZyZXNwb25zZUhycHBQYXR0ZXJuU2V0ElcKF3Jlc3Bv'
    'bnNlX2hycHBfc3RhdGVfZ2V0GJ0HIAEoCzIdLmhkeV9ycGMuUmVzcG9uc2VIcnBwU3RhdGVHZX'
    'RIAFIUcmVzcG9uc2VIcnBwU3RhdGVHZXQSYAoacmVzcG9uc2VfaHJwcF9wYXR0ZXJuc19nZXQY'
    'ngcgASgLMiAuaGR5X3JwYy5SZXNwb25zZUhycHBQYXR0ZXJuc0dldEgAUhdyZXNwb25zZUhycH'
    'BQYXR0ZXJuc0dldBJtCh9yZXNwb25zZV9ocnBwX3BsYXliYWNrX3JhdGVfc2V0GJ8HIAEoCzIk'
    'LmhkeV9ycGMuUmVzcG9uc2VIcnBwUGxheWJhY2tSYXRlU2V0SABSG3Jlc3BvbnNlSHJwcFBsYX'
    'liYWNrUmF0ZVNldBJNChNyZXNwb25zZV9ocnBwX3BhdXNlGKAHIAEoCzIaLmhkeV9ycGMuUmVz'
    'cG9uc2VIcnBwUGF1c2VIAFIRcmVzcG9uc2VIcnBwUGF1c2USbwofcmVzcG9uc2Vfc2V0dGluZ3'
    'NfcmVndWxhdG9yX2dldBjfDyABKAsyJS5oZHlfcnBjLlJlc3BvbnNlU2V0dGluZ3NSZWd1bGF0'
    'b3JHZXRIAFIccmVzcG9uc2VTZXR0aW5nc1JlZ3VsYXRvckdldBJgChpyZXNwb25zZV9zZXR0aW'
    '5nc19oYWxsX2dldBjhDyABKAsyIC5oZHlfcnBjLlJlc3BvbnNlU2V0dGluZ3NIYWxsR2V0SABS'
    'F3Jlc3BvbnNlU2V0dGluZ3NIYWxsR2V0EmAKGnJlc3BvbnNlX3NsaWRlX3Byb2ZpbGVfZ2V0GO'
    'MPIAEoCzIgLmhkeV9ycGMuUmVzcG9uc2VTbGlkZVByb2ZpbGVHZXRIAFIXcmVzcG9uc2VTbGlk'
    'ZVByb2ZpbGVHZXQSJAoFZXJyb3IYAiABKAsyDi5oZHlfcnBjLkVycm9yUgVlcnJvckIICgZyZX'
    'N1bHQ=');

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
