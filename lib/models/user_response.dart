import 'package:json_annotation/json_annotation.dart';

part 'user_response.g.dart';

@JsonSerializable(createToJson: false)
class UserResponse {
  const UserResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    required this.otpCode,
    required this.profilePath,
    required this.phoneNumber,
    required this.isFullAvailable,
    required this.voyageurVerified,
    required this.guideVerified,
    required this.rue,
    required this.codePostal,
    required this.ville,
    required this.emailVerifiedAt,
    required this.userType,
    required this.sirenNumber,
    required this.hasUpdatedHesSchedule,
    required this.pieceIdentite,
    required this.kbisFile,
    required this.otherDocument,
  });

  /// Short live token, used to access API.
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'otp_code')
  final String otpCode;
  @JsonKey(name: 'profile_path')
  final String profilePath;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  @JsonKey(name: 'is_full_available')
  final bool isFullAvailable;
  @JsonKey(name: 'is_voyageur_verified')
  final bool voyageurVerified;
  @JsonKey(name: 'is_guide_verified')
  final bool guideVerified;
  @JsonKey(name: 'rue')
  final String? rue;
  @JsonKey(name: 'code_postal')
  final String? codePostal;
  @JsonKey(name: 'ville')
  final String? ville;
  @JsonKey(name: 'email_verified_at')
  final String? emailVerifiedAt;
  @JsonKey(name: 'user_type')
  final String? userType;
  @JsonKey(name: 'siren_number')
  final String? sirenNumber;
  @JsonKey(name: 'has_updated_hes_schedule')
  final bool hasUpdatedHesSchedule;
  @JsonKey(name: 'piece_d_identite')
  final String? pieceIdentite;
  @JsonKey(name: 'KBIS_file')
  final String? kbisFile;
  @JsonKey(name: 'other_documents')
  final List<OtherDocument>? otherDocument;

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);
}

@JsonSerializable()
class OtherDocument {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'document_title')
  final String documentTitle;
  @JsonKey(name: 'document_path')
  final String documentPath;

  OtherDocument({
    required this.id,
    required this.userId,
    required this.documentTitle,
    required this.documentPath,
  });

  factory OtherDocument.fromJson(Map<String, dynamic> json) => _$OtherDocumentFromJson(json);
}
