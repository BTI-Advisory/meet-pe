import 'dart:convert';

class GuideReservationResponse {
  final int id;
  final String dateTime;
  final int nombreDesVoyageurs;
  final String messageAuGuide;
  final bool isPayed;
  final int voyageurId;
  final String createdAt;
  final String updatedAt;
  final String status;
  final int experienceId;
  final Voyageur voyageur;
  final Experience experience;

  GuideReservationResponse({
    required this.id,
    required this.dateTime,
    required this.nombreDesVoyageurs,
    required this.messageAuGuide,
    required this.isPayed,
    required this.voyageurId,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.experienceId,
    required this.voyageur,
    required this.experience,
  });

  factory GuideReservationResponse.fromJson(Map<String, dynamic> json) {
    return GuideReservationResponse(
      id: json['id'],
      dateTime: json['date_time'],
      nombreDesVoyageurs: json['nombre_des_voyageurs'],
      messageAuGuide: json['message_au_guide'],
      isPayed: json['is_payed'],
      voyageurId: json['voyageur_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
      experienceId: json['experience_id'],
      voyageur: Voyageur.fromJson(json['voyageur']),
      experience: Experience.fromJson(json['experience']),
    );
  }
}

class Voyageur {
  final int id;
  final String name;
  final String email;
  final String createdAt;
  final String updatedAt;
  final String otpCode;
  final String profilePath;
  final String phoneNumber;
  final bool isFullAvailable;
  final bool isVerified;
  final int numberOfExperiences;

  Voyageur({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    required this.otpCode,
    required this.profilePath,
    required this.phoneNumber,
    required this.isFullAvailable,
    required this.isVerified,
    required this.numberOfExperiences,
  });

  factory Voyageur.fromJson(Map<String, dynamic> json) {
    return Voyageur(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      otpCode: json['otp_code'],
      profilePath: json['profile_path'],
      phoneNumber: json['phone_number'],
      isFullAvailable: json['is_full_available'],
      isVerified: json['is_verified'],
      numberOfExperiences: json['number_of_experiences'],
    );
  }
}

class Experience {
  final int id;
  final String title;
  final String description;
  final String? dure; // Optional field
  final String prixParVoyageur;
  final int nombreDesVoyageur;
  final String ville;
  final String addresse;
  final String codePostal;
  final String createdAt;
  final String updatedAt;
  final int userId;
  final String status;
  final String country;
  final String categorie;
  final String guidePersonnesPeuvesParticiper;
  final String etAvecCa;
  final bool isOnline;

  Experience({
    required this.id,
    required this.title,
    required this.description,
    this.dure,
    required this.prixParVoyageur,
    required this.nombreDesVoyageur,
    required this.ville,
    required this.addresse,
    required this.codePostal,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.status,
    required this.country,
    required this.categorie,
    required this.guidePersonnesPeuvesParticiper,
    required this.etAvecCa,
    required this.isOnline,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dure: json['dure'],
      prixParVoyageur: json['prix_par_voyageur'],
      nombreDesVoyageur: json['nombre_des_voyageur'],
      ville: json['ville'],
      addresse: json['addresse'],
      codePostal: json['code_postale'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      userId: json['user_id'],
      status: json['status'],
      country: json['country'],
      categorie: json['categorie'],
      guidePersonnesPeuvesParticiper: json['guide_personnes_peuves_participer'],
      etAvecCa: json['et_avec_ça'],
      isOnline: json['is_online'],
    );
  }
}

Map<String, List<GuideReservationResponse>> parseGuideReservationItem(
    String responseBody) {
  final Map<String, dynamic> parsed = jsonDecode(responseBody);

  // Iterate over each key-value pair (date and list of reservations)
  return parsed.map<String, List<GuideReservationResponse>>((date, reservations) {
    var reservationList = (reservations as List)
        .map((reservationJson) => GuideReservationResponse.fromJson(reservationJson))
        .toList();
    return MapEntry(date, reservationList);
  });
}
