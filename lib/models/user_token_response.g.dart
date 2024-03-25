// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserTokenResponse _$UserTokenResponseFromJson(Map<String, dynamic> json) =>
    UserTokenResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['access_token'] as String,
      roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$UserTokenResponseToJson(UserTokenResponse instance) =>
    <String, dynamic>{
      'user': instance.user,
      'access_token': instance.accessToken,
      'roles': instance.roles,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      name: json['name'] as String,
      email: json['email'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      otpCode: json['otp_code'] as String,
      isVerifiedAccount: json['is_verified_account'] as bool,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'otp_code': instance.otpCode,
      'is_verified_account': instance.isVerifiedAccount,
    };
