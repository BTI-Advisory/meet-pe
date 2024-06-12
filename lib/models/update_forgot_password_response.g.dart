// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_forgot_password_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateForgotPasswordResponse _$UpdateForgotPasswordResponseFromJson(
        Map<String, dynamic> json) =>
    UpdateForgotPasswordResponse(
      message: json['message'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$UpdateForgotPasswordResponseToJson(
        UpdateForgotPasswordResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
    };
