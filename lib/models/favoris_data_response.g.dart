// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favoris_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavorisDataResponse _$FavorisDataResponseFromJson(Map<String, dynamic> json) =>
    FavorisDataResponse(
      id: (json['id'] as num).toInt(),
      experienceId: (json['experience_id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      experience: ExperienceDataResponse.fromJson(
          json['experience'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String,
    );
