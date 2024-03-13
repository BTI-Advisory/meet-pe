import 'package:json_annotation/json_annotation.dart';

part 'user_social_response.g.dart';

@JsonSerializable()
class UserSocialResponse {
  final User user;
  @JsonKey(name: 'token')
  final String token;
  final List<String> roles;
  @JsonKey(name: 'action')
  final String action;

  UserSocialResponse({
    required this.user,
    required this.token,
    required this.roles,
    required this.action,
  });

  factory UserSocialResponse.fromJson(Map<String, dynamic> json) =>
      _$UserSocialResponseFromJson(json);
}

@JsonSerializable()
class User {
  final String name;
  final String email;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'otp_code')
  final String otpCode;

  User({
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    required this.otpCode,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
