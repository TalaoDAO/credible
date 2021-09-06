import 'package:flutter_modular/flutter_modular.dart';
import 'package:talao/app/pages/credentials/models/credential.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:talao/app/shared/model/default_credential_subject/default_credential_subject.dart';
import 'package:talao/app/shared/model/proof.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/shared/model/translation.dart';

part 'credential.g.dart';

@JsonSerializable()
class Credential {
  final String id;
  final List<String> type;
  final String issuer;
  @JsonKey(defaultValue: [], fromJson: _fromJsonTranslations)
  final List<Translation> description;
  @JsonKey(defaultValue: [])
  final List<Translation> name;
  final String issuanceDate;
  @JsonKey(fromJson: _fromJsonProofs)
  final List<Proof> proof;
  final CredentialSubject credentialSubject;

  Credential(this.id, this.type, this.issuer, this.issuanceDate, this.proof,
      this.credentialSubject, this.description, this.name);

  factory Credential.fromJson(Map<String, dynamic> json) {
    if (json['type'] == 'VerifiableCredential') {
      return Credential.dummy();
    }
    return _$CredentialFromJson(json);
  }

  factory Credential.dummy() {
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
        DefaultCredentialSubject('dummy', 'dummy'),
        [Translation('en', 'dummy')],
        [Translation('en', 'dummy')]);
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

    var typeLabel = '';
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

  static List<Translation> _fromJsonTranslations(json) {
    if (json == null || json == '') {
      return [];
    }
    if (json is List) {
      return (json)
          .map((e) => Translation.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [Translation.fromJson(json)];
  }

  static Credential fromJsonOrErrorPage(Map<String, dynamic> data) {
    try {
      return Credential.fromJson(data);
    } catch (e) {
      print(e.toString());
      Modular.to.pushNamed(
        '/error',
        arguments: e.toString(),
      );
      return Credential.dummy();
    }
  }

  static Credential fromJsonOrDummy(Map<String, dynamic> data) {
    try {
      return Credential.fromJson(data);
    } catch (e) {
      print(e.toString());
      return Credential.dummy();
    }
  }
}
