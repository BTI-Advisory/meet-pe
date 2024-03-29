import 'package:json_annotation/json_annotation.dart';

part 'step_list_response.g.dart';

@JsonSerializable()
class StepListResponse {
  int id;
  String choiceTxt;
  String svg;

  StepListResponse({required this.id, required this.choiceTxt, required this.svg});

  factory StepListResponse.fromJson(Map<String, dynamic> json) =>
      _$StepListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StepListResponseToJson(this);
}
