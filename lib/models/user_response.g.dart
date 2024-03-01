// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      otpCode: json['otp_code'] as String,
      profilePath: json['profile_path'] as String,
      phoneNumber: json['phone_number'] as String,
      isFullAvailable: json['is_full_available'] as bool,
      IBAN: json['IBAN'] as String?,
      BIC: json['BIC'] as String?,
      nomDuTitulaire: json['nom_du_titulaire'] as String?,
      rue: json['rue'] as String?,
      codePostal: json['code_postal'] as String?,
      ville: json['ville'] as String?,
      emailVerifiedAt: json['email_verified_at'] as String?,
      userType: json['user_type'] as String?,
      sirenNumber: json['siren_number'] as String?,
      hasUpdatedHesSchedule: json['has_updated_hes_schedule'] as bool,
    );
