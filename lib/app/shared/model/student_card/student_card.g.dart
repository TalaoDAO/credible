// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentCard _$StudentCardFromJson(Map<String, dynamic> json) => StudentCard(
      StudentCard._fromJsonProfessionalStudentCardRecipient(json['recipient']),
      json['expires'] as String? ?? '',
      CredentialSubject.fromJsonAuthor(json['issuedBy']),
      json['id'] as String,
      json['type'] as String,
    );

Map<String, dynamic> _$StudentCardToJson(StudentCard instance) =>
    <String, dynamic>{
      'recipient': instance.recipient.toJson(),
      'expires': instance.expires,
      'issuedBy': instance.issuedBy.toJson(),
      'id': instance.id,
      'type': instance.type,
    };
