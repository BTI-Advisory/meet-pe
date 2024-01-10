import 'package:json_annotation/json_annotation.dart';

part 'step_list_response.g.dart';

@JsonSerializable()
class StepListResponse {
  String choiceTxt;

  StepListResponse({required this.choiceTxt});

  factory StepListResponse.fromJson(Map<String, dynamic> json) =>
      _$StepListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StepListResponseToJson(this);
}
