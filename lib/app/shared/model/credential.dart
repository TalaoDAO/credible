import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_status_field.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:talao/app/shared/model/default_credential_subject/default_credential_subject.dart';
import 'package:talao/app/shared/model/evidence.dart';
import 'package:talao/app/shared/model/proof.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/model/translation.dart';

part 'credential.g.dart';

@JsonSerializable(explicitToJson: true)
class Credential {
  final String id;
  final List<String> type;
  final String issuer;
  @JsonKey(fromJson: _fromJsonTranslations)
  final List<Translation> description;
  @JsonKey(defaultValue: [])
  final List<Translation> name;
  final String issuanceDate;
  @JsonKey(fromJson: _fromJsonProofs)
  final List<Proof> proof;
  final CredentialSubject credentialSubject;
  @JsonKey(fromJson: _fromJsonEvidence)
  final List<Evidence> evidence;
  @JsonKey(fromJson: _fromJsonCredentialStatus)
  final CredentialStatusField credentialStatus;

  Credential(
    this.id,
    this.type,
    this.issuer,
    this.issuanceDate,
    this.proof,
    this.credentialSubject,
    this.description,
    this.name,
    this.credentialStatus,
    this.evidence,
  );

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
        Proof.dummy(),
      ],
      DefaultCredentialSubject('dummy', 'dummy', Author('', '')),
      [Translation('en', '')],
      [Translation('en', '')],
      CredentialStatusField.emptyCredentialStatusField(),
      [Evidence.emptyEvidence()],
    );
  }

  Map<String, dynamic> toJson() => _$CredentialToJson(this);

  static List<Proof> _fromJsonProofs(json) {
    if (json == null) {
      return [Proof.dummy()];
    }
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

  static CredentialStatusField _fromJsonCredentialStatus(json) {
    if (json == null || json == '') {
      return CredentialStatusField.emptyCredentialStatusField();
    }
    return CredentialStatusField.fromJson(json);
  }

  static List<Evidence> _fromJsonEvidence(json) {
    if (json == null) {
      return [Evidence.emptyEvidence()];
    }
    if (json is List) {
      return (json)
          .map((e) => Evidence.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [Evidence.fromJson(json)];
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
