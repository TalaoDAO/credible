import 'package:talao/app/interop/crypto_keys/crypto_keys.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talao/app/shared/encryption.dart';

void main() {
  group('CryptoKeys', () {
    var mnemonic =
        'notice photo opera keen climb agent soft parrot best joke field devote';

    var message = '{"name": "My name is Bibash Shrestha."}';
    var cipherText = '\x05¨`ýp<ÐW3AR1¯#.í©¥¿e,|V\x1Brt{)Ð¢\x17HØl\x01GP¹';
    var authenticationTag = '§Sß-ð4´tY<ÞT	ú';

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
  });
}
