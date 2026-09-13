// This is a generated file - do not edit.
//
// Generated from messages.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class SlideMaintVerdict extends $pb.ProtobufEnum {
  static const SlideMaintVerdict SLIDE_MAINT_OK =
      SlideMaintVerdict._(0, _omitEnumNames ? '' : 'SLIDE_MAINT_OK');
  static const SlideMaintVerdict SLIDE_MAINT_CHECK =
      SlideMaintVerdict._(1, _omitEnumNames ? '' : 'SLIDE_MAINT_CHECK');
  static const SlideMaintVerdict SLIDE_MAINT_FAIL =
      SlideMaintVerdict._(2, _omitEnumNames ? '' : 'SLIDE_MAINT_FAIL');

  static const $core.List<SlideMaintVerdict> values = <SlideMaintVerdict>[
    SLIDE_MAINT_OK,
    SLIDE_MAINT_CHECK,
    SLIDE_MAINT_FAIL,
  ];

  static final $core.List<SlideMaintVerdict?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static SlideMaintVerdict? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SlideMaintVerdict._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
