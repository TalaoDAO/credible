// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificate_of_employment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CertificateOfEmployment _$CertificateOfEmploymentFromJson(
        Map<String, dynamic> json) =>
    CertificateOfEmployment(
      json['id'] as String,
      json['type'] as String,
      json['familyName'] as String? ?? '',
      json['givenName'] as String? ?? '',
      json['startDate'] as String? ?? '',
      WorkFor.fromJson(json['workFor'] as Map<String, dynamic>),
      json['employmentType'] as String? ?? '',
      json['jobTitle'] as String? ?? '',
      json['baseSalary'] as String? ?? '',
      CredentialSubject.fromJsonAuthor(json['issuedBy']),
    );

Map<String, dynamic> _$CertificateOfEmploymentToJson(
        CertificateOfEmployment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'familyName': instance.familyName,
      'givenName': instance.givenName,
      'startDate': instance.startDate,
      'workFor': instance.workFor.toJson(),
      'employmentType': instance.employmentType,
      'jobTitle': instance.jobTitle,
      'baseSalary': instance.baseSalary,
      'issuedBy': instance.issuedBy.toJson(),
    };
