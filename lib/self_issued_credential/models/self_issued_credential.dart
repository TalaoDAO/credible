import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/model/credential_subject.dart';

part 'self_issued_credential.g.dart';

@JsonSerializable(explicitToJson: true)
class SelfIssuedCredential {
  @JsonKey(name: '@context', defaultValue: _context)
  final List<dynamic> context;
  final String id;
  @JsonKey(defaultValue: _type)
  final List type;
  final CredentialSubject credentialSubject;
  final String issuer;
  final String issuanceDate;
  @JsonKey(defaultValue: _description)
  final List<dynamic> description;
  @JsonKey(defaultValue: _name)
  final List<dynamic> name;

  SelfIssuedCredential(
      {required this.id,
      required this.issuer,
      required this.issuanceDate,
      required this.credentialSubject,
      this.context = _context,
      this.type = _type,
      this.name = _name,
      this.description = _description});

  factory SelfIssuedCredential.fromJson(Map<String, dynamic> json) {
    return _$SelfIssuedCredentialFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SelfIssuedCredentialToJson(this);


  static const List<String> _type = ['VerifiableCredential', 'SelfIssued'];
  static const List<dynamic> _description = [
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
  static const List<dynamic> _name = [
    {'@language': 'en', '@value': 'Self Issued credential'},
    {'@language': 'de', '@value': ''},
    {'@language': 'fr', '@value': 'Attestation déclarative'}
  ];

  static const List<dynamic> _context = [
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
          'jobTitle' : 'schema:jobTitle',
          'workFor' : 'schema:workFor',
          'companyWebsite' : 'schema:website',
          'id': '@id',
          'schema': 'https://schema.org/',
          'telephone': 'schema:telephone',
          'type': '@type'
        },
        '@id': 'https://github.com/TalaoDAO/context/blob/main/README.md'
      }
    }
  ];
}
