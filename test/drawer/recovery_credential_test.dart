import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

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

    test('json string contains required key', () async {
      var jsonString =
          '{ "cipherText":"John", "authenticationTag":"New York" }';
      var decodedJSON = json.decode(jsonString) as Map<String, dynamic>;
      expect(decodedJSON.containsKey('cipherText'), true);
      expect(decodedJSON.containsKey('authenticationTag'), true);
      expect(decodedJSON.containsKey('random'), false);
    });

    test('json string contains string value', () async {
      var jsonString =
          '{ "cipherText":"John", "authenticationTag":"New York" }';
      var decodedJSON = json.decode(jsonString) as Map<String, dynamic>;
      expect(decodedJSON['cipherText'] is String, true);
      expect(decodedJSON['authenticationTag'] is String, true);
      expect(decodedJSON['authenticationTag'] is int, false);
    });
  });
}
