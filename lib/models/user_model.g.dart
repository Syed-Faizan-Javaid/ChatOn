// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetail _$UserDetailFromJson(Map<String, dynamic> json) => UserDetail()
  ..id = json['id'] as String? ?? ''
  ..image = json['image'] as String? ?? ''
  ..name = json['name'] as String? ?? ''
  ..address = json['address'] as String? ?? ''
  ..email = json['email'] as String? ?? ''
  ..phone = json['phone'] as String? ?? ''
  ..deviceToken = json['deviceToken'] as String? ?? '';

Map<String, dynamic> _$UserDetailToJson(UserDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'name': instance.name,
      'address': instance.address,
      'email': instance.email,
      'phone': instance.phone,
      'deviceToken': instance.deviceToken,
    };
