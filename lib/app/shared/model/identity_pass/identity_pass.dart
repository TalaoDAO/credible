import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/shared/model/author.dart';
import 'package:credible/app/shared/model/credential_subject.dart';
import 'package:credible/app/shared/model/identity_pass/identity_pass_recipient.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'identity_pass.g.dart';

@JsonSerializable()
class IdentityPass extends CredentialSubject {
  final IdentityPassRecipient recipient;
  @JsonKey(defaultValue: '')
  final String expires;
  final Author author;
  @override
  final String id;
  @override
  final String type;

  factory IdentityPass.fromJson(Map<String, dynamic> json) =>
      _$IdentityPassFromJson(json);

  IdentityPass(this.recipient, this.expires, this.author, this.id, this.type)
      : super(id, type);

  @override
  Map<String, dynamic> toJson() => _$IdentityPassToJson(this);

  @override
  Widget displayInList(BuildContext context, CredentialModel item) {
    return Text('display list identity');
  }

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(expires),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(recipient.jobTitle),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(recipient.familyName),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(recipient.givenName),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(recipient.image),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(recipient.address),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(recipient.birthDate),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(recipient.email),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(recipient.gender),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(recipient.telephone),
        ),
      ],
    );
  }
}
