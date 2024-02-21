import 'dart:convert';

class AbsenceListResponse {
  final int id;
  final String? from;
  final String? to;
  final String createdAt;
  final String updatedAt;
  final int userId;
  final String? day;
  final String? dateFrom;
  final String? dateTo;

  AbsenceListResponse({
    required this.id,
    required this.from,
    required this.to,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.day,
    required this.dateFrom,
    required this.dateTo,
  });

  factory AbsenceListResponse.fromJson(Map<String, dynamic> json) {
    return AbsenceListResponse(
      id: json['id'],
      from: json['from'],
      to: json['to'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      userId: json['user_id'],
      day: json['day'],
      dateFrom: json['date_from'],
      dateTo: json['date_to'],
    );
  }
}

List<AbsenceListResponse> parseScheduleEntries(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<AbsenceListResponse>((json) => AbsenceListResponse.fromJson(json)).toList();
}
