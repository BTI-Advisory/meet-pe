import 'dart:convert';

class GuideReservationResponse {
  final int id;
  final String dateTime;
  final int nombreDesVoyageurs;
  final String messageAuGuide;
  final bool isPayed;
  final int voyageurId;
  final int guidId;
  final String createdAt;
  final String updatedAt;
  //final String dure;
  final String status;
  final Voyageur voyageur;
  final Experience experience;

  GuideReservationResponse({
    required this.id,
    required this.dateTime,
    required this.nombreDesVoyageurs,
    required this.messageAuGuide,
    required this.isPayed,
    required this.voyageurId,
    required this.guidId,
    required this.createdAt,
    required this.updatedAt,
    //required this.dure,
    required this.status,
    required this.voyageur,
    required this.experience
  });

  factory GuideReservationResponse.fromJson(Map<String, dynamic> json) {
    var voyageurJson = json['voyageur'] as Map<String, dynamic>;
    Voyageur voyageur = Voyageur.fromJson(voyageurJson);
    var experienceJson = json['experience'] as Map<String, dynamic>;
    Experience experience = Experience.fromJson(experienceJson);

    return GuideReservationResponse(
      id: json['id'],
      dateTime: json['date_time'],
      nombreDesVoyageurs: json['nombre_des_voyageurs'],
      messageAuGuide: json['message_au_guide'],
      isPayed: json['is_payed'],
      voyageurId: json['voyageur_id'],
      guidId: json['guid_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      //dure: json['dure'],
      status: json['status'],
      voyageur: voyageur,
      experience: experience,
    );
  }
}

class Voyageur {
  final int id;
  final String name;
  final String email;
  //final String emailVerifiedAt;
  final String createdAt;
  final String updatedAt;
  final String otpCode;
  //final String userType;
  final String profilePath;
  //final String sirenNumber;
  final String phoneNumber;
  final bool isFullAvailable;
  /*final String iBAN;
  final String bIC;
  final String nomDuTitulaire;
  final String rue;
  final String codePostal;
  final String ville;*/
  final bool isVerified;
  final int numberOfExperiences;

  Voyageur({
    required this.id,
    required this.name,
    required this.email,
    //required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.otpCode,
    //required this.userType,
    required this.profilePath,
    //required this.sirenNumber,
    required this.phoneNumber,
    required this.isFullAvailable,
    /*required this.iBAN,
    required this.bIC,
    required this.nomDuTitulaire,
    required this.rue,
    required this.codePostal,
    required this.ville,*/
    required this.isVerified,
    required this.numberOfExperiences,
  });

  factory Voyageur.fromJson(Map<String, dynamic> json) {
    return Voyageur(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      //emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      otpCode: json['otp_code'],
      //userType: json['user_type'],
      profilePath: json['profile_path'],
      //sirenNumber: json['siren_number'],
      phoneNumber: json['phone_number'],
      isFullAvailable: json['is_full_available'],
      /*iBAN: json['IBAN'],
      bIC: json['BIC'],
      nomDuTitulaire: json['nom_du_titulaire'],
      rue: json['rue'],
      codePostal: json['code_postal'],
      ville: json['ville'],*/
      isVerified: json['is_verified'],
      numberOfExperiences: json['number_of_experiences'],
    );
  }
}

class Experience {
  final int id;
  final String title;
  final String description;
  final String dure;
  final String prixParVoyageur;
  //final String inclus;
  final String nombreDesVoyageur;
  //final String typeDesVoyageur;
  final String ville;
  final String addresse;
  final String codePostal;
  final String createdAt;
  final String updatedAt;
  //final String audioFile;
  final int userId;
  final String status;
  final String country;
  final String categorie;
  final String guidePersonnesPeuvesParticiper;
  final String etAvecCa;
  final bool isOnline;
  //final String lang;
  //final String lat;

  Experience({
    required this.id,
    required this.title,
    required this.description,
    required this.dure,
    required this.prixParVoyageur,
    //required this.inclus,
    required this.nombreDesVoyageur,
    //required this.typeDesVoyageur,
    required this.ville,
    required this.addresse,
    required this.codePostal,
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
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dure: json['dure'],
      prixParVoyageur: json['prix_par_voyageur'],
      //inclus: json['inclus'],
      nombreDesVoyageur: json['nombre_des_voyageur'],
      //typeDesVoyageur: json['type_des_voyageur'],
      ville: json['ville'],
      addresse: json['addresse'],
      codePostal: json['code_postale'],
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
    );
  }
}

List<GuideReservationResponse> parseGuideReservationItem(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<GuideReservationResponse>((json) => GuideReservationResponse.fromJson(json)).toList();
}
