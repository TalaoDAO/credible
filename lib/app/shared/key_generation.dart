import 'dart:convert';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:hex/hex.dart';
import 'package:secp256k1/secp256k1.dart';

class KeyGeneration {
  static Future<String> privateKey(String mnemonic) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    var rootKey = bip32.BIP32.fromSeed(seed);
    // derive path for ethereum '60' see bip 44, first address
    final child = rootKey.derivePath("m/44'/60'/0'/0/0");
    Iterable<int> iterable = child.privateKey!;
    final epk = HEX.encode(List.from(iterable));
    print(epk);
    final pk = PrivateKey.fromHex(epk);
    final pub = pk.publicKey.toHex().substring(2);
    final ad = HEX.decode(epk);
    final d = base64Url.encode(ad).substring(0, 43); // remove "=" padding 43/44
    final mx = pub.substring(0, 64); // first 32 bytes
    final ax = HEX.decode(mx);
    final x = base64Url.encode(ax).substring(0, 43); // remove "=" padding 43/44
    final my = pub.substring(64); // last 32 bytes
    final ay = HEX.decode(my);
    final y = base64Url.encode(ay).substring(0, 43);
    // ATTENTION !!!!!
    // alg "ES256K-R" for did:ethr and did:tz2 "EcdsaSecp256k1RecoverySignature2020"
    // use alg "ES256K" for did:key
    final key = {
      'kty': 'EC',
      'crv': 'secp256k1',
      'd': d,
      'x': x,
      'y': y,
      'alg': 'ES256K-R' // or 'alg': "ES256K" for did:key
    };
    return jsonEncode(key);
  }
}
