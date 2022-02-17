import 'package:flutter_test/flutter_test.dart';
import 'package:talao/app/pages/profile/usecase/create_credential.dart';

void main() {
  group('self issued credential', () {

    test('self issued credential from profile data', () async {
      final selfIssuedJson = {
        '@context': [
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
        ],
        'id': 'urn:uuid:07f57d49-f6bb-442c-8052-cdca64357b73',
        'type': [
          'VerifiableCredential',
          'SelfIssued'
        ],
        'credentialSubject': {
          'id': 'did:tz:tz2E4kuaB9zHa1C3LqNeZncvZogYjQsXxvxz',
          'type': 'SelfIssued',
          'givenName': 'Thierry',
          'familyName': 'Thevenet'
        },
        'issuer': '',
        'issuanceDate': '',
        'expirationDate': '2022-02-12T09:14:58Z',
        'description': [
          {
            '@language': 'en',
            '@value': 'This signed electronic certificate has been issued by the user itself.'
          },
          {
            '@language': 'de',
            '@value': ''
          },
          {
            '@language': 'fr',
            '@value': "Cette attestation électronique est signée par l'utilisateur."
          }
        ],
        'name': [
          {
            '@language': 'en',
            '@value': 'Self Issued credential'
          },
          {
            '@language': 'de',
            '@value': ''
          },
          {
            '@language': 'fr',
            '@value': 'Attestation déclarative'
          }
        ]
      };
      final key = 'did:tz:tz2Qv4HgkUeuZC9atHsKoJVGj19HZQ3vWQGt';
      //todo write expectation
      //expect(await CreateCredential(credential: selfIssuedJson, key: key), matcher)
    });
  });
}