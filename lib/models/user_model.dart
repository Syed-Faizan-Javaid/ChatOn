import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserDetail {
  @JsonKey(defaultValue: '')
  String id = '';
  @JsonKey(defaultValue: '')
  String image = '';
  @JsonKey(defaultValue: '')
  String name = '';
  @JsonKey(defaultValue: '')
  String address = '';
  @JsonKey(defaultValue: '')
  String email = '';
  @JsonKey(defaultValue: '')
  String phone = '';
  @JsonKey(defaultValue: '')
  String deviceToken = '';
  UserDetail();
  Map<String, dynamic> toJson() => _$UserDetailToJson(this);

  factory UserDetail.fromJson(Map<String, dynamic> json) => _$UserDetailFromJson(json);
}
