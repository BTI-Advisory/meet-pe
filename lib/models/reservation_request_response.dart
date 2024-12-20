import 'package:json_annotation/json_annotation.dart';

part 'reservation_request_response.g.dart';

@JsonSerializable(createToJson: false)
class ReservationRequestResponse {
  const ReservationRequestResponse({
    required this.id,
    required this.dateTime,
    required this.nombreDesVoyageurs,
    required this.voyageurId,
    required this.experienceId,
    required this.messageAuGuide,
    required this.nom,
    required this.prenom,
    required this.phone,
    required this.isPayed,
    required this.createdAt,
    required this.updatedAt
  });

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'date_time')
  final String dateTime;
  @JsonKey(name: 'nombre_des_voyageurs')
  final int nombreDesVoyageurs;
  @JsonKey(name: 'voyageur_id')
  final int voyageurId;
  @JsonKey(name: 'experience_id')
  final int experienceId;
  @JsonKey(name: 'message_au_guide')
  final String messageAuGuide;
  @JsonKey(name: 'nom')
  final String nom;
  @JsonKey(name: 'prenom')
  final String prenom;
  @JsonKey(name: 'phone')
  final String phone;
  @JsonKey(name: 'is_payed')
  final bool isPayed;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  factory ReservationRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$ReservationRequestResponseFromJson(json);
}
