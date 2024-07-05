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
      duration: json['dure'] as String,
      aboutGuide: json['about_guide'] as String,
      pricePerTraveler: json['prix_par_voyageur'] as String,
      numberOfTravelers: json['nombre_des_voyageur'] as int,
      city: json['ville'] as String,
      address: json['addresse'] as String,
      postalCode: json['code_postale'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      userId: json['user_id'] as int,
      status: json['status'] as String,
      country: json['country'] as String,
      categories:
          (json['categorie'] as List<dynamic>).map((e) => e as String).toList(),
      guideParticipants:
          (json['guide_personnes_peuves_participer'] as List<dynamic>?)
              ?.map((e) => e as String?)
              .toList(),
      etAvecCa: (json['et_avec_ça'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isOnline: json['is_online'] as bool,
      isProfessionalGuide: json['guide_is_pro'] as bool,
      guideDescription: json['description_guide'] as String?,
      guideName: json['nom_of_guide'] as String,
      mainPhoto: PhotoPrincipal.fromJson(
          json['photoprincipal'] as Map<String, dynamic>),
      image0: json['image_0'] == null
          ? null
          : PhotoPrincipal.fromJson(json['image_0'] as Map<String, dynamic>),
      image1: json['image_1'] == null
          ? null
          : PhotoPrincipal.fromJson(json['image_1'] as Map<String, dynamic>),
      image2: json['image_2'] == null
          ? null
          : PhotoPrincipal.fromJson(json['image_2'] as Map<String, dynamic>),
      image3: json['image_3'] == null
          ? null
          : PhotoPrincipal.fromJson(json['image_3'] as Map<String, dynamic>),
      image4: json['image_4'] == null
          ? null
          : PhotoPrincipal.fromJson(json['image_4'] as Map<String, dynamic>),
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
