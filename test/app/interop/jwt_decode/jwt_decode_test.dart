import 'package:flutter_test/flutter_test.dart';
import 'package:talao/app/interop/jwt_decode/jwt_decode.dart';

void main() {
  group('JWTDecode', () {
    var token =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6ImRpZDp3ZWI6dGFsYW8uY28ja2V5LTIifQ.eyJzY29wZSI6Im9wZW5pZCIsInJlc3BvbnNlX3R5cGUiOiJpZF90b2tlbiIsImNsaWVudF9pZCI6ImRpZDp3ZWI6dGFsYW8uY28iLCJyZWRpcmVjdF91cmkiOiJodHRwczovL3RhbGFvLmNvL2dhaWF4L2xvZ2luX3JlZGlyZWN0LzI4N2Y1OGU5LWE1MGMtMTFlYy1iZWEwLTBhMTYyODk1ODU2MCIsInJlc3BvbnNlX21vZGUiOiJwb3N0IiwiY2xhaW1zIjoie1wiaWRfdG9rZW5cIjp7fSxcInZwX3Rva2VuXCI6e1wicHJlc2VudGF0aW9uX2RlZmluaXRpb25cIjp7XCJpZFwiOlwicGFzc19mb3JfZ2FpYXhcIixcImlucHV0X2Rlc2NyaXB0b3JzXCI6W3tcImlkXCI6XCJHYWlheFBhc3MgaXNzdWVkIGJ5IFRhbGFvXCIsXCJwdXJwb3NlXCI6XCJUZXN0IGZvciBHYWlhLVggaGFja2F0aG9uXCIsXCJmb3JtYXRcIjp7XCJsZHBfdmNcIjp7XCJwcm9vZl90eXBlXCI6W1wiSnNvbldlYlNpZ25hdHVyZTIwMjBcIl19fSxcImNvbnN0cmFpbnRzXCI6e1wibGltaXRfZGlzY2xvc3VyZVwiOlwicmVxdWlyZWRcIixcImZpZWxkc1wiOlt7XCJwYXRoXCI6W1wiJC5jcmVkZW50aWFsU3ViamVjdC50eXBlXCJdLFwicHVycG9zZVwiOlwiT25lIGNhbiBvbmx5IGFjY2VwdCBHYWlheFBhc3NcIixcImZpbHRlclwiOntcInR5cGVcIjpcInN0cmluZ1wiLFwicGF0dGVyblwiOlwiR2FpYXhQYXNzXCJ9fSx7XCJwYXRoXCI6W1wiJC5pc3N1ZXJcIl0sXCJwdXJwb3NlXCI6XCJPbmUgY2FuIGFjY2VwdCBvbmx5IEdhaWF4UGFzcyBzaWduZWQgYnkgVGFsYW9cIixcImZpbHRlclwiOntcInR5cGVcIjpcInN0cmluZ1wiLFwicGF0dGVyblwiOlwiZGlkOndlYjp0YWxhby5jb1wifX1dfX1dfX19Iiwibm9uY2UiOiI2ajBSQVRaZUlqIiwicmVnaXN0cmF0aW9uIjoie1wiaWRfdG9rZW5fc2lnbmluZ19hbGdfdmFsdWVzX3N1cHBvcnRlZFwiOltcIlJTMjU2XCIsXCJFUzI1NlwiLFwiRVMyNTZLXCIsXCJFZERTQVwiXSxcInN1YmplY3Rfc3ludGF4X3R5cGVzX3N1cHBvcnRlZFwiOltcImRpZDp3ZWJcIixcImRpZDp0elwiLFwiZGlkOmtleVwiLFwiZGlkOmlvblwiLFwiZGlkOnBraFwiLFwiZGlkOmV0aHJcIl19IiwicmVxdWVzdF91cmkiOiJodHRwczovL3RhbGFvLmNvL2dhaWF4L2xvZ2luX3JlcXVlc3RfdXJpLzI4N2Y1OGU5LWE1MGMtMTFlYy1iZWEwLTBhMTYyODk1ODU2MCJ9.XU17UUTA1CZU6vHtV5nOxVYb9J6lI2jj9GDn8aoRiOhFjvEbylg_ycCHBSZmR6aoAXTVv9bQxBvvg6z0UmxEeo29slVLzSFVvmysY5nL3zw5I0A-IBnpHxMkt44GNIZTJEnrkne7bdOSYhxETt4cE42ZXAA61MJIu--iFJ53E_CnhKymwn7yCoddt9RRVIiOYKEegBMTXsOO5HnQDcxv39vpuHxmAuOd1seZB8zZs7cTtqcKRjU_YnuBCZwF0xGHCe6Su5zgfXKivvaTYrXK0Bgl3y614vN3_qSXFeJ-CoLyy0AJkIYxvxD7PKMHswRrY-NVqJ6_YmUo3uDIr9BmSw';

    var jsonString =
        '''{scope: openid, response_type: id_token, client_id: did:web:talao.co, redirect_uri: https://talao.co/gaiax/login_redirect/287f58e9-a50c-11ec-bea0-0a1628958560, response_mode: post, claims: {"id_token":{},"vp_token":{"presentation_definition":{"id":"pass_for_gaiax","input_descriptors":[{"id":"GaiaxPass issued by Talao","purpose":"Test for Gaia-X hackathon","format":{"ldp_vc":{"proof_type":["JsonWebSignature2020"]}},"constraints":{"limit_disclosure":"required","fields":[{"path":["\$.credentialSubject.type"],"purpose":"One can only accept GaiaxPass","filter":{"type":"string","pattern":"GaiaxPass"}},{"path":["\$.issuer"],"purpose":"One can accept only GaiaxPass signed by Talao","filter":{"type":"string","pattern":"did:web:talao.co"}}]}}]}}}, nonce: 6j0RATZeIj, registration: {"id_token_signing_alg_values_supported":["RS256","ES256","ES256K","EdDSA"],"subject_syntax_types_supported":["did:web","did:tz","did:key","did:ion","did:pkh","did:ethr"]}, request_uri: https://talao.co/gaiax/login_request_uri/287f58e9-a50c-11ec-bea0-0a1628958560}''';

    test('Decode', () async {
      var decoded = JWTDecode().parseJwt(token);
      expect(decoded.toString(), equals(jsonString.toString()));
    });
  });
}
