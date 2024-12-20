// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_request_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationRequestResponse _$ReservationRequestResponseFromJson(
        Map<String, dynamic> json) =>
    ReservationRequestResponse(
      id: (json['id'] as num).toInt(),
      dateTime: json['date_time'] as String,
      nombreDesVoyageurs: (json['nombre_des_voyageurs'] as num).toInt(),
      voyageurId: (json['voyageur_id'] as num).toInt(),
      experienceId: (json['experience_id'] as num).toInt(),
      messageAuGuide: json['message_au_guide'] as String,
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      phone: json['phone'] as String,
      isPayed: json['is_payed'] as bool,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
