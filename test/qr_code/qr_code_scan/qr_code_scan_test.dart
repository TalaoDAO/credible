import 'package:flutter_test/flutter_test.dart';
import 'package:json_path/json_path.dart';

void main() {
  group('QR Code Scan', () {
    var openIdUrl =
        'openid://?scope=openid&response_type=id_token&client_id=did%3Aweb%3Atalao.co&redirect_uri=https%3A%2F%2Ftalao.co%2Fgaiax%2Flogin_redirect%2F287f58e9-a50c-11ec-bea0-0a1628958560&response_mode=post&claims=%7B%22id_token%22%3A%7B%7D%2C%22vp_token%22%3A%7B%22presentation_definition%22%3A%7B%22id%22%3A%22pass_for_gaiax%22%2C%22input_descriptors%22%3A%5B%7B%22id%22%3A%22GaiaxPass+issued+by+Talao%22%2C%22purpose%22%3A%22Test+for+Gaia-X+hackathon%22%2C%22format%22%3A%7B%22ldp_vc%22%3A%7B%22proof_type%22%3A%5B%22JsonWebSignature2020%22%5D%7D%7D%2C%22constraints%22%3A%7B%22limit_disclosure%22%3A%22required%22%2C%22fields%22%3A%5B%7B%22path%22%3A%5B%22%24.credentialSubject.type%22%5D%2C%22purpose%22%3A%22One+can+only+accept+GaiaxPass%22%2C%22filter%22%3A%7B%22type%22%3A%22string%22%2C%22pattern%22%3A%22GaiaxPass%22%7D%7D%2C%7B%22path%22%3A%5B%22%24.issuer%22%5D%2C%22purpose%22%3A%22One+can+accept+only+GaiaxPass+signed+by+Talao%22%2C%22filter%22%3A%7B%22type%22%3A%22string%22%2C%22pattern%22%3A%22did%3Aweb%3Atalao.co%22%7D%7D%5D%7D%7D%5D%7D%7D%7D&nonce=6j0RATZeIj&registration=%7B%22id_token_signing_alg_values_supported%22%3A%5B%22RS256%22%2C%22ES256%22%2C%22ES256K%22%2C%22EdDSA%22%5D%2C%22subject_syntax_types_supported%22%3A%5B%22did%3Aweb%22%2C%22did%3Atz%22%2C%22did%3Akey%22%2C%22did%3Aion%22%2C%22did%3Apkh%22%2C%22did%3Aethr%22%5D%7D&request_uri=https%3A%2F%2Ftalao.co%2Fgaiax%2Flogin_request_uri%2F287f58e9-a50c-11ec-bea0-0a1628958560';

    var claim = {
      'id_token': {},
      'vp_token': {
        'presentation_definition': {
          'id': 'pass_for_gaiax',
          'input_descriptors': [
            {
              'id': 'GaiaxPass issued by Talao',
              'purpose': 'Test for Gaia-X hackathon',
              'format': {
                'ldp_vc': {
                  'proof_type': ['JsonWebSignature2020']
                }
              },
              'constraints': {
                'limit_disclosure': 'required',
                'fields': [
                  {
                    'path': ['\$.credentialSubject.type'],
                    'purpose': 'One can only accept GaiaxPass',
                    'filter': {'type': 'string', 'pattern': 'GaiaxPass'}
                  },
                  {
                    'path': ['\$.issuer'],
                    'purpose': 'One can accept only GaiaxPass signed by Talao',
                    'filter': {'type': 'string', 'pattern': 'did:web:talao.co'}
                  }
                ]
              }
            }
          ]
        }
      }
    };

    test('OpenId Request is valid', () async {
      var uri = Uri.parse(openIdUrl);
      var condition = false;
      uri.queryParameters.forEach((key, value) {
        if (key == 'scope' && value == 'openid') {
          condition = true;
        }
      });
      expect(condition, true);
    });

    test('OpenId Request is inValid', () async {
      var uri = Uri.parse(
          'https://talao.co/wallet/test/wallet_credential/urn:uuid:374d3bea-0e22-11ec-9ef1-f37fc4c32c40?issuer=did%3Aethr%3A0xee09654eedaa79429f8d216fa51a129db0f72250');
      var condition = false;
      uri.queryParameters.forEach((key, value) {
        if (key == 'scope' && value == 'openid') {
          condition = true;
        }
      });
      expect(condition, false);
    });

    test('Is request attribute exists', () async {
      var uri = Uri.parse(openIdUrl);
      var condition = false;
      uri.queryParameters.forEach((key, value) {
        if (key == 'request') {
          condition = true;
        }
      });
      expect(condition, false);
    });

    test('Type is GaiaxPass', () async {
      final fieldsPath = JsonPath(r'$..fields');
      var credentialField = fieldsPath
          .read(claim)
          .first
          .value
          .where((e) =>
              e['path'].toString() == '[\$.credentialSubject.type]'.toString())
          .toList()
          .first;
      var credential = credentialField['filter']['pattern'];
      expect(credential, 'GaiaxPass');
    });

    test('Issuer is did:web:talao.co', () async {
      final fieldsPath = JsonPath(r'$..fields');
      var issuerField = fieldsPath
          .read(claim)
          .first
          .value
          .where((e) => e['path'].toString() == '[\$.issuer]'.toString())
          .toList()
          .first;
      var issuer = issuerField['filter']['pattern'];
      expect(issuer, 'did:web:talao.co');
    });
  });
}
