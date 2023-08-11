import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class MessageModel {
  @JsonKey(defaultValue: 0)
  int contentType = 0;
  String? id;
  String? messageSenderId;
  String? messageReceiverId;
  String? content;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  DateTime? messageSendingTime;
  MessageModel();
  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);
  static DateTime? _fromJson(Timestamp timestamp) => timestamp.toDate();
  static Timestamp? _toJson(DateTime? date) => Timestamp.fromDate(date!);
}
