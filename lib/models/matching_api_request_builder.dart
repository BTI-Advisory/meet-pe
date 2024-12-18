class FiltersRequest {
  String? filtreDateDebut;
  String? filtreDateFin;
  String? filtreVille;
  String? filtrePays;
  String? filtreLat;
  String? filtreLang;
  String? filtreDistance;
  String? filtreCategorie;
  String? filtreLangue;
  int? filtrePrixMin;
  int? filtrePrixMax;
  int? filtreNbAdult;
  int? filtreNbEnfant;
  int? filtreNbBebes;

  FiltersRequest({
    this.filtreDateDebut,
    this.filtreDateFin,
    this.filtreVille,
    this.filtrePays,
    this.filtreLat,
    this.filtreLang,
    this.filtreDistance,
    this.filtreCategorie,
    this.filtreLangue,
    this.filtrePrixMin,
    this.filtrePrixMax,
    this.filtreNbAdult,
    this.filtreNbEnfant,
    this.filtreNbBebes,
  });

  /// Converts the object into a Map (JSON format) with only non-null fields.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    if (filtreDateDebut != null) json['filtre_date_debut'] = filtreDateDebut;
    if (filtreDateFin != null) json['filtre_date_fin'] = filtreDateFin;
    if (filtreVille != null) json['filtre_ville'] = filtreVille;
    if (filtrePays != null) json['filtre_pays'] = filtrePays;
    if (filtreLat != null) json['filtre_lat'] = filtreLat;
    if (filtreLang != null) json['filtre_lang'] = filtreLang;
    if (filtreDistance != null) json['filtre_distance'] = filtreDistance;
    if (filtreCategorie != null) json['filtre_categorie'] = filtreCategorie;
    if (filtreLangue != null) json['filtre_langue'] = filtreLangue;
    if (filtrePrixMin != null) json['filtre_prix_min'] = filtrePrixMin;
    if (filtrePrixMax != null) json['filtre_prix_max'] = filtrePrixMax;
    if (filtreNbAdult != null) json['filtre_nb_adultes'] = filtreNbAdult;
    if (filtreNbEnfant != null) json['filtre_nb_enfants'] = filtreNbEnfant;
    if (filtreNbBebes != null) json['filtre_nb_bebes'] = filtreNbBebes;

    return json;
  }
}
