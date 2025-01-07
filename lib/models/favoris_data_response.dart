import 'package:json_annotation/json_annotation.dart';
import 'experience_data_response.dart';

part 'favoris_data_response.g.dart';

@JsonSerializable(createToJson: false)
class FavorisDataResponse {
  final int id;
  final int experienceId;
  final int userId;
  final ExperienceDataResponse experience;
  final String createdAt;

  FavorisDataResponse({
    required this.id,
    required this.experienceId,
    required this.userId,
    required this.experience,
    required this.createdAt,
  });

  factory FavorisDataResponse.fromJson(Map<String, dynamic> json) =>
      _$FavorisDataResponseFromJson(json);
}
