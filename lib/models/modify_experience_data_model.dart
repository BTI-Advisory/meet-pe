import 'dart:io';

class ModifyExperienceDataModel {
  int? experienceId;
  String? description;
  String? aboutGuide;
  int? prixParVoyageur;
  int? priceGroupPrive;
  int? numberVoyageur;
  int? discountKidsBetween2And12;
  String? imagePrincipale;
  String? image1;
  String? image2;
  String? image3;
  String? image4;
  String? image5;
  String? title;
  List<AvailabilitiesDataModel>? availabilitiesData;

  ModifyExperienceDataModel({
    this.experienceId,
    this.description,
    this.aboutGuide,
    this.prixParVoyageur,
    this.priceGroupPrive,
    this.numberVoyageur,
    this.discountKidsBetween2And12,
    this.imagePrincipale,
    this.image1,
    this.image2,
    this.image3,
    this.image4,
    this.image5,
    this.title,
    this.availabilitiesData
  });
}

class AvailabilitiesDataModel {
  String day;
  bool availableFullDay;
  String startTime;
  String endTime;
  String? startSecondTime;
  String? endSecondTime;

  AvailabilitiesDataModel({
    required this.day,
    required this.availableFullDay,
    required this.startTime,
    required this.endTime,
    this.startSecondTime,
    this.endSecondTime,
  });
}
