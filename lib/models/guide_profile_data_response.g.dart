// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guide_profile_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GuideProfileDataResponse _$GuideProfileDataResponseFromJson(
        Map<String, dynamic> json) =>
    GuideProfileDataResponse(
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
      mainPhoto: json['photoprincipal'] as String,
      image0: json['image_0'] as String?,
      image1: json['image_1'] as String?,
      image2: json['image_2'] as String?,
      image3: json['image_3'] as String?,
      image4: json['image_4'] as String?,
    );
