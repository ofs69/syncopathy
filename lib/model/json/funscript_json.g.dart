// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'funscript_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FunscriptAction _$FunscriptActionFromJson(Map<String, dynamic> json) =>
    FunscriptAction(
      at: (json['at'] as num).toInt(),
      pos: (json['pos'] as num).toInt(),
    );

Map<String, dynamic> _$FunscriptActionToJson(FunscriptAction instance) =>
    <String, dynamic>{'at': instance.at, 'pos': instance.pos};

FunscriptJson _$FunscriptJsonFromJson(Map<String, dynamic> json) =>
    FunscriptJson(
      version: json['version'] == null
          ? "1.0"
          : const VersionConverter().fromJson(json['version']),
      inverted: json['inverted'] as bool? ?? false,
      range: (json['range'] as num?)?.toInt() ?? 100,
      actions: (json['actions'] as List<dynamic>)
          .map((e) => FunscriptAction.fromJson(e as Map<String, dynamic>))
          .toList(),
      metadata: json['metadata'] == null
          ? null
          : FunscriptMetadata.fromJson(
              json['metadata'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$FunscriptJsonToJson(FunscriptJson instance) =>
    <String, dynamic>{
      'version': const VersionConverter().toJson(instance.version),
      'inverted': instance.inverted,
      'range': instance.range,
      'actions': instance.actions,
      'metadata': instance.metadata,
    };
