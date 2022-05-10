// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verifiable_diploma.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifiableDiploma _$VerifiableDiplomaFromJson(Map<String, dynamic> json) =>
    VerifiableDiploma(
      json['id'] as String,
      json['type'] as String,
      json['familyName'] as String? ?? '',
      json['givenName'] as String? ?? '',
      json['email'] as String? ?? '',
      json['dateOfBirth'] as String? ?? '',
      CredentialSubject.fromJsonAuthor(json['issuedBy']),
      json['identifier'] as String? ?? '',
      VerifiableDiploma._learningAchievementFromJson(
          json['learningAchievement']),
    );

Map<String, dynamic> _$VerifiableDiplomaToJson(VerifiableDiploma instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'familyName': instance.familyName,
      'givenName': instance.givenName,
      'email': instance.email,
      'dateOfBirth': instance.dateOfBirth,
      'identifier': instance.identifier,
      'learningAchievement': instance.learningAchievement.toJson(),
      'issuedBy': instance.issuedBy.toJson(),
    };
