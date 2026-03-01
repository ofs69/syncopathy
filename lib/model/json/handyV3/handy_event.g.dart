// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handy_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HandyEventData _$HandyEventDataFromJson(Map<String, dynamic> json) =>
    HandyEventData(connectionKey: json['connection_key'] as String);

Map<String, dynamic> _$HandyEventDataToJson(HandyEventData instance) =>
    <String, dynamic>{'connection_key': instance.connectionKey};

HandyEventConnectedData _$HandyEventConnectedDataFromJson(
  Map<String, dynamic> json,
) => HandyEventConnectedData(connected: json['connected'] as bool);

Map<String, dynamic> _$HandyEventConnectedDataToJson(
  HandyEventConnectedData instance,
) => <String, dynamic>{'connected': instance.connected};

HandyDeviceStatusData _$HandyDeviceStatusDataFromJson(
  Map<String, dynamic> json,
) => HandyDeviceStatusData(
  connected: json['connected'] as bool,
  info: HandyInfo.fromJson(json['info'] as Map<String, dynamic>),
);

Map<String, dynamic> _$HandyDeviceStatusDataToJson(
  HandyDeviceStatusData instance,
) => <String, dynamic>{'connected': instance.connected, 'info': instance.info};

HandyDeviceStatus _$HandyDeviceStatusFromJson(Map<String, dynamic> json) =>
    HandyDeviceStatus(
      connectionKey: json['connection_key'] as String,
      data: HandyDeviceStatusData.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$HandyDeviceStatusToJson(HandyDeviceStatus instance) =>
    <String, dynamic>{
      'connection_key': instance.connectionKey,
      'data': instance.data,
    };
