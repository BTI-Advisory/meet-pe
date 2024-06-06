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
      pieceIdentite: json['piece_d_identite'] as String?,
      kbisFile: json['KBIS_file'] as String?,
      otherDocument: (json['otherDocument'] as List<dynamic>?)
          ?.map((e) => OtherDocument.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

OtherDocument _$OtherDocumentFromJson(Map<String, dynamic> json) =>
    OtherDocument(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      documentTitle: json['document_title'] as String,
      documentPath: json['document_path'] as String,
    );

Map<String, dynamic> _$OtherDocumentToJson(OtherDocument instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'document_title': instance.documentTitle,
      'document_path': instance.documentPath,
    };
