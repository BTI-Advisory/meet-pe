import 'package:json_annotation/json_annotation.dart';

part 'experience_data_response.g.dart';

@JsonSerializable(createToJson: false)
class ExperienceDataResponse {
  const ExperienceDataResponse(
      {required this.id,
      required this.title,
      required this.description,
      required this.dure,
      required this.createdAt,
      required this.updatedAt,
      required this.userId,
      required this.status,
      required this.country,
      required this.isOnline});

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'dure')
  final String dure;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'country')
  final String country;
  @JsonKey(name: 'is_online')
  final bool isOnline;

  factory ExperienceDataResponse.fromJson(Map<String, dynamic> json) =>
      _$ExperienceDataResponseFromJson(json);
}
