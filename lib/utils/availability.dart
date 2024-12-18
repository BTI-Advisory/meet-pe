class Availability {
  String day;
  bool isAvailableFullDay;

  Availability({
    required this.day,
    required this.isAvailableFullDay,
  });

  Map<String, dynamic> toJson() => {
    'day': day,
    'is_available_full_day': isAvailableFullDay,
  };
}

class Absence {
  String day;
  String dayFrom;
  String dayTo;

  Absence({
    required this.day,
    required this.dayFrom,
    required this.dayTo,
  });

  Map<String, dynamic> toJson() => {
    'day': day,
    'day_from': dayFrom,
    'day_to': dayTo,
  };
}

class ModifyAbsence {
  int id;
  String day;
  String dayFrom;
  String dayTo;

  ModifyAbsence({
    required this.id,
    required this.day,
    required this.dayFrom,
    required this.dayTo,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'day': day,
    'day_from': dayFrom,
    'day_to': dayTo,
  };
}

class SearchByDate {
  String dayFrom;
  String dayTo;

  SearchByDate({
    required this.dayFrom,
    required this.dayTo,
  });

  Map<String, dynamic> toJson() => {
    'day_from': dayFrom,
    'day_to': dayTo,
  };
}