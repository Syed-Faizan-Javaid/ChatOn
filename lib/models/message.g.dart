// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel()
  ..contentType = json['contentType'] as int? ?? 0
  ..id = json['id'] as String?
  ..messageSenderId = json['messageSenderId'] as String?
  ..messageReceiverId = json['messageReceiverId'] as String?
  ..content = json['content'] as String?
  ..messageSendingTime =
      MessageModel._fromJson(json['messageSendingTime'] as Timestamp);

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'contentType': instance.contentType,
      'id': instance.id,
      'messageSenderId': instance.messageSenderId,
      'messageReceiverId': instance.messageReceiverId,
      'content': instance.content,
      'messageSendingTime': MessageModel._toJson(instance.messageSendingTime),
    };
