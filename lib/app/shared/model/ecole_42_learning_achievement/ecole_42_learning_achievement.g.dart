// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ecole_42_learning_achievement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ecole42LearningAchievement _$Ecole42LearningAchievementFromJson(
        Map<String, dynamic> json) =>
    Ecole42LearningAchievement(
      json['id'] as String,
      json['type'] as String,
      CredentialSubject.fromJsonAuthor(json['issuedBy']),
      json['givenName'] as String? ?? '',
      Ecole42LearningAchievement._signatureLinesFromJson(
          json['signatureLines']),
      json['birthDate'] as String? ?? '',
      json['familyName'] as String? ?? '',
      Ecole42LearningAchievement._hasCreddentialEcole42FromJson(
          json['hasCredential']),
    );

Map<String, dynamic> _$Ecole42LearningAchievementToJson(
        Ecole42LearningAchievement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'givenName': instance.givenName,
      'signatureLines': instance.signatureLines.toJson(),
      'birthDate': instance.birthDate,
      'hasCredential': instance.hasCredential.toJson(),
      'familyName': instance.familyName,
      'issuedBy': instance.issuedBy.toJson(),
    };
