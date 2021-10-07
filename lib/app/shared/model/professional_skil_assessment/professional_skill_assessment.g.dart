// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'professional_skill_assessment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfessionalSkillAssessment _$ProfessionalSkillAssessmentFromJson(
    Map<String, dynamic> json) {
  return ProfessionalSkillAssessment(
    json['id'] as String,
    json['type'] as String,
    (json['skills'] as List<dynamic>)
        .map((e) => Skill.fromJson(e as Map<String, dynamic>))
        .toList(),
    CredentialSubject.fromJsonAuthor(json['issuedBy']),
    ProfessionalSkillAssessment._signatureLinesFromJson(json['signatureLines']),
    json['familyName'] as String? ?? '',
    json['givenName'] as String? ?? '',
  );
}

Map<String, dynamic> _$ProfessionalSkillAssessmentToJson(
        ProfessionalSkillAssessment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'skills': instance.skills.map((e) => e.toJson()).toList(),
      'issuedBy': instance.issuedBy.toJson(),
      'familyName': instance.familyName,
      'givenName': instance.givenName,
      'signatureLines': instance.signatureLines.map((e) => e.toJson()).toList(),
    };
