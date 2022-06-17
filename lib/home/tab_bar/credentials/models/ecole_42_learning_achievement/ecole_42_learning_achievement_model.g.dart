// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ecole_42_learning_achievement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ecole42LearningAchievementModel _$Ecole42LearningAchievementModelFromJson(
        Map<String, dynamic> json) =>
    Ecole42LearningAchievementModel(
      id: json['id'] as String?,
      type: json['type'] as String?,
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      givenName: json['givenName'] as String? ?? '',
      signatureLines: Ecole42LearningAchievementModel._signatureLinesFromJson(
          json['signatureLines']),
      birthDate: json['birthDate'] as String? ?? '',
      familyName: json['familyName'] as String? ?? '',
      hasCredential:
          Ecole42LearningAchievementModel._hasCredentialEcole42FromJson(
              json['hasCredential']),
    );

Map<String, dynamic> _$Ecole42LearningAchievementModelToJson(
        Ecole42LearningAchievementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      'givenName': instance.givenName,
      'signatureLines': instance.signatureLines?.toJson(),
      'birthDate': instance.birthDate,
      'hasCredential': instance.hasCredential?.toJson(),
      'familyName': instance.familyName,
    };
