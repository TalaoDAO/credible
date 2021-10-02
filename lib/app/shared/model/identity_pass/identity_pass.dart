import 'package:talao/app/pages/credentials/models/credential.dart';
import 'package:talao/app/pages/credentials/widget/display_issuer.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:talao/app/shared/model/identity_pass/identity_pass_recipient.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('${localizations.expires} '),
                    Text('$expires',
                        style: TextStyle(
                            inherit: true, fontWeight: FontWeight.w700)),
                  ],
                ),
              )
            : SizedBox.shrink(),
        recipient.jobTitle != ''
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('${localizations.jobTitle} '),
                    Text('${recipient.jobTitle}',
                        style: TextStyle(
                            inherit: true, fontWeight: FontWeight.w700)),
                  ],
                ),
              )
            : SizedBox.shrink(),
        recipient.familyName != ''
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('${localizations.firstName} '),
                    Text('${recipient.familyName}',
                        style: TextStyle(
                            inherit: true, fontWeight: FontWeight.w700)),
                  ],
                ),
              )
            : SizedBox.shrink(),
        recipient.givenName != ''
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('${localizations.lastName} '),
                    Text('${recipient.givenName}',
                        style: TextStyle(
                            inherit: true, fontWeight: FontWeight.w700)),
                  ],
                ),
              )
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
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('${localizations.address} '),
                    Text('${recipient.address}',
                        style: TextStyle(
                            inherit: true, fontWeight: FontWeight.w700)),
                  ],
                ),
              )
            : SizedBox.shrink(),
        recipient.birthDate != ''
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('${localizations.birthdate} '),
                    Text('${recipient.birthDate}',
                        style: TextStyle(
                            inherit: true, fontWeight: FontWeight.w700)),
                  ],
                ),
              )
            : SizedBox.shrink(),
        recipient.email != ''
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('${localizations.personalMail} '),
                    Text('${recipient.email}',
                        style: TextStyle(
                            inherit: true, fontWeight: FontWeight.w700)),
                  ],
                ),
              )
            : SizedBox.shrink(),
        recipient.gender != ''
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('${localizations.gender} '),
                    Text('${recipient.gender}',
                        style: TextStyle(
                            inherit: true, fontWeight: FontWeight.w700)),
                  ],
                ),
              )
            : SizedBox.shrink(),
        recipient.telephone != ''
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('${localizations.personalPhone} '),
                    Text('${recipient.telephone}',
                        style: TextStyle(
                            inherit: true, fontWeight: FontWeight.w700)),
                  ],
                ),
              )
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
