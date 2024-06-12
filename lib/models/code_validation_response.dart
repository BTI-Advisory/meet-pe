import 'package:json_annotation/json_annotation.dart';

part 'code_validation_response.g.dart';

@JsonSerializable(createToJson: false)
class CodeValidationResponse {
  const CodeValidationResponse({required this.message, required this.token});

  /// Short live token, used to access API.
  @JsonKey(name: 'msg')    // OPTI restore camelCase when server's ready
  final String message;
  @JsonKey(name: 'token')
  final String token;

  factory CodeValidationResponse.fromJson(Map<String, dynamic> json) => _$CodeValidationResponseFromJson(json);
}
