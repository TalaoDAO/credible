// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'self_issued.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelfIssued _$SelfIssuedFromJson(Map<String, dynamic> json) => SelfIssued(
      id: json['id'] as String,
      address: json['address'] as String?,
      familyName: json['familyName'] as String?,
      givenName: json['givenName'] as String?,
      type: json['type'] as String? ?? 'SelfIssued',
      telephone: json['telephone'] as String?,
      email: json['email'] as String?,
      companyName: json['companyName'] as String?,
      companyWebsite: json['companyWebsite'] as String?,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$SelfIssuedToJson(SelfIssued instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'type': instance.type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('address', instance.address);
  writeNotNull('familyName', instance.familyName);
  writeNotNull('givenName', instance.givenName);
  writeNotNull('telephone', instance.telephone);
  writeNotNull('email', instance.email);
  writeNotNull('companyName', instance.companyName);
  writeNotNull('companyWebsite', instance.companyWebsite);
  writeNotNull('title', instance.title);
  return val;
}
