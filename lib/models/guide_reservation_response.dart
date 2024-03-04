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
  final String dure;
  final String status;
  final Voyageur voyageur;

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
    required this.dure,
    required this.status,
    required this.voyageur,
  });

  factory GuideReservationResponse.fromJson(Map<String, dynamic> json) {
    var voyageurJson = json['voyageur'] as Map<String, dynamic>;
    Voyageur voyageur = Voyageur.fromJson(voyageurJson);

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
      dure: json['dure'],
      status: json['status'],
      voyageur: voyageur,
    );
  }
}

class Voyageur {
  final int id;
  final String name;
  final String email;
  final String emailVerifiedAt;
  final String createdAt;
  final String updatedAt;
  final String otpCode;
  final String userType;
  final String profilePath;
  final String sirenNumber;
  final String phoneNumber;
  final bool isFullAvailable;
  final String iBAN;
  final String bIC;
  final String nomDuTitulaire;
  final String rue;
  final String codePostal;
  final String ville;

  Voyageur({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.otpCode,
    required this.userType,
    required this.profilePath,
    required this.sirenNumber,
    required this.phoneNumber,
    required this.isFullAvailable,
    required this.iBAN,
    required this.bIC,
    required this.nomDuTitulaire,
    required this.rue,
    required this.codePostal,
    required this.ville,
  });

  factory Voyageur.fromJson(Map<String, dynamic> json) {
    return Voyageur(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      otpCode: json['otp_code'],
      userType: json['user_type'],
      profilePath: json['profile_path'],
      sirenNumber: json['siren_number'],
      phoneNumber: json['phone_number'],
      isFullAvailable: json['is_full_available'],
      iBAN: json['IBAN'],
      bIC: json['BIC'],
      nomDuTitulaire: json['nom_du_titulaire'],
      rue: json['rue'],
      codePostal: json['code_postal'],
      ville: json['ville'],
    );
  }
}

List<GuideReservationResponse> parseGuideReservationItem(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<GuideReservationResponse>((json) => GuideReservationResponse.fromJson(json)).toList();
}
