import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/pages/credentials/widget/display_issuer.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/certificate_of_employment/work_for.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/shared/widget/base/credential_field.dart';

part 'certificate_of_employment.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
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
  @JsonKey(defaultValue: '')
  String employmentType;
  @JsonKey(defaultValue: '')
  String jobTitle;
  @JsonKey(defaultValue: '')
  String baseSalary;
  @override
  final Author issuedBy;

  CertificateOfEmployment(
      this.id,
      this.type,
      this.familyName,
      this.givenName,
      this.startDate,
      this.workFor,
      this.employmentType,
      this.jobTitle,
      this.baseSalary,
      this.issuedBy)
      : super(id, type, issuedBy);

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
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('${localizations.firstName} '),
              Text('$familyName',
                  style: TextStyle(inherit: true, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('${localizations.lastName} '),
              Text('$givenName',
                  style: TextStyle(inherit: true, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('${localizations.jobTitle} '),
              Text('$jobTitle',
                  style: TextStyle(inherit: true, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        (workFor.name != '')
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('${localizations.workFor} '),
                    Text(workFor.name,
                        style: TextStyle(
                            inherit: true, fontWeight: FontWeight.w700)),
                    Spacer(),
                    (workFor.logo != '')
                        ? Container(
                            height: 30, child: Image.network(workFor.logo))
                        : SizedBox.shrink()
                  ],
                ),
              )
            : SizedBox.shrink(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('${localizations.startDate} '),
              Text('$startDate',
                  style: TextStyle(inherit: true, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        CredentialField(
            value: employmentType, title: localizations.employmentType),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('${localizations.baseSalary} '),
              Text('$baseSalary',
                  style: TextStyle(inherit: true, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DisplayIssuer(
            issuer: issuedBy,
          ),
        )
      ],
    );
  }
}
