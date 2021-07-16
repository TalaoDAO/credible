// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificate_of_employment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CertificateOfEmployment _$CertificateOfEmploymentFromJson(
    Map<String, dynamic> json) {
  return CertificateOfEmployment(
    json['id'] as String,
    json['type'] as String,
    json['familyName'] as String? ?? '',
    json['givenName'] as String? ?? '',
    json['startDate'] as String? ?? '',
    WorkFor.fromJson(json['workFor'] as Map<String, dynamic>),
    SignatureLines.fromJson(json['signatureLines'] as Map<String, dynamic>),
    json['employmentType'] as String? ?? '',
    json['jobTitle'] as String? ?? '',
    json['baseSalary'] as int? ?? 0,
  );
}

Map<String, dynamic> _$CertificateOfEmploymentToJson(
        CertificateOfEmployment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'familyName': instance.familyName,
      'givenName': instance.givenName,
      'startDate': instance.startDate,
      'workFor': instance.workFor,
      'signatureLines': instance.signatureLines,
      'employmentType': instance.employmentType,
      'jobTitle': instance.jobTitle,
      'baseSalary': instance.baseSalary,
    };
