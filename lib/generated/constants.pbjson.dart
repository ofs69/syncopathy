// This is a generated file - do not edit.
//
// Generated from constants.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use handyErrorCodesDescriptor instead')
const HandyErrorCodes$json = {
  '1': 'HandyErrorCodes',
  '2': [
    {'1': 'HANDY_ERROR_CODE_PROTO2_LEGACY_COMP_DO_NOT_USE', '2': 0},
    {'1': 'ERROR_UNKNOWN_REQUEST_TYPE', '2': 100000},
    {'1': 'ERROR_UNKNOWN_RESPONSE_TYPE', '2': 100001},
    {'1': 'ERROR_UNKNOWN_COMMAND', '2': 100002},
    {'1': 'ERROR_NOT_IMPLEMENTED', '2': 100003},
    {'1': 'ERROR_WRONG_MODE', '2': 100004},
    {'1': 'ERROR_TEMP_HIGH', '2': 100005},
    {'1': 'ERROR_SLIDER_BLOCKED', '2': 100006},
    {'1': 'ERROR_UNKNOWN_MODE_ERROR', '2': 100007},
    {'1': 'ERROR_TIME_NOT_SYNCED', '2': 100008},
    {'1': 'ERROR_NEGATIVE_NETWORK_DELAY', '2': 100009},
    {'1': 'ERROR_MESSAGE_SIZE_TOO_BIG', '2': 100010},
    {'1': 'ERROR_MESSAGE_NOT_CONNECTED', '2': 100011},
    {'1': 'ERROR_MESSAGE_GENERIC_SERVER_ERROR', '2': 100012},
    {'1': 'ERROR_MESSAGE_QUEUE_FULL', '2': 100014},
    {'1': 'ERROR_OTA_STARTED', '2': 100013},
    {'1': 'ERROR_OTA_QUEUE_WRITE_FAILURE', '2': 100015},
    {'1': 'ERROR_OTA_ERROR', '2': 100016},
    {'1': 'ERROR_OTA_MEM_ERROR', '2': 100024},
    {'1': 'ERROR_OTA_NOT_STARTED', '2': 100025},
    {'1': 'ERROR_FUNCTION_NOT_SUPPORTED', '2': 100017},
    {'1': 'ERROR_RPC_MSG_POOL_FULL', '2': 100019},
    {'1': 'ERROR_RPC_FAILED_TO_UNPACK', '2': 100020},
    {'1': 'ERROR_RPC_NOT_ALLOWED_WITH_THIS_TRANSPORT_MODE', '2': 100021},
    {'1': 'ERROR_RPC_NETWORK_DELAY_TOO_BIG', '2': 100022},
    {'1': 'ERROR_RPC_NOT_INITIALIZED', '2': 100029},
    {'1': 'ERROR_RPC_HANDLER_QUEUE_FULL', '2': 100030},
    {'1': 'ERROR_RPC_SEND_TIMEOUT', '2': 100031},
    {'1': 'ERROR_FAIL', '2': 100023},
    {'1': 'ERROR_HALL_SENSOR_ERROR', '2': 100026},
    {'1': 'ERROR_OVERCLOCKING_NOT_SUPPORTED', '2': 100027},
    {'1': 'ERROR_OVERCLOCKING_IS_NOT_ENABLED', '2': 100028},
    {'1': 'ERROR_MODE_CHANGE_NOT_ALLOWED_WHEN_DISABLED', '2': 100032},
    {'1': 'ERROR_OTA_ERR_NO_OTA_PARTITION', '2': 200001},
    {'1': 'ERROR_OTA_ERR_INVALID_BIN', '2': 20000},
    {'1': 'ERROR_OTA_ERR_INVALID_PARAM', '2': 200003},
    {'1': 'ERROR_OTA_ERR_NEW_OTA_HAS_PREVIOUSLY_FAILED', '2': 200004},
    {'1': 'ERROR_OTA_ERR_NEW_OTA_SAME_AS_CURRENT', '2': 200005},
  ],
};

/// Descriptor for `HandyErrorCodes`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List handyErrorCodesDescriptor = $convert.base64Decode(
    'Cg9IYW5keUVycm9yQ29kZXMSMgouSEFORFlfRVJST1JfQ09ERV9QUk9UTzJfTEVHQUNZX0NPTV'
    'BfRE9fTk9UX1VTRRAAEiAKGkVSUk9SX1VOS05PV05fUkVRVUVTVF9UWVBFEKCNBhIhChtFUlJP'
    'Ul9VTktOT1dOX1JFU1BPTlNFX1RZUEUQoY0GEhsKFUVSUk9SX1VOS05PV05fQ09NTUFORBCijQ'
    'YSGwoVRVJST1JfTk9UX0lNUExFTUVOVEVEEKONBhIWChBFUlJPUl9XUk9OR19NT0RFEKSNBhIV'
    'Cg9FUlJPUl9URU1QX0hJR0gQpY0GEhoKFEVSUk9SX1NMSURFUl9CTE9DS0VEEKaNBhIeChhFUl'
    'JPUl9VTktOT1dOX01PREVfRVJST1IQp40GEhsKFUVSUk9SX1RJTUVfTk9UX1NZTkNFRBCojQYS'
    'IgocRVJST1JfTkVHQVRJVkVfTkVUV09SS19ERUxBWRCpjQYSIAoaRVJST1JfTUVTU0FHRV9TSV'
    'pFX1RPT19CSUcQqo0GEiEKG0VSUk9SX01FU1NBR0VfTk9UX0NPTk5FQ1RFRBCrjQYSKAoiRVJS'
    'T1JfTUVTU0FHRV9HRU5FUklDX1NFUlZFUl9FUlJPUhCsjQYSHgoYRVJST1JfTUVTU0FHRV9RVU'
    'VVRV9GVUxMEK6NBhIXChFFUlJPUl9PVEFfU1RBUlRFRBCtjQYSIwodRVJST1JfT1RBX1FVRVVF'
    'X1dSSVRFX0ZBSUxVUkUQr40GEhUKD0VSUk9SX09UQV9FUlJPUhCwjQYSGQoTRVJST1JfT1RBX0'
    '1FTV9FUlJPUhC4jQYSGwoVRVJST1JfT1RBX05PVF9TVEFSVEVEELmNBhIiChxFUlJPUl9GVU5D'
    'VElPTl9OT1RfU1VQUE9SVEVEELGNBhIdChdFUlJPUl9SUENfTVNHX1BPT0xfRlVMTBCzjQYSIA'
    'oaRVJST1JfUlBDX0ZBSUxFRF9UT19VTlBBQ0sQtI0GEjQKLkVSUk9SX1JQQ19OT1RfQUxMT1dF'
    'RF9XSVRIX1RISVNfVFJBTlNQT1JUX01PREUQtY0GEiUKH0VSUk9SX1JQQ19ORVRXT1JLX0RFTE'
    'FZX1RPT19CSUcQto0GEh8KGUVSUk9SX1JQQ19OT1RfSU5JVElBTElaRUQQvY0GEiIKHEVSUk9S'
    'X1JQQ19IQU5ETEVSX1FVRVVFX0ZVTEwQvo0GEhwKFkVSUk9SX1JQQ19TRU5EX1RJTUVPVVQQv4'
    '0GEhAKCkVSUk9SX0ZBSUwQt40GEh0KF0VSUk9SX0hBTExfU0VOU09SX0VSUk9SELqNBhImCiBF'
    'UlJPUl9PVkVSQ0xPQ0tJTkdfTk9UX1NVUFBPUlRFRBC7jQYSJwohRVJST1JfT1ZFUkNMT0NLSU'
    '5HX0lTX05PVF9FTkFCTEVEELyNBhIxCitFUlJPUl9NT0RFX0NIQU5HRV9OT1RfQUxMT1dFRF9X'
    'SEVOX0RJU0FCTEVEEMCNBhIkCh5FUlJPUl9PVEFfRVJSX05PX09UQV9QQVJUSVRJT04QwZoMEh'
    '8KGUVSUk9SX09UQV9FUlJfSU5WQUxJRF9CSU4QoJwBEiEKG0VSUk9SX09UQV9FUlJfSU5WQUxJ'
    'RF9QQVJBTRDDmgwSMQorRVJST1JfT1RBX0VSUl9ORVdfT1RBX0hBU19QUkVWSU9VU0xZX0ZBSU'
    'xFRBDEmgwSKwolRVJST1JfT1RBX0VSUl9ORVdfT1RBX1NBTUVfQVNfQ1VSUkVOVBDFmgw=');

@$core.Deprecated('Use modeDescriptor instead')
const Mode$json = {
  '1': 'Mode',
  '2': [
    {'1': 'MODE_HAMP', '2': 0},
    {'1': 'MODE_HSSP', '2': 1},
    {'1': 'MODE_HDSP', '2': 2},
    {'1': 'MODE_MAINTENANCE', '2': 3},
    {'1': 'MODE_HSP', '2': 4},
    {'1': 'MODE_OTA', '2': 5},
    {'1': 'MODE_BUTTON', '2': 6},
    {'1': 'MODE_IDLE', '2': 7},
    {'1': 'MODE_HVP', '2': 8},
    {'1': 'MODE_HRPP', '2': 9},
    {'1': 'MODE_DISABLED', '2': 10},
  ],
};

/// Descriptor for `Mode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List modeDescriptor = $convert.base64Decode(
    'CgRNb2RlEg0KCU1PREVfSEFNUBAAEg0KCU1PREVfSFNTUBABEg0KCU1PREVfSERTUBACEhQKEE'
    '1PREVfTUFJTlRFTkFOQ0UQAxIMCghNT0RFX0hTUBAEEgwKCE1PREVfT1RBEAUSDwoLTU9ERV9C'
    'VVRUT04QBhINCglNT0RFX0lETEUQBxIMCghNT0RFX0hWUBAIEg0KCU1PREVfSFJQUBAJEhEKDU'
    '1PREVfRElTQUJMRUQQCg==');

@$core.Deprecated('Use hampPlayStateDescriptor instead')
const HampPlayState$json = {
  '1': 'HampPlayState',
  '2': [
    {'1': 'HAMP_STATE_STOPPED', '2': 0},
    {'1': 'HAMP_STATE_RUNNING', '2': 1},
  ],
};

/// Descriptor for `HampPlayState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List hampPlayStateDescriptor = $convert.base64Decode(
    'Cg1IYW1wUGxheVN0YXRlEhYKEkhBTVBfU1RBVEVfU1RPUFBFRBAAEhYKEkhBTVBfU1RBVEVfUl'
    'VOTklORxAB');

@$core.Deprecated('Use hrppPatternTypeDescriptor instead')
const HrppPatternType$json = {
  '1': 'HrppPatternType',
  '2': [
    {'1': 'HRPP_NOT_SET', '2': 0},
    {'1': 'HRPP_SCRIPT', '2': 1},
    {'1': 'HRPP_WAVE', '2': 2},
  ],
};

/// Descriptor for `HrppPatternType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List hrppPatternTypeDescriptor = $convert.base64Decode(
    'Cg9IcnBwUGF0dGVyblR5cGUSEAoMSFJQUF9OT1RfU0VUEAASDwoLSFJQUF9TQ1JJUFQQARINCg'
    'lIUlBQX1dBVkUQAg==');

@$core.Deprecated('Use hdspPlayStateDescriptor instead')
const HdspPlayState$json = {
  '1': 'HdspPlayState',
  '2': [
    {'1': 'HDSP_STATE_STOPPED', '2': 0},
    {'1': 'HDSP_STATE_MOVING', '2': 1},
    {'1': 'HDSP_STATE_REACHED', '2': 2},
  ],
};

/// Descriptor for `HdspPlayState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List hdspPlayStateDescriptor = $convert.base64Decode(
    'Cg1IZHNwUGxheVN0YXRlEhYKEkhEU1BfU1RBVEVfU1RPUFBFRBAAEhUKEUhEU1BfU1RBVEVfTU'
    '9WSU5HEAESFgoSSERTUF9TVEFURV9SRUFDSEVEEAI=');

@$core.Deprecated('Use hspPlayStateDescriptor instead')
const HspPlayState$json = {
  '1': 'HspPlayState',
  '2': [
    {'1': 'HSP_STATE_NOT_INITIALIZED', '2': 0},
    {'1': 'HSP_STATE_PLAYING', '2': 1},
    {'1': 'HSP_STATE_STOPPED', '2': 2},
    {'1': 'HSP_STATE_PAUSED', '2': 3},
    {'1': 'HSP_STATE_STARVING', '2': 4},
  ],
};

/// Descriptor for `HspPlayState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List hspPlayStateDescriptor = $convert.base64Decode(
    'CgxIc3BQbGF5U3RhdGUSHQoZSFNQX1NUQVRFX05PVF9JTklUSUFMSVpFRBAAEhUKEUhTUF9TVE'
    'FURV9QTEFZSU5HEAESFQoRSFNQX1NUQVRFX1NUT1BQRUQQAhIUChBIU1BfU1RBVEVfUEFVU0VE'
    'EAMSFgoSSFNQX1NUQVRFX1NUQVJWSU5HEAQ=');

@$core.Deprecated('Use buttonDescriptor instead')
const Button$json = {
  '1': 'Button',
  '2': [
    {'1': 'BUTTON_ON', '2': 0},
    {'1': 'BUTTON_UP', '2': 1},
    {'1': 'BUTTON_LEFT', '2': 2},
    {'1': 'BUTTON_RIGHT', '2': 3},
    {'1': 'BUTTON_DOWN', '2': 4},
    {'1': 'BUTTON_WIFI', '2': 5},
  ],
};

/// Descriptor for `Button`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List buttonDescriptor = $convert.base64Decode(
    'CgZCdXR0b24SDQoJQlVUVE9OX09OEAASDQoJQlVUVE9OX1VQEAESDwoLQlVUVE9OX0xFRlQQAh'
    'IQCgxCVVRUT05fUklHSFQQAxIPCgtCVVRUT05fRE9XThAEEg8KC0JVVFRPTl9XSUZJEAU=');

@$core.Deprecated('Use buttonEventDescriptor instead')
const ButtonEvent$json = {
  '1': 'ButtonEvent',
  '2': [
    {'1': 'BUTTON_EVENT_PRESSED', '2': 0},
    {'1': 'BUTTON_EVENT_RELEASED', '2': 1},
    {'1': 'BUTTON_EVENT_SHORTPRESS', '2': 2},
    {'1': 'BUTTON_EVENT_LONGPRESS_START', '2': 3},
    {'1': 'BUTTON_EVENT_LONGPRESS_STEP', '2': 4},
    {'1': 'BUTTON_EVENT_LONGPRESS_STOP', '2': 5},
  ],
};

/// Descriptor for `ButtonEvent`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List buttonEventDescriptor = $convert.base64Decode(
    'CgtCdXR0b25FdmVudBIYChRCVVRUT05fRVZFTlRfUFJFU1NFRBAAEhkKFUJVVFRPTl9FVkVOVF'
    '9SRUxFQVNFRBABEhsKF0JVVFRPTl9FVkVOVF9TSE9SVFBSRVNTEAISIAocQlVUVE9OX0VWRU5U'
    'X0xPTkdQUkVTU19TVEFSVBADEh8KG0JVVFRPTl9FVkVOVF9MT05HUFJFU1NfU1RFUBAEEh8KG0'
    'JVVFRPTl9FVkVOVF9MT05HUFJFU1NfU1RPUBAF');

@$core.Deprecated('Use authModesDescriptor instead')
const AuthModes$json = {
  '1': 'AuthModes',
  '2': [
    {'1': 'AUTH_OPEN', '2': 0},
    {'1': 'AUTH_WEP', '2': 1},
    {'1': 'AUTH_WPA_PSK', '2': 2},
    {'1': 'AUTH_WPA2_PSK', '2': 3},
    {'1': 'AUTH_WPA_WPA2_PSK', '2': 4},
    {'1': 'AUTH_WPA2_ENTERPRISE', '2': 5},
    {'1': 'AUTH_WPA3_PSK', '2': 6},
    {'1': 'AUTH_WPA2_WPA3_PSK', '2': 7},
    {'1': 'AUTH_WAPI_PSK', '2': 8},
    {'1': 'AUTH_OWE', '2': 9},
    {'1': 'AUTH_MAX', '2': 10},
  ],
};

/// Descriptor for `AuthModes`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List authModesDescriptor = $convert.base64Decode(
    'CglBdXRoTW9kZXMSDQoJQVVUSF9PUEVOEAASDAoIQVVUSF9XRVAQARIQCgxBVVRIX1dQQV9QU0'
    'sQAhIRCg1BVVRIX1dQQTJfUFNLEAMSFQoRQVVUSF9XUEFfV1BBMl9QU0sQBBIYChRBVVRIX1dQ'
    'QTJfRU5URVJQUklTRRAFEhEKDUFVVEhfV1BBM19QU0sQBhIWChJBVVRIX1dQQTJfV1BBM19QU0'
    'sQBxIRCg1BVVRIX1dBUElfUFNLEAgSDAoIQVVUSF9PV0UQCRIMCghBVVRIX01BWBAK');

@$core.Deprecated('Use wifiStateDescriptor instead')
const WifiState$json = {
  '1': 'WifiState',
  '2': [
    {'1': 'WIFI_STATE_DISCONNECTED', '2': 0},
    {'1': 'WIFI_STATE_CONNECTED', '2': 1},
    {'1': 'WIFI_STATE_CONNECTING', '2': 2},
    {'1': 'WIFI_STATE_RECONNECTING', '2': 3},
    {'1': 'WIFI_STATE_FAILED_TO_CONNECT', '2': 4},
    {'1': 'WIFI_STATE_DISCONNECTING', '2': 5},
  ],
};

/// Descriptor for `WifiState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List wifiStateDescriptor = $convert.base64Decode(
    'CglXaWZpU3RhdGUSGwoXV0lGSV9TVEFURV9ESVNDT05ORUNURUQQABIYChRXSUZJX1NUQVRFX0'
    'NPTk5FQ1RFRBABEhkKFVdJRklfU1RBVEVfQ09OTkVDVElORxACEhsKF1dJRklfU1RBVEVfUkVD'
    'T05ORUNUSU5HEAMSIAocV0lGSV9TVEFURV9GQUlMRURfVE9fQ09OTkVDVBAEEhwKGFdJRklfU1'
    'RBVEVfRElTQ09OTkVDVElORxAF');

@$core.Deprecated('Use wifiFailedReasonDescriptor instead')
const WifiFailedReason$json = {
  '1': 'WifiFailedReason',
  '2': [
    {'1': 'WIFI_REASON_DO_NOT_USE', '2': 0},
    {'1': 'WIFI_REASON_UNSPECIFIED', '2': 1},
    {'1': 'WIFI_REASON_AUTH_EXPIRE', '2': 2},
    {'1': 'WIFI_REASON_AUTH_LEAVE', '2': 3},
    {'1': 'WIFI_REASON_ASSOC_EXPIRE', '2': 4},
    {'1': 'WIFI_REASON_ASSOC_TOOMANY', '2': 5},
    {'1': 'WIFI_REASON_NOT_AUTHED', '2': 6},
    {'1': 'WIFI_REASON_NOT_ASSOCED', '2': 7},
    {'1': 'WIFI_REASON_ASSOC_LEAVE', '2': 8},
    {'1': 'WIFI_REASON_ASSOC_NOT_AUTHED', '2': 9},
    {'1': 'WIFI_REASON_DISASSOC_PWRCAP_BAD', '2': 10},
    {'1': 'WIFI_REASON_DISASSOC_SUPCHAN_BAD', '2': 11},
    {'1': 'WIFI_REASON_BSS_TRANSITION_DISASSOC', '2': 12},
    {'1': 'WIFI_REASON_IE_INVALID', '2': 13},
    {'1': 'WIFI_REASON_MIC_FAILURE', '2': 14},
    {'1': 'WIFI_REASON_4WAY_HANDSHAKE_TIMEOUT', '2': 15},
    {'1': 'WIFI_REASON_GROUP_KEY_UPDATE_TIMEOUT', '2': 16},
    {'1': 'WIFI_REASON_IE_IN_4WAY_DIFFERS', '2': 17},
    {'1': 'WIFI_REASON_GROUP_CIPHER_INVALID', '2': 18},
    {'1': 'WIFI_REASON_PAIRWISE_CIPHER_INVALID', '2': 19},
    {'1': 'WIFI_REASON_AKMP_INVALID', '2': 20},
    {'1': 'WIFI_REASON_UNSUPP_RSN_IE_VERSION', '2': 21},
    {'1': 'WIFI_REASON_INVALID_RSN_IE_CAP', '2': 22},
    {'1': 'WIFI_REASON_802_1X_AUTH_FAILED', '2': 23},
    {'1': 'WIFI_REASON_CIPHER_SUITE_REJECTED', '2': 24},
    {'1': 'WIFI_REASON_TDLS_PEER_UNREACHABLE', '2': 25},
    {'1': 'WIFI_REASON_TDLS_UNSPECIFIED', '2': 26},
    {'1': 'WIFI_REASON_SSP_REQUESTED_DISASSOC', '2': 27},
    {'1': 'WIFI_REASON_NO_SSP_ROAMING_AGREEMENT', '2': 28},
    {'1': 'WIFI_REASON_BAD_CIPHER_OR_AKM', '2': 29},
    {'1': 'WIFI_REASON_NOT_AUTHORIZED_THIS_LOCATION', '2': 30},
    {'1': 'WIFI_REASON_SERVICE_CHANGE_PERCLUDES_TS', '2': 31},
    {'1': 'WIFI_REASON_UNSPECIFIED_QOS', '2': 32},
    {'1': 'WIFI_REASON_NOT_ENOUGH_BANDWIDTH', '2': 33},
    {'1': 'WIFI_REASON_MISSING_ACKS', '2': 34},
    {'1': 'WIFI_REASON_EXCEEDED_TXOP', '2': 35},
    {'1': 'WIFI_REASON_STA_LEAVING', '2': 36},
    {'1': 'WIFI_REASON_END_BA', '2': 37},
    {'1': 'WIFI_REASON_UNKNOWN_BA', '2': 38},
    {'1': 'WIFI_REASON_TIMEOUT', '2': 39},
    {'1': 'WIFI_REASON_PEER_INITIATED', '2': 46},
    {'1': 'WIFI_REASON_AP_INITIATED', '2': 47},
    {'1': 'WIFI_REASON_INVALID_FT_ACTION_FRAME_COUNT', '2': 48},
    {'1': 'WIFI_REASON_INVALID_PMKID', '2': 49},
    {'1': 'WIFI_REASON_INVALID_MDE', '2': 50},
    {'1': 'WIFI_REASON_INVALID_FTE', '2': 51},
    {'1': 'WIFI_REASON_TRANSMISSION_LINK_ESTABLISH_FAILED', '2': 67},
    {'1': 'WIFI_REASON_ALTERATIVE_CHANNEL_OCCUPIED', '2': 68},
    {'1': 'WIFI_REASON_BEACON_TIMEOUT', '2': 200},
    {'1': 'WIFI_REASON_NO_AP_FOUND', '2': 201},
    {'1': 'WIFI_REASON_AUTH_FAIL', '2': 202},
    {'1': 'WIFI_REASON_ASSOC_FAIL', '2': 203},
    {'1': 'WIFI_REASON_HANDSHAKE_TIMEOUT', '2': 204},
    {'1': 'WIFI_REASON_CONNECTION_FAIL', '2': 205},
    {'1': 'WIFI_REASON_AP_TSF_RESET', '2': 206},
    {'1': 'WIFI_REASON_ROAMING', '2': 207},
    {'1': 'WIFI_REASON_ASSOC_COMEBACK_TIME_TOO_LONG', '2': 208},
    {'1': 'WIFI_REASON_SA_QUERY_TIMEOUT', '2': 209},
  ],
};

/// Descriptor for `WifiFailedReason`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List wifiFailedReasonDescriptor = $convert.base64Decode(
    'ChBXaWZpRmFpbGVkUmVhc29uEhoKFldJRklfUkVBU09OX0RPX05PVF9VU0UQABIbChdXSUZJX1'
    'JFQVNPTl9VTlNQRUNJRklFRBABEhsKF1dJRklfUkVBU09OX0FVVEhfRVhQSVJFEAISGgoWV0lG'
    'SV9SRUFTT05fQVVUSF9MRUFWRRADEhwKGFdJRklfUkVBU09OX0FTU09DX0VYUElSRRAEEh0KGV'
    'dJRklfUkVBU09OX0FTU09DX1RPT01BTlkQBRIaChZXSUZJX1JFQVNPTl9OT1RfQVVUSEVEEAYS'
    'GwoXV0lGSV9SRUFTT05fTk9UX0FTU09DRUQQBxIbChdXSUZJX1JFQVNPTl9BU1NPQ19MRUFWRR'
    'AIEiAKHFdJRklfUkVBU09OX0FTU09DX05PVF9BVVRIRUQQCRIjCh9XSUZJX1JFQVNPTl9ESVNB'
    'U1NPQ19QV1JDQVBfQkFEEAoSJAogV0lGSV9SRUFTT05fRElTQVNTT0NfU1VQQ0hBTl9CQUQQCx'
    'InCiNXSUZJX1JFQVNPTl9CU1NfVFJBTlNJVElPTl9ESVNBU1NPQxAMEhoKFldJRklfUkVBU09O'
    'X0lFX0lOVkFMSUQQDRIbChdXSUZJX1JFQVNPTl9NSUNfRkFJTFVSRRAOEiYKIldJRklfUkVBU0'
    '9OXzRXQVlfSEFORFNIQUtFX1RJTUVPVVQQDxIoCiRXSUZJX1JFQVNPTl9HUk9VUF9LRVlfVVBE'
    'QVRFX1RJTUVPVVQQEBIiCh5XSUZJX1JFQVNPTl9JRV9JTl80V0FZX0RJRkZFUlMQERIkCiBXSU'
    'ZJX1JFQVNPTl9HUk9VUF9DSVBIRVJfSU5WQUxJRBASEicKI1dJRklfUkVBU09OX1BBSVJXSVNF'
    'X0NJUEhFUl9JTlZBTElEEBMSHAoYV0lGSV9SRUFTT05fQUtNUF9JTlZBTElEEBQSJQohV0lGSV'
    '9SRUFTT05fVU5TVVBQX1JTTl9JRV9WRVJTSU9OEBUSIgoeV0lGSV9SRUFTT05fSU5WQUxJRF9S'
    'U05fSUVfQ0FQEBYSIgoeV0lGSV9SRUFTT05fODAyXzFYX0FVVEhfRkFJTEVEEBcSJQohV0lGSV'
    '9SRUFTT05fQ0lQSEVSX1NVSVRFX1JFSkVDVEVEEBgSJQohV0lGSV9SRUFTT05fVERMU19QRUVS'
    'X1VOUkVBQ0hBQkxFEBkSIAocV0lGSV9SRUFTT05fVERMU19VTlNQRUNJRklFRBAaEiYKIldJRk'
    'lfUkVBU09OX1NTUF9SRVFVRVNURURfRElTQVNTT0MQGxIoCiRXSUZJX1JFQVNPTl9OT19TU1Bf'
    'Uk9BTUlOR19BR1JFRU1FTlQQHBIhCh1XSUZJX1JFQVNPTl9CQURfQ0lQSEVSX09SX0FLTRAdEi'
    'wKKFdJRklfUkVBU09OX05PVF9BVVRIT1JJWkVEX1RISVNfTE9DQVRJT04QHhIrCidXSUZJX1JF'
    'QVNPTl9TRVJWSUNFX0NIQU5HRV9QRVJDTFVERVNfVFMQHxIfChtXSUZJX1JFQVNPTl9VTlNQRU'
    'NJRklFRF9RT1MQIBIkCiBXSUZJX1JFQVNPTl9OT1RfRU5PVUdIX0JBTkRXSURUSBAhEhwKGFdJ'
    'RklfUkVBU09OX01JU1NJTkdfQUNLUxAiEh0KGVdJRklfUkVBU09OX0VYQ0VFREVEX1RYT1AQIx'
    'IbChdXSUZJX1JFQVNPTl9TVEFfTEVBVklORxAkEhYKEldJRklfUkVBU09OX0VORF9CQRAlEhoK'
    'FldJRklfUkVBU09OX1VOS05PV05fQkEQJhIXChNXSUZJX1JFQVNPTl9USU1FT1VUECcSHgoaV0'
    'lGSV9SRUFTT05fUEVFUl9JTklUSUFURUQQLhIcChhXSUZJX1JFQVNPTl9BUF9JTklUSUFURUQQ'
    'LxItCilXSUZJX1JFQVNPTl9JTlZBTElEX0ZUX0FDVElPTl9GUkFNRV9DT1VOVBAwEh0KGVdJRk'
    'lfUkVBU09OX0lOVkFMSURfUE1LSUQQMRIbChdXSUZJX1JFQVNPTl9JTlZBTElEX01ERRAyEhsK'
    'F1dJRklfUkVBU09OX0lOVkFMSURfRlRFEDMSMgouV0lGSV9SRUFTT05fVFJBTlNNSVNTSU9OX0'
    'xJTktfRVNUQUJMSVNIX0ZBSUxFRBBDEisKJ1dJRklfUkVBU09OX0FMVEVSQVRJVkVfQ0hBTk5F'
    'TF9PQ0NVUElFRBBEEh8KGldJRklfUkVBU09OX0JFQUNPTl9USU1FT1VUEMgBEhwKF1dJRklfUk'
    'VBU09OX05PX0FQX0ZPVU5EEMkBEhoKFVdJRklfUkVBU09OX0FVVEhfRkFJTBDKARIbChZXSUZJ'
    'X1JFQVNPTl9BU1NPQ19GQUlMEMsBEiIKHVdJRklfUkVBU09OX0hBTkRTSEFLRV9USU1FT1VUEM'
    'wBEiAKG1dJRklfUkVBU09OX0NPTk5FQ1RJT05fRkFJTBDNARIdChhXSUZJX1JFQVNPTl9BUF9U'
    'U0ZfUkVTRVQQzgESGAoTV0lGSV9SRUFTT05fUk9BTUlORxDPARItCihXSUZJX1JFQVNPTl9BU1'
    'NPQ19DT01FQkFDS19USU1FX1RPT19MT05HENABEiEKHFdJRklfUkVBU09OX1NBX1FVRVJZX1RJ'
    'TUVPVVQQ0QE=');

@$core.Deprecated('Use connectionModeDescriptor instead')
const ConnectionMode$json = {
  '1': 'ConnectionMode',
  '2': [
    {'1': 'CONNECTION_MODE_NOT_SET', '2': 0},
    {'1': 'CONNECTION_MODE_WIFI', '2': 1},
    {'1': 'CONNECTION_MODE_BLE', '2': 2},
    {'1': 'CONNECTION_MODE_WIFI_AND_BLE', '2': 3},
    {'1': 'CONNECTION_MODE_OFFLINE', '2': 4},
    {'1': 'CONNECTION_MODE_LEGACY_BLE', '2': 5},
    {'1': 'CONNECTION_MODE_FACTORY', '2': 6},
    {'1': 'CONNECTION_MODE_AUDIO', '2': 7},
  ],
};

/// Descriptor for `ConnectionMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List connectionModeDescriptor = $convert.base64Decode(
    'Cg5Db25uZWN0aW9uTW9kZRIbChdDT05ORUNUSU9OX01PREVfTk9UX1NFVBAAEhgKFENPTk5FQ1'
    'RJT05fTU9ERV9XSUZJEAESFwoTQ09OTkVDVElPTl9NT0RFX0JMRRACEiAKHENPTk5FQ1RJT05f'
    'TU9ERV9XSUZJX0FORF9CTEUQAxIbChdDT05ORUNUSU9OX01PREVfT0ZGTElORRAEEh4KGkNPTk'
    '5FQ1RJT05fTU9ERV9MRUdBQ1lfQkxFEAUSGwoXQ09OTkVDVElPTl9NT0RFX0ZBQ1RPUlkQBhIZ'
    'ChVDT05ORUNUSU9OX01PREVfQVVESU8QBw==');

@$core.Deprecated('Use serverEnvironmentDescriptor instead')
const ServerEnvironment$json = {
  '1': 'ServerEnvironment',
  '2': [
    {'1': 'SOCKET_SERVER_ENV_PRODUCTION', '2': 0},
    {'1': 'SOCKET_SERVER_ENV_STAGING', '2': 1},
    {'1': 'SOCKET_SERVER_ENV_DEVELOPMENT', '2': 2},
    {'1': 'SOCKET_SERVER_ENV_CUSTOM', '2': 3},
  ],
};

/// Descriptor for `ServerEnvironment`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List serverEnvironmentDescriptor = $convert.base64Decode(
    'ChFTZXJ2ZXJFbnZpcm9ubWVudBIgChxTT0NLRVRfU0VSVkVSX0VOVl9QUk9EVUNUSU9OEAASHQ'
    'oZU09DS0VUX1NFUlZFUl9FTlZfU1RBR0lORxABEiEKHVNPQ0tFVF9TRVJWRVJfRU5WX0RFVkVM'
    'T1BNRU5UEAISHAoYU09DS0VUX1NFUlZFUl9FTlZfQ1VTVE9NEAM=');

@$core.Deprecated('Use bleStateDescriptor instead')
const BleState$json = {
  '1': 'BleState',
  '2': [
    {'1': 'BLE_STATE_NOT_INITIALIZED', '2': 0},
    {'1': 'BLE_STATE_INITIALIZING', '2': 1},
    {'1': 'BLE_STATE_ADVERTISING', '2': 2},
    {'1': 'BLE_STATE_CONNECTED', '2': 3},
  ],
};

/// Descriptor for `BleState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List bleStateDescriptor = $convert.base64Decode(
    'CghCbGVTdGF0ZRIdChlCTEVfU1RBVEVfTk9UX0lOSVRJQUxJWkVEEAASGgoWQkxFX1NUQVRFX0'
    'lOSVRJQUxJWklORxABEhkKFUJMRV9TVEFURV9BRFZFUlRJU0lORxACEhcKE0JMRV9TVEFURV9D'
    'T05ORUNURUQQAw==');

@$core.Deprecated('Use batteryDriverDescriptor instead')
const BatteryDriver$json = {
  '1': 'BatteryDriver',
  '2': [
    {'1': 'BATTERY_DRIVER_NOT_SET', '2': 0},
    {'1': 'BATTERY_DRIVER_OH', '2': 1},
    {'1': 'BATTERY_DRIVER_H2', '2': 2},
  ],
};

/// Descriptor for `BatteryDriver`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List batteryDriverDescriptor = $convert.base64Decode(
    'Cg1CYXR0ZXJ5RHJpdmVyEhoKFkJBVFRFUllfRFJJVkVSX05PVF9TRVQQABIVChFCQVRURVJZX0'
    'RSSVZFUl9PSBABEhUKEUJBVFRFUllfRFJJVkVSX0gyEAI=');

@$core.Deprecated('Use idleTimeoutStateDescriptor instead')
const IdleTimeoutState$json = {
  '1': 'IdleTimeoutState',
  '2': [
    {'1': 'IDLE_TIMEOUT_STATE_WARNING', '2': 0},
    {'1': 'IDLE_TIMEOUT_STATE_CANCELLED', '2': 1},
    {'1': 'IDLE_TIMEOUT_STATE_SLEEPING', '2': 2},
  ],
};

/// Descriptor for `IdleTimeoutState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List idleTimeoutStateDescriptor = $convert.base64Decode(
    'ChBJZGxlVGltZW91dFN0YXRlEh4KGklETEVfVElNRU9VVF9TVEFURV9XQVJOSU5HEAASIAocSU'
    'RMRV9USU1FT1VUX1NUQVRFX0NBTkNFTExFRBABEh8KG0lETEVfVElNRU9VVF9TVEFURV9TTEVF'
    'UElORxAC');

@$core.Deprecated('Use settingTypeDescriptor instead')
const SettingType$json = {
  '1': 'SettingType',
  '2': [
    {'1': 'SETTINGS_NOT_SET', '2': 0},
    {'1': 'SETTINGS_BASE', '2': 1},
    {'1': 'SETTINGS_SLIDER', '2': 2},
    {'1': 'SETTINGS_LRA', '2': 3},
    {'1': 'SETTINGS_ERM', '2': 4},
    {'1': 'SETTINGS_BATTERY', '2': 5},
    {'1': 'SETTINGS_SERVER', '2': 6},
  ],
};

/// Descriptor for `SettingType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List settingTypeDescriptor = $convert.base64Decode(
    'CgtTZXR0aW5nVHlwZRIUChBTRVRUSU5HU19OT1RfU0VUEAASEQoNU0VUVElOR1NfQkFTRRABEh'
    'MKD1NFVFRJTkdTX1NMSURFUhACEhAKDFNFVFRJTkdTX0xSQRADEhAKDFNFVFRJTkdTX0VSTRAE'
    'EhQKEFNFVFRJTkdTX0JBVFRFUlkQBRITCg9TRVRUSU5HU19TRVJWRVIQBg==');

@$core.Deprecated('Use hampStateDescriptor instead')
const HampState$json = {
  '1': 'HampState',
  '2': [
    {
      '1': 'play_state',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.HampPlayState',
      '10': 'playState'
    },
    {'1': 'velocity', '3': 2, '4': 1, '5': 2, '10': 'velocity'},
    {'1': 'direction', '3': 3, '4': 1, '5': 8, '10': 'direction'},
    {'1': 'min', '3': 4, '4': 1, '5': 2, '10': 'min'},
    {'1': 'max', '3': 5, '4': 1, '5': 2, '10': 'max'},
  ],
};

/// Descriptor for `HampState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hampStateDescriptor = $convert.base64Decode(
    'CglIYW1wU3RhdGUSNQoKcGxheV9zdGF0ZRgBIAEoDjIWLmhkeV9ycGMuSGFtcFBsYXlTdGF0ZV'
    'IJcGxheVN0YXRlEhoKCHZlbG9jaXR5GAIgASgCUgh2ZWxvY2l0eRIcCglkaXJlY3Rpb24YAyAB'
    'KAhSCWRpcmVjdGlvbhIQCgNtaW4YBCABKAJSA21pbhIQCgNtYXgYBSABKAJSA21heA==');

@$core.Deprecated('Use hrppPatternDescriptor instead')
const HrppPattern$json = {
  '1': 'HrppPattern',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'version', '3': 3, '4': 1, '5': 13, '10': 'version'},
    {'1': 'custom_pattern', '3': 4, '4': 1, '5': 8, '10': 'customPattern'},
    {'1': 'slot', '3': 5, '4': 1, '5': 13, '10': 'slot'},
    {
      '1': 'type',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.HrppPatternType',
      '10': 'type'
    },
    {'1': 'pause_random_min', '3': 7, '4': 1, '5': 13, '10': 'pauseRandomMin'},
    {'1': 'pause_random_max', '3': 8, '4': 1, '5': 13, '10': 'pauseRandomMax'},
  ],
};

/// Descriptor for `HrppPattern`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hrppPatternDescriptor = $convert.base64Decode(
    'CgtIcnBwUGF0dGVybhIOCgJpZBgBIAEoDVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIYCgd2ZX'
    'JzaW9uGAMgASgNUgd2ZXJzaW9uEiUKDmN1c3RvbV9wYXR0ZXJuGAQgASgIUg1jdXN0b21QYXR0'
    'ZXJuEhIKBHNsb3QYBSABKA1SBHNsb3QSLAoEdHlwZRgGIAEoDjIYLmhkeV9ycGMuSHJwcFBhdH'
    'Rlcm5UeXBlUgR0eXBlEigKEHBhdXNlX3JhbmRvbV9taW4YByABKA1SDnBhdXNlUmFuZG9tTWlu'
    'EigKEHBhdXNlX3JhbmRvbV9tYXgYCCABKA1SDnBhdXNlUmFuZG9tTWF4');

@$core.Deprecated('Use hrppStateDescriptor instead')
const HrppState$json = {
  '1': 'HrppState',
  '2': [
    {
      '1': 'current_pattern_nr',
      '3': 1,
      '4': 1,
      '5': 13,
      '10': 'currentPatternNr'
    },
    {
      '1': 'current_pattern',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.HrppPattern',
      '10': 'currentPattern'
    },
    {'1': 'nr_of_patterns', '3': 3, '4': 1, '5': 13, '10': 'nrOfPatterns'},
    {'1': 'enabled', '3': 4, '4': 1, '5': 8, '10': 'enabled'},
    {'1': 'amplitude', '3': 5, '4': 1, '5': 2, '10': 'amplitude'},
    {'1': 'playback_speed', '3': 6, '4': 1, '5': 2, '10': 'playbackSpeed'},
  ],
};

/// Descriptor for `HrppState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hrppStateDescriptor = $convert.base64Decode(
    'CglIcnBwU3RhdGUSLAoSY3VycmVudF9wYXR0ZXJuX25yGAEgASgNUhBjdXJyZW50UGF0dGVybk'
    '5yEj0KD2N1cnJlbnRfcGF0dGVybhgCIAEoCzIULmhkeV9ycGMuSHJwcFBhdHRlcm5SDmN1cnJl'
    'bnRQYXR0ZXJuEiQKDm5yX29mX3BhdHRlcm5zGAMgASgNUgxuck9mUGF0dGVybnMSGAoHZW5hYm'
    'xlZBgEIAEoCFIHZW5hYmxlZBIcCglhbXBsaXR1ZGUYBSABKAJSCWFtcGxpdHVkZRIlCg5wbGF5'
    'YmFja19zcGVlZBgGIAEoAlINcGxheWJhY2tTcGVlZA==');

@$core.Deprecated('Use hspStateDescriptor instead')
const HspState$json = {
  '1': 'HspState',
  '2': [
    {
      '1': 'play_state',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.HspPlayState',
      '10': 'playState'
    },
    {'1': 'points', '3': 2, '4': 1, '5': 13, '10': 'points'},
    {'1': 'max_points', '3': 3, '4': 1, '5': 13, '10': 'maxPoints'},
    {'1': 'current_point', '3': 4, '4': 1, '5': 5, '10': 'currentPoint'},
    {'1': 'current_time', '3': 5, '4': 1, '5': 5, '10': 'currentTime'},
    {'1': 'loop', '3': 6, '4': 1, '5': 8, '10': 'loop'},
    {'1': 'playback_rate', '3': 7, '4': 1, '5': 2, '10': 'playbackRate'},
    {'1': 'first_point_time', '3': 8, '4': 1, '5': 13, '10': 'firstPointTime'},
    {'1': 'last_point_time', '3': 9, '4': 1, '5': 13, '10': 'lastPointTime'},
    {'1': 'stream_id', '3': 10, '4': 1, '5': 13, '10': 'streamId'},
    {
      '1': 'tail_point_stream_index',
      '3': 11,
      '4': 1,
      '5': 5,
      '10': 'tailPointStreamIndex'
    },
    {
      '1': 'tail_point_stream_index_threshold',
      '3': 12,
      '4': 1,
      '5': 13,
      '10': 'tailPointStreamIndexThreshold'
    },
    {
      '1': 'pause_on_starving',
      '3': 13,
      '4': 1,
      '5': 8,
      '10': 'pauseOnStarving'
    },
  ],
};

/// Descriptor for `HspState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hspStateDescriptor = $convert.base64Decode(
    'CghIc3BTdGF0ZRI0CgpwbGF5X3N0YXRlGAEgASgOMhUuaGR5X3JwYy5Ic3BQbGF5U3RhdGVSCX'
    'BsYXlTdGF0ZRIWCgZwb2ludHMYAiABKA1SBnBvaW50cxIdCgptYXhfcG9pbnRzGAMgASgNUglt'
    'YXhQb2ludHMSIwoNY3VycmVudF9wb2ludBgEIAEoBVIMY3VycmVudFBvaW50EiEKDGN1cnJlbn'
    'RfdGltZRgFIAEoBVILY3VycmVudFRpbWUSEgoEbG9vcBgGIAEoCFIEbG9vcBIjCg1wbGF5YmFj'
    'a19yYXRlGAcgASgCUgxwbGF5YmFja1JhdGUSKAoQZmlyc3RfcG9pbnRfdGltZRgIIAEoDVIOZm'
    'lyc3RQb2ludFRpbWUSJgoPbGFzdF9wb2ludF90aW1lGAkgASgNUg1sYXN0UG9pbnRUaW1lEhsK'
    'CXN0cmVhbV9pZBgKIAEoDVIIc3RyZWFtSWQSNQoXdGFpbF9wb2ludF9zdHJlYW1faW5kZXgYCy'
    'ABKAVSFHRhaWxQb2ludFN0cmVhbUluZGV4EkgKIXRhaWxfcG9pbnRfc3RyZWFtX2luZGV4X3Ro'
    'cmVzaG9sZBgMIAEoDVIddGFpbFBvaW50U3RyZWFtSW5kZXhUaHJlc2hvbGQSKgoRcGF1c2Vfb2'
    '5fc3RhcnZpbmcYDSABKAhSD3BhdXNlT25TdGFydmluZw==');

@$core.Deprecated('Use hvpStateDescriptor instead')
const HvpState$json = {
  '1': 'HvpState',
  '2': [
    {'1': 'enabled', '3': 1, '4': 1, '5': 8, '10': 'enabled'},
    {'1': 'amplitude', '3': 2, '4': 1, '5': 2, '10': 'amplitude'},
    {'1': 'frequency', '3': 3, '4': 1, '5': 13, '10': 'frequency'},
    {'1': 'position', '3': 4, '4': 1, '5': 2, '10': 'position'},
  ],
};

/// Descriptor for `HvpState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hvpStateDescriptor = $convert.base64Decode(
    'CghIdnBTdGF0ZRIYCgdlbmFibGVkGAEgASgIUgdlbmFibGVkEhwKCWFtcGxpdHVkZRgCIAEoAl'
    'IJYW1wbGl0dWRlEhwKCWZyZXF1ZW5jeRgDIAEoDVIJZnJlcXVlbmN5EhoKCHBvc2l0aW9uGAQg'
    'ASgCUghwb3NpdGlvbg==');

@$core.Deprecated('Use pointDescriptor instead')
const Point$json = {
  '1': 'Point',
  '2': [
    {'1': 't', '3': 1, '4': 1, '5': 13, '10': 't'},
    {'1': 'x', '3': 2, '4': 1, '5': 13, '10': 'x'},
  ],
};

/// Descriptor for `Point`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pointDescriptor =
    $convert.base64Decode('CgVQb2ludBIMCgF0GAEgASgNUgF0EgwKAXgYAiABKA1SAXg=');

@$core.Deprecated('Use apInfoDescriptor instead')
const ApInfo$json = {
  '1': 'ApInfo',
  '2': [
    {'1': 'ssid', '3': 1, '4': 1, '5': 9, '10': 'ssid'},
    {'1': 'bssid', '3': 2, '4': 1, '5': 9, '10': 'bssid'},
    {'1': 'channel', '3': 3, '4': 1, '5': 13, '10': 'channel'},
    {
      '1': 'authmode',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.AuthModes',
      '10': 'authmode'
    },
    {'1': 'rssi', '3': 5, '4': 1, '5': 5, '10': 'rssi'},
    {'1': 'ip', '3': 6, '4': 1, '5': 9, '10': 'ip'},
  ],
};

/// Descriptor for `ApInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List apInfoDescriptor = $convert.base64Decode(
    'CgZBcEluZm8SEgoEc3NpZBgBIAEoCVIEc3NpZBIUCgVic3NpZBgCIAEoCVIFYnNzaWQSGAoHY2'
    'hhbm5lbBgDIAEoDVIHY2hhbm5lbBIuCghhdXRobW9kZRgEIAEoDjISLmhkeV9ycGMuQXV0aE1v'
    'ZGVzUghhdXRobW9kZRISCgRyc3NpGAUgASgFUgRyc3NpEg4KAmlwGAYgASgJUgJpcA==');

@$core.Deprecated('Use batteryStateDescriptor instead')
const BatteryState$json = {
  '1': 'BatteryState',
  '2': [
    {'1': 'level', '3': 1, '4': 1, '5': 13, '10': 'level'},
    {
      '1': 'charger_connected',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'chargerConnected'
    },
    {
      '1': 'charging_complete',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'chargingComplete'
    },
    {'1': 'usb_voltage', '3': 4, '4': 1, '5': 2, '10': 'usbVoltage'},
    {'1': 'battery_voltage', '3': 5, '4': 1, '5': 2, '10': 'batteryVoltage'},
    {'1': 'usb_adc_value', '3': 6, '4': 1, '5': 13, '10': 'usbAdcValue'},
    {
      '1': 'battery_adc_value',
      '3': 7,
      '4': 1,
      '5': 13,
      '10': 'batteryAdcValue'
    },
    {
      '1': 'battery_temperature',
      '3': 8,
      '4': 1,
      '5': 2,
      '10': 'batteryTemperature'
    },
    {
      '1': 'battery_temperature_adc_value',
      '3': 9,
      '4': 1,
      '5': 13,
      '10': 'batteryTemperatureAdcValue'
    },
    {
      '1': 'not_supported_charger',
      '3': 10,
      '4': 1,
      '5': 8,
      '10': 'notSupportedCharger'
    },
    {
      '1': 'shut_down_voltage_detected',
      '3': 11,
      '4': 1,
      '5': 8,
      '10': 'shutDownVoltageDetected'
    },
    {
      '1': 'charger_fault_detected',
      '3': 12,
      '4': 1,
      '5': 8,
      '10': 'chargerFaultDetected'
    },
    {
      '1': 'last_fully_charged_voltage',
      '3': 13,
      '4': 1,
      '5': 2,
      '10': 'lastFullyChargedVoltage'
    },
    {'1': 'chgr', '3': 14, '4': 1, '5': 8, '10': 'chgr'},
    {'1': 'ic_done', '3': 15, '4': 1, '5': 8, '10': 'icDone'},
    {'1': 'pg', '3': 16, '4': 1, '5': 8, '10': 'pg'},
    {'1': 'charger_disabled', '3': 17, '4': 1, '5': 8, '10': 'chargerDisabled'},
    {'1': 'charging', '3': 18, '4': 1, '5': 8, '10': 'charging'},
  ],
};

/// Descriptor for `BatteryState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List batteryStateDescriptor = $convert.base64Decode(
    'CgxCYXR0ZXJ5U3RhdGUSFAoFbGV2ZWwYASABKA1SBWxldmVsEisKEWNoYXJnZXJfY29ubmVjdG'
    'VkGAIgASgIUhBjaGFyZ2VyQ29ubmVjdGVkEisKEWNoYXJnaW5nX2NvbXBsZXRlGAMgASgIUhBj'
    'aGFyZ2luZ0NvbXBsZXRlEh8KC3VzYl92b2x0YWdlGAQgASgCUgp1c2JWb2x0YWdlEicKD2JhdH'
    'Rlcnlfdm9sdGFnZRgFIAEoAlIOYmF0dGVyeVZvbHRhZ2USIgoNdXNiX2FkY192YWx1ZRgGIAEo'
    'DVILdXNiQWRjVmFsdWUSKgoRYmF0dGVyeV9hZGNfdmFsdWUYByABKA1SD2JhdHRlcnlBZGNWYW'
    'x1ZRIvChNiYXR0ZXJ5X3RlbXBlcmF0dXJlGAggASgCUhJiYXR0ZXJ5VGVtcGVyYXR1cmUSQQod'
    'YmF0dGVyeV90ZW1wZXJhdHVyZV9hZGNfdmFsdWUYCSABKA1SGmJhdHRlcnlUZW1wZXJhdHVyZU'
    'FkY1ZhbHVlEjIKFW5vdF9zdXBwb3J0ZWRfY2hhcmdlchgKIAEoCFITbm90U3VwcG9ydGVkQ2hh'
    'cmdlchI7ChpzaHV0X2Rvd25fdm9sdGFnZV9kZXRlY3RlZBgLIAEoCFIXc2h1dERvd25Wb2x0YW'
    'dlRGV0ZWN0ZWQSNAoWY2hhcmdlcl9mYXVsdF9kZXRlY3RlZBgMIAEoCFIUY2hhcmdlckZhdWx0'
    'RGV0ZWN0ZWQSOwoabGFzdF9mdWxseV9jaGFyZ2VkX3ZvbHRhZ2UYDSABKAJSF2xhc3RGdWxseU'
    'NoYXJnZWRWb2x0YWdlEhIKBGNoZ3IYDiABKAhSBGNoZ3ISFwoHaWNfZG9uZRgPIAEoCFIGaWNE'
    'b25lEg4KAnBnGBAgASgIUgJwZxIpChBjaGFyZ2VyX2Rpc2FibGVkGBEgASgIUg9jaGFyZ2VyRG'
    'lzYWJsZWQSGgoIY2hhcmdpbmcYEiABKAhSCGNoYXJnaW5n');
