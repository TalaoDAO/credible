import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/credentials/widget/display_issuer.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/shared/widget/base/credential_field.dart';

part 'email_pass.g.dart';

@JsonSerializable(explicitToJson: true)
class EmailPass extends CredentialSubject {
  @JsonKey(defaultValue: '')
  final String expires;
  @JsonKey(defaultValue: '')
  final String email;
  @override
  final String id;
  @override
  final String type;
  @override
  final Author issuedBy;
  @JsonKey(defaultValue: '')
  final String passbaseMetadata;

  factory EmailPass.fromJson(Map<String, dynamic> json) =>
      _$EmailPassFromJson(json);

  EmailPass(this.expires, this.email, this.id, this.type, this.issuedBy,
      this.passbaseMetadata)
      : super(id, type, issuedBy);

  @override
  Map<String, dynamic> toJson() => _$EmailPassToJson(this);

  @override
  Widget displayInList(BuildContext context, CredentialModel item) {
    return Text('display list identity');
  }

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DisplayIssuer(
            issuer: issuedBy,
          ),
        ),
        CredentialField(title: localizations.personalMail, value: email),
      ],
    );
  }
}
