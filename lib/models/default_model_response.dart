import 'package:json_annotation/json_annotation.dart';

part 'default_model_response.g.dart';

@JsonSerializable(createToJson: false)
class DefaultModelResponse {
  const DefaultModelResponse({required this.message});

  /// Short live token, used to access API.
  @JsonKey(name: 'message')     // OPTI restore camelCase when server's ready
  final String message;

  factory DefaultModelResponse.fromJson(Map<String, dynamic> json) => _$DefaultModelResponseFromJson(json);
}
