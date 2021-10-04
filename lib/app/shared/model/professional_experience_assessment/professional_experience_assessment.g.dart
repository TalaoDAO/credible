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
    CredentialSubject.fromJsonAuthor(json['issuedBy']),
    (json['review'] as List<dynamic>?)
            ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    ProfessionalExperienceAssessment._signatureLinesFromJson(
        json['signatureLines']),
    json['familyName'] as String? ?? '',
    json['givenName'] as String? ?? '',
  );
}

Map<String, dynamic> _$ProfessionalExperienceAssessmentToJson(
        ProfessionalExperienceAssessment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'skills': instance.skills.map((e) => e.toJson()).toList(),
      'title': instance.title,
      'familyName': instance.familyName,
      'givenName': instance.givenName,
      'endDate': instance.endDate,
      'startDate': instance.startDate,
      'issuedBy': instance.issuedBy.toJson(),
      'expires': instance.expires,
      'email': instance.email,
      'type': instance.type,
      'review': instance.review.map((e) => e.toJson()).toList(),
      'signatureLines': instance.signatureLines.map((e) => e.toJson()).toList(),
    };
