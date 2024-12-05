import 'package:json_annotation/json_annotation.dart';

part 'experience_data_response.g.dart';

@JsonSerializable(createToJson: false)
class ExperienceDataResponse {
  const ExperienceDataResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.categories,
    required this.languages,
    required this.planning,
    required this.duration,
    required this.mainPhoto,
    required this.photos,
    required this.numberOfTravelers,
    required this.typeDesVoyageur,
    required this.pricePerTraveler,
    required this.maxNumberOfTravelers,
    required this.options,
    required this.city,
    required this.country,
    required this.address,
    this.latitude,
    this.longitude,
    required this.postalCode,
    required this.supportGroupPrive,
    this.priceGroupPrive,
    this.discountKids,
    this.lastMinuteReservation,
    required this.nameGuide,
    required this.descriptionGuide,
    required this.createdAt,
  });

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'categories')
  final List<String> categories;
  @JsonKey(name: 'languages')
  final List<String> languages;
  @JsonKey(name: 'planning')
  final List<Planning> planning;
  @JsonKey(name: 'duree')
  final String duration;
  @JsonKey(name: 'photoprincipal')
  final Photo mainPhoto;
  @JsonKey(name: 'photos')
  final List<Photo> photos;
  @JsonKey(name: 'nombre_voyageur')
  final int numberOfTravelers;
  @JsonKey(name: 'type_voyageur')
  final List<String> typeDesVoyageur;
  @JsonKey(name: 'prix_par_voyageur')
  final String pricePerTraveler;
  @JsonKey(name: 'Max_nb_voyageur')
  final int maxNumberOfTravelers;
  @JsonKey(name: 'options')
  final List<String> options;
  @JsonKey(name: 'ville')
  final String city;
  @JsonKey(name: 'pays')
  final String country;
  @JsonKey(name: 'adresse')
  final String address;
  @JsonKey(name: 'lat')
  final double? latitude;
  @JsonKey(name: 'lang')
  final double? longitude;
  @JsonKey(name: 'code_postal')
  final String postalCode;
  @JsonKey(name: 'support_group_prive')
  final bool supportGroupPrive;
  @JsonKey(name: 'prix_par_group')
  final int? priceGroupPrive;
  @JsonKey(name: 'discount_kids')
  final bool? discountKids;
  @JsonKey(name: 'dernier_minute_reservation')
  final String? lastMinuteReservation;
  @JsonKey(name: 'name_guide')
  final String nameGuide;
  @JsonKey(name: 'description_guide')
  final String descriptionGuide;
  @JsonKey(name: 'createdAt')
  final String createdAt;

  factory ExperienceDataResponse.fromJson(Map<String, dynamic> json) =>
      _$ExperienceDataResponseFromJson(json);
}

@JsonSerializable()
class Photo {
  const Photo({
    required this.photoUrl,
    required this.typeImage,
  });

  @JsonKey(name: 'photo_url')
  final String photoUrl;

  @JsonKey(name: 'type_image')
  final String typeImage;

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);
}

@JsonSerializable()
class Planning {
  const Planning({
    required this.startDate,
    required this.endDate,
    required this.schedules,
  });

  @JsonKey(name: 'start_date')
  final String startDate;
  @JsonKey(name: 'end_date')
  final String endDate;
  @JsonKey(name: 'schedules')
  final List<Schedule> schedules;

  factory Planning.fromJson(Map<String, dynamic> json) =>
      _$PlanningFromJson(json);
}

@JsonSerializable()
class Schedule {
  const Schedule({
    required this.startTime,
    required this.endTime,
  });

  @JsonKey(name: 'start_time')
  final String startTime;
  @JsonKey(name: 'end_time')
  final String endTime;

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);
}
