// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'professional_experience_assessment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfessionalExperienceAssessment _$ProfessionalExperienceAssessmentFromJson(
    Map<String, dynamic> json) {
  return ProfessionalExperienceAssessment(
    json['expires'] as String? ?? '',
    json['email'] as String? ?? '',
    json['id'] as String,
    json['type'] as String,
    (json['skills'] as List<dynamic>)
        .map((e) => Skill.fromJson(e as Map<String, dynamic>))
        .toList(),
    json['title'] as String? ?? '',
    json['endDate'] as String? ?? '',
    json['startDate'] as String? ?? '',
    Author.fromJson(json['issuedBy'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ProfessionalExperienceAssessmentToJson(
        ProfessionalExperienceAssessment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'skills': instance.skills,
      'title': instance.title,
      'endDate': instance.endDate,
      'startDate': instance.startDate,
      'issuedBy': instance.issuedBy,
      'expires': instance.expires,
      'email': instance.email,
      'type': instance.type,
    };
