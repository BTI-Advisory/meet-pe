// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_social_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSocialResponse _$UserSocialResponseFromJson(Map<String, dynamic> json) =>
    UserSocialResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
      roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
      action: json['action'] as String,
    );

Map<String, dynamic> _$UserSocialResponseToJson(UserSocialResponse instance) =>
    <String, dynamic>{
      'user': instance.user,
      'token': instance.token,
      'roles': instance.roles,
      'action': instance.action,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      name: json['name'] as String,
      email: json['email'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      otpCode: json['otp_code'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'otp_code': instance.otpCode,
    };
