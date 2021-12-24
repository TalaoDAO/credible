import 'package:talao/app/pages/credentials/models/credential_model.dart';
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
        AspectRatio(
          aspectRatio: 508.67 / 319.67,
          child: Container(
            height: 319.67,
            width: 508.67,
            child: Stack(
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Colors.pink,
                        image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            image: AssetImage(
                              'assets/image/adecco_student_card_verso.png',
                            ))),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(43, 52, 0, 0),
                              child: Text(recipient.familyName),
                            )
                          ],
                        )
                      ],
                    )),
                Positioned(left: 10, top: 20, child: Text(recipient.familyName))
              ],
            ),
          ),
        )
      ],
    );
  }
}
