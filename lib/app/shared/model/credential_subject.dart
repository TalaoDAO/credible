import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/shared/model/certificate_of_employment/certificate_of_employment.dart';
import 'package:credible/app/shared/model/default_credential_subject/default_credential_subject.dart';
import 'package:credible/app/shared/model/email_pass/email_pass.dart';
import 'package:credible/app/shared/model/identity_pass/identity_pass.dart';
import 'package:credible/app/shared/model/professional_experience_assessment/professional_experience_assessment.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credential_subject.g.dart';

@JsonSerializable()
class CredentialSubject {
  final String id;
  final String type;

  CredentialSubject(this.id, this.type);

  Widget displayInList(BuildContext context, CredentialModel item) {
    return Text('first display');
  }

  Widget displayDetail(BuildContext context, CredentialModel item) {
    return Text('first display');
  }

  factory CredentialSubject.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'IdentityPass':
        return IdentityPass.fromJson(json);
      case 'CertificateOfEmployment':
        return CertificateOfEmployment.fromJson(json);
      case 'EmailPass':
        return EmailPass.fromJson(json);
      case 'ProfessionalExperienceAssessment':
        return ProfessionalExperienceAssessment.fromJson(json);
    }
    return DefaultCredentialSubject.fromJson(json);
  }

  Map<String, dynamic> toJson() => _$CredentialSubjectToJson(this);
}
