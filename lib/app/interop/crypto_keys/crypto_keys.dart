import 'dart:convert';
import 'dart:typed_data';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:crypto_keys/crypto_keys.dart';
import 'package:hex/hex.dart';
import 'package:intl/intl.dart';
import 'package:secp256k1/secp256k1.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:talao/app/shared/encryption.dart';

class CryptoKeys {
  Future<KeyPair> generateKeyPair(String mnemonic) async {
    final seed = bip39.mnemonicToSeed(mnemonic);

    var rootKey = bip32.BIP32.fromSeed(seed); //Instance of 'BIP32'

    // derive path for ethereum '60' see bip 44, first address
    final child = rootKey.derivePath("m/44'/60'/0'/0/0"); //Instance of 'BIP32'

    final privateKey = child.privateKey!;
    //[44, 254, 73, 198, 41, 37, 89, 193, 190, 104, 116, 244, 188, 50, 31, 128, 25, 101, 57, 132, 49, 132, 105, 153, 166, 32, 39, 237, 145, 88, 63, 154]

    final key = SymmetricKey(keyValue: privateKey);

    var keyPair = KeyPair.symmetric(key);
    return keyPair;
  }

  Future<Encryption> encrypt(String message, String mnemonic) async {
    var keyPair = await generateKeyPair(mnemonic);
    var encryptor =
        keyPair.publicKey!.createEncrypter(algorithms.encryption.aes.gcm);
    var encryptedBytes = encryptor.encrypt(
      Uint8List.fromList(message.codeUnits),
      additionalAuthenticatedData: Uint8List.fromList(mnemonic.codeUnits),
      initializationVector: Uint8List.fromList(Constants.ivVector.codeUnits),
    );
    return Encryption(
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      cipherText: String.fromCharCodes(encryptedBytes.data),
      authenticationTag:
          String.fromCharCodes(encryptedBytes.authenticationTag!),
    );
  }

  Future<String> decrypt(String mnemonic, Encryption encryption) async {
    var keyPair = await generateKeyPair(mnemonic);
    var decrypter =
        keyPair.privateKey!.createEncrypter(algorithms.encryption.aes.gcm);

    var decryptedBytes = decrypter.decrypt(EncryptionResult(
      Uint8List.fromList(encryption.cipherText!.runes.toList()),
      authenticationTag:
          Uint8List.fromList(encryption.authenticationTag!.runes.toList()),
      additionalAuthenticatedData: Uint8List.fromList(mnemonic.codeUnits),
      initializationVector: Uint8List.fromList(Constants.ivVector.codeUnits),
    ));

    var decryptedString = String.fromCharCodes(decryptedBytes);
    return decryptedString;
  }
}
