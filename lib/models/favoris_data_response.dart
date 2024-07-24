import 'package:json_annotation/json_annotation.dart';

part 'favoris_data_response.g.dart';

@JsonSerializable(createToJson: false)
class FavorisDataResponse {
  const FavorisDataResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.aboutGuide,
    required this.pricePerTraveler,
    required this.numberOfTravelers,
    required this.city,
    required this.address,
    required this.postalCode,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.status,
    required this.country,
    required this.categories,
    this.guideParticipants,
    required this.etAvecCa,
    required this.isOnline,
    required this.isProfessionalGuide,
    required this.guideDescription,
    required this.guideName,
    required this.mainPhoto,
    this.image0,
    this.image1,
    this.image2,
    this.image3,
    this.image4});

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'dure')
  final String duration;
  @JsonKey(name: 'about_guide')
  final String aboutGuide;
  @JsonKey(name: 'prix_par_voyageur')
  final String pricePerTraveler;
  @JsonKey(name: 'nombre_des_voyageur')
  final int numberOfTravelers;
  @JsonKey(name: 'ville')
  final String city;
  @JsonKey(name: 'addresse')
  final String address;
  @JsonKey(name: 'code_postale')
  final String postalCode;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'country')
  final String country;
  @JsonKey(name: 'categorie')
  final List<String> categories;
  @JsonKey(name: 'guide_personnes_peuves_participer')
  final List<String?>? guideParticipants;
  @JsonKey(name: 'et_avec_ça')
  final List<String> etAvecCa;
  @JsonKey(name: 'is_online')
  final bool isOnline;
  @JsonKey(name: 'guide_is_pro')
  final bool isProfessionalGuide;
  @JsonKey(name: 'description_guide')
  final String? guideDescription;
  @JsonKey(name: 'nom_of_guide')
  final String guideName;
  @JsonKey(name: 'photoprincipal')
  final String mainPhoto;
  @JsonKey(name: 'image_0')
  final String? image0;
  @JsonKey(name: 'image_1')
  final String? image1;
  @JsonKey(name: 'image_2')
  final String? image2;
  @JsonKey(name: 'image_3')
  final String? image3;
  @JsonKey(name: 'image_4')
  final String? image4;

  factory FavorisDataResponse.fromJson(Map<String, dynamic> json) =>
      _$FavorisDataResponseFromJson(json);
}
