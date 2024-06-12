import 'package:json_annotation/json_annotation.dart';

part 'update_forgot_password_response.g.dart';

@JsonSerializable()
class UpdateForgotPasswordResponse{
  String message;
  String status;

  UpdateForgotPasswordResponse({required this.message, required this.status});

  factory UpdateForgotPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateForgotPasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateForgotPasswordResponseToJson(this);
}
