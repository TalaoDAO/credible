import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:json_annotation/json_annotation.dart';

part 'self_issued_credential.g.dart';

@JsonSerializable(explicitToJson: true)
class SelfIssuedCredential {
  @JsonKey(name: '@context')
  final List context = [
    'https://www.w3.org/2018/credentials/v1',
    {
      'name': 'https://schema.org/name',
      'description': 'https://schema.org/description',
      'SelfIssued': {
        '@context': {
          '@protected': true,
          '@version': 1.1,
          'address': 'schema:address',
          'email': 'schema:email',
          'familyName': 'schema:familyName',
          'givenName': 'scheama:givenName',
          'id': '@id',
          'schema': 'https://schema.org/',
          'telephone': 'schema:telephone',
          'type': '@type'
        },
        '@id': 'https://github.com/TalaoDAO/context/blob/main/README.md'
      }
    }
  ];
  final String id;
  final List type = ['VerifiableCredential', 'SelfIssued'];
  final CredentialSubject credentialSubject;
  final String issuer;
  final String issuanceDate;

  final List description = [
    {
      '@language': 'en',
      '@value':
          'This signed electronic certificate has been issued by the user itself.'
    },
    {'@language': 'de', '@value': ''},
    {
      '@language': 'fr',
      '@value': "Cette attestation électronique est signée par l'utilisateur."
    }
  ];
  final List name = [
    {'@language': 'en', '@value': 'Self Issued credential'},
    {'@language': 'de', '@value': ''},
    {'@language': 'fr', '@value': 'Attestation déclarative'}
  ];
  SelfIssuedCredential(
    this.id,
    this.issuer,
    this.issuanceDate,
    this.credentialSubject,
  );

  factory SelfIssuedCredential.fromJson(Map<String, dynamic> json) {
    return _$SelfIssuedCredentialFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SelfIssuedCredentialToJson(this);
}
