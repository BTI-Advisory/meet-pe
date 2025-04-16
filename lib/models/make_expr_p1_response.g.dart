// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'make_expr_p1_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MakeExprP1Response _$MakeExprP1ResponseFromJson(Map<String, dynamic> json) =>
    MakeExprP1Response(
      experience:
          Experience.fromJson(json['experience'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MakeExprP1ResponseToJson(MakeExprP1Response instance) =>
    <String, dynamic>{
      'experience': instance.experience,
    };

Experience _$ExperienceFromJson(Map<String, dynamic> json) => Experience(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      duree: json['duree'] as String,
      prixParVoyageur: json['prix_par_voyageur'] as String?,
      inclus: json['inclus'] as String?,
      nombreDesVoyageur: json['nombre_des_voyageur'] as int?,
      typeDesVoyageur: json['type_des_voyageur'] as String?,
      ville: json['ville'] as String?,
      addresse: json['addresse'] as String?,
      codePostale: json['code_postale'] as String?,
      userId: json['user_id'] as int,
      status: json['status'] as String,
    );

Map<String, dynamic> _$ExperienceToJson(Experience instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'duree': instance.duree,
      'prix_par_voyageur': instance.prixParVoyageur,
      'inclus': instance.inclus,
      'nombre_des_voyageur': instance.nombreDesVoyageur,
      'type_des_voyageur': instance.typeDesVoyageur,
      'ville': instance.ville,
      'addresse': instance.addresse,
      'code_postale': instance.codePostale,
      'user_id': instance.userId,
      'status': instance.status,
    };
