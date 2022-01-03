// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'default_credential_subject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DefaultCredentialSubject _$DefaultCredentialSubjectFromJson(
        Map<String, dynamic> json) =>
    DefaultCredentialSubject(
      json['id'] as String,
      json['type'] as String,
      CredentialSubject.fromJsonAuthor(json['issuedBy']),
    );

Map<String, dynamic> _$DefaultCredentialSubjectToJson(
        DefaultCredentialSubject instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy.toJson(),
    };
