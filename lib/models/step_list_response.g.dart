// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StepListResponse _$StepListResponseFromJson(Map<String, dynamic> json) =>
    StepListResponse(
      id: json['id'] as int,
      choiceTxt: json['choice_txt'] as String,
    );

Map<String, dynamic> _$StepListResponseToJson(StepListResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'choice_txt': instance.choiceTxt,
    };
