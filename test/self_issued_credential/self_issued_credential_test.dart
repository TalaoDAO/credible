import 'dart:convert';

import 'package:didkit/didkit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SelfIssuedCredential', () {

    test('issueCredential, verifyCredential', () async {
      final key = DIDKit.generateEd25519Key();
      final did = DIDKit.keyToDID('key', key);
      final verificationMethod = DIDKit.keyToVerificationMethod('key', key);
      final options = {
        'proofPurpose': 'assertionMethod',
        'verificationMethod': verificationMethod
      };
      final credential = {
        '@context': 'https://www.w3.org/2018/credentials/v1',
        'id': 'http://example.org/credentials/3731',
        'type': ['VerifiableCredential'],
        'issuer': did,
        'issuanceDate': '2020-08-19T21:41:50Z',
        'credentialSubject': {'id': 'did:example:d23dd687a7dc6787646f2eb98d0'}
      };
      final vc = DIDKit.issueCredential(
          jsonEncode(credential), jsonEncode(options), key);

      final verifyOptions = {'proofPurpose': 'assertionMethod'};
      final verifyResult =
      jsonDecode(DIDKit.verifyCredential(vc, jsonEncode(verifyOptions)));
      expect(verifyResult['errors'], isEmpty);
    });
  });
}
