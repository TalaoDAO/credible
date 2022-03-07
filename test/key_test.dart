import 'package:talao/app/interop/key_generation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('KeyGeneration', () {
    test(
        '.privateKey() should always derive the same key when using the same mnemonic',
        () async {
      final mnemonic =
          'state draft moral repeat knife trend animal pretty delay collect fall adjust';
      final generatedKey = await KeyGeneration().privateKey(mnemonic);
      print(generatedKey);
      expect(
          generatedKey,
          equals(
              '{"kty":"EC","crv":"secp256k1","d":"mtg1R2_WON8UW0MJcgd_dBw72ICeOaQ1ctaBgosrVLg","x":"v1frfQs65qaez150X_bEYRURnRFHipCL8qQeBZ0HgGY","y":"BSJiZsc4uOIdUVtCqlWHPUKToRf98VA2Xyfky2xzNPU","alg":"ES256K-R"}'));
    });
  });
}
