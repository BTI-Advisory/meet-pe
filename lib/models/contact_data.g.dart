// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactAvatarData _$ContactAvatarDataFromJson(Map<String, dynamic> json) =>
    ContactAvatarData(
      isAvatarAvailable: toBoolConverter(json['photoDisponible']),
      avatarModifiedAt: const NullableDateTimeConverter()
          .fromJson(json['dateDerniereModificationPhoto'] as String?),
      qrCode: json['qrCode'] as String,
    );

ContactData _$ContactDataFromJson(Map<String, dynamic> json) => ContactData(
  firstName: json['prenom'] as String,
  lastName: json['nom'] as String,
  isAvatarAvailable: toBoolConverter(json['photoDisponible']),
  avatarModifiedAt: const NullableDateTimeConverter()
      .fromJson(json['dateDerniereModificationPhoto'] as String?),
  contactInformation: ContactInformation.fromJson(
      json['coordonnees'] as Map<String, dynamic>),
  qrCode: json['qrCode'] as String,
  titre: json['titre'] as String?,
  region: json['region'] == null
      ? null
      : Region.fromJson(json['region'] as Map<String, dynamic>),
  mobileNumber: json['mobile'] as String?,
  logoUrl: json['logo'] as String?,
  isInUserDirectory: toNullableBoolConverter(json['isUserScanned']),
);

Map<String, dynamic> _$ContactDataToJson(ContactData instance) {
  final val = <String, dynamic>{
    'photoDisponible': instance.isAvatarAvailable,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('dateDerniereModificationPhoto',
      const NullableDateTimeConverter().toJson(instance.avatarModifiedAt));
  val['qrCode'] = instance.qrCode;
  val['prenom'] = instance.firstName;
  val['nom'] = instance.lastName;
  val['coordonnees'] = instance.contactInformation.toJson();
  writeNotNull('titre', instance.titre);
  writeNotNull('region', instance.region?.toJson());
  writeNotNull('mobile', instance.mobileNumber);
  writeNotNull('logo', instance.logoUrl);
  writeNotNull('isUserScanned', instance.isInUserDirectory);
  return val;
}

ContactInformation _$ContactInformationFromJson(Map<String, dynamic> json) =>
    ContactInformation(
      address: json['adresse'] == null
          ? null
          : Address.fromJson(json['adresse'] as Map<String, dynamic>),
      phone: json['telephone'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$ContactInformationToJson(ContactInformation instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('adresse', instance.address?.toJson());
  writeNotNull('telephone', instance.phone);
  writeNotNull('email', instance.email);
  return val;
}

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
  line1: json['ligne1'] as String?,
  line2: json['ligne2'] as String?,
  line3: json['ligne3'] as String?,
  companyName: json['nomSociete'] as String?,
  city: json['ville'] as String?,
  zipCode: json['codePostal'] as String?,
  latitude: toNullableDoubleConverter(json['latitude']),
  longitude: toNullableDoubleConverter(json['longitude']),
);

Map<String, dynamic> _$AddressToJson(Address instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('ligne1', instance.line1);
  writeNotNull('ligne2', instance.line2);
  writeNotNull('ligne3', instance.line3);
  writeNotNull('nomSociete', instance.companyName);
  writeNotNull('ville', instance.city);
  writeNotNull('codePostal', instance.zipCode);
  writeNotNull('latitude', instance.latitude);
  writeNotNull('longitude', instance.longitude);
  return val;
}

ApiEnum _$ApiEnumFromJson(Map<String, dynamic> json) => ApiEnum(
  code: toStringConverter(json['code']),
  name: json['libelle'] as String,
);

Map<String, dynamic> _$ApiEnumToJson(ApiEnum instance) => <String, dynamic>{
  'code': instance.code,
  'libelle': instance.name,
};

Region _$RegionFromJson(Map<String, dynamic> json) => Region(
  code: toStringConverter(json['code']),
  name: json['libelle'] as String?,
  mobileNumber: json['telephone'] as String?,
  email: json['mail'] as String?,
);

Map<String, dynamic> _$RegionToJson(Region instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('code', instance.code);
  writeNotNull('mail', instance.email);
  writeNotNull('telephone', instance.mobileNumber);
  writeNotNull('libelle', instance.name);
  return val;
}
