class ReservationRequest {
  int? experienceId;
  String? dateTime;
  int? voyageursAdultes;
  int? voyageursEnfants;
  int? voyageursBebes;
  String? prenom;
  bool isGroup;
  double price;

  ReservationRequest({
    this.experienceId,
    this.dateTime,
    this.voyageursAdultes,
    this.voyageursEnfants,
    this.voyageursBebes,
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
    if (prenom != null) json['prenom'] = prenom;
    json['is_group'] = isGroup;
    json['total_price'] = price;

    return json;
  }
}
