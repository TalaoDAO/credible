import 'dart:convert';
import 'package:talao/app/interop/crypto_keys/crypto_keys.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talao/app/shared/encryption.dart';

void main() {
  group('RecoverWallet', () {
    test('The provided string is valid JSON', () async {
      var jsonString =
          '{ "cipherText":"John", "authenticationTag":"New York" }';
      try {
        var decodedJSON = json.decode(jsonString) as Map<String, dynamic>;
        expect(decodedJSON, equals(json.decode(jsonString)));
      } catch (e) {
        print(e);
      }
    });

    test('The provided string is not valid JSON', () async {
      var jsonString = '';
      try {
        json.decode(jsonString) as Map<String, dynamic>;
      } on FormatException catch (e) {
        var error = e.toString().startsWith('FormatException');
        expect(error, true);
      }
    });
  });
}
