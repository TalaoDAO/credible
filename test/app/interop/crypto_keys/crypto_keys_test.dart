import 'package:talao/app/interop/crypto_keys/crypto_keys.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talao/app/shared/model/encryption/encryption.dart';

void main() {
  group('CryptoKeys', () {
    var mnemonic =
        'notice photo opera keen climb agent soft parrot best joke field devote';

    var message = '{"name": "My name is Bibash."}';
    var cipherText = '¨`ýp<ÐW3AR1¯#.í©¥¿e,|VrtuXÅ';
    var authenticationTag = 'äU~ÇÍÞ¦BÌuDÅ';

    test(
        'generateKeyPair() should always derive the same keypair when using the same mnemonic',
        () async {
      final generatedKey = await CryptoKeys().generateKeyPair(mnemonic);
      expect(generatedKey.privateKey.hashCode, equals(1100798733));
      expect(generatedKey.publicKey.hashCode, equals(1100798733));
    });

    test('encrypt', () async {
      final encryptedData = await CryptoKeys().encrypt(message, mnemonic);
      expect(encryptedData.cipherText, equals(cipherText));
      expect(encryptedData.authenticationTag, equals(authenticationTag));
    });

    test('decrypt', () async {
      var encryption = Encryption(
          cipherText: cipherText, authenticationTag: authenticationTag);
      final decryptedData = await CryptoKeys().decrypt(mnemonic, encryption);
      expect(decryptedData, equals(message.toString()));
    });

    test('invalid cipherText', () async {
      var inCipherText = '123';
      var encryption = Encryption(
          cipherText: inCipherText, authenticationTag: authenticationTag);
      try {
        await CryptoKeys().decrypt(mnemonic, encryption);
      } catch (e) {
        var error = e.toString().startsWith('Auth error');
        expect(error, true);
      }
    });

    test('invalid authenticationTag', () async {
      var inValidAuthenticationTag = '123';
      var encryption = Encryption(
          cipherText: cipherText, authenticationTag: inValidAuthenticationTag);
      try {
        await CryptoKeys().decrypt(mnemonic, encryption);
      } catch (e) {
        var error = e.toString().startsWith('Auth error');
        expect(error, true);
      }
    });
  });
}
