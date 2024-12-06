class ModifyExperienceDataModel {
  String? title;
  String? description;
  String? duree;
  String? experienceLanguages;
  List<HorairesDataModel>? horaires;
  int? prixParVoyageur;
  int? priceGroupPrive;
  int? maxNumberOfPersons;
  String? discountKidsBetween2And12;
  String? imagePrincipale;
  String? image1;
  String? image2;
  String? image3;
  String? image4;
  String? image5;

  ModifyExperienceDataModel({
    this.title,
    this.description,
    this.duree,
    this.experienceLanguages,
    this.horaires,
    this.prixParVoyageur,
    this.priceGroupPrive,
    this.maxNumberOfPersons,
    this.discountKidsBetween2And12,
    this.imagePrincipale,
    this.image1,
    this.image2,
    this.image3,
    this.image4,
    this.image5,
  });
}

class HorairesDataModel {
  String? heureDebut;
  String? heureFin;
  List<DatesDataModel> dates;

  HorairesDataModel({
    this.heureDebut,
    this.heureFin,
    required this.dates,
  });
}

class DatesDataModel {
  String? dateDebut;
  String? dateFin;

  DatesDataModel({
    this.dateDebut,
    this.dateFin,
  });
}
