// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'professional_student_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfessionalStudentCard _$ProfessionalStudentCardFromJson(
        Map<String, dynamic> json) =>
    ProfessionalStudentCard(
      ProfessionalStudentCardRecipient.fromJson(
          json['recipient'] as Map<String, dynamic>),
      json['expires'] as String? ?? '',
      CredentialSubject.fromJsonAuthor(json['issuedBy']),
      json['id'] as String,
      json['type'] as String,
    );

Map<String, dynamic> _$ProfessionalStudentCardToJson(
        ProfessionalStudentCard instance) =>
    <String, dynamic>{
      'recipient': instance.recipient.toJson(),
      'expires': instance.expires,
      'issuedBy': instance.issuedBy.toJson(),
      'id': instance.id,
      'type': instance.type,
    };
