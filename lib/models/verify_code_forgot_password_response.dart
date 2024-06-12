import 'package:json_annotation/json_annotation.dart';

part 'verify_code_forgot_password_response.g.dart';

@JsonSerializable()
class VerifyCodeForgotPasswordResponse{
  String msg;

  VerifyCodeForgotPasswordResponse({required this.msg});

  factory VerifyCodeForgotPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyCodeForgotPasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyCodeForgotPasswordResponseToJson(this);
}
