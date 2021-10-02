// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Credential _$CredentialFromJson(Map<String, dynamic> json) {
  return Credential(
    json['id'] as String,
    (json['type'] as List<dynamic>).map((e) => e as String).toList(),
    json['issuer'] as String,
    json['issuanceDate'] as String,
    Credential._fromJsonProofs(json['proof']),
    CredentialSubject.fromJson(
        json['credentialSubject'] as Map<String, dynamic>),
    Credential._fromJsonTranslations(json['description']),
    (json['name'] as List<dynamic>?)
            ?.map((e) => Translation.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$CredentialToJson(Credential instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuer': instance.issuer,
      'description': instance.description.map((e) => e.toJson()).toList(),
      'name': instance.name.map((e) => e.toJson()).toList(),
      'issuanceDate': instance.issuanceDate,
      'proof': instance.proof.map((e) => e.toJson()).toList(),
      'credentialSubject': instance.credentialSubject.toJson(),
    };
