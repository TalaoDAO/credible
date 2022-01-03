// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_subject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialSubject _$CredentialSubjectFromJson(Map<String, dynamic> json) =>
    CredentialSubject(
      json['id'] as String,
      json['type'] as String,
      CredentialSubject.fromJsonAuthor(json['issuedBy']),
    );

Map<String, dynamic> _$CredentialSubjectToJson(CredentialSubject instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy.toJson(),
    };
