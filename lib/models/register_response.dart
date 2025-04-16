import 'package:json_annotation/json_annotation.dart';

part 'register_response.g.dart';

@JsonSerializable()
class RegisterResponse {
  final String accessToken;
  final User user;

  RegisterResponse({required this.accessToken, required this.user});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);
}

@JsonSerializable()
class User {
  final String name;
  final String email;
  final int otp_code;
  final bool isVerifiedAccount;
  final String updated_at;
  final String created_at;
  final int id;

  User({
    required this.name,
    required this.email,
    required this.otp_code,
    required this.isVerifiedAccount,
    required this.updated_at,
    required this.created_at,
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
