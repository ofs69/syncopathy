// This is a generated file - do not edit.
//
// Generated from constants.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// NB! The codes are not in order, but in groups
class HandyErrorCodes extends $pb.ProtobufEnum {
  static const HandyErrorCodes HANDY_ERROR_CODE_PROTO2_LEGACY_COMP_DO_NOT_USE = HandyErrorCodes._(0, _omitEnumNames ? '' : 'HANDY_ERROR_CODE_PROTO2_LEGACY_COMP_DO_NOT_USE');
  static const HandyErrorCodes ERROR_UNKNOWN_REQUEST_TYPE = HandyErrorCodes._(100000, _omitEnumNames ? '' : 'ERROR_UNKNOWN_REQUEST_TYPE');
  static const HandyErrorCodes ERROR_UNKNOWN_RESPONSE_TYPE = HandyErrorCodes._(100001, _omitEnumNames ? '' : 'ERROR_UNKNOWN_RESPONSE_TYPE');
  static const HandyErrorCodes ERROR_UNKNOWN_COMMAND = HandyErrorCodes._(100002, _omitEnumNames ? '' : 'ERROR_UNKNOWN_COMMAND');
  static const HandyErrorCodes ERROR_NOT_IMPLEMENTED = HandyErrorCodes._(100003, _omitEnumNames ? '' : 'ERROR_NOT_IMPLEMENTED');
  static const HandyErrorCodes ERROR_WRONG_MODE = HandyErrorCodes._(100004, _omitEnumNames ? '' : 'ERROR_WRONG_MODE');
  static const HandyErrorCodes ERROR_TEMP_HIGH = HandyErrorCodes._(100005, _omitEnumNames ? '' : 'ERROR_TEMP_HIGH');
  static const HandyErrorCodes ERROR_SLIDER_BLOCKED = HandyErrorCodes._(100006, _omitEnumNames ? '' : 'ERROR_SLIDER_BLOCKED');
  static const HandyErrorCodes ERROR_UNKNOWN_MODE_ERROR = HandyErrorCodes._(100007, _omitEnumNames ? '' : 'ERROR_UNKNOWN_MODE_ERROR');
  static const HandyErrorCodes ERROR_TIME_NOT_SYNCED = HandyErrorCodes._(100008, _omitEnumNames ? '' : 'ERROR_TIME_NOT_SYNCED');
  static const HandyErrorCodes ERROR_NEGATIVE_NETWORK_DELAY = HandyErrorCodes._(100009, _omitEnumNames ? '' : 'ERROR_NEGATIVE_NETWORK_DELAY');
  static const HandyErrorCodes ERROR_MESSAGE_SIZE_TOO_BIG = HandyErrorCodes._(100010, _omitEnumNames ? '' : 'ERROR_MESSAGE_SIZE_TOO_BIG');
  static const HandyErrorCodes ERROR_MESSAGE_NOT_CONNECTED = HandyErrorCodes._(100011, _omitEnumNames ? '' : 'ERROR_MESSAGE_NOT_CONNECTED');
  static const HandyErrorCodes ERROR_MESSAGE_GENERIC_SERVER_ERROR = HandyErrorCodes._(100012, _omitEnumNames ? '' : 'ERROR_MESSAGE_GENERIC_SERVER_ERROR');
  static const HandyErrorCodes ERROR_MESSAGE_QUEUE_FULL = HandyErrorCodes._(100014, _omitEnumNames ? '' : 'ERROR_MESSAGE_QUEUE_FULL');
  static const HandyErrorCodes ERROR_OTA_STARTED = HandyErrorCodes._(100013, _omitEnumNames ? '' : 'ERROR_OTA_STARTED');
  static const HandyErrorCodes ERROR_OTA_QUEUE_WRITE_FAILURE = HandyErrorCodes._(100015, _omitEnumNames ? '' : 'ERROR_OTA_QUEUE_WRITE_FAILURE');
  static const HandyErrorCodes ERROR_OTA_ERROR = HandyErrorCodes._(100016, _omitEnumNames ? '' : 'ERROR_OTA_ERROR');
  static const HandyErrorCodes ERROR_OTA_MEM_ERROR = HandyErrorCodes._(100024, _omitEnumNames ? '' : 'ERROR_OTA_MEM_ERROR');
  static const HandyErrorCodes ERROR_OTA_NOT_STARTED = HandyErrorCodes._(100025, _omitEnumNames ? '' : 'ERROR_OTA_NOT_STARTED');
  static const HandyErrorCodes ERROR_FUNCTION_NOT_SUPPORTED = HandyErrorCodes._(100017, _omitEnumNames ? '' : 'ERROR_FUNCTION_NOT_SUPPORTED');
  static const HandyErrorCodes ERROR_RPC_MSG_POOL_FULL = HandyErrorCodes._(100019, _omitEnumNames ? '' : 'ERROR_RPC_MSG_POOL_FULL');
  static const HandyErrorCodes ERROR_RPC_FAILED_TO_UNPACK = HandyErrorCodes._(100020, _omitEnumNames ? '' : 'ERROR_RPC_FAILED_TO_UNPACK');
  static const HandyErrorCodes ERROR_RPC_NOT_ALLOWED_WITH_THIS_TRANSPORT_MODE = HandyErrorCodes._(100021, _omitEnumNames ? '' : 'ERROR_RPC_NOT_ALLOWED_WITH_THIS_TRANSPORT_MODE');
  static const HandyErrorCodes ERROR_RPC_NETWORK_DELAY_TOO_BIG = HandyErrorCodes._(100022, _omitEnumNames ? '' : 'ERROR_RPC_NETWORK_DELAY_TOO_BIG');
  static const HandyErrorCodes ERROR_FAIL = HandyErrorCodes._(100023, _omitEnumNames ? '' : 'ERROR_FAIL');
  static const HandyErrorCodes ERROR_HALL_SENSOR_ERROR = HandyErrorCodes._(100026, _omitEnumNames ? '' : 'ERROR_HALL_SENSOR_ERROR');
  static const HandyErrorCodes ERROR_OVERCLOCKING_NOT_SUPPORTED = HandyErrorCodes._(100027, _omitEnumNames ? '' : 'ERROR_OVERCLOCKING_NOT_SUPPORTED');
  static const HandyErrorCodes ERROR_OVERCLOCKING_IS_NOT_ENABLED = HandyErrorCodes._(100028, _omitEnumNames ? '' : 'ERROR_OVERCLOCKING_IS_NOT_ENABLED');
  /// Power OTA errors
  static const HandyErrorCodes ERROR_OTA_ERR_NO_OTA_PARTITION = HandyErrorCodes._(200001, _omitEnumNames ? '' : 'ERROR_OTA_ERR_NO_OTA_PARTITION');
  static const HandyErrorCodes ERROR_OTA_ERR_INVALID_BIN = HandyErrorCodes._(20000, _omitEnumNames ? '' : 'ERROR_OTA_ERR_INVALID_BIN');
  static const HandyErrorCodes ERROR_OTA_ERR_INVALID_PARAM = HandyErrorCodes._(200003, _omitEnumNames ? '' : 'ERROR_OTA_ERR_INVALID_PARAM');
  static const HandyErrorCodes ERROR_OTA_ERR_NEW_OTA_HAS_PREVIOUSLY_FAILED = HandyErrorCodes._(200004, _omitEnumNames ? '' : 'ERROR_OTA_ERR_NEW_OTA_HAS_PREVIOUSLY_FAILED');
  static const HandyErrorCodes ERROR_OTA_ERR_NEW_OTA_SAME_AS_CURRENT = HandyErrorCodes._(200005, _omitEnumNames ? '' : 'ERROR_OTA_ERR_NEW_OTA_SAME_AS_CURRENT');

  static const $core.List<HandyErrorCodes> values = <HandyErrorCodes> [
    HANDY_ERROR_CODE_PROTO2_LEGACY_COMP_DO_NOT_USE,
    ERROR_UNKNOWN_REQUEST_TYPE,
    ERROR_UNKNOWN_RESPONSE_TYPE,
    ERROR_UNKNOWN_COMMAND,
    ERROR_NOT_IMPLEMENTED,
    ERROR_WRONG_MODE,
    ERROR_TEMP_HIGH,
    ERROR_SLIDER_BLOCKED,
    ERROR_UNKNOWN_MODE_ERROR,
    ERROR_TIME_NOT_SYNCED,
    ERROR_NEGATIVE_NETWORK_DELAY,
    ERROR_MESSAGE_SIZE_TOO_BIG,
    ERROR_MESSAGE_NOT_CONNECTED,
    ERROR_MESSAGE_GENERIC_SERVER_ERROR,
    ERROR_MESSAGE_QUEUE_FULL,
    ERROR_OTA_STARTED,
    ERROR_OTA_QUEUE_WRITE_FAILURE,
    ERROR_OTA_ERROR,
    ERROR_OTA_MEM_ERROR,
    ERROR_OTA_NOT_STARTED,
    ERROR_FUNCTION_NOT_SUPPORTED,
    ERROR_RPC_MSG_POOL_FULL,
    ERROR_RPC_FAILED_TO_UNPACK,
    ERROR_RPC_NOT_ALLOWED_WITH_THIS_TRANSPORT_MODE,
    ERROR_RPC_NETWORK_DELAY_TOO_BIG,
    ERROR_FAIL,
    ERROR_HALL_SENSOR_ERROR,
    ERROR_OVERCLOCKING_NOT_SUPPORTED,
    ERROR_OVERCLOCKING_IS_NOT_ENABLED,
    ERROR_OTA_ERR_NO_OTA_PARTITION,
    ERROR_OTA_ERR_INVALID_BIN,
    ERROR_OTA_ERR_INVALID_PARAM,
    ERROR_OTA_ERR_NEW_OTA_HAS_PREVIOUSLY_FAILED,
    ERROR_OTA_ERR_NEW_OTA_SAME_AS_CURRENT,
  ];

  static final $core.Map<$core.int, HandyErrorCodes> _byValue = $pb.ProtobufEnum.initByValue(values);
  static HandyErrorCodes? valueOf($core.int value) => _byValue[value];

  const HandyErrorCodes._(super.value, super.name);
}

/// /////////////////////// Mode related constants /////////////////////////
class Mode extends $pb.ProtobufEnum {
  static const Mode MODE_HAMP = Mode._(0, _omitEnumNames ? '' : 'MODE_HAMP');
  static const Mode MODE_HSSP = Mode._(1, _omitEnumNames ? '' : 'MODE_HSSP');
  static const Mode MODE_HDSP = Mode._(2, _omitEnumNames ? '' : 'MODE_HDSP');
  static const Mode MODE_MAINTENANCE = Mode._(3, _omitEnumNames ? '' : 'MODE_MAINTENANCE');
  static const Mode MODE_HSP = Mode._(4, _omitEnumNames ? '' : 'MODE_HSP');
  static const Mode MODE_OTA = Mode._(5, _omitEnumNames ? '' : 'MODE_OTA');
  static const Mode MODE_BUTTON = Mode._(6, _omitEnumNames ? '' : 'MODE_BUTTON');
  static const Mode MODE_IDLE = Mode._(7, _omitEnumNames ? '' : 'MODE_IDLE');
  static const Mode MODE_HVP = Mode._(8, _omitEnumNames ? '' : 'MODE_HVP');
  static const Mode MODE_HRPP = Mode._(9, _omitEnumNames ? '' : 'MODE_HRPP');

  static const $core.List<Mode> values = <Mode> [
    MODE_HAMP,
    MODE_HSSP,
    MODE_HDSP,
    MODE_MAINTENANCE,
    MODE_HSP,
    MODE_OTA,
    MODE_BUTTON,
    MODE_IDLE,
    MODE_HVP,
    MODE_HRPP,
  ];

  static final $core.List<Mode?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 9);
  static Mode? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Mode._(super.value, super.name);
}

class HampPlayState extends $pb.ProtobufEnum {
  static const HampPlayState HAMP_STATE_STOPPED = HampPlayState._(0, _omitEnumNames ? '' : 'HAMP_STATE_STOPPED');
  static const HampPlayState HAMP_STATE_RUNNING = HampPlayState._(1, _omitEnumNames ? '' : 'HAMP_STATE_RUNNING');

  static const $core.List<HampPlayState> values = <HampPlayState> [
    HAMP_STATE_STOPPED,
    HAMP_STATE_RUNNING,
  ];

  static final $core.List<HampPlayState?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 1);
  static HampPlayState? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const HampPlayState._(super.value, super.name);
}

class HrppPatternType extends $pb.ProtobufEnum {
  static const HrppPatternType HRPP_NOT_SET = HrppPatternType._(0, _omitEnumNames ? '' : 'HRPP_NOT_SET');
  static const HrppPatternType HRPP_SCRIPT = HrppPatternType._(1, _omitEnumNames ? '' : 'HRPP_SCRIPT');
  static const HrppPatternType HRPP_WAVE = HrppPatternType._(2, _omitEnumNames ? '' : 'HRPP_WAVE');

  static const $core.List<HrppPatternType> values = <HrppPatternType> [
    HRPP_NOT_SET,
    HRPP_SCRIPT,
    HRPP_WAVE,
  ];

  static final $core.List<HrppPatternType?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 2);
  static HrppPatternType? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const HrppPatternType._(super.value, super.name);
}

class HdspPlayState extends $pb.ProtobufEnum {
  static const HdspPlayState HDSP_STATE_STOPPED = HdspPlayState._(0, _omitEnumNames ? '' : 'HDSP_STATE_STOPPED');
  static const HdspPlayState HDSP_STATE_MOVING = HdspPlayState._(1, _omitEnumNames ? '' : 'HDSP_STATE_MOVING');
  static const HdspPlayState HDSP_STATE_REACHED = HdspPlayState._(2, _omitEnumNames ? '' : 'HDSP_STATE_REACHED');

  static const $core.List<HdspPlayState> values = <HdspPlayState> [
    HDSP_STATE_STOPPED,
    HDSP_STATE_MOVING,
    HDSP_STATE_REACHED,
  ];

  static final $core.List<HdspPlayState?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 2);
  static HdspPlayState? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const HdspPlayState._(super.value, super.name);
}

/// /////////////////////// HSP constants /////////////////////////
class HspPlayState extends $pb.ProtobufEnum {
  static const HspPlayState HSP_STATE_NOT_INITIALIZED = HspPlayState._(0, _omitEnumNames ? '' : 'HSP_STATE_NOT_INITIALIZED');
  static const HspPlayState HSP_STATE_PLAYING = HspPlayState._(1, _omitEnumNames ? '' : 'HSP_STATE_PLAYING');
  static const HspPlayState HSP_STATE_STOPPED = HspPlayState._(2, _omitEnumNames ? '' : 'HSP_STATE_STOPPED');
  static const HspPlayState HSP_STATE_PAUSED = HspPlayState._(3, _omitEnumNames ? '' : 'HSP_STATE_PAUSED');
  static const HspPlayState HSP_STATE_STARVING = HspPlayState._(4, _omitEnumNames ? '' : 'HSP_STATE_STARVING');

  static const $core.List<HspPlayState> values = <HspPlayState> [
    HSP_STATE_NOT_INITIALIZED,
    HSP_STATE_PLAYING,
    HSP_STATE_STOPPED,
    HSP_STATE_PAUSED,
    HSP_STATE_STARVING,
  ];

  static final $core.List<HspPlayState?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 4);
  static HspPlayState? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const HspPlayState._(super.value, super.name);
}

/// /////////////////////// Button constants /////////////////////////
class Button extends $pb.ProtobufEnum {
  static const Button BUTTON_ON = Button._(0, _omitEnumNames ? '' : 'BUTTON_ON');
  static const Button BUTTON_UP = Button._(1, _omitEnumNames ? '' : 'BUTTON_UP');
  static const Button BUTTON_LEFT = Button._(2, _omitEnumNames ? '' : 'BUTTON_LEFT');
  static const Button BUTTON_RIGHT = Button._(3, _omitEnumNames ? '' : 'BUTTON_RIGHT');
  static const Button BUTTON_DOWN = Button._(4, _omitEnumNames ? '' : 'BUTTON_DOWN');
  static const Button BUTTON_WIFI = Button._(5, _omitEnumNames ? '' : 'BUTTON_WIFI');

  static const $core.List<Button> values = <Button> [
    BUTTON_ON,
    BUTTON_UP,
    BUTTON_LEFT,
    BUTTON_RIGHT,
    BUTTON_DOWN,
    BUTTON_WIFI,
  ];

  static final $core.List<Button?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 5);
  static Button? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Button._(super.value, super.name);
}

class ButtonEvent extends $pb.ProtobufEnum {
  static const ButtonEvent BUTTON_EVENT_PRESSED = ButtonEvent._(0, _omitEnumNames ? '' : 'BUTTON_EVENT_PRESSED');
  static const ButtonEvent BUTTON_EVENT_RELEASED = ButtonEvent._(1, _omitEnumNames ? '' : 'BUTTON_EVENT_RELEASED');
  static const ButtonEvent BUTTON_EVENT_SHORTPRESS = ButtonEvent._(2, _omitEnumNames ? '' : 'BUTTON_EVENT_SHORTPRESS');
  static const ButtonEvent BUTTON_EVENT_LONGPRESS_START = ButtonEvent._(3, _omitEnumNames ? '' : 'BUTTON_EVENT_LONGPRESS_START');
  static const ButtonEvent BUTTON_EVENT_LONGPRESS_STEP = ButtonEvent._(4, _omitEnumNames ? '' : 'BUTTON_EVENT_LONGPRESS_STEP');
  static const ButtonEvent BUTTON_EVENT_LONGPRESS_STOP = ButtonEvent._(5, _omitEnumNames ? '' : 'BUTTON_EVENT_LONGPRESS_STOP');

  static const $core.List<ButtonEvent> values = <ButtonEvent> [
    BUTTON_EVENT_PRESSED,
    BUTTON_EVENT_RELEASED,
    BUTTON_EVENT_SHORTPRESS,
    BUTTON_EVENT_LONGPRESS_START,
    BUTTON_EVENT_LONGPRESS_STEP,
    BUTTON_EVENT_LONGPRESS_STOP,
  ];

  static final $core.List<ButtonEvent?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ButtonEvent? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ButtonEvent._(super.value, super.name);
}

///
/// Excact copy of ESP_IDF wifi_auth_mode_t
class AuthModes extends $pb.ProtobufEnum {
  static const AuthModes AUTH_OPEN = AuthModes._(0, _omitEnumNames ? '' : 'AUTH_OPEN');
  static const AuthModes AUTH_WEP = AuthModes._(1, _omitEnumNames ? '' : 'AUTH_WEP');
  static const AuthModes AUTH_WPA_PSK = AuthModes._(2, _omitEnumNames ? '' : 'AUTH_WPA_PSK');
  static const AuthModes AUTH_WPA2_PSK = AuthModes._(3, _omitEnumNames ? '' : 'AUTH_WPA2_PSK');
  static const AuthModes AUTH_WPA_WPA2_PSK = AuthModes._(4, _omitEnumNames ? '' : 'AUTH_WPA_WPA2_PSK');
  static const AuthModes AUTH_WPA2_ENTERPRISE = AuthModes._(5, _omitEnumNames ? '' : 'AUTH_WPA2_ENTERPRISE');
  static const AuthModes AUTH_WPA3_PSK = AuthModes._(6, _omitEnumNames ? '' : 'AUTH_WPA3_PSK');
  static const AuthModes AUTH_WPA2_WPA3_PSK = AuthModes._(7, _omitEnumNames ? '' : 'AUTH_WPA2_WPA3_PSK');
  static const AuthModes AUTH_WAPI_PSK = AuthModes._(8, _omitEnumNames ? '' : 'AUTH_WAPI_PSK');
  static const AuthModes AUTH_OWE = AuthModes._(9, _omitEnumNames ? '' : 'AUTH_OWE');
  static const AuthModes AUTH_MAX = AuthModes._(10, _omitEnumNames ? '' : 'AUTH_MAX');

  static const $core.List<AuthModes> values = <AuthModes> [
    AUTH_OPEN,
    AUTH_WEP,
    AUTH_WPA_PSK,
    AUTH_WPA2_PSK,
    AUTH_WPA_WPA2_PSK,
    AUTH_WPA2_ENTERPRISE,
    AUTH_WPA3_PSK,
    AUTH_WPA2_WPA3_PSK,
    AUTH_WAPI_PSK,
    AUTH_OWE,
    AUTH_MAX,
  ];

  static final $core.List<AuthModes?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 10);
  static AuthModes? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AuthModes._(super.value, super.name);
}

/// Matches hdyWifiConnectionStatus_t (does not matches the legacy protobuf enum from espresif)
class WifiState extends $pb.ProtobufEnum {
  static const WifiState WIFI_STATE_DISCONNECTED = WifiState._(0, _omitEnumNames ? '' : 'WIFI_STATE_DISCONNECTED');
  static const WifiState WIFI_STATE_CONNECTED = WifiState._(1, _omitEnumNames ? '' : 'WIFI_STATE_CONNECTED');
  static const WifiState WIFI_STATE_CONNECTING = WifiState._(2, _omitEnumNames ? '' : 'WIFI_STATE_CONNECTING');
  static const WifiState WIFI_STATE_RECONNECTING = WifiState._(3, _omitEnumNames ? '' : 'WIFI_STATE_RECONNECTING');
  static const WifiState WIFI_STATE_FAILED_TO_CONNECT = WifiState._(4, _omitEnumNames ? '' : 'WIFI_STATE_FAILED_TO_CONNECT');
  static const WifiState WIFI_STATE_DISCONNECTING = WifiState._(5, _omitEnumNames ? '' : 'WIFI_STATE_DISCONNECTING');

  static const $core.List<WifiState> values = <WifiState> [
    WIFI_STATE_DISCONNECTED,
    WIFI_STATE_CONNECTED,
    WIFI_STATE_CONNECTING,
    WIFI_STATE_RECONNECTING,
    WIFI_STATE_FAILED_TO_CONNECT,
    WIFI_STATE_DISCONNECTING,
  ];

  static final $core.List<WifiState?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 5);
  static WifiState? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const WifiState._(super.value, super.name);
}

///
/// Excact copy of ESP_IDF wifi_err_reason_t (except for the first one)
class WifiFailedReason extends $pb.ProtobufEnum {
  static const WifiFailedReason WIFI_REASON_DO_NOT_USE = WifiFailedReason._(0, _omitEnumNames ? '' : 'WIFI_REASON_DO_NOT_USE');
  static const WifiFailedReason WIFI_REASON_UNSPECIFIED = WifiFailedReason._(1, _omitEnumNames ? '' : 'WIFI_REASON_UNSPECIFIED');
  static const WifiFailedReason WIFI_REASON_AUTH_EXPIRE = WifiFailedReason._(2, _omitEnumNames ? '' : 'WIFI_REASON_AUTH_EXPIRE');
  static const WifiFailedReason WIFI_REASON_AUTH_LEAVE = WifiFailedReason._(3, _omitEnumNames ? '' : 'WIFI_REASON_AUTH_LEAVE');
  static const WifiFailedReason WIFI_REASON_ASSOC_EXPIRE = WifiFailedReason._(4, _omitEnumNames ? '' : 'WIFI_REASON_ASSOC_EXPIRE');
  static const WifiFailedReason WIFI_REASON_ASSOC_TOOMANY = WifiFailedReason._(5, _omitEnumNames ? '' : 'WIFI_REASON_ASSOC_TOOMANY');
  static const WifiFailedReason WIFI_REASON_NOT_AUTHED = WifiFailedReason._(6, _omitEnumNames ? '' : 'WIFI_REASON_NOT_AUTHED');
  static const WifiFailedReason WIFI_REASON_NOT_ASSOCED = WifiFailedReason._(7, _omitEnumNames ? '' : 'WIFI_REASON_NOT_ASSOCED');
  static const WifiFailedReason WIFI_REASON_ASSOC_LEAVE = WifiFailedReason._(8, _omitEnumNames ? '' : 'WIFI_REASON_ASSOC_LEAVE');
  static const WifiFailedReason WIFI_REASON_ASSOC_NOT_AUTHED = WifiFailedReason._(9, _omitEnumNames ? '' : 'WIFI_REASON_ASSOC_NOT_AUTHED');
  static const WifiFailedReason WIFI_REASON_DISASSOC_PWRCAP_BAD = WifiFailedReason._(10, _omitEnumNames ? '' : 'WIFI_REASON_DISASSOC_PWRCAP_BAD');
  static const WifiFailedReason WIFI_REASON_DISASSOC_SUPCHAN_BAD = WifiFailedReason._(11, _omitEnumNames ? '' : 'WIFI_REASON_DISASSOC_SUPCHAN_BAD');
  static const WifiFailedReason WIFI_REASON_BSS_TRANSITION_DISASSOC = WifiFailedReason._(12, _omitEnumNames ? '' : 'WIFI_REASON_BSS_TRANSITION_DISASSOC');
  static const WifiFailedReason WIFI_REASON_IE_INVALID = WifiFailedReason._(13, _omitEnumNames ? '' : 'WIFI_REASON_IE_INVALID');
  static const WifiFailedReason WIFI_REASON_MIC_FAILURE = WifiFailedReason._(14, _omitEnumNames ? '' : 'WIFI_REASON_MIC_FAILURE');
  static const WifiFailedReason WIFI_REASON_4WAY_HANDSHAKE_TIMEOUT = WifiFailedReason._(15, _omitEnumNames ? '' : 'WIFI_REASON_4WAY_HANDSHAKE_TIMEOUT');
  static const WifiFailedReason WIFI_REASON_GROUP_KEY_UPDATE_TIMEOUT = WifiFailedReason._(16, _omitEnumNames ? '' : 'WIFI_REASON_GROUP_KEY_UPDATE_TIMEOUT');
  static const WifiFailedReason WIFI_REASON_IE_IN_4WAY_DIFFERS = WifiFailedReason._(17, _omitEnumNames ? '' : 'WIFI_REASON_IE_IN_4WAY_DIFFERS');
  static const WifiFailedReason WIFI_REASON_GROUP_CIPHER_INVALID = WifiFailedReason._(18, _omitEnumNames ? '' : 'WIFI_REASON_GROUP_CIPHER_INVALID');
  static const WifiFailedReason WIFI_REASON_PAIRWISE_CIPHER_INVALID = WifiFailedReason._(19, _omitEnumNames ? '' : 'WIFI_REASON_PAIRWISE_CIPHER_INVALID');
  static const WifiFailedReason WIFI_REASON_AKMP_INVALID = WifiFailedReason._(20, _omitEnumNames ? '' : 'WIFI_REASON_AKMP_INVALID');
  static const WifiFailedReason WIFI_REASON_UNSUPP_RSN_IE_VERSION = WifiFailedReason._(21, _omitEnumNames ? '' : 'WIFI_REASON_UNSUPP_RSN_IE_VERSION');
  static const WifiFailedReason WIFI_REASON_INVALID_RSN_IE_CAP = WifiFailedReason._(22, _omitEnumNames ? '' : 'WIFI_REASON_INVALID_RSN_IE_CAP');
  static const WifiFailedReason WIFI_REASON_802_1X_AUTH_FAILED = WifiFailedReason._(23, _omitEnumNames ? '' : 'WIFI_REASON_802_1X_AUTH_FAILED');
  static const WifiFailedReason WIFI_REASON_CIPHER_SUITE_REJECTED = WifiFailedReason._(24, _omitEnumNames ? '' : 'WIFI_REASON_CIPHER_SUITE_REJECTED');
  static const WifiFailedReason WIFI_REASON_TDLS_PEER_UNREACHABLE = WifiFailedReason._(25, _omitEnumNames ? '' : 'WIFI_REASON_TDLS_PEER_UNREACHABLE');
  static const WifiFailedReason WIFI_REASON_TDLS_UNSPECIFIED = WifiFailedReason._(26, _omitEnumNames ? '' : 'WIFI_REASON_TDLS_UNSPECIFIED');
  static const WifiFailedReason WIFI_REASON_SSP_REQUESTED_DISASSOC = WifiFailedReason._(27, _omitEnumNames ? '' : 'WIFI_REASON_SSP_REQUESTED_DISASSOC');
  static const WifiFailedReason WIFI_REASON_NO_SSP_ROAMING_AGREEMENT = WifiFailedReason._(28, _omitEnumNames ? '' : 'WIFI_REASON_NO_SSP_ROAMING_AGREEMENT');
  static const WifiFailedReason WIFI_REASON_BAD_CIPHER_OR_AKM = WifiFailedReason._(29, _omitEnumNames ? '' : 'WIFI_REASON_BAD_CIPHER_OR_AKM');
  static const WifiFailedReason WIFI_REASON_NOT_AUTHORIZED_THIS_LOCATION = WifiFailedReason._(30, _omitEnumNames ? '' : 'WIFI_REASON_NOT_AUTHORIZED_THIS_LOCATION');
  static const WifiFailedReason WIFI_REASON_SERVICE_CHANGE_PERCLUDES_TS = WifiFailedReason._(31, _omitEnumNames ? '' : 'WIFI_REASON_SERVICE_CHANGE_PERCLUDES_TS');
  static const WifiFailedReason WIFI_REASON_UNSPECIFIED_QOS = WifiFailedReason._(32, _omitEnumNames ? '' : 'WIFI_REASON_UNSPECIFIED_QOS');
  static const WifiFailedReason WIFI_REASON_NOT_ENOUGH_BANDWIDTH = WifiFailedReason._(33, _omitEnumNames ? '' : 'WIFI_REASON_NOT_ENOUGH_BANDWIDTH');
  static const WifiFailedReason WIFI_REASON_MISSING_ACKS = WifiFailedReason._(34, _omitEnumNames ? '' : 'WIFI_REASON_MISSING_ACKS');
  static const WifiFailedReason WIFI_REASON_EXCEEDED_TXOP = WifiFailedReason._(35, _omitEnumNames ? '' : 'WIFI_REASON_EXCEEDED_TXOP');
  static const WifiFailedReason WIFI_REASON_STA_LEAVING = WifiFailedReason._(36, _omitEnumNames ? '' : 'WIFI_REASON_STA_LEAVING');
  static const WifiFailedReason WIFI_REASON_END_BA = WifiFailedReason._(37, _omitEnumNames ? '' : 'WIFI_REASON_END_BA');
  static const WifiFailedReason WIFI_REASON_UNKNOWN_BA = WifiFailedReason._(38, _omitEnumNames ? '' : 'WIFI_REASON_UNKNOWN_BA');
  static const WifiFailedReason WIFI_REASON_TIMEOUT = WifiFailedReason._(39, _omitEnumNames ? '' : 'WIFI_REASON_TIMEOUT');
  static const WifiFailedReason WIFI_REASON_PEER_INITIATED = WifiFailedReason._(46, _omitEnumNames ? '' : 'WIFI_REASON_PEER_INITIATED');
  static const WifiFailedReason WIFI_REASON_AP_INITIATED = WifiFailedReason._(47, _omitEnumNames ? '' : 'WIFI_REASON_AP_INITIATED');
  static const WifiFailedReason WIFI_REASON_INVALID_FT_ACTION_FRAME_COUNT = WifiFailedReason._(48, _omitEnumNames ? '' : 'WIFI_REASON_INVALID_FT_ACTION_FRAME_COUNT');
  static const WifiFailedReason WIFI_REASON_INVALID_PMKID = WifiFailedReason._(49, _omitEnumNames ? '' : 'WIFI_REASON_INVALID_PMKID');
  static const WifiFailedReason WIFI_REASON_INVALID_MDE = WifiFailedReason._(50, _omitEnumNames ? '' : 'WIFI_REASON_INVALID_MDE');
  static const WifiFailedReason WIFI_REASON_INVALID_FTE = WifiFailedReason._(51, _omitEnumNames ? '' : 'WIFI_REASON_INVALID_FTE');
  static const WifiFailedReason WIFI_REASON_TRANSMISSION_LINK_ESTABLISH_FAILED = WifiFailedReason._(67, _omitEnumNames ? '' : 'WIFI_REASON_TRANSMISSION_LINK_ESTABLISH_FAILED');
  static const WifiFailedReason WIFI_REASON_ALTERATIVE_CHANNEL_OCCUPIED = WifiFailedReason._(68, _omitEnumNames ? '' : 'WIFI_REASON_ALTERATIVE_CHANNEL_OCCUPIED');
  static const WifiFailedReason WIFI_REASON_BEACON_TIMEOUT = WifiFailedReason._(200, _omitEnumNames ? '' : 'WIFI_REASON_BEACON_TIMEOUT');
  static const WifiFailedReason WIFI_REASON_NO_AP_FOUND = WifiFailedReason._(201, _omitEnumNames ? '' : 'WIFI_REASON_NO_AP_FOUND');
  static const WifiFailedReason WIFI_REASON_AUTH_FAIL = WifiFailedReason._(202, _omitEnumNames ? '' : 'WIFI_REASON_AUTH_FAIL');
  static const WifiFailedReason WIFI_REASON_ASSOC_FAIL = WifiFailedReason._(203, _omitEnumNames ? '' : 'WIFI_REASON_ASSOC_FAIL');
  static const WifiFailedReason WIFI_REASON_HANDSHAKE_TIMEOUT = WifiFailedReason._(204, _omitEnumNames ? '' : 'WIFI_REASON_HANDSHAKE_TIMEOUT');
  static const WifiFailedReason WIFI_REASON_CONNECTION_FAIL = WifiFailedReason._(205, _omitEnumNames ? '' : 'WIFI_REASON_CONNECTION_FAIL');
  static const WifiFailedReason WIFI_REASON_AP_TSF_RESET = WifiFailedReason._(206, _omitEnumNames ? '' : 'WIFI_REASON_AP_TSF_RESET');
  static const WifiFailedReason WIFI_REASON_ROAMING = WifiFailedReason._(207, _omitEnumNames ? '' : 'WIFI_REASON_ROAMING');
  static const WifiFailedReason WIFI_REASON_ASSOC_COMEBACK_TIME_TOO_LONG = WifiFailedReason._(208, _omitEnumNames ? '' : 'WIFI_REASON_ASSOC_COMEBACK_TIME_TOO_LONG');
  static const WifiFailedReason WIFI_REASON_SA_QUERY_TIMEOUT = WifiFailedReason._(209, _omitEnumNames ? '' : 'WIFI_REASON_SA_QUERY_TIMEOUT');

  static const $core.List<WifiFailedReason> values = <WifiFailedReason> [
    WIFI_REASON_DO_NOT_USE,
    WIFI_REASON_UNSPECIFIED,
    WIFI_REASON_AUTH_EXPIRE,
    WIFI_REASON_AUTH_LEAVE,
    WIFI_REASON_ASSOC_EXPIRE,
    WIFI_REASON_ASSOC_TOOMANY,
    WIFI_REASON_NOT_AUTHED,
    WIFI_REASON_NOT_ASSOCED,
    WIFI_REASON_ASSOC_LEAVE,
    WIFI_REASON_ASSOC_NOT_AUTHED,
    WIFI_REASON_DISASSOC_PWRCAP_BAD,
    WIFI_REASON_DISASSOC_SUPCHAN_BAD,
    WIFI_REASON_BSS_TRANSITION_DISASSOC,
    WIFI_REASON_IE_INVALID,
    WIFI_REASON_MIC_FAILURE,
    WIFI_REASON_4WAY_HANDSHAKE_TIMEOUT,
    WIFI_REASON_GROUP_KEY_UPDATE_TIMEOUT,
    WIFI_REASON_IE_IN_4WAY_DIFFERS,
    WIFI_REASON_GROUP_CIPHER_INVALID,
    WIFI_REASON_PAIRWISE_CIPHER_INVALID,
    WIFI_REASON_AKMP_INVALID,
    WIFI_REASON_UNSUPP_RSN_IE_VERSION,
    WIFI_REASON_INVALID_RSN_IE_CAP,
    WIFI_REASON_802_1X_AUTH_FAILED,
    WIFI_REASON_CIPHER_SUITE_REJECTED,
    WIFI_REASON_TDLS_PEER_UNREACHABLE,
    WIFI_REASON_TDLS_UNSPECIFIED,
    WIFI_REASON_SSP_REQUESTED_DISASSOC,
    WIFI_REASON_NO_SSP_ROAMING_AGREEMENT,
    WIFI_REASON_BAD_CIPHER_OR_AKM,
    WIFI_REASON_NOT_AUTHORIZED_THIS_LOCATION,
    WIFI_REASON_SERVICE_CHANGE_PERCLUDES_TS,
    WIFI_REASON_UNSPECIFIED_QOS,
    WIFI_REASON_NOT_ENOUGH_BANDWIDTH,
    WIFI_REASON_MISSING_ACKS,
    WIFI_REASON_EXCEEDED_TXOP,
    WIFI_REASON_STA_LEAVING,
    WIFI_REASON_END_BA,
    WIFI_REASON_UNKNOWN_BA,
    WIFI_REASON_TIMEOUT,
    WIFI_REASON_PEER_INITIATED,
    WIFI_REASON_AP_INITIATED,
    WIFI_REASON_INVALID_FT_ACTION_FRAME_COUNT,
    WIFI_REASON_INVALID_PMKID,
    WIFI_REASON_INVALID_MDE,
    WIFI_REASON_INVALID_FTE,
    WIFI_REASON_TRANSMISSION_LINK_ESTABLISH_FAILED,
    WIFI_REASON_ALTERATIVE_CHANNEL_OCCUPIED,
    WIFI_REASON_BEACON_TIMEOUT,
    WIFI_REASON_NO_AP_FOUND,
    WIFI_REASON_AUTH_FAIL,
    WIFI_REASON_ASSOC_FAIL,
    WIFI_REASON_HANDSHAKE_TIMEOUT,
    WIFI_REASON_CONNECTION_FAIL,
    WIFI_REASON_AP_TSF_RESET,
    WIFI_REASON_ROAMING,
    WIFI_REASON_ASSOC_COMEBACK_TIME_TOO_LONG,
    WIFI_REASON_SA_QUERY_TIMEOUT,
  ];

  static final $core.Map<$core.int, WifiFailedReason> _byValue = $pb.ProtobufEnum.initByValue(values);
  static WifiFailedReason? valueOf($core.int value) => _byValue[value];

  const WifiFailedReason._(super.value, super.name);
}

///
/// Must match typedef enum hdyConfigConnection_t
class ConnectionMode extends $pb.ProtobufEnum {
  static const ConnectionMode CONNECTION_MODE_NOT_SET = ConnectionMode._(0, _omitEnumNames ? '' : 'CONNECTION_MODE_NOT_SET');
  static const ConnectionMode CONNECTION_MODE_WIFI = ConnectionMode._(1, _omitEnumNames ? '' : 'CONNECTION_MODE_WIFI');
  static const ConnectionMode CONNECTION_MODE_BLE = ConnectionMode._(2, _omitEnumNames ? '' : 'CONNECTION_MODE_BLE');
  static const ConnectionMode CONNECTION_MODE_WIFI_AND_BLE = ConnectionMode._(3, _omitEnumNames ? '' : 'CONNECTION_MODE_WIFI_AND_BLE');
  static const ConnectionMode CONNECTION_MODE_OFFLINE = ConnectionMode._(4, _omitEnumNames ? '' : 'CONNECTION_MODE_OFFLINE');
  static const ConnectionMode CONNECTION_MODE_LEGACY_BLE = ConnectionMode._(5, _omitEnumNames ? '' : 'CONNECTION_MODE_LEGACY_BLE');
  static const ConnectionMode CONNECTION_MODE_FACTORY = ConnectionMode._(6, _omitEnumNames ? '' : 'CONNECTION_MODE_FACTORY');
  static const ConnectionMode CONNECTION_MODE_AUDIO = ConnectionMode._(7, _omitEnumNames ? '' : 'CONNECTION_MODE_AUDIO');

  static const $core.List<ConnectionMode> values = <ConnectionMode> [
    CONNECTION_MODE_NOT_SET,
    CONNECTION_MODE_WIFI,
    CONNECTION_MODE_BLE,
    CONNECTION_MODE_WIFI_AND_BLE,
    CONNECTION_MODE_OFFLINE,
    CONNECTION_MODE_LEGACY_BLE,
    CONNECTION_MODE_FACTORY,
    CONNECTION_MODE_AUDIO,
  ];

  static final $core.List<ConnectionMode?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 7);
  static ConnectionMode? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ConnectionMode._(super.value, super.name);
}

///
/// Must match hdy_socket_server_env_t
class ServerEnvironment extends $pb.ProtobufEnum {
  static const ServerEnvironment SOCKET_SERVER_ENV_PRODUCTION = ServerEnvironment._(0, _omitEnumNames ? '' : 'SOCKET_SERVER_ENV_PRODUCTION');
  static const ServerEnvironment SOCKET_SERVER_ENV_STAGING = ServerEnvironment._(1, _omitEnumNames ? '' : 'SOCKET_SERVER_ENV_STAGING');
  static const ServerEnvironment SOCKET_SERVER_ENV_DEVELOPMENT = ServerEnvironment._(2, _omitEnumNames ? '' : 'SOCKET_SERVER_ENV_DEVELOPMENT');

  static const $core.List<ServerEnvironment> values = <ServerEnvironment> [
    SOCKET_SERVER_ENV_PRODUCTION,
    SOCKET_SERVER_ENV_STAGING,
    SOCKET_SERVER_ENV_DEVELOPMENT,
  ];

  static final $core.List<ServerEnvironment?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ServerEnvironment? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ServerEnvironment._(super.value, super.name);
}

///
/// Must match hdyBleConnectionStatus_t
class BleState extends $pb.ProtobufEnum {
  static const BleState BLE_STATE_NOT_INITIALIZED = BleState._(0, _omitEnumNames ? '' : 'BLE_STATE_NOT_INITIALIZED');
  static const BleState BLE_STATE_INITIALIZING = BleState._(1, _omitEnumNames ? '' : 'BLE_STATE_INITIALIZING');
  static const BleState BLE_STATE_ADVERTISING = BleState._(2, _omitEnumNames ? '' : 'BLE_STATE_ADVERTISING');
  static const BleState BLE_STATE_CONNECTED = BleState._(3, _omitEnumNames ? '' : 'BLE_STATE_CONNECTED');

  static const $core.List<BleState> values = <BleState> [
    BLE_STATE_NOT_INITIALIZED,
    BLE_STATE_INITIALIZING,
    BLE_STATE_ADVERTISING,
    BLE_STATE_CONNECTED,
  ];

  static final $core.List<BleState?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 3);
  static BleState? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const BleState._(super.value, super.name);
}

/// There is no need to set the transportation. This is handled in the FW.
class Transportation extends $pb.ProtobufEnum {
  static const Transportation TRANSPORTATION_WIFI = Transportation._(0, _omitEnumNames ? '' : 'TRANSPORTATION_WIFI');
  static const Transportation TRANSPORTATION_BLE = Transportation._(1, _omitEnumNames ? '' : 'TRANSPORTATION_BLE');
  static const Transportation TRANSPORTATION_EXTERNAL = Transportation._(3, _omitEnumNames ? '' : 'TRANSPORTATION_EXTERNAL');
  static const Transportation TRANSPORTATION_AP = Transportation._(4, _omitEnumNames ? '' : 'TRANSPORTATION_AP');

  static const $core.List<Transportation> values = <Transportation> [
    TRANSPORTATION_WIFI,
    TRANSPORTATION_BLE,
    TRANSPORTATION_EXTERNAL,
    TRANSPORTATION_AP,
  ];

  static final $core.List<Transportation?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 4);
  static Transportation? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Transportation._(super.value, super.name);
}


const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
