import 'package:meet_pe/utils/_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact_data.g.dart';

@JsonSerializable(createToJson: false)
class ContactAvatarData {
  const ContactAvatarData({
    required this.isAvatarAvailable,
    this.avatarModifiedAt,
    required this.qrCode,
  });

  @JsonKey(name: 'photoDisponible', fromJson: toBoolConverter)
  final bool isAvatarAvailable;

  @JsonKey(name: 'dateDerniereModificationPhoto')
  @NullableDateTimeConverter()
  final DateTime? avatarModifiedAt;

  final String qrCode;

  factory ContactAvatarData.fromJson(Map<String, dynamic> json) =>
      _$ContactAvatarDataFromJson(json);
}

@JsonSerializable()
class ContactData extends ContactAvatarData {
  const ContactData({
    required this.firstName,
    required this.lastName,
    required super.isAvatarAvailable,
    super.avatarModifiedAt,
    required this.contactInformation,
    required super.qrCode,
    this.titre,
    required this.region,
    this.mobileNumber,
    this.logoUrl,
    this.isInUserDirectory,
  });

  @JsonKey(name: 'prenom')
  final String firstName;

  @JsonKey(name: 'nom')
  final String lastName;

  String get fullName => '$firstName $lastName';

  @JsonKey(name: 'coordonnees')
  final ContactInformation contactInformation;

  @JsonKey(name: 'titre')
  final String? titre;

  final Region? region;

  @JsonKey(name: 'mobile')
  final String? mobileNumber;

  @JsonKey(name: 'logo')
  final String? logoUrl;

  @JsonKey(name: 'isUserScanned', fromJson: toNullableBoolConverter)
  final bool? isInUserDirectory;

  String? get callNumber => contactInformation.phone ?? mobileNumber;

  factory ContactData.fromJson(Map<String, dynamic> json) =>
      _$ContactDataFromJson(json);
  Map<String, dynamic> toJson() => _$ContactDataToJson(this);
}

@JsonSerializable()
class ContactInformation {
  const ContactInformation({
    this.address,
    this.phone,
    required this.email,
  });

  @JsonKey(name: 'adresse')
  final Address? address;

  @JsonKey(name: 'telephone')
  final String? phone;

  final String? email;

  factory ContactInformation.fromJson(Map<String, dynamic> json) =>
      _$ContactInformationFromJson(json);
  Map<String, dynamic> toJson() => _$ContactInformationToJson(this);
}

@JsonSerializable()
class Address {
  const Address({
    this.line1,
    this.line2,
    this.line3,
    this.companyName,
    this.city,
    this.zipCode,
    this.latitude,
    this.longitude,
  });

  @JsonKey(name: 'ligne1')
  final String? line1;
  @JsonKey(name: 'ligne2')
  final String? line2;
  @JsonKey(name: 'ligne3')
  final String? line3;
  @JsonKey(name: 'nomSociete')
  final String? companyName;
  @JsonKey(name: 'ville')
  final String? city;
  @JsonKey(name: 'codePostal')
  final String? zipCode;
  @JsonKey(fromJson: toNullableDoubleConverter)
  final double? latitude;
  @JsonKey(fromJson: toNullableDoubleConverter)
  final double? longitude;

  String get fullAddress => [
    companyName,
    line1,
    line2,
    line3,
    [zipCode, city].joinNotEmpty(' '),
  ].toLines();

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}

@JsonSerializable()
class ApiEnum {
  const ApiEnum({
    required this.code,
    required this.name,
  });

  @JsonKey(fromJson: toStringConverter)
  final String code;
  @JsonKey(name: 'libelle')
  final String name;

  factory ApiEnum.fromJson(Map<String, dynamic> json) =>
      _$ApiEnumFromJson(json);
  Map<String, dynamic> toJson() => _$ApiEnumToJson(this);
}

@JsonSerializable()
class Region {
  const Region({
    required this.code,
    required this.name,
    required this.mobileNumber,
    required this.email,
  });

  @JsonKey(fromJson: toStringConverter)
  final String? code;
  @JsonKey(name: 'mail')
  final String? email;
  @JsonKey(name: 'telephone')
  final String? mobileNumber;
  @JsonKey(name: 'libelle')
  final String? name;

  factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);
  Map<String, dynamic> toJson() => _$RegionToJson(this);
}
