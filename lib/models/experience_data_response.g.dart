// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experience_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExperienceDataResponse _$ExperienceDataResponseFromJson(
        Map<String, dynamic> json) =>
    ExperienceDataResponse(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      languages:
          (json['languages'] as List<dynamic>).map((e) => e as String).toList(),
      planning: (json['planning'] as List<dynamic>)
          .map((e) => Planning.fromJson(e as Map<String, dynamic>))
          .toList(),
      duration: json['duree'] as String,
      mainPhoto: Photo.fromJson(json['photoprincipal'] as Map<String, dynamic>),
      photos: (json['photos'] as List<dynamic>)
          .map((e) => Photo.fromJson(e as Map<String, dynamic>))
          .toList(),
      numberOfTravelers: (json['nombre_voyageur'] as num).toInt(),
      typeDesVoyageur: (json['type_voyageur'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      pricePerTraveler: json['prix_par_voyageur'] as String,
      maxNumberOfTravelers: (json['Max_nb_voyageur'] as num).toInt(),
      options:
          (json['options'] as List<dynamic>).map((e) => e as String).toList(),
      city: json['ville'] as String,
      country: json['pays'] as String,
      address: json['adresse'] as String,
      latitude: (json['lat'] as num?)?.toDouble(),
      longitude: (json['lang'] as num?)?.toDouble(),
      postalCode: json['code_postal'] as String,
      supportGroupPrive: json['support_group_prive'] as bool,
      priceGroupPrive: (json['prix_par_group'] as num?)?.toInt(),
      discountKids: json['discount_kids'] as bool?,
      lastMinuteReservation: json['dernier_minute_reservation'] as String?,
      nameGuide: json['name_guide'] as String,
      descriptionGuide: json['description_guide'] as String,
      createdAt: json['createdAt'] as String,
    );

Photo _$PhotoFromJson(Map<String, dynamic> json) => Photo(
      photoUrl: json['photo_url'] as String,
      typeImage: json['type_image'] as String,
    );

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
      'photo_url': instance.photoUrl,
      'type_image': instance.typeImage,
    };

Planning _$PlanningFromJson(Map<String, dynamic> json) => Planning(
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      schedules: (json['schedules'] as List<dynamic>)
          .map((e) => Schedule.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlanningToJson(Planning instance) => <String, dynamic>{
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'schedules': instance.schedules,
    };

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
    );

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'start_time': instance.startTime,
      'end_time': instance.endTime,
    };
