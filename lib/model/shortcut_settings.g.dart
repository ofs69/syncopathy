// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shortcut_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortcutBinding _$ShortcutBindingFromJson(Map<String, dynamic> json) =>
    ShortcutBinding(
      keyId: (json['keyId'] as num).toInt(),
      control: json['control'] as bool? ?? false,
      shift: json['shift'] as bool? ?? false,
      alt: json['alt'] as bool? ?? false,
      meta: json['meta'] as bool? ?? false,
    );

Map<String, dynamic> _$ShortcutBindingToJson(ShortcutBinding instance) =>
    <String, dynamic>{
      'keyId': instance.keyId,
      'control': instance.control,
      'shift': instance.shift,
      'alt': instance.alt,
      'meta': instance.meta,
    };
