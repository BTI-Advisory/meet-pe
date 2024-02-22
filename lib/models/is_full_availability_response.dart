import 'package:json_annotation/json_annotation.dart';

part 'is_full_availability_response.g.dart';

@JsonSerializable(createToJson: false)
class IsFullAvailabilityResponse {
  const IsFullAvailabilityResponse({required this.available});

  /// Short live token, used to access API.
  @JsonKey(name: 'is_full_available')     // OPTI restore camelCase when server's ready
  final bool available;

  factory IsFullAvailabilityResponse.fromJson(Map<String, dynamic> json) => _$IsFullAvailabilityResponseFromJson(json);
}
