import 'package:json_annotation/json_annotation.dart';

part 'auth_tokens.g.dart';

@JsonSerializable(createToJson: false)
class AuthTokens {
  const AuthTokens({required this.refreshToken, required this.accessToken});

  /// Single use token, used to get a new [accessToken].
  @JsonKey(name: 'refresh_token')     // OPTI restore camelCase when server's ready
  final String refreshToken;

  /// Short live token, used to access API.
  @JsonKey(name: 'access_token')     // OPTI restore camelCase when server's ready
  final String accessToken;

  factory AuthTokens.fromJson(Map<String, dynamic> json) => _$AuthTokensFromJson(json);
}
