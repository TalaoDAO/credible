import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/credentials/widget/display_issuer.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:talao/app/shared/model/identity_pass/identity_pass_recipient.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/shared/widget/base/credential_field.dart';

part 'identity_pass.g.dart';

@JsonSerializable(explicitToJson: true)
class IdentityPass extends CredentialSubject {
  final IdentityPassRecipient recipient;
  @JsonKey(defaultValue: '')
  final String expires;
  @override
  final Author issuedBy;
  @override
  final String id;
  @override
  final String type;

  factory IdentityPass.fromJson(Map<String, dynamic> json) =>
      _$IdentityPassFromJson(json);

  IdentityPass(this.recipient, this.expires, this.issuedBy, this.id, this.type)
      : super(id, type, issuedBy);

  @override
  Map<String, dynamic> toJson() => _$IdentityPassToJson(this);

  @override
  Widget displayInList(BuildContext context, CredentialModel item) {
    return Text('display list identity');
  }

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      children: [
        expires != ''
            ? CredentialField(title: localizations.expires, value: expires)
            : SizedBox.shrink(),
        recipient.jobTitle != ''
            ? CredentialField(
                title: localizations.jobTitle, value: recipient.jobTitle)
            : SizedBox.shrink(),
        recipient.familyName != ''
            ? CredentialField(
                title: localizations.firstName, value: recipient.familyName)
            : SizedBox.shrink(),
        recipient.givenName != ''
            ? CredentialField(
                title: localizations.lastName, value: recipient.givenName)
            : SizedBox.shrink(),
        recipient.image != ''
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(recipient.image,
                    loadingBuilder: (context, child, loadingProgress) =>
                        (loadingProgress == null)
                            ? child
                            : CircularProgressIndicator(),
                    errorBuilder: (context, error, stackTrace) =>
                        SizedBox.shrink()),
              )
            : SizedBox.shrink(),
        recipient.address != ''
            ? CredentialField(
                title: localizations.address, value: recipient.address)
            : SizedBox.shrink(),
        recipient.birthDate != ''
            ? CredentialField(
                title: localizations.birthdate, value: recipient.birthDate)
            : SizedBox.shrink(),
        recipient.email != ''
            ? CredentialField(
                title: localizations.personalMail, value: recipient.email)
            : SizedBox.shrink(),
        recipient.gender != ''
            ? CredentialField(
                title: localizations.gender, value: recipient.gender)
            : SizedBox.shrink(),
        recipient.telephone != ''
            ? CredentialField(
                title: localizations.personalPhone, value: recipient.telephone)
            : SizedBox.shrink(),
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
