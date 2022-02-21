// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'self_issued_credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelfIssuedCredential _$SelfIssuedCredentialFromJson(
        Map<String, dynamic> json) =>
    SelfIssuedCredential(
      json['id'] as String,
      json['issuer'] as String,
      json['issuanceDate'] as String,
      CredentialSubject.fromJson(
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
