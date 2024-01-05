import 'package:json_annotation/json_annotation.dart';

part 'verify_code.g.dart';

@JsonSerializable(createToJson: false)
class VerifyCode {
  const VerifyCode({required this.verified});

  /// Short live token, used to access API.
  @JsonKey(name: 'msg')     // OPTI restore camelCase when server's ready
  final String verified;

  factory VerifyCode.fromJson(Map<String, dynamic> json) => _$VerifyCodeFromJson(json);
}
