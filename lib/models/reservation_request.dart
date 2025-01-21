class ReservationRequest {
  int? experienceId;
  String? dateTime;
  int? voyageursAdultes;
  int? voyageursEnfants;
  int? voyageursBebes;
  String? messageAuGuide;
  String? prenom;
  bool isGroup;
  double price;

  ReservationRequest({
    this.experienceId,
    this.dateTime,
    this.voyageursAdultes,
    this.voyageursEnfants,
    this.voyageursBebes,
    this.messageAuGuide,
    this.prenom,
    required this.isGroup,
    required this.price,
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
    if (prenom != null) json['prenom'] = prenom;
    json['is_group'] = isGroup;
    json['total_price'] = price;

    return json;
  }
}
