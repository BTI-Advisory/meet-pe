import 'dart:convert';

class ArchivedReservationResponse {
  final int id;
  final String dateTime;
  final int nombreDesVoyageurs;
  final String messageAuGuide;
  final bool isPayed;
  final int voyageurId;
  final String nom;
  final String prenom;
  final String phone;
  final String createdAt;
  final String updatedAt;
  final String status;
  final String totalPrice;
  final String? refundAmount;
  final bool isGroup;
  final int experienceId;
  final String? canceledAt;
  final String? cancelReason;
  final String? cancelDescription;
  final Voyageur voyageur;
  final Experiencess experience;

  ArchivedReservationResponse({
    required this.id,
    required this.dateTime,
    required this.nombreDesVoyageurs,
    required this.messageAuGuide,
    required this.isPayed,
    required this.voyageurId,
    required this.nom,
    required this.prenom,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.totalPrice,
    this.refundAmount,
    required this.isGroup,
    required this.experienceId,
    this.canceledAt,
    this.cancelReason,
    this.cancelDescription,
    required this.voyageur,
    required this.experience,
  });

  factory ArchivedReservationResponse.fromJson(Map<String, dynamic> json) {
    var voyageurJson = json['voyageur'] as Map<String, dynamic>;
    Voyageur voyageur = Voyageur.fromJson(voyageurJson);
    var experienceJson = json['experience'] as Map<String, dynamic>;
    Experiencess experience = Experiencess.fromJson(experienceJson);

    return ArchivedReservationResponse(
      id: json['id'],
      dateTime: json['date_time'],
      nombreDesVoyageurs: json['nombre_des_voyageurs'],
      messageAuGuide: json['message_au_guide'],
      isPayed: json['is_payed'],
      voyageurId: json['voyageur_id'],
      nom: json['nom'],
      prenom: json['prenom'],
      phone: json['phone'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
      totalPrice: json['total_price'],
      refundAmount: json['refund_amount'],
      isGroup: json['is_group'] == 1,
      experienceId: json['experience_id'],
      canceledAt: json['canceled_at'],
      cancelReason: json['cancel_reason'],
      cancelDescription: json['cancel_description'],
      voyageur: voyageur,
      experience: experience,
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
  final String userType;
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
    required this.userType,
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
      userType: json['user_type'],
      profilePath: json['profile_path'],
      phoneNumber: json['phone_number'],
      isFullAvailable: json['is_full_available'],
      isVerified: json['is_verified'],
      numberOfExperiences: json['number_of_experiences'],
    );
  }
}

class Experiencess {
  final int id;
  final String title;
  final String description;
  final String dure;
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
  final String lang;
  final String lat;
  final bool supportGroupPrive;
  final int priceGroupPrive;
  final bool discountKidsBetween2And12;
  final String dernierMinuteReservation;
  final int maxGroupSize;

  Experiencess({
    required this.id,
    required this.title,
    required this.description,
    required this.dure,
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
    required this.lang,
    required this.lat,
    required this.supportGroupPrive,
    required this.priceGroupPrive,
    required this.discountKidsBetween2And12,
    required this.dernierMinuteReservation,
    required this.maxGroupSize,
  });

  factory Experiencess.fromJson(Map<String, dynamic> json) {
    return Experiencess(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dure: json['duree'],
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
      lang: json['lang'],
      lat: json['lat'],
      supportGroupPrive: json['support_group_prive'],
      priceGroupPrive: json['price_group_prive'],
      discountKidsBetween2And12: json['discount_kids_between_2_and_12'],
      dernierMinuteReservation: json['dernier_minute_reservation'] ?? false,
      maxGroupSize: json['max_group_size'],
    );
  }
}

List<ArchivedReservationResponse> parseArchivedReservation(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<ArchivedReservationResponse>((json) => ArchivedReservationResponse.fromJson(json)).toList();
}
