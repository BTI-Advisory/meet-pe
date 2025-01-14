import 'package:json_annotation/json_annotation.dart';

part 'experience_model.g.dart';

@JsonSerializable(createToJson: false)
class ExperienceModel {
  final int weightedMatchScore;
  final Experience experience;

  ExperienceModel({
    required this.weightedMatchScore,
    required this.experience,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) =>
      _$ExperienceModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class Experience {
  final String id;
  final String title;
  final String description;
  final List<Category> categories;
  final List<Language> languages;
  final List<Planning> planning;
  final String? duree;
  final Photo photoprincipal;
  final List<Photo> photos;
  final String? nombreVoyageur;
  final List<TravelerType> typeVoyageur;
  final String? prixParVoyageur;
  final String? maxNbVoyageur;
  final List<Option> options;
  final String? ville;
  final String? pays;
  final String? adresse;
  final String? codePostal;
  final String? supportGroupPrive;
  final String? prixParGroup;
  final String? discountKids;
  final String? prixParEnfant;
  final List<DernierMinute> dernierMinuteReservation;
  final String nameGuide;
  final String descriptionGuide;

  Experience({
    required this.id,
    required this.title,
    required this.description,
    required this.categories,
    required this.languages,
    required this.planning,
    this.duree,
    required this.photoprincipal,
    required this.photos,
    this.nombreVoyageur,
    required this.typeVoyageur,
    this.prixParVoyageur,
    this.maxNbVoyageur,
    required this.options,
    this.ville,
    this.pays,
    this.adresse,
    this.codePostal,
    this.supportGroupPrive,
    this.prixParGroup,
    this.discountKids,
    this.prixParEnfant,
    required this.dernierMinuteReservation,
    required this.nameGuide,
    required this.descriptionGuide
  });

  factory Experience.fromJson(Map<String, dynamic> json) =>
      _$ExperienceFromJson(json);
}

@JsonSerializable(createToJson: false)
class Category {
  final int id;
  final String choix;
  final String svg;

  Category({required this.id, required this.choix, required this.svg});

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}

@JsonSerializable(createToJson: false)
class Language {
  final int id;
  final String choix;
  final String svg;

  Language({required this.id, required this.choix, required this.svg});

  factory Language.fromJson(Map<String, dynamic> json) =>
      _$LanguageFromJson(json);
}

@JsonSerializable(createToJson: false)
class Planning {
  final String startDate;
  final String endDate;
  final List<Schedule> schedules;

  Planning({
    required this.startDate,
    required this.endDate,
    required this.schedules,
  });

  factory Planning.fromJson(Map<String, dynamic> json) =>
      _$PlanningFromJson(json);
}

@JsonSerializable(createToJson: false)
class Schedule {
  final String startTime;
  final String endTime;

  Schedule({required this.startTime, required this.endTime});

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);
}

@JsonSerializable(createToJson: false)
class Photo {
  final String typeImage;
  final String photoUrl;

  Photo({required this.typeImage, required this.photoUrl});

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);
}

@JsonSerializable(createToJson: false)
class TravelerType {
  final int id;
  final String choix;
  final String svg;

  TravelerType({required this.id, required this.choix, required this.svg});

  factory TravelerType.fromJson(Map<String, dynamic> json) =>
      _$TravelerTypeFromJson(json);
}

@JsonSerializable(createToJson: false)
class Option {
  final int id;
  final String choix;
  final String svg;

  Option({required this.id, required this.choix, required this.svg});

  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);
}

@JsonSerializable(createToJson: false)
class DernierMinute {
  final int id;
  final String choix;
  final String svg;

  DernierMinute({required this.id, required this.choix, required this.svg});

  factory DernierMinute.fromJson(Map<String, dynamic> json) =>
      _$DernierMinuteFromJson(json);
}
