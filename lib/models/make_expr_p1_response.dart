import 'package:json_annotation/json_annotation.dart';

part 'make_expr_p1_response.g.dart';

@JsonSerializable()
class MakeExprP1Response {
  final Experience experience;

  MakeExprP1Response({
    required this.experience,
  });

  factory MakeExprP1Response.fromJson(Map<String, dynamic> json) =>
      _$MakeExprP1ResponseFromJson(json);
}

@JsonSerializable()
class Experience {
  final int id;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'dure')
  final String dure;
  @JsonKey(name: 'prix_par_voyageur')
  final String? prixParVoyageur;
  @JsonKey(name: 'inclus')
  final String? inclus;
  @JsonKey(name: 'nombre_des_voyageur')
  final int? nombreDesVoyageur;
  @JsonKey(name: 'type_des_voyageur')
  final String? typeDesVoyageur;
  @JsonKey(name: 'ville')
  final String? ville;
  @JsonKey(name: 'addresse')
  final String? addresse;
  @JsonKey(name: 'code_postale')
  final String? codePostale;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'status')
  final String status;

  Experience({
    required this.id,
    required this.title,
    required this.description,
    required this.dure,
    required this.prixParVoyageur,
    required this.inclus,
    required this.nombreDesVoyageur,
    required this.typeDesVoyageur,
    required this.ville,
    required this.addresse,
    required this.codePostale,
    required this.userId,
    required this.status,
  });

  factory Experience.fromJson(Map<String, dynamic> json) => _$ExperienceFromJson(json);
}
