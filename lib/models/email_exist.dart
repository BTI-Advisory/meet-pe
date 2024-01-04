import 'package:json_annotation/json_annotation.dart';

part 'email_exist.g.dart';

@JsonSerializable(createToJson: false)
class EmailExist {
  const EmailExist({required this.exist});

  /// Short live token, used to access API.
  @JsonKey(name: 'msg')     // OPTI restore camelCase when server's ready
  final String exist;

  factory EmailExist.fromJson(Map<String, dynamic> json) => _$EmailExistFromJson(json);
}
