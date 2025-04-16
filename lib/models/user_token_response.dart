import 'package:json_annotation/json_annotation.dart';

part 'user_token_response.g.dart';

@JsonSerializable()
class UserTokenResponse {
  final User user;
  @JsonKey(name: 'access_token')
  final String accessToken;
  final List<String> roles;

  UserTokenResponse({
    required this.user,
    required this.accessToken,
    required this.roles,
  });

  factory UserTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$UserTokenResponseFromJson(json);
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
  @JsonKey(name: 'is_verified_account')
  final bool isVerifiedAccount;

  User({
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    required this.otpCode,
    required this.isVerifiedAccount
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
