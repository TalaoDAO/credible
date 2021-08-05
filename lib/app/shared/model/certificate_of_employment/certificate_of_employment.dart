import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/shared/model/certificate_of_employment/signature_lines.dart';
import 'package:credible/app/shared/model/certificate_of_employment/work_for.dart';
import 'package:credible/app/shared/model/credential_subject.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'certificate_of_employment.g.dart';

@JsonSerializable(includeIfNull: false)
class CertificateOfEmployment extends CredentialSubject {
  @override
  String id;
  @override
  String type;
  @JsonKey(defaultValue: '')
  String familyName;
  @JsonKey(defaultValue: '')
  String givenName;
  @JsonKey(defaultValue: '')
  String startDate;
  WorkFor workFor;
  SignatureLines signatureLines;
  @JsonKey(defaultValue: '')
  String employmentType;
  @JsonKey(defaultValue: '')
  String jobTitle;
  @JsonKey(defaultValue: '')
  String baseSalary;

  CertificateOfEmployment(
      this.id,
      this.type,
      this.familyName,
      this.givenName,
      this.startDate,
      this.workFor,
      this.signatureLines,
      this.employmentType,
      this.jobTitle,
      this.baseSalary)
      : super(id, type);

  factory CertificateOfEmployment.fromJson(Map<String, dynamic> json) =>
      _$CertificateOfEmploymentFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CertificateOfEmploymentToJson(this);

  @override
  Widget displayInList(BuildContext context, CredentialModel item) {
    return Text('display list certificate');
  }

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(id),
        ),
      ],
    );
  }
}
