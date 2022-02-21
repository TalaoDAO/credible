// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'self_issued_credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelfIssuedCredential _$SelfIssuedCredentialFromJson(
        Map<String, dynamic> json) =>
    SelfIssuedCredential(
      id: json['id'] as String,
      issuer: json['issuer'] as String,
      issuanceDate: json['issuanceDate'] as String,
      credentialSubject: CredentialSubject.fromJson(
          json['credentialSubject'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SelfIssuedCredentialToJson(
        SelfIssuedCredential instance) =>
    <String, dynamic>{
      'id': instance.id,
      'credentialSubject': instance.credentialSubject.toJson(),
      'issuer': instance.issuer,
      'issuanceDate': instance.issuanceDate,
    };
