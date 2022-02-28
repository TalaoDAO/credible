import 'dart:typed_data';

import 'package:talao/app/interop/key_generation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:crypto_keys/crypto_keys.dart';
import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;

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
    var mnemonics =
        'notice photo opera keen climb agent soft parrot best joke field devote';

    final seed = bip39.mnemonicToSeed(mnemonics);

    var rootKey = bip32.BIP32.fromSeed(seed); //Instance of 'BIP32'

    // derive path for ethereum '60' see bip 44, first address
    final child = rootKey.derivePath("m/44'/60'/0'/0/0"); //Instance of 'BIP32'

    final privateKey = child.privateKey!;
    //[44, 254, 73, 198, 41, 37, 89, 193, 190, 104, 116, 244, 188, 50, 31, 128, 25, 101, 57, 132, 49, 132, 105, 153, 166, 32, 39, 237, 145, 88, 63, 154]

    final key = SymmetricKey(keyValue: privateKey);

    var keyPair = KeyPair.symmetric(key);
    var message = '{"name": "My name is Bibash Shrestha"}';
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
