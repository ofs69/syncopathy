import 'package:json_annotation/json_annotation.dart';
import 'package:syncopathy/model/json/handyV3/handy_response.dart';

part 'handy_event.g.dart';

class HandySseEvent {
  final String? id;
  final String? event;
  final String data;

  HandySseEvent({this.id, this.event, required this.data});

  @override
  String toString() => 'ID: $id, Event: $event, Data: $data';
}

/*
{
  "data": {
    "connection_key": "dsaA98ds",
    "data": {
      "connected": true,
      "info": {
        "fw_status": 0,
        "fw_version": "4.0.0",
        "session_id": "01HYMVKHMPYH1S6WTVD6BM7TQA",
        "fw_feature_flags": "production",
        "hw_model_no": 1,
        "hw_model_name": "H01",
        "hw_model_variant": 1,
      },
    },
  },
}
*/

@JsonSerializable(fieldRename: FieldRename.snake)
class HandyEventData {
  final String connectionKey;
  HandyEventData({required this.connectionKey});

  factory HandyEventData.fromJson(Map<String, dynamic> json) =>
      _$HandyEventDataFromJson(json);
  Map<String, dynamic> toJson() => _$HandyEventDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class HandyEventConnectedData {
  final bool connected;
  HandyEventConnectedData({required this.connected});

  factory HandyEventConnectedData.fromJson(Map<String, dynamic> json) =>
      _$HandyEventConnectedDataFromJson(json);
  Map<String, dynamic> toJson() => _$HandyEventConnectedDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class HandyDeviceStatusData extends HandyEventConnectedData {
  final HandyInfo info;

  HandyDeviceStatusData({required super.connected, required this.info});

  factory HandyDeviceStatusData.fromJson(Map<String, dynamic> json) =>
      _$HandyDeviceStatusDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$HandyDeviceStatusDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class HandyDeviceStatus extends HandyEventData {
  @JsonKey(name: 'data')
  final HandyDeviceStatusData data;

  HandyDeviceStatus({required super.connectionKey, required this.data});

  factory HandyDeviceStatus.fromJson(Map<String, dynamic> json) =>
      _$HandyDeviceStatusFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$HandyDeviceStatusToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class HandyHspStatusEvent extends HandyEventData {
  @JsonKey(name: 'data')
  final HandyHspState data;

  HandyHspStatusEvent({required super.connectionKey, required this.data});

  factory HandyHspStatusEvent.fromJson(Map<String, dynamic> json) =>
      _$HandyHspStatusEventFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$HandyHspStatusEventToJson(this);
}
