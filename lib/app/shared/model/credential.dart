import 'package:talao/app/pages/credentials/models/credential.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:talao/app/shared/model/default_credential_subject/default_credential_subject.dart';
import 'package:talao/app/shared/model/proof.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'credential.g.dart';

@JsonSerializable()
class Credential {
  final String id;
  final List<String> type;
  final String issuer;
  final String issuanceDate;
  @JsonKey(fromJson: _fromJsonProofs)
  final List<Proof> proof;
  final CredentialSubject credentialSubject;

  Credential(this.id, this.type, this.issuer, this.issuanceDate, this.proof,
      this.credentialSubject);

  factory Credential.fromJson(Map<String, dynamic> json) {
    if (json['type'] == 'VerifiableCredential') {
      return Credential(
          'dummy',
          ['dummy'],
          'dummy',
          'dummy',
          [
            Proof(
              'dummy',
              'dummy',
              'dummy',
              'dummy',
              'dummy',
            )
          ],
          DefaultCredentialSubject('dummy', 'dummy'));
    }
    return _$CredentialFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CredentialToJson(this);

  Widget displayDetail(BuildContext context, CredentialModel item) {
    return credentialSubject.displayDetail(context, item);
  }

  Widget displayList(BuildContext context, CredentialModel item) {
    return (credentialSubject is DefaultCredentialSubject)
        ? credentialSubject.displayDetail(context, item)
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: displayType(context, type.last),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(DateTime.parse(issuanceDate).toString()),
              )
            ],
          );
  }

  Widget displayType(BuildContext context, String type) {
    final localizations = AppLocalizations.of(context)!;

    String typeLabel = '';
    switch (type) {
      case 'ResidentCard':
        typeLabel = localizations.residentCard;
        break;
      default:
        typeLabel = type;
    }
    return Text(typeLabel.toString());
  }

  static List<Proof> _fromJsonProofs(json) {
    if (json is List) {
      return (json)
          .map((e) => Proof.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [Proof.fromJson(json)];
  }
}
