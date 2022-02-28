import 'dart:typed_data';

import 'package:talao/app/interop/key_generation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:crypto_keys/crypto_keys.dart';

void main() {
  group('KeyGeneration', () {
    test(
        '.privateKey() should always derive the same key when using the same mnemonic',
        () async {
      final mnemonic =
          'state draft moral repeat knife trend animal pretty delay collect fall adjust';
      final generatedKey = await KeyGeneration().privateKey(mnemonic);
      expect(
          generatedKey,
          equals(
              '{"kty":"OKP","crv":"Ed25519","d":"wHwSUdy4a00qTxAhnuOHeWpai4ERjdZGslaou-Lig5g=","x":"AI4pdGWalv3JXZcatmtBM8OfSIBCFC0o_RNzTg-mEAh6"}'));
    });
  });

  group('CryptoKeys', () {
    //todo: generate keypair using mnemonics
    var keyPair = KeyPair.generateSymmetric(128);

    var message = '{"name": "My name is Bibash Shresth"}';
    var mnemonics =
        'notice photo opera keen climb agent soft parrot best joke field devote';
    var ivVector = 'Talao';

    test('encryptAndDecrypt', () async {
      //encryption
      var encryptor =
          keyPair.publicKey!.createEncrypter(algorithms.encryption.aes.gcm);
      var encryptedBytes = encryptor.encrypt(
        Uint8List.fromList(message.codeUnits),
        additionalAuthenticatedData: Uint8List.fromList(mnemonics.codeUnits),
        initializationVector: Uint8List.fromList(ivVector.codeUnits),
      );

      //decryption
      var decrypter =
          keyPair.privateKey!.createEncrypter(algorithms.encryption.aes.gcm);

      var decryptedBytes = decrypter.decrypt(EncryptionResult(
        encryptedBytes.data,
        authenticationTag: encryptedBytes.authenticationTag,
        additionalAuthenticatedData: Uint8List.fromList(mnemonics.codeUnits),
        initializationVector: Uint8List.fromList(ivVector.codeUnits),
      ));

      var decryptedString = String.fromCharCodes(decryptedBytes);

      print(decryptedString);
      expect(decryptedString, equals(message));
    });
  });
}
