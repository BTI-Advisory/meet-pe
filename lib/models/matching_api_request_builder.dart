class FiltersRequest {
  String? filtreDateDebut;
  String? filtreDateFin;
  String? filtreVille;
  String? filtrePays;
  String? filtreLat;
  String? filtreLang;
  int? filtreDistance;
  String? filtreCategorie;
  String? filtreLangue;
  String? filtreNbVoyageurTotal;
  int? filtrePrixMin;
  int? filtrePrixMax;

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
    this.filtreNbVoyageurTotal,
    this.filtrePrixMin,
    this.filtrePrixMax,
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
    if (filtreNbVoyageurTotal != null) {
      json['filtre_nb_voyageur_total'] = filtreNbVoyageurTotal;
    }
    if (filtrePrixMin != null) json['filtre_prix_min'] = filtrePrixMin;
    if (filtrePrixMax != null) json['filtre_prix_max'] = filtrePrixMax;

    return json;
  }
}
