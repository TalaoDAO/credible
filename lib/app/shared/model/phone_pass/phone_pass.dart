import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/credentials/widget/credential_background.dart';
import 'package:talao/credentials/widget/display_issuer.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/shared/widget/base/credential_field.dart';

part 'phone_pass.g.dart';

@JsonSerializable(explicitToJson: true)
class PhonePass extends CredentialSubject {
  @JsonKey(defaultValue: '')
  final String expires;
  @JsonKey(defaultValue: '')
  final String phone;
  @override
  final String id;
  @override
  final String type;
  @override
  final Author issuedBy;

  factory PhonePass.fromJson(Map<String, dynamic> json) =>
      _$PhonePassFromJson(json);

  PhonePass(this.expires, this.phone, this.id, this.type, this.issuedBy)
      : super(id, type, issuedBy);

  @override
  Map<String, dynamic> toJson() => _$PhonePassToJson(this);

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    final localizations = AppLocalizations.of(context)!;

    return CredentialBackground(
      model: item,
      child: Column(
        children: [
          CredentialField(title: localizations.personalPhone, value: phone),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DisplayIssuer(
              issuer: issuedBy,
            ),
          ),
        ],
      ),
    );
  }
}
