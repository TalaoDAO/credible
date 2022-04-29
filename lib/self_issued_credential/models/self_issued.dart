import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:talao/app/shared/widget/base/credential_field.dart';
import 'package:talao/credentials/widget/credential_background.dart';
import 'package:talao/l10n/l10n.dart';

part 'self_issued.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class SelfIssued extends CredentialSubject {
  @override
  final String id;
  @override
  final String type;
  final String? address;
  final String? familyName;
  final String? givenName;
  final String? telephone;
  final String? email;
  final String? workFor;
  final String? companyWebsite;
  final String? jobTitle;

  factory SelfIssued.fromJson(Map<String, dynamic> json) =>
      _$SelfIssuedFromJson(json);

  SelfIssued(
      {required this.id,
      this.address,
      this.familyName,
      this.givenName,
      this.type = 'SelfIssued',
      this.telephone,
      this.email,
      this.workFor,
      this.companyWebsite,
      this.jobTitle})
      : super(id, type, Author('', ''));

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        if (givenName != null && givenName!.isNotEmpty) 'givenName': givenName,
        if (familyName != null && familyName!.isNotEmpty)
          'familyName': familyName,
        if (telephone != null && telephone!.isNotEmpty) 'telephone': telephone,
        if (address != null && address!.isNotEmpty) 'address': address,
        'type': type,
        if (email != null && email!.isNotEmpty) 'email': email,
        if (workFor != null && workFor!.isNotEmpty) 'workFor': workFor,
        if (companyWebsite != null && companyWebsite!.isNotEmpty)
          'companyWebsite': companyWebsite,
        if (jobTitle != null && jobTitle!.isNotEmpty) 'jobTitle': jobTitle,
      };

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    final localizations = context.l10n;
    return CredentialBackground(
      model: item,
      child: Column(
        children: [
          givenName?.isNotEmpty ?? false
              ? CredentialField(
                  title: localizations.firstName, value: givenName!)
              : SizedBox.shrink(),
          familyName?.isNotEmpty ?? false
              ? CredentialField(
                  title: localizations.lastName, value: familyName!)
              : SizedBox.shrink(),
          telephone?.isNotEmpty ?? false
              ? CredentialField(
                  title: localizations.personalPhone, value: telephone!)
              : SizedBox.shrink(),
          address?.isNotEmpty ?? false
              ? CredentialField(title: localizations.address, value: address!)
              : SizedBox.shrink(),
          email?.isNotEmpty ?? false
              ? CredentialField(
                  title: localizations.personalMail, value: email!)
              : SizedBox.shrink(),
          workFor?.isNotEmpty ?? false
              ? CredentialField(
                  title: localizations.companyName, value: workFor!)
              : SizedBox.shrink(),
          companyWebsite?.isNotEmpty ?? false
              ? CredentialField(
                  title: localizations.companyWebsite, value: companyWebsite!)
              : SizedBox.shrink(),
          jobTitle?.isNotEmpty ?? false
              ? CredentialField(title: localizations.jobTitle, value: jobTitle!)
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
