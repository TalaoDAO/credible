import 'dart:convert';

import 'package:talao/app/interop/didkit/didkit.dart';

Future<dynamic> CreateCredential(
    {required Map credential,
    required Map options,
    required Map verifyOptions,
    required String key}) async {
  final vc = await DIDKitProvider.instance
      .issueCredential(jsonEncode(credential), jsonEncode(options), key);
  final result = await DIDKitProvider.instance
      .verifyCredential(vc, jsonEncode(verifyOptions));
  final verifyResult = jsonDecode(result);
  return verifyResult;
}
