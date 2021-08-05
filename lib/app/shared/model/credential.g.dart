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
  );
}

Map<String, dynamic> _$CredentialToJson(Credential instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuer': instance.issuer,
      'issuanceDate': instance.issuanceDate,
      'proof': instance.proof,
      'credentialSubject': instance.credentialSubject,
    };
