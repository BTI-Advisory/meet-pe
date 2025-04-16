// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterResponse _$RegisterResponseFromJson(Map<String, dynamic> json) =>
    RegisterResponse(
      accessToken: json['access_token'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RegisterResponseToJson(RegisterResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'user': instance.user,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      name: json['name'] as String,
      email: json['email'] as String,
      otp_code: json['otp_code'] as int,
      isVerifiedAccount: json['is_verified_account'] as bool,
      updated_at: json['updated_at'] as String,
      created_at: json['created_at'] as String,
      id: json['id'] as int,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'otp_code': instance.otp_code,
      'is_verified_account': instance.isVerifiedAccount,
      'updated_at': instance.updated_at,
      'created_at': instance.created_at,
      'id': instance.id,
    };
