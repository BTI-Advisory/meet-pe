class ReservationRequest {
  int? experienceId;
  String? dateTime;
  int? voyageursAdultes;
  int? voyageursEnfants;
  int? voyageursBebes;
  String? messageAuGuide;
  String? nom;
  String? prenom;
  String? phone;

  ReservationRequest({
    this.experienceId,
    this.dateTime,
    this.voyageursAdultes,
    this.voyageursEnfants,
    this.voyageursBebes,
    this.messageAuGuide,
    this.nom,
    this.prenom,
    this.phone,
  });

  /// Converts the object into a Map (JSON format) with only non-null fields.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    if (experienceId != null) json['experience_id'] = experienceId;
    if (dateTime != null) json['date_time'] = dateTime;
    if (voyageursAdultes != null) json['voyageurs_adultes'] = voyageursAdultes;
    if (voyageursEnfants != null) json['voyageurs_enfants'] = voyageursEnfants;
    if (voyageursBebes != null) json['voyageurs_bebes'] = voyageursBebes;
    if (messageAuGuide != null) json['message_au_guide'] = messageAuGuide;
    if (nom != null) json['nom'] = nom;
    if (prenom != null) json['prenom'] = prenom;
    if (phone != null) json['phone'] = phone;

    return json;
  }
}
