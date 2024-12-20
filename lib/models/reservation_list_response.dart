import 'dart:convert';

class ReservationListResponse {
  final int id;
  final String? dateTime;
  final int? nombreDesVoyageurs;
  final String messageAuGuide;
  final bool isPayed;
  final int voyageurId;
  final int? guideId;
  final String? duree;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  ReservationListResponse({
    required this.id,
    required this.dateTime,
    required this.nombreDesVoyageurs,
    required this.messageAuGuide,
    required this.isPayed,
    required this.voyageurId,
    required this.guideId,
    required this.duree,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReservationListResponse.fromJson(Map<String, dynamic> json) {
    return ReservationListResponse(
      id: json['id'],
      dateTime: json['date_time'],
      nombreDesVoyageurs: json['nombre_des_voyageurs'],
      messageAuGuide: json['message_au_guide'],
      isPayed: json['is_payed'],
      voyageurId: json['voyageur_id'],
      guideId: json['guid_id'],
      duree: json['duree'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

List<ReservationListResponse> parseReservationList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<ReservationListResponse>((json) => ReservationListResponse.fromJson(json)).toList();
}

