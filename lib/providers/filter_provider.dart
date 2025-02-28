import 'package:flutter/material.dart';

import '../models/experience_model.dart';
import '../models/matching_api_request_builder.dart';
import '../services/app_service.dart';

class FilterProvider with ChangeNotifier {
  // Existing fields
  String? selectedCity;
  String? selectedCountry;
  String? startDate;
  String? endDate;
  String? nbAdultes;
  String? nbEnfants;
  String? nbBebes;
  String? prixMin;
  String? prixMax;
  String? categorie;
  String? langue;
  double? latitude;
  double? longitude;
  int? radius;

  List<ExperienceModel> _matchingList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ExperienceModel> get matchingList => _matchingList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch matching experiences
  Future<void> fetchMatchingExperiences() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      FiltersRequest filters = FiltersRequest(
        filtreVille: selectedCity,
        filtrePays: selectedCountry,
        filtreDateDebut: startDate,
        filtreDateFin: endDate,
        filtreNbAdult: nbAdultes,
        filtreNbEnfant: nbEnfants,
        filtreNbBebes: nbBebes,
        filtrePrixMin: prixMin,
        filtrePrixMax: prixMax,
        filtreCategorie: categorie,
        filtreLangue: langue,
        filtreLat: latitude?.toString(),
        filtreLang: longitude?.toString(),
        filtreDistance: radius?.toString(),
      );

      _matchingList = await AppService.api.fetchExperiences(filters);
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateCity(String city, String country) {
    selectedCity = city;
    selectedCountry = country;
    notifyListeners();
  }

  void updateDateRange(String? start, String? end) {
    startDate = start;
    endDate = end;
    notifyListeners();
  }

  void updateFilters({
    String? nbAdultes,
    String? nbEnfants,
    String? nbBebes,
    String? prixMin,
    String? prixMax,
    String? categorie,
    String? langue,
  }) {
    this.nbAdultes = nbAdultes;
    this.nbEnfants = nbEnfants;
    this.nbBebes = nbBebes;
    this.prixMin = prixMin;
    this.prixMax = prixMax;
    this.categorie = categorie;
    this.langue = langue;
    notifyListeners();
  }

  void updateLocationFilters(double? lat, double? lng, int? rad) {
    latitude = lat;
    longitude = lng;
    radius = rad;
    notifyListeners();
  }
}
