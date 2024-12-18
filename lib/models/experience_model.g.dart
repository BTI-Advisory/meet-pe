// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experience_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExperienceModel _$ExperienceModelFromJson(Map<String, dynamic> json) =>
    ExperienceModel(
      weightedMatchScore: json['weighted_match_score'] as String,
      experience:
          Experience.fromJson(json['experience'] as Map<String, dynamic>),
    );

Experience _$ExperienceFromJson(Map<String, dynamic> json) => Experience(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      languages: (json['languages'] as List<dynamic>)
          .map((e) => Language.fromJson(e as Map<String, dynamic>))
          .toList(),
      planning: (json['planning'] as List<dynamic>)
          .map((e) => Planning.fromJson(e as Map<String, dynamic>))
          .toList(),
      duree: json['duree'] as String?,
      photoprincipal:
          Photo.fromJson(json['photoprincipal'] as Map<String, dynamic>),
      photos: (json['photos'] as List<dynamic>)
          .map((e) => Photo.fromJson(e as Map<String, dynamic>))
          .toList(),
      nombreVoyageur: json['nombre_voyageur'] as String?,
      typeVoyageur: (json['type_voyageur'] as List<dynamic>)
          .map((e) => TravelerType.fromJson(e as Map<String, dynamic>))
          .toList(),
      prixParVoyageur: json['prix_par_voyageur'] as String?,
      maxNbVoyageur: json['Max_nb_voyageur'] as String?,
      options: (json['options'] as List<dynamic>)
          .map((e) => Option.fromJson(e as Map<String, dynamic>))
          .toList(),
      ville: json['ville'] as String?,
      pays: json['pays'] as String?,
      adresse: json['adresse'] as String?,
      codePostal: json['code_postal'] as String?,
      supportGroupPrive: json['support_group_prive'] as String?,
      prixParGroup: json['prix_par_group'] as String?,
      discountKids: json['discount_kids'] as String?,
      prixParEnfant: json['prix_par_enfant'] as String?,
      dernierMinuteReservation: json['dernier_minute_reservation'] as String?,
      nameGuide: json['name_guide'] as String,
      descriptionGuide: json['description_guide'] as String,
    );

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: (json['id'] as num).toInt(),
      choix: json['choix'] as String,
      svg: json['svg'] as String,
    );

Language _$LanguageFromJson(Map<String, dynamic> json) => Language(
      id: (json['id'] as num).toInt(),
      choix: json['choix'] as String,
      svg: json['svg'] as String,
    );

Planning _$PlanningFromJson(Map<String, dynamic> json) => Planning(
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      schedules: (json['schedules'] as List<dynamic>)
          .map((e) => Schedule.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
    );

Photo _$PhotoFromJson(Map<String, dynamic> json) => Photo(
      typeImage: json['type_image'] as String,
      photoUrl: json['photo_url'] as String,
    );

TravelerType _$TravelerTypeFromJson(Map<String, dynamic> json) => TravelerType(
      id: (json['id'] as num).toInt(),
      choix: json['choix'] as String,
      svg: json['svg'] as String,
    );

Option _$OptionFromJson(Map<String, dynamic> json) => Option(
      id: (json['id'] as num).toInt(),
      choix: json['choix'] as String,
      svg: json['svg'] as String,
    );
