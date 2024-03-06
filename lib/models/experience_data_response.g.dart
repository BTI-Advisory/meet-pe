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
      prixParVoyageur: json['prix_par_voyageur'] as String,
      nombreDesVoyageur: json['nombre_des_voyageur'] as String,
      ville: json['ville'] as String,
      addresse: json['addresse'] as String,
      codePostale: json['code_postale'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      userId: json['user_id'] as int,
      status: json['status'] as String,
      country: json['country'] as String,
      categorie:
          (json['categorie'] as List<dynamic>).map((e) => e as String).toList(),
      guidePersonnesPeuvesParticiper:
          (json['guide_personnes_peuves_participer'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      etAvecCa: (json['et_avec_ça'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isOnline: json['is_online'] as bool,
      guideIsPro: json['guide_is_pro'] as bool,
      photoPrincipal: PhotoPrincipal.fromJson(
          json['photoprincipal'] as Map<String, dynamic>),
    );

PhotoPrincipal _$PhotoPrincipalFromJson(Map<String, dynamic> json) =>
    PhotoPrincipal(
      id: json['id'] as int,
      guideExperienceId: json['guide_experience_id'] as int,
      photoUrl: json['photo_url'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      typeImage: json['type_image'] as String,
    );

Map<String, dynamic> _$PhotoPrincipalToJson(PhotoPrincipal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'guide_experience_id': instance.guideExperienceId,
      'photo_url': instance.photoUrl,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'type_image': instance.typeImage,
    };
