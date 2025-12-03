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

class MessageType extends $pb.ProtobufEnum {
  static const MessageType MESSAGE_TYPE_UNKNOWN =
      MessageType._(0, _omitEnumNames ? '' : 'MESSAGE_TYPE_UNKNOWN');
  static const MessageType MESSAGE_TYPE_REQUEST =
      MessageType._(1, _omitEnumNames ? '' : 'MESSAGE_TYPE_REQUEST');
  static const MessageType MESSAGE_TYPE_REQUESTS =
      MessageType._(2, _omitEnumNames ? '' : 'MESSAGE_TYPE_REQUESTS');
  static const MessageType MESSAGE_TYPE_RESPONSE =
      MessageType._(3, _omitEnumNames ? '' : 'MESSAGE_TYPE_RESPONSE');
  static const MessageType MESSAGE_TYPE_NOTIFICATION =
      MessageType._(4, _omitEnumNames ? '' : 'MESSAGE_TYPE_NOTIFICATION');

  static const $core.List<MessageType> values = <MessageType>[
    MESSAGE_TYPE_UNKNOWN,
    MESSAGE_TYPE_REQUEST,
    MESSAGE_TYPE_REQUESTS,
    MESSAGE_TYPE_RESPONSE,
    MESSAGE_TYPE_NOTIFICATION,
  ];

  static final $core.List<MessageType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static MessageType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MessageType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
