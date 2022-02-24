import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:talao/app/shared/widget/base/credential_field.dart';
import 'package:talao/l10n/l10n.dart';

part 'self_issued.g.dart';

@JsonSerializable(explicitToJson: true)
class SelfIssued extends CredentialSubject {
  @override
  final String id;
  @override
  final String type;
  @JsonKey(defaultValue: '')
  final String address;
  @JsonKey(defaultValue: '')
  final String familyName;
  @JsonKey(defaultValue: '')
  final String givenName;
  @JsonKey(defaultValue: '')
  final String telephone;
  @JsonKey(defaultValue: '')
  final String email;

  factory SelfIssued.fromJson(Map<String, dynamic> json) =>
      _$SelfIssuedFromJson(json);

  SelfIssued(
      {required this.id,
      required this.address,
      required this.familyName,
      required this.givenName,
      this.type = 'SelfIssued',
      required this.telephone,
      required this.email})
      : super(id, type, Author('', ''));

  @override
  Map<String, dynamic> toJson() => _$SelfIssuedToJson(this);

  @override
  Widget displayInList(BuildContext context, CredentialModel item) {
    return Text('display self-issued data');
  }

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      children: [
        familyName.isNotEmpty
            ? CredentialField(title: localizations.firstName, value: familyName)
            : SizedBox.shrink(),
        givenName.isNotEmpty
            ? CredentialField(title: localizations.lastName, value: givenName)
            : SizedBox.shrink(),
        address.isNotEmpty
            ? CredentialField(title: localizations.address, value: address)
            : SizedBox.shrink(),
        email.isNotEmpty
            ? CredentialField(title: localizations.personalMail, value: email)
            : SizedBox.shrink(),
        telephone.isNotEmpty
            ? CredentialField(
                title: localizations.personalPhone, value: telephone)
            : SizedBox.shrink(),
      ],
    );
  }
}
