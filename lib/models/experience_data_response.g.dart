// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experience_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExperienceDataResponse _$ExperienceDataResponseFromJson(
        Map<String, dynamic> json) =>
    ExperienceDataResponse(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      dure: json['dure'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      userId: json['user_id'] as int,
      status: json['status'] as String,
      country: json['country'] as String,
      isOnline: json['is_online'] as bool,
    );
