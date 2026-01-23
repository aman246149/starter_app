// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_ws_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthWsEventModel _$AuthWsEventModelFromJson(Map<String, dynamic> json) =>
    _AuthWsEventModel(
      event: json['event'] as String,
      data: json['data'] == null
          ? null
          : UserModel.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$AuthWsEventModelToJson(_AuthWsEventModel instance) =>
    <String, dynamic>{
      'event': instance.event,
      'data': instance.data,
      'timestamp': instance.timestamp?.toIso8601String(),
    };
