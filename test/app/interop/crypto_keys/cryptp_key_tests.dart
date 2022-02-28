import 'package:talao/app/interop/crypto_keys/crypto_keys.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CryptoKeys', () {
    var mnemonic =
        'notice photo opera keen climb agent soft parrot best joke field devote';

    test(
        'generateKeyPair() should always derive the same keypair when using the same mnemonic',
        () async {
      final generatedKey = await CryptoKeys().generateKeyPair(mnemonic);
      expect(generatedKey.privateKey.hashCode, equals(1100798733));
      expect(generatedKey.publicKey.hashCode, equals(1100798733));
    });
  });
}
