class Availability {
  String day;
  bool isAvailableFullDay;
  List<TimeSlot> times;

  Availability({
    required this.day,
    required this.isAvailableFullDay,
    required this.times,
  });

  Map<String, dynamic> toJson() => {
    'day': day,
    'is_available_full_day': isAvailableFullDay,
    'times': times.map((timeSlot) => timeSlot.toJson()).toList(),
  };
}

class TimeSlot {
  String from;
  String to;

  TimeSlot({
    required this.from,
    required this.to,
  });

  Map<String, dynamic> toJson() => {
    'from': from,
    'to': to,
  };
}

class Absence {
  String day;
  String dayFrom;
  String dayTo;
  List<TimeSlot> times;

  Absence({
    required this.day,
    required this.dayFrom,
    required this.dayTo,
    required this.times,
  });

  Map<String, dynamic> toJson() => {
    'day': day,
    'day_from': dayFrom,
    'day_to': dayTo,
    'horraires': times.map((timeSlot) => timeSlot.toJson()).toList(),
  };
}

class ModifyAbsence {
  int id;
  String day;
  String dayFrom;
  String dayTo;
  List<TimeSlot> times;

  ModifyAbsence({
    required this.id,
    required this.day,
    required this.dayFrom,
    required this.dayTo,
    required this.times,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'day': day,
    'day_from': dayFrom,
    'day_to': dayTo,
    'horraires': times.map((timeSlot) => timeSlot.toJson()).toList(),
  };
}