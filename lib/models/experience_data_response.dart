import 'package:json_annotation/json_annotation.dart';

part 'experience_data_response.g.dart';

@JsonSerializable(createToJson: false)
class ExperienceDataResponse {
  const ExperienceDataResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.dure,
    required this.prixParVoyageur,
    required this.nombreDesVoyageur,
    required this.ville,
    required this.addresse,
    required this.codePostale,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.status,
    required this.country,
    required this.categorie,
    required this.guidePersonnesPeuvesParticiper,
    required this.etAvecCa,
    required this.isOnline,
    required this.guideIsPro,
    required this.descriptionGuide,
    required this.nameGuide,
    required this.photoPrincipal});

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'dure')
  final String dure;
  @JsonKey(name: 'prix_par_voyageur')
  final String prixParVoyageur;
  @JsonKey(name: 'nombre_des_voyageur')
  final int nombreDesVoyageur;
  @JsonKey(name: 'ville')
  final String ville;
  @JsonKey(name: 'addresse')
  final String addresse;
  @JsonKey(name: 'code_postale')
  final String codePostale;
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
  final List<String> categorie;
  @JsonKey(name: 'guide_personnes_peuves_participer')
  final List<String> guidePersonnesPeuvesParticiper;
  @JsonKey(name: 'et_avec_ça')
  final List<String> etAvecCa;
  @JsonKey(name: 'is_online')
  final bool isOnline;
  @JsonKey(name: 'guide_is_pro')
  final bool guideIsPro;
  @JsonKey(name: 'description_guide')
  final String? descriptionGuide;
  @JsonKey(name: 'nom_of_guide')
  final String nameGuide;
  @JsonKey(name: 'photoprincipal')
  final PhotoPrincipal photoPrincipal;

  factory ExperienceDataResponse.fromJson(Map<String, dynamic> json) =>
      _$ExperienceDataResponseFromJson(json);
}

@JsonSerializable()
class PhotoPrincipal {
  final int id;
  @JsonKey(name: 'guide_experience_id')
  final int guideExperienceId;
  @JsonKey(name: 'photo_url')
  final String photoUrl;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'type_image')
  final String typeImage;

  PhotoPrincipal({
    required this.id,
    required this.guideExperienceId,
    required this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.typeImage,
  });

  factory PhotoPrincipal.fromJson(Map<String, dynamic> json) =>
      _$PhotoPrincipalFromJson(json);
}
