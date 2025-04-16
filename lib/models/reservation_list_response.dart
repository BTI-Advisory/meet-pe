import 'dart:convert';

class Photo {
  final int id;
  final int guideExperienceId;
  final String photoUrl;
  final String createdAt;
  final String updatedAt;
  final String typeImage;

  Photo({
    required this.id,
    required this.guideExperienceId,
    required this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.typeImage,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      guideExperienceId: json['guide_experience_id'],
      photoUrl: json['photo_url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      typeImage: json['type_image'],
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String? profilePath;
  final String? phoneNumber;
  final bool isVerifiedAccount;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profilePath,
    this.phoneNumber,
    required this.isVerifiedAccount,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profilePath: json['profile_path'],
      phoneNumber: json['phone_number'],
      isVerifiedAccount: json['is_verified_account'],
    );
  }
}

class Experience {
  final int id;
  final String title;
  final String description;
  final String duree;
  final String prixParVoyageur;
  final String? prixAPayeParVoyageur;
  final String inclus;
  final int nombreDesVoyageur;
  final String typeDesVoyageur;
  final String ville;
  final String addresse;
  final String codePostale;
  final String createdAt;
  final String updatedAt;
  final String? audioFile;
  final int userId;
  final String status;
  final String country;
  final String categorie;
  final String? guidePersonnesPeuvesParticiper;
  final String? etAvecCa;
  final bool isOnline;
  final String lang;
  final String lat;
  final bool supportGroupPrive;
  final int? priceGroupPrive;
  final String? prixGroupePrivePayeParVoyageur;
  final bool discountKidsBetween2And12;
  final String? dernierMinuteReservation;
  final int? maxGroupSize;
  final String? day;
  final String? heure;
  final String? raison;
  final String languages;
  final String duration;
  final List<Photo> photos;
  final User user;

  Experience({
    required this.id,
    required this.title,
    required this.description,
    required this.duree,
    required this.prixParVoyageur,
    required this.prixAPayeParVoyageur,
    required this.inclus,
    required this.nombreDesVoyageur,
    required this.typeDesVoyageur,
    required this.ville,
    required this.addresse,
    required this.codePostale,
    required this.createdAt,
    required this.updatedAt,
    required this.audioFile,
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
    this.priceGroupPrive,
    required this.prixGroupePrivePayeParVoyageur,
    required this.discountKidsBetween2And12,
    required this.dernierMinuteReservation,
    this.maxGroupSize,
    required this.day,
    required this.heure,
    required this.raison,
    required this.languages,
    required this.duration,
    required this.photos,
    required this.user,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      duree: json['duree'],
      prixParVoyageur: json['prix_par_voyageur'],
      prixAPayeParVoyageur: json['prix_a_paye_par_voyageur'],
      inclus: json['inclus'],
      nombreDesVoyageur: json['nombre_des_voyageur'],
      typeDesVoyageur: json['type_des_voyageur'],
      ville: json['ville'],
      addresse: json['addresse'],
      codePostale: json['code_postale'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      audioFile: json['audio_file'],
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
      prixGroupePrivePayeParVoyageur: json['prix_groupe_prive_paye_par_voyageur'],
      discountKidsBetween2And12: json['discount_kids_between_2_and_12'],
      dernierMinuteReservation: json['dernier_minute_reservation'],
      maxGroupSize: json['max_group_size'],
      day: json['day'],
      heure: json['heure'],
      raison: json['raison'],
      languages: json['languages'],
      duration: json['duration'],
      photos: (json['photos'] as List<dynamic>)
          .map((photoJson) => Photo.fromJson(photoJson))
          .toList(),
      user: User.fromJson(json['user']),
    );
  }
}

class ReservationListResponse {
  final int id;
  final String dateTime;
  final int nombreDesVoyageurs;
  final String messageAuGuide;
  final bool isPayed;
  final int voyageurId;
  final String? nom;
  final String? phone;
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
  final String? stripePaymentIntentId;
  final String? stripePaymentError;
  final Experience experience;

  ReservationListResponse({
    required this.id,
    required this.dateTime,
    required this.nombreDesVoyageurs,
    required this.messageAuGuide,
    required this.isPayed,
    required this.voyageurId,
    this.nom,
    this.phone,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.totalPrice,
    required this.refundAmount,
    required this.isGroup,
    required this.experienceId,
    required this.canceledAt,
    required this.cancelReason,
    required this.cancelDescription,
    required this.stripePaymentIntentId,
    required this.stripePaymentError,
    required this.experience,
  });

  factory ReservationListResponse.fromJson(Map<String, dynamic> json) {
    return ReservationListResponse(
      id: json['id'],
      dateTime: json['date_time'],
      nombreDesVoyageurs: json['nombre_des_voyageurs'],
      messageAuGuide: json['message_au_guide'],
      isPayed: json['is_payed'],
      voyageurId: json['voyageur_id'],
      nom: json['nom'],
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
      stripePaymentIntentId: json['stripe_payment_intent_id'],
      stripePaymentError: json['stripe_payment_error'],
      experience: Experience.fromJson(json['experience']),
    );
  }
}

List<ReservationListResponse> parseReservationList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<ReservationListResponse>((json) => ReservationListResponse.fromJson(json)).toList();
}

