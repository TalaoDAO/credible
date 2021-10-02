// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_achievement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LearningAchievement _$LearningAchievementFromJson(Map<String, dynamic> json) {
  return LearningAchievement(
    json['id'] as String,
    json['type'] as String,
    json['familyName'] as String? ?? '',
    json['givenName'] as String? ?? '',
    json['email'] as String? ?? '',
    json['birthDate'] as String? ?? '',
    HasCredential.fromJson(json['hasCredential'] as Map<String, dynamic>),
    CredentialSubject.fromJsonAuthor(json['issuedBy']),
  );
}

Map<String, dynamic> _$LearningAchievementToJson(
        LearningAchievement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'familyName': instance.familyName,
      'givenName': instance.givenName,
      'email': instance.email,
      'birthDate': instance.birthDate,
      'hasCredential': instance.hasCredential.toJson(),
      'issuedBy': instance.issuedBy.toJson(),
    };
