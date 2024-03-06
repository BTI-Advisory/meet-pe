import 'dart:convert';

class GuideExperiencesResponse {
  final int id;
  final String title;
  final String description;
  final String dure;
  final String prixParVoyageur;
  //final String? inclus;
  final String nombreDesVoyageurs;
  //final String? typeDesVoyageurs;
  final String ville;
  final String addresse;
  final String codePostale;
  final String createdAt;
  final String updatedAt;
  //final String? audioFile;
  final int userId;
  final String status;
  final String country;
  final String categorie;
  final String guidePersonnesPeuvesParticiper;
  final String etAvecCa;
  final bool isOnline;
  //final String? lang;
  //final String? lat;
  final PhotoPrincipal photoPrincipal;

  GuideExperiencesResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.dure,
    required this.prixParVoyageur,
    //required this.inclus,
    required this.nombreDesVoyageurs,
    //required this.typeDesVoyageurs,
    required this.ville,
    required this.addresse,
    required this.codePostale,
    required this.createdAt,
    required this.updatedAt,
    //required this.audioFile,
    required this.userId,
    required this.status,
    required this.country,
    required this.categorie,
    required this.guidePersonnesPeuvesParticiper,
    required this.etAvecCa,
    required this.isOnline,
    //required this.lang,
    //required this.lat,
    required this.photoPrincipal,
  });

  factory GuideExperiencesResponse.fromJson(Map<String, dynamic> json) {

    return GuideExperiencesResponse(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dure: json['dure'],
      prixParVoyageur: json['prix_par_voyageur'],
      //inclus: json['inclus'],
      nombreDesVoyageurs: json['nombre_des_voyageur'],
      //typeDesVoyageurs: json['type_des_voyageur'],
      ville: json['ville'],
      addresse: json['addresse'],
      codePostale: json['code_postale'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      //audioFile: json['audio_file'],
      userId: json['user_id'],
      status: json['status'],
      country: json['country'],
      categorie: json['categorie'],
      guidePersonnesPeuvesParticiper: json['guide_personnes_peuves_participer'],
      etAvecCa: json['et_avec_ça'],
      isOnline: json['is_online'],
      //lang: json['lang'],
      //lat: json['lat'],
      photoPrincipal: PhotoPrincipal.fromJson(json['photoprincipal']),
    );
  }
}

class PhotoPrincipal {
  final int id;
  final int guideExperienceId;
  final String photoUrl;
  final String typeImage;
  final String createdAt;
  final String updatedAt;

  PhotoPrincipal({
    required this.id,
    required this.guideExperienceId,
    required this.photoUrl,
    required this.typeImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PhotoPrincipal.fromJson(Map<String, dynamic> json) {
    return PhotoPrincipal(
      id: json['id'],
      guideExperienceId: json['guide_experience_id'],
      photoUrl: json['photo_url'],
      typeImage: json['type_image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

List<GuideExperiencesResponse> parseGuideExperiencesItem(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<GuideExperiencesResponse>((json) => GuideExperiencesResponse.fromJson(json)).toList();
}
