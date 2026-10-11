// This is a generated file - do not edit.
//
// Generated from constants.proto.

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
    {'1': 'ERROR_OTA_OFFSET_MISMATCH', '2': 100039},
    {'1': 'ERROR_OTA_TOTAL_SIZE_MISMATCH', '2': 100040},
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
    {'1': 'ERROR_SERVER_DEVICE_NOT_CONNECTED_TO_SERVER', '2': 100033},
    {'1': 'ERROR_SERVER_NOT_ALLOWED', '2': 100034},
    {'1': 'ERROR_OTA_ERR_NO_OTA_PARTITION', '2': 200001},
    {'1': 'ERROR_OTA_ERR_INVALID_BIN', '2': 20000},
    {'1': 'ERROR_OTA_ERR_INVALID_PARAM', '2': 200003},
    {'1': 'ERROR_OTA_ERR_NEW_OTA_HAS_PREVIOUSLY_FAILED', '2': 200004},
    {'1': 'ERROR_OTA_ERR_NEW_OTA_SAME_AS_CURRENT', '2': 200005},
    {'1': 'ERROR_OTA_ERR_WRONG_FLASH_ENCRYPTION', '2': 200006},
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
    '1FTV9FUlJPUhC4jQYSGwoVRVJST1JfT1RBX05PVF9TVEFSVEVEELmNBhIfChlFUlJPUl9PVEFf'
    'T0ZGU0VUX01JU01BVENIEMeNBhIjCh1FUlJPUl9PVEFfVE9UQUxfU0laRV9NSVNNQVRDSBDIjQ'
    'YSIgocRVJST1JfRlVOQ1RJT05fTk9UX1NVUFBPUlRFRBCxjQYSHQoXRVJST1JfUlBDX01TR19Q'
    'T09MX0ZVTEwQs40GEiAKGkVSUk9SX1JQQ19GQUlMRURfVE9fVU5QQUNLELSNBhI0Ci5FUlJPUl'
    '9SUENfTk9UX0FMTE9XRURfV0lUSF9USElTX1RSQU5TUE9SVF9NT0RFELWNBhIlCh9FUlJPUl9S'
    'UENfTkVUV09SS19ERUxBWV9UT09fQklHELaNBhIfChlFUlJPUl9SUENfTk9UX0lOSVRJQUxJWk'
    'VEEL2NBhIiChxFUlJPUl9SUENfSEFORExFUl9RVUVVRV9GVUxMEL6NBhIcChZFUlJPUl9SUENf'
    'U0VORF9USU1FT1VUEL+NBhIQCgpFUlJPUl9GQUlMELeNBhIdChdFUlJPUl9IQUxMX1NFTlNPUl'
    '9FUlJPUhC6jQYSJgogRVJST1JfT1ZFUkNMT0NLSU5HX05PVF9TVVBQT1JURUQQu40GEicKIUVS'
    'Uk9SX09WRVJDTE9DS0lOR19JU19OT1RfRU5BQkxFRBC8jQYSMQorRVJST1JfTU9ERV9DSEFOR0'
    'VfTk9UX0FMTE9XRURfV0hFTl9ESVNBQkxFRBDAjQYSMQorRVJST1JfU0VSVkVSX0RFVklDRV9O'
    'T1RfQ09OTkVDVEVEX1RPX1NFUlZFUhDBjQYSHgoYRVJST1JfU0VSVkVSX05PVF9BTExPV0VEEM'
    'KNBhIkCh5FUlJPUl9PVEFfRVJSX05PX09UQV9QQVJUSVRJT04QwZoMEh8KGUVSUk9SX09UQV9F'
    'UlJfSU5WQUxJRF9CSU4QoJwBEiEKG0VSUk9SX09UQV9FUlJfSU5WQUxJRF9QQVJBTRDDmgwSMQ'
    'orRVJST1JfT1RBX0VSUl9ORVdfT1RBX0hBU19QUkVWSU9VU0xZX0ZBSUxFRBDEmgwSKwolRVJS'
    'T1JfT1RBX0VSUl9ORVdfT1RBX1NBTUVfQVNfQ1VSUkVOVBDFmgwSKgokRVJST1JfT1RBX0VSUl'
    '9XUk9OR19GTEFTSF9FTkNSWVBUSU9OEMaaDA==');

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
    {'1': 'HRPP_PATTERN_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'HRPP_PATTERN_TYPE_SCRIPT', '2': 1},
    {'1': 'HRPP_PATTERN_TYPE_WAVE', '2': 2},
  ],
};

/// Descriptor for `HrppPatternType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List hrppPatternTypeDescriptor = $convert.base64Decode(
    'Cg9IcnBwUGF0dGVyblR5cGUSIQodSFJQUF9QQVRURVJOX1RZUEVfVU5TUEVDSUZJRUQQABIcCh'
    'hIUlBQX1BBVFRFUk5fVFlQRV9TQ1JJUFQQARIaChZIUlBQX1BBVFRFUk5fVFlQRV9XQVZFEAI=');

@$core.Deprecated('Use hrppPlayStateDescriptor instead')
const HrppPlayState$json = {
  '1': 'HrppPlayState',
  '2': [
    {'1': 'HRPP_PLAY_STATE_UNSPECIFIED', '2': 0},
    {'1': 'HRPP_PLAY_STATE_STOPPED', '2': 1},
    {'1': 'HRPP_PLAY_STATE_PLAYING', '2': 2},
    {'1': 'HRPP_PLAY_STATE_PAUSED', '2': 3},
  ],
};

/// Descriptor for `HrppPlayState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List hrppPlayStateDescriptor = $convert.base64Decode(
    'Cg1IcnBwUGxheVN0YXRlEh8KG0hSUFBfUExBWV9TVEFURV9VTlNQRUNJRklFRBAAEhsKF0hSUF'
    'BfUExBWV9TVEFURV9TVE9QUEVEEAESGwoXSFJQUF9QTEFZX1NUQVRFX1BMQVlJTkcQAhIaChZI'
    'UlBQX1BMQVlfU1RBVEVfUEFVU0VEEAM=');

@$core.Deprecated('Use hrppPatternAccessDescriptor instead')
const HrppPatternAccess$json = {
  '1': 'HrppPatternAccess',
  '2': [
    {'1': 'HRPP_PATTERN_ACCESS_UNSPECIFIED', '2': 0},
    {'1': 'HRPP_PATTERN_ACCESS_PUBLIC', '2': 1},
    {'1': 'HRPP_PATTERN_ACCESS_PRIVATE', '2': 2},
    {'1': 'HRPP_PATTERN_ACCESS_PREMIUM', '2': 3},
  ],
};

/// Descriptor for `HrppPatternAccess`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List hrppPatternAccessDescriptor = $convert.base64Decode(
    'ChFIcnBwUGF0dGVybkFjY2VzcxIjCh9IUlBQX1BBVFRFUk5fQUNDRVNTX1VOU1BFQ0lGSUVEEA'
    'ASHgoaSFJQUF9QQVRURVJOX0FDQ0VTU19QVUJMSUMQARIfChtIUlBQX1BBVFRFUk5fQUNDRVNT'
    'X1BSSVZBVEUQAhIfChtIUlBQX1BBVFRFUk5fQUNDRVNTX1BSRU1JVU0QAw==');

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
    {'1': 'SOCKET_SERVER_ENV_FACTORY', '2': 4},
  ],
};

/// Descriptor for `ServerEnvironment`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List serverEnvironmentDescriptor = $convert.base64Decode(
    'ChFTZXJ2ZXJFbnZpcm9ubWVudBIgChxTT0NLRVRfU0VSVkVSX0VOVl9QUk9EVUNUSU9OEAASHQ'
    'oZU09DS0VUX1NFUlZFUl9FTlZfU1RBR0lORxABEiEKHVNPQ0tFVF9TRVJWRVJfRU5WX0RFVkVM'
    'T1BNRU5UEAISHAoYU09DS0VUX1NFUlZFUl9FTlZfQ1VTVE9NEAMSHQoZU09DS0VUX1NFUlZFUl'
    '9FTlZfRkFDVE9SWRAE');

@$core.Deprecated('Use customServerCertificateTypeDescriptor instead')
const CustomServerCertificateType$json = {
  '1': 'CustomServerCertificateType',
  '2': [
    {'1': 'CUSTOM_SERVER_CERTIFICATE_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'CUSTOM_SERVER_CERTIFICATE_TYPE_OPEN', '2': 1},
    {'1': 'CUSTOM_SERVER_CERTIFICATE_TYPE_PUBLIC', '2': 5},
  ],
};

/// Descriptor for `CustomServerCertificateType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List customServerCertificateTypeDescriptor =
    $convert.base64Decode(
        'ChtDdXN0b21TZXJ2ZXJDZXJ0aWZpY2F0ZVR5cGUSLgoqQ1VTVE9NX1NFUlZFUl9DRVJUSUZJQ0'
        'FURV9UWVBFX1VOU1BFQ0lGSUVEEAASJwojQ1VTVE9NX1NFUlZFUl9DRVJUSUZJQ0FURV9UWVBF'
        'X09QRU4QARIpCiVDVVNUT01fU0VSVkVSX0NFUlRJRklDQVRFX1RZUEVfUFVCTElDEAU=');

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
    {'1': 'BATTERY_DRIVER_H21', '2': 3},
  ],
};

/// Descriptor for `BatteryDriver`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List batteryDriverDescriptor = $convert.base64Decode(
    'Cg1CYXR0ZXJ5RHJpdmVyEhoKFkJBVFRFUllfRFJJVkVSX05PVF9TRVQQABIVChFCQVRURVJZX0'
    'RSSVZFUl9PSBABEhUKEUJBVFRFUllfRFJJVkVSX0gyEAISFgoSQkFUVEVSWV9EUklWRVJfSDIx'
    'EAM=');

@$core.Deprecated('Use firmwareStatusDescriptor instead')
const FirmwareStatus$json = {
  '1': 'FirmwareStatus',
  '2': [
    {'1': 'FIRMWARE_STATUS_UP_TO_DATE', '2': 0},
    {'1': 'FIRMWARE_STATUS_UPDATE_AVAILABLE', '2': 1},
    {'1': 'FIRMWARE_STATUS_UPDATE_REQUIRED', '2': 2},
  ],
};

/// Descriptor for `FirmwareStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List firmwareStatusDescriptor = $convert.base64Decode(
    'Cg5GaXJtd2FyZVN0YXR1cxIeChpGSVJNV0FSRV9TVEFUVVNfVVBfVE9fREFURRAAEiQKIEZJUk'
    '1XQVJFX1NUQVRVU19VUERBVEVfQVZBSUxBQkxFEAESIwofRklSTVdBUkVfU1RBVFVTX1VQREFU'
    'RV9SRVFVSVJFRBAC');

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
    {'1': 'SETTINGS_SENSOR', '2': 7},
    {'1': 'SETTINGS_REGULATOR', '2': 8},
    {'1': 'SETTINGS_HALL', '2': 9},
  ],
};

/// Descriptor for `SettingType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List settingTypeDescriptor = $convert.base64Decode(
    'CgtTZXR0aW5nVHlwZRIUChBTRVRUSU5HU19OT1RfU0VUEAASEQoNU0VUVElOR1NfQkFTRRABEh'
    'MKD1NFVFRJTkdTX1NMSURFUhACEhAKDFNFVFRJTkdTX0xSQRADEhAKDFNFVFRJTkdTX0VSTRAE'
    'EhQKEFNFVFRJTkdTX0JBVFRFUlkQBRITCg9TRVRUSU5HU19TRVJWRVIQBhITCg9TRVRUSU5HU1'
    '9TRU5TT1IQBxIWChJTRVRUSU5HU19SRUdVTEFUT1IQCBIRCg1TRVRUSU5HU19IQUxMEAk=');

@$core.Deprecated('Use sensorMasterRuleDescriptor instead')
const SensorMasterRule$json = {
  '1': 'SensorMasterRule',
  '2': [
    {'1': 'SENSOR_MASTER_TOP', '2': 0},
    {'1': 'SENSOR_MASTER_BOTTOM', '2': 1},
    {'1': 'SENSOR_MASTER_AVG', '2': 2},
  ],
};

/// Descriptor for `SensorMasterRule`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List sensorMasterRuleDescriptor = $convert.base64Decode(
    'ChBTZW5zb3JNYXN0ZXJSdWxlEhUKEVNFTlNPUl9NQVNURVJfVE9QEAASGAoUU0VOU09SX01BU1'
    'RFUl9CT1RUT00QARIVChFTRU5TT1JfTUFTVEVSX0FWRxAC');

@$core.Deprecated('Use slideDiagChannelDescriptor instead')
const SlideDiagChannel$json = {
  '1': 'SlideDiagChannel',
  '2': [
    {'1': 'SLIDE_DIAG_CHANNEL_HALL', '2': 0},
    {'1': 'SLIDE_DIAG_CHANNEL_REGULATOR', '2': 1},
    {'1': 'SLIDE_DIAG_CHANNEL_HSP', '2': 2},
    {'1': 'SLIDE_DIAG_CHANNEL_SENSOR', '2': 3},
  ],
};

/// Descriptor for `SlideDiagChannel`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List slideDiagChannelDescriptor = $convert.base64Decode(
    'ChBTbGlkZURpYWdDaGFubmVsEhsKF1NMSURFX0RJQUdfQ0hBTk5FTF9IQUxMEAASIAocU0xJRE'
    'VfRElBR19DSEFOTkVMX1JFR1VMQVRPUhABEhoKFlNMSURFX0RJQUdfQ0hBTk5FTF9IU1AQAhId'
    'ChlTTElERV9ESUFHX0NIQU5ORUxfU0VOU09SEAM=');

@$core.Deprecated('Use slideProfileDescriptor instead')
const SlideProfile$json = {
  '1': 'SlideProfile',
  '2': [
    {'1': 'SLIDE_PROFILE_BALANCED', '2': 0},
    {'1': 'SLIDE_PROFILE_SILENT', '2': 1},
    {'1': 'SLIDE_PROFILE_SPORT', '2': 2},
    {'1': 'SLIDE_PROFILE_ACCURACY', '2': 3},
    {'1': 'SLIDE_PROFILE_CUSTOM', '2': 4},
    {'1': 'SLIDE_PROFILE_FLUID', '2': 5},
    {'1': 'SLIDE_PROFILE_CUSTOM_1', '2': 6},
    {'1': 'SLIDE_PROFILE_CUSTOM_2', '2': 7},
    {'1': 'SLIDE_PROFILE_RAW', '2': 8},
    {'1': 'SLIDE_PROFILE_PURE', '2': 9},
  ],
};

/// Descriptor for `SlideProfile`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List slideProfileDescriptor = $convert.base64Decode(
    'CgxTbGlkZVByb2ZpbGUSGgoWU0xJREVfUFJPRklMRV9CQUxBTkNFRBAAEhgKFFNMSURFX1BST0'
    'ZJTEVfU0lMRU5UEAESFwoTU0xJREVfUFJPRklMRV9TUE9SVBACEhoKFlNMSURFX1BST0ZJTEVf'
    'QUNDVVJBQ1kQAxIYChRTTElERV9QUk9GSUxFX0NVU1RPTRAEEhcKE1NMSURFX1BST0ZJTEVfRk'
    'xVSUQQBRIaChZTTElERV9QUk9GSUxFX0NVU1RPTV8xEAYSGgoWU0xJREVfUFJPRklMRV9DVVNU'
    'T01fMhAHEhUKEVNMSURFX1BST0ZJTEVfUkFXEAgSFgoSU0xJREVfUFJPRklMRV9QVVJFEAk=');

@$core.Deprecated('Use slideDiagStateDescriptor instead')
const SlideDiagState$json = {
  '1': 'SlideDiagState',
  '2': [
    {'1': 'SLIDE_DIAG_STATE_DISABLED', '2': 0},
    {'1': 'SLIDE_DIAG_STATE_RUNNING', '2': 1},
    {'1': 'SLIDE_DIAG_STATE_STOPPED', '2': 2},
  ],
};

/// Descriptor for `SlideDiagState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List slideDiagStateDescriptor = $convert.base64Decode(
    'Cg5TbGlkZURpYWdTdGF0ZRIdChlTTElERV9ESUFHX1NUQVRFX0RJU0FCTEVEEAASHAoYU0xJRE'
    'VfRElBR19TVEFURV9SVU5OSU5HEAESHAoYU0xJREVfRElBR19TVEFURV9TVE9QUEVEEAI=');

@$core.Deprecated('Use sensorNotificationModeDescriptor instead')
const SensorNotificationMode$json = {
  '1': 'SensorNotificationMode',
  '2': [
    {'1': 'SENSOR_NOTIFICATION_MODE_ON_CHANGE', '2': 0},
    {'1': 'SENSOR_NOTIFICATION_MODE_ON_INTERVAL', '2': 1},
  ],
};

/// Descriptor for `SensorNotificationMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List sensorNotificationModeDescriptor = $convert.base64Decode(
    'ChZTZW5zb3JOb3RpZmljYXRpb25Nb2RlEiYKIlNFTlNPUl9OT1RJRklDQVRJT05fTU9ERV9PTl'
    '9DSEFOR0UQABIoCiRTRU5TT1JfTk9USUZJQ0FUSU9OX01PREVfT05fSU5URVJWQUwQAQ==');

@$core.Deprecated('Use memsPositionMethodDescriptor instead')
const MemsPositionMethod$json = {
  '1': 'MemsPositionMethod',
  '2': [
    {'1': 'MEMS_POSITION_HIGHEST', '2': 0},
    {'1': 'MEMS_POSITION_HIGHEST_INTERP', '2': 1},
    {'1': 'MEMS_POSITION_CENTROID', '2': 2},
    {'1': 'MEMS_POSITION_PEAK', '2': 3},
  ],
};

/// Descriptor for `MemsPositionMethod`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List memsPositionMethodDescriptor = $convert.base64Decode(
    'ChJNZW1zUG9zaXRpb25NZXRob2QSGQoVTUVNU19QT1NJVElPTl9ISUdIRVNUEAASIAocTUVNU1'
    '9QT1NJVElPTl9ISUdIRVNUX0lOVEVSUBABEhoKFk1FTVNfUE9TSVRJT05fQ0VOVFJPSUQQAhIW'
    'ChJNRU1TX1BPU0lUSU9OX1BFQUsQAw==');

@$core.Deprecated('Use memsTestTypeDescriptor instead')
const MemsTestType$json = {
  '1': 'MemsTestType',
  '2': [
    {'1': 'MEMS_TEST_BENCH', '2': 0},
    {'1': 'MEMS_TEST_FIFO', '2': 1},
  ],
};

/// Descriptor for `MemsTestType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List memsTestTypeDescriptor = $convert.base64Decode(
    'CgxNZW1zVGVzdFR5cGUSEwoPTUVNU19URVNUX0JFTkNIEAASEgoOTUVNU19URVNUX0ZJRk8QAQ'
    '==');

@$core.Deprecated('Use memsTestStateDescriptor instead')
const MemsTestState$json = {
  '1': 'MemsTestState',
  '2': [
    {'1': 'MEMS_TEST_STATE_IDLE', '2': 0},
    {'1': 'MEMS_TEST_STATE_RUNNING', '2': 1},
    {'1': 'MEMS_TEST_STATE_DONE', '2': 2},
    {'1': 'MEMS_TEST_STATE_FAILED', '2': 3},
  ],
};

/// Descriptor for `MemsTestState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List memsTestStateDescriptor = $convert.base64Decode(
    'Cg1NZW1zVGVzdFN0YXRlEhgKFE1FTVNfVEVTVF9TVEFURV9JRExFEAASGwoXTUVNU19URVNUX1'
    'NUQVRFX1JVTk5JTkcQARIYChRNRU1TX1RFU1RfU1RBVEVfRE9ORRACEhoKFk1FTVNfVEVTVF9T'
    'VEFURV9GQUlMRUQQAw==');

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
    {
      '1': 'access',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.HrppPatternAccess',
      '10': 'access'
    },
  ],
};

/// Descriptor for `HrppPattern`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hrppPatternDescriptor = $convert.base64Decode(
    'CgtIcnBwUGF0dGVybhIOCgJpZBgBIAEoDVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIYCgd2ZX'
    'JzaW9uGAMgASgNUgd2ZXJzaW9uEiUKDmN1c3RvbV9wYXR0ZXJuGAQgASgIUg1jdXN0b21QYXR0'
    'ZXJuEhIKBHNsb3QYBSABKA1SBHNsb3QSLAoEdHlwZRgGIAEoDjIYLmhkeV9ycGMuSHJwcFBhdH'
    'Rlcm5UeXBlUgR0eXBlEigKEHBhdXNlX3JhbmRvbV9taW4YByABKA1SDnBhdXNlUmFuZG9tTWlu'
    'EigKEHBhdXNlX3JhbmRvbV9tYXgYCCABKA1SDnBhdXNlUmFuZG9tTWF4EjIKBmFjY2VzcxgJIA'
    'EoDjIaLmhkeV9ycGMuSHJwcFBhdHRlcm5BY2Nlc3NSBmFjY2Vzcw==');

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
    {'1': 'amplitude', '3': 5, '4': 1, '5': 2, '10': 'amplitude'},
    {'1': 'playback_rate', '3': 7, '4': 1, '5': 2, '10': 'playbackRate'},
    {
      '1': 'play_state',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.HrppPlayState',
      '10': 'playState'
    },
  ],
};

/// Descriptor for `HrppState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hrppStateDescriptor = $convert.base64Decode(
    'CglIcnBwU3RhdGUSLAoSY3VycmVudF9wYXR0ZXJuX25yGAEgASgNUhBjdXJyZW50UGF0dGVybk'
    '5yEj0KD2N1cnJlbnRfcGF0dGVybhgCIAEoCzIULmhkeV9ycGMuSHJwcFBhdHRlcm5SDmN1cnJl'
    'bnRQYXR0ZXJuEiQKDm5yX29mX3BhdHRlcm5zGAMgASgNUgxuck9mUGF0dGVybnMSHAoJYW1wbG'
    'l0dWRlGAUgASgCUglhbXBsaXR1ZGUSIwoNcGxheWJhY2tfcmF0ZRgHIAEoAlIMcGxheWJhY2tS'
    'YXRlEjUKCnBsYXlfc3RhdGUYCCABKA4yFi5oZHlfcnBjLkhycHBQbGF5U3RhdGVSCXBsYXlTdG'
    'F0ZQ==');

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
    {'1': 'jitter_filter', '3': 14, '4': 1, '5': 8, '10': 'jitterFilter'},
    {
      '1': 'jitter_filter_threshold_mm',
      '3': 15,
      '4': 1,
      '5': 2,
      '10': 'jitterFilterThresholdMm'
    },
    {'1': 'script_speed', '3': 16, '4': 1, '5': 8, '10': 'scriptSpeed'},
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
    '5fc3RhcnZpbmcYDSABKAhSD3BhdXNlT25TdGFydmluZxIjCg1qaXR0ZXJfZmlsdGVyGA4gASgI'
    'UgxqaXR0ZXJGaWx0ZXISOwoaaml0dGVyX2ZpbHRlcl90aHJlc2hvbGRfbW0YDyABKAJSF2ppdH'
    'RlckZpbHRlclRocmVzaG9sZE1tEiEKDHNjcmlwdF9zcGVlZBgQIAEoCFILc2NyaXB0U3BlZWQ=');

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

@$core.Deprecated('Use speedStatsBucketDescriptor instead')
const SpeedStatsBucket$json = {
  '1': 'SpeedStatsBucket',
  '2': [
    {'1': 'samples', '3': 1, '4': 1, '5': 13, '10': 'samples'},
    {'1': 'avg_speed', '3': 2, '4': 1, '5': 2, '10': 'avgSpeed'},
    {'1': 'avg_target_speed', '3': 3, '4': 1, '5': 2, '10': 'avgTargetSpeed'},
    {'1': 'avg_motor', '3': 4, '4': 1, '5': 2, '10': 'avgMotor'},
    {'1': 'avg_trim', '3': 5, '4': 1, '5': 2, '10': 'avgTrim'},
    {
      '1': 'avg_abs_speed_error',
      '3': 6,
      '4': 1,
      '5': 2,
      '10': 'avgAbsSpeedError'
    },
  ],
};

/// Descriptor for `SpeedStatsBucket`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List speedStatsBucketDescriptor = $convert.base64Decode(
    'ChBTcGVlZFN0YXRzQnVja2V0EhgKB3NhbXBsZXMYASABKA1SB3NhbXBsZXMSGwoJYXZnX3NwZW'
    'VkGAIgASgCUghhdmdTcGVlZBIoChBhdmdfdGFyZ2V0X3NwZWVkGAMgASgCUg5hdmdUYXJnZXRT'
    'cGVlZBIbCglhdmdfbW90b3IYBCABKAJSCGF2Z01vdG9yEhkKCGF2Z190cmltGAUgASgCUgdhdm'
    'dUcmltEi0KE2F2Z19hYnNfc3BlZWRfZXJyb3IYBiABKAJSEGF2Z0Fic1NwZWVkRXJyb3I=');

@$core.Deprecated('Use speedStatsDescriptor instead')
const SpeedStats$json = {
  '1': 'SpeedStats',
  '2': [
    {'1': 'seq', '3': 1, '4': 1, '5': 13, '10': 'seq'},
    {'1': 'window_ms', '3': 2, '4': 1, '5': 13, '10': 'windowMs'},
    {'1': 'end_time_us', '3': 3, '4': 1, '5': 4, '10': 'endTimeUs'},
    {
      '1': 'backward',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.SpeedStatsBucket',
      '10': 'backward'
    },
    {
      '1': 'forward',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.SpeedStatsBucket',
      '10': 'forward'
    },
    {
      '1': 'combined',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.SpeedStatsBucket',
      '10': 'combined'
    },
  ],
};

/// Descriptor for `SpeedStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List speedStatsDescriptor = $convert.base64Decode(
    'CgpTcGVlZFN0YXRzEhAKA3NlcRgBIAEoDVIDc2VxEhsKCXdpbmRvd19tcxgCIAEoDVIId2luZG'
    '93TXMSHgoLZW5kX3RpbWVfdXMYAyABKARSCWVuZFRpbWVVcxI1CghiYWNrd2FyZBgEIAEoCzIZ'
    'LmhkeV9ycGMuU3BlZWRTdGF0c0J1Y2tldFIIYmFja3dhcmQSMwoHZm9yd2FyZBgFIAEoCzIZLm'
    'hkeV9ycGMuU3BlZWRTdGF0c0J1Y2tldFIHZm9yd2FyZBI1Cghjb21iaW5lZBgGIAEoCzIZLmhk'
    'eV9ycGMuU3BlZWRTdGF0c0J1Y2tldFIIY29tYmluZWQ=');

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

@$core.Deprecated('Use connectedDeviceInfoDescriptor instead')
const ConnectedDeviceInfo$json = {
  '1': 'ConnectedDeviceInfo',
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
    {'1': 'has_fw_status', '3': 5, '4': 1, '5': 8, '10': 'hasFwStatus'},
    {
      '1': 'fw_status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.FirmwareStatus',
      '10': 'fwStatus'
    },
    {'1': 'latest_version', '3': 7, '4': 1, '5': 9, '10': 'latestVersion'},
  ],
};

/// Descriptor for `ConnectedDeviceInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectedDeviceInfoDescriptor = $convert.base64Decode(
    'ChNDb25uZWN0ZWREZXZpY2VJbmZvEiYKD2h3X21vZGVsX251bWJlchgBIAEoDVINaHdNb2RlbE'
    '51bWJlchI1Chdod19tb2RlbF92YXJpYW50X251bWJlchgCIAEoDVIUaHdNb2RlbFZhcmlhbnRO'
    'dW1iZXISHQoKZndfdmVyc2lvbhgDIAEoCVIJZndWZXJzaW9uEigKEGZ3X2ZlYXR1cmVfZmxhZ3'
    'MYBCABKAlSDmZ3RmVhdHVyZUZsYWdzEiIKDWhhc19md19zdGF0dXMYBSABKAhSC2hhc0Z3U3Rh'
    'dHVzEjQKCWZ3X3N0YXR1cxgGIAEoDjIXLmhkeV9ycGMuRmlybXdhcmVTdGF0dXNSCGZ3U3RhdH'
    'VzEiUKDmxhdGVzdF92ZXJzaW9uGAcgASgJUg1sYXRlc3RWZXJzaW9u');

@$core.Deprecated('Use deviceDisconnectInfoDescriptor instead')
const DeviceDisconnectInfo$json = {
  '1': 'DeviceDisconnectInfo',
  '2': [
    {'1': 'reason', '3': 1, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
  ],
};

/// Descriptor for `DeviceDisconnectInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceDisconnectInfoDescriptor = $convert.base64Decode(
    'ChREZXZpY2VEaXNjb25uZWN0SW5mbxIWCgZyZWFzb24YASABKAlSBnJlYXNvbhIgCgtkZXNjcm'
    'lwdGlvbhgCIAEoCVILZGVzY3JpcHRpb24=');

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
    {
      '1': 'low_voltage_detected',
      '3': 19,
      '4': 1,
      '5': 8,
      '10': 'lowVoltageDetected'
    },
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
    'lzYWJsZWQSGgoIY2hhcmdpbmcYEiABKAhSCGNoYXJnaW5nEjAKFGxvd192b2x0YWdlX2RldGVj'
    'dGVkGBMgASgIUhJsb3dWb2x0YWdlRGV0ZWN0ZWQ=');

@$core.Deprecated('Use sensorRawDataDescriptor instead')
const SensorRawData$json = {
  '1': 'SensorRawData',
  '2': [
    {'1': 'ports', '3': 1, '4': 1, '5': 12, '10': 'ports'},
  ],
};

/// Descriptor for `SensorRawData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sensorRawDataDescriptor = $convert
    .base64Decode('Cg1TZW5zb3JSYXdEYXRhEhQKBXBvcnRzGAEgASgMUgVwb3J0cw==');

@$core.Deprecated('Use sensorPositionAbsDescriptor instead')
const SensorPositionAbs$json = {
  '1': 'SensorPositionAbs',
  '2': [
    {'1': 'master', '3': 1, '4': 1, '5': 2, '10': 'master'},
    {'1': 'side_a', '3': 2, '4': 1, '5': 2, '10': 'sideA'},
    {'1': 'side_b', '3': 3, '4': 1, '5': 2, '10': 'sideB'},
  ],
};

/// Descriptor for `SensorPositionAbs`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sensorPositionAbsDescriptor = $convert.base64Decode(
    'ChFTZW5zb3JQb3NpdGlvbkFicxIWCgZtYXN0ZXIYASABKAJSBm1hc3RlchIVCgZzaWRlX2EYAi'
    'ABKAJSBXNpZGVBEhUKBnNpZGVfYhgDIAEoAlIFc2lkZUI=');

@$core.Deprecated('Use sensorPositionRelDescriptor instead')
const SensorPositionRel$json = {
  '1': 'SensorPositionRel',
  '2': [
    {'1': 'master', '3': 1, '4': 1, '5': 2, '10': 'master'},
    {'1': 'side_a', '3': 2, '4': 1, '5': 2, '10': 'sideA'},
    {'1': 'side_b', '3': 3, '4': 1, '5': 2, '10': 'sideB'},
  ],
};

/// Descriptor for `SensorPositionRel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sensorPositionRelDescriptor = $convert.base64Decode(
    'ChFTZW5zb3JQb3NpdGlvblJlbBIWCgZtYXN0ZXIYASABKAJSBm1hc3RlchIVCgZzaWRlX2EYAi'
    'ABKAJSBXNpZGVBEhUKBnNpZGVfYhgDIAEoAlIFc2lkZUI=');

@$core.Deprecated('Use sensorStateDescriptor instead')
const SensorState$json = {
  '1': 'SensorState',
  '2': [
    {
      '1': 'raw',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.SensorRawData',
      '10': 'raw'
    },
    {'1': 'bits', '3': 2, '4': 1, '5': 4, '10': 'bits'},
    {
      '1': 'position_abs',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.SensorPositionAbs',
      '10': 'positionAbs'
    },
    {
      '1': 'position_rel',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.SensorPositionRel',
      '10': 'positionRel'
    },
    {'1': 'contact_side_a', '3': 5, '4': 1, '5': 8, '10': 'contactSideA'},
    {'1': 'contact_side_b', '3': 6, '4': 1, '5': 8, '10': 'contactSideB'},
    {'1': 'timestamp_ms', '3': 7, '4': 1, '5': 13, '10': 'timestampMs'},
    {'1': 'sleeping', '3': 8, '4': 1, '5': 8, '10': 'sleeping'},
    {
      '1': 'force',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.SensorForce',
      '10': 'force'
    },
  ],
};

/// Descriptor for `SensorState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sensorStateDescriptor = $convert.base64Decode(
    'CgtTZW5zb3JTdGF0ZRIoCgNyYXcYASABKAsyFi5oZHlfcnBjLlNlbnNvclJhd0RhdGFSA3Jhdx'
    'ISCgRiaXRzGAIgASgEUgRiaXRzEj0KDHBvc2l0aW9uX2FicxgDIAEoCzIaLmhkeV9ycGMuU2Vu'
    'c29yUG9zaXRpb25BYnNSC3Bvc2l0aW9uQWJzEj0KDHBvc2l0aW9uX3JlbBgEIAEoCzIaLmhkeV'
    '9ycGMuU2Vuc29yUG9zaXRpb25SZWxSC3Bvc2l0aW9uUmVsEiQKDmNvbnRhY3Rfc2lkZV9hGAUg'
    'ASgIUgxjb250YWN0U2lkZUESJAoOY29udGFjdF9zaWRlX2IYBiABKAhSDGNvbnRhY3RTaWRlQh'
    'IhCgx0aW1lc3RhbXBfbXMYByABKA1SC3RpbWVzdGFtcE1zEhoKCHNsZWVwaW5nGAggASgIUghz'
    'bGVlcGluZxIqCgVmb3JjZRgJIAEoCzIULmhkeV9ycGMuU2Vuc29yRm9yY2VSBWZvcmNl');

@$core.Deprecated('Use sensorForceDescriptor instead')
const SensorForce$json = {
  '1': 'SensorForce',
  '2': [
    {'1': 'force', '3': 1, '4': 3, '5': 17, '10': 'force'},
    {'1': 'present_mask', '3': 2, '4': 1, '5': 13, '10': 'presentMask'},
    {'1': 'peak', '3': 3, '4': 1, '5': 17, '10': 'peak'},
    {'1': 'peak_index', '3': 4, '4': 1, '5': 13, '10': 'peakIndex'},
    {'1': 'threshold', '3': 5, '4': 1, '5': 13, '10': 'threshold'},
    {
      '1': 'release_threshold',
      '3': 6,
      '4': 1,
      '5': 13,
      '10': 'releaseThreshold'
    },
    {'1': 'total', '3': 7, '4': 1, '5': 17, '10': 'total'},
    {
      '1': 'method',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.MemsPositionMethod',
      '10': 'method'
    },
    {'1': 'candidate_rel', '3': 9, '4': 3, '5': 2, '10': 'candidateRel'},
  ],
};

/// Descriptor for `SensorForce`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sensorForceDescriptor = $convert.base64Decode(
    'CgtTZW5zb3JGb3JjZRIUCgVmb3JjZRgBIAMoEVIFZm9yY2USIQoMcHJlc2VudF9tYXNrGAIgAS'
    'gNUgtwcmVzZW50TWFzaxISCgRwZWFrGAMgASgRUgRwZWFrEh0KCnBlYWtfaW5kZXgYBCABKA1S'
    'CXBlYWtJbmRleBIcCgl0aHJlc2hvbGQYBSABKA1SCXRocmVzaG9sZBIrChFyZWxlYXNlX3Rocm'
    'VzaG9sZBgGIAEoDVIQcmVsZWFzZVRocmVzaG9sZBIUCgV0b3RhbBgHIAEoEVIFdG90YWwSMwoG'
    'bWV0aG9kGAggASgOMhsuaGR5X3JwYy5NZW1zUG9zaXRpb25NZXRob2RSBm1ldGhvZBIjCg1jYW'
    '5kaWRhdGVfcmVsGAkgAygCUgxjYW5kaWRhdGVSZWw=');

@$core.Deprecated('Use memsSensorConfigDescriptor instead')
const MemsSensorConfig$json = {
  '1': 'MemsSensorConfig',
  '2': [
    {'1': 'rate_sps', '3': 1, '4': 1, '5': 13, '10': 'rateSps'},
    {'1': 'lpf_enabled', '3': 2, '4': 1, '5': 8, '10': 'lpfEnabled'},
    {'1': 'lpf_cutoff', '3': 3, '4': 1, '5': 13, '10': 'lpfCutoff'},
    {'1': 'fifo_enabled', '3': 4, '4': 1, '5': 8, '10': 'fifoEnabled'},
  ],
};

/// Descriptor for `MemsSensorConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List memsSensorConfigDescriptor = $convert.base64Decode(
    'ChBNZW1zU2Vuc29yQ29uZmlnEhkKCHJhdGVfc3BzGAEgASgNUgdyYXRlU3BzEh8KC2xwZl9lbm'
    'FibGVkGAIgASgIUgpscGZFbmFibGVkEh0KCmxwZl9jdXRvZmYYAyABKA1SCWxwZkN1dG9mZhIh'
    'CgxmaWZvX2VuYWJsZWQYBCABKAhSC2ZpZm9FbmFibGVk');

@$core.Deprecated('Use memsSensorInfoDescriptor instead')
const MemsSensorInfo$json = {
  '1': 'MemsSensorInfo',
  '2': [
    {'1': 'index', '3': 1, '4': 1, '5': 13, '10': 'index'},
    {'1': 'i2c_address', '3': 2, '4': 1, '5': 13, '10': 'i2cAddress'},
    {'1': 'present', '3': 3, '4': 1, '5': 8, '10': 'present'},
    {'1': 'chip_id', '3': 4, '4': 1, '5': 13, '10': 'chipId'},
    {'1': 'version', '3': 5, '4': 1, '5': 13, '10': 'version'},
    {'1': 'baseline', '3': 6, '4': 1, '5': 17, '10': 'baseline'},
    {
      '1': 'config',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.hdy_rpc.MemsSensorConfig',
      '10': 'config'
    },
  ],
};

/// Descriptor for `MemsSensorInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List memsSensorInfoDescriptor = $convert.base64Decode(
    'Cg5NZW1zU2Vuc29ySW5mbxIUCgVpbmRleBgBIAEoDVIFaW5kZXgSHwoLaTJjX2FkZHJlc3MYAi'
    'ABKA1SCmkyY0FkZHJlc3MSGAoHcHJlc2VudBgDIAEoCFIHcHJlc2VudBIXCgdjaGlwX2lkGAQg'
    'ASgNUgZjaGlwSWQSGAoHdmVyc2lvbhgFIAEoDVIHdmVyc2lvbhIaCghiYXNlbGluZRgGIAEoEV'
    'IIYmFzZWxpbmUSMQoGY29uZmlnGAcgASgLMhkuaGR5X3JwYy5NZW1zU2Vuc29yQ29uZmlnUgZj'
    'b25maWc=');

@$core.Deprecated('Use memsReadingDescriptor instead')
const MemsReading$json = {
  '1': 'MemsReading',
  '2': [
    {'1': 'index', '3': 1, '4': 1, '5': 13, '10': 'index'},
    {'1': 'ok', '3': 2, '4': 1, '5': 8, '10': 'ok'},
    {'1': 'raw', '3': 3, '4': 1, '5': 17, '10': 'raw'},
    {'1': 'force', '3': 4, '4': 1, '5': 17, '10': 'force'},
  ],
};

/// Descriptor for `MemsReading`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List memsReadingDescriptor = $convert.base64Decode(
    'CgtNZW1zUmVhZGluZxIUCgVpbmRleBgBIAEoDVIFaW5kZXgSDgoCb2sYAiABKAhSAm9rEhAKA3'
    'JhdxgDIAEoEVIDcmF3EhQKBWZvcmNlGAQgASgRUgVmb3JjZQ==');

@$core.Deprecated('Use memsSensorResultDescriptor instead')
const MemsSensorResult$json = {
  '1': 'MemsSensorResult',
  '2': [
    {'1': 'index', '3': 1, '4': 1, '5': 13, '10': 'index'},
    {'1': 'ok', '3': 2, '4': 1, '5': 8, '10': 'ok'},
    {'1': 'baseline', '3': 3, '4': 1, '5': 17, '10': 'baseline'},
  ],
};

/// Descriptor for `MemsSensorResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List memsSensorResultDescriptor = $convert.base64Decode(
    'ChBNZW1zU2Vuc29yUmVzdWx0EhQKBWluZGV4GAEgASgNUgVpbmRleBIOCgJvaxgCIAEoCFICb2'
    'sSGgoIYmFzZWxpbmUYAyABKBFSCGJhc2VsaW5l');

@$core.Deprecated('Use memsTemperatureDescriptor instead')
const MemsTemperature$json = {
  '1': 'MemsTemperature',
  '2': [
    {'1': 'index', '3': 1, '4': 1, '5': 13, '10': 'index'},
    {'1': 'ok', '3': 2, '4': 1, '5': 8, '10': 'ok'},
    {'1': 'temp_c', '3': 3, '4': 1, '5': 2, '10': 'tempC'},
  ],
};

/// Descriptor for `MemsTemperature`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List memsTemperatureDescriptor = $convert.base64Decode(
    'Cg9NZW1zVGVtcGVyYXR1cmUSFAoFaW5kZXgYASABKA1SBWluZGV4Eg4KAm9rGAIgASgIUgJvax'
    'IVCgZ0ZW1wX2MYAyABKAJSBXRlbXBD');

@$core.Deprecated('Use memsTestSensorStatsDescriptor instead')
const MemsTestSensorStats$json = {
  '1': 'MemsTestSensorStats',
  '2': [
    {'1': 'index', '3': 1, '4': 1, '5': 13, '10': 'index'},
    {'1': 'errors', '3': 2, '4': 1, '5': 13, '10': 'errors'},
    {'1': 'reads', '3': 3, '4': 1, '5': 13, '10': 'reads'},
    {'1': 'read_min_us', '3': 4, '4': 1, '5': 13, '10': 'readMinUs'},
    {'1': 'read_avg_us', '3': 5, '4': 1, '5': 13, '10': 'readAvgUs'},
    {'1': 'read_max_us', '3': 6, '4': 1, '5': 13, '10': 'readMaxUs'},
    {'1': 'samples', '3': 7, '4': 1, '5': 13, '10': 'samples'},
    {'1': 'samples_per_s', '3': 8, '4': 1, '5': 13, '10': 'samplesPerS'},
    {'1': 'full_events', '3': 9, '4': 1, '5': 13, '10': 'fullEvents'},
    {'1': 'mean_vs_adc', '3': 10, '4': 1, '5': 17, '10': 'meanVsAdc'},
  ],
};

/// Descriptor for `MemsTestSensorStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List memsTestSensorStatsDescriptor = $convert.base64Decode(
    'ChNNZW1zVGVzdFNlbnNvclN0YXRzEhQKBWluZGV4GAEgASgNUgVpbmRleBIWCgZlcnJvcnMYAi'
    'ABKA1SBmVycm9ycxIUCgVyZWFkcxgDIAEoDVIFcmVhZHMSHgoLcmVhZF9taW5fdXMYBCABKA1S'
    'CXJlYWRNaW5VcxIeCgtyZWFkX2F2Z191cxgFIAEoDVIJcmVhZEF2Z1VzEh4KC3JlYWRfbWF4X3'
    'VzGAYgASgNUglyZWFkTWF4VXMSGAoHc2FtcGxlcxgHIAEoDVIHc2FtcGxlcxIiCg1zYW1wbGVz'
    'X3Blcl9zGAggASgNUgtzYW1wbGVzUGVyUxIfCgtmdWxsX2V2ZW50cxgJIAEoDVIKZnVsbEV2ZW'
    '50cxIeCgttZWFuX3ZzX2FkYxgKIAEoEVIJbWVhblZzQWRj');

@$core.Deprecated('Use memsTestResultDescriptor instead')
const MemsTestResult$json = {
  '1': 'MemsTestResult',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.MemsTestState',
      '10': 'state'
    },
    {
      '1': 'type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.hdy_rpc.MemsTestType',
      '10': 'type'
    },
    {'1': 'sensor_mask', '3': 3, '4': 1, '5': 13, '10': 'sensorMask'},
    {'1': 'sweeps', '3': 4, '4': 1, '5': 13, '10': 'sweeps'},
    {'1': 'duration_ms', '3': 5, '4': 1, '5': 13, '10': 'durationMs'},
    {'1': 'rate_sps', '3': 6, '4': 1, '5': 13, '10': 'rateSps'},
    {'1': 'elapsed_ms', '3': 7, '4': 1, '5': 13, '10': 'elapsedMs'},
    {'1': 'errors', '3': 8, '4': 1, '5': 13, '10': 'errors'},
    {'1': 'error', '3': 9, '4': 1, '5': 9, '10': 'error'},
    {'1': 'sweep_min_us', '3': 10, '4': 1, '5': 13, '10': 'sweepMinUs'},
    {'1': 'sweep_avg_us', '3': 11, '4': 1, '5': 13, '10': 'sweepAvgUs'},
    {'1': 'sweep_max_us', '3': 12, '4': 1, '5': 13, '10': 'sweepMaxUs'},
    {'1': 'reads_per_s', '3': 13, '4': 1, '5': 13, '10': 'readsPerS'},
    {'1': 'samples_per_s', '3': 14, '4': 1, '5': 13, '10': 'samplesPerS'},
    {'1': 'bus_percent', '3': 15, '4': 1, '5': 13, '10': 'busPercent'},
    {
      '1': 'bus_us_per_sample',
      '3': 16,
      '4': 1,
      '5': 13,
      '10': 'busUsPerSample'
    },
    {'1': 'drains', '3': 17, '4': 1, '5': 13, '10': 'drains'},
    {'1': 'max_drain_words', '3': 18, '4': 1, '5': 13, '10': 'maxDrainWords'},
    {'1': 'full_events', '3': 19, '4': 1, '5': 13, '10': 'fullEvents'},
    {
      '1': 'sensors',
      '3': 20,
      '4': 3,
      '5': 11,
      '6': '.hdy_rpc.MemsTestSensorStats',
      '10': 'sensors'
    },
  ],
};

/// Descriptor for `MemsTestResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List memsTestResultDescriptor = $convert.base64Decode(
    'Cg5NZW1zVGVzdFJlc3VsdBIsCgVzdGF0ZRgBIAEoDjIWLmhkeV9ycGMuTWVtc1Rlc3RTdGF0ZV'
    'IFc3RhdGUSKQoEdHlwZRgCIAEoDjIVLmhkeV9ycGMuTWVtc1Rlc3RUeXBlUgR0eXBlEh8KC3Nl'
    'bnNvcl9tYXNrGAMgASgNUgpzZW5zb3JNYXNrEhYKBnN3ZWVwcxgEIAEoDVIGc3dlZXBzEh8KC2'
    'R1cmF0aW9uX21zGAUgASgNUgpkdXJhdGlvbk1zEhkKCHJhdGVfc3BzGAYgASgNUgdyYXRlU3Bz'
    'Eh0KCmVsYXBzZWRfbXMYByABKA1SCWVsYXBzZWRNcxIWCgZlcnJvcnMYCCABKA1SBmVycm9ycx'
    'IUCgVlcnJvchgJIAEoCVIFZXJyb3ISIAoMc3dlZXBfbWluX3VzGAogASgNUgpzd2VlcE1pblVz'
    'EiAKDHN3ZWVwX2F2Z191cxgLIAEoDVIKc3dlZXBBdmdVcxIgCgxzd2VlcF9tYXhfdXMYDCABKA'
    '1SCnN3ZWVwTWF4VXMSHgoLcmVhZHNfcGVyX3MYDSABKA1SCXJlYWRzUGVyUxIiCg1zYW1wbGVz'
    'X3Blcl9zGA4gASgNUgtzYW1wbGVzUGVyUxIfCgtidXNfcGVyY2VudBgPIAEoDVIKYnVzUGVyY2'
    'VudBIpChFidXNfdXNfcGVyX3NhbXBsZRgQIAEoDVIOYnVzVXNQZXJTYW1wbGUSFgoGZHJhaW5z'
    'GBEgASgNUgZkcmFpbnMSJgoPbWF4X2RyYWluX3dvcmRzGBIgASgNUg1tYXhEcmFpbldvcmRzEh'
    '8KC2Z1bGxfZXZlbnRzGBMgASgNUgpmdWxsRXZlbnRzEjYKB3NlbnNvcnMYFCADKAsyHC5oZHlf'
    'cnBjLk1lbXNUZXN0U2Vuc29yU3RhdHNSB3NlbnNvcnM=');

@$core.Deprecated('Use connectedDeviceDescriptor instead')
const ConnectedDevice$json = {
  '1': 'ConnectedDevice',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'serial', '3': 2, '4': 1, '5': 13, '10': 'serial'},
    {'1': 'hw_model_number', '3': 3, '4': 1, '5': 13, '10': 'hwModelNumber'},
  ],
};

/// Descriptor for `ConnectedDevice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectedDeviceDescriptor = $convert.base64Decode(
    'Cg9Db25uZWN0ZWREZXZpY2USEAoDa2V5GAEgASgJUgNrZXkSFgoGc2VyaWFsGAIgASgNUgZzZX'
    'JpYWwSJgoPaHdfbW9kZWxfbnVtYmVyGAMgASgNUg1od01vZGVsTnVtYmVy');
