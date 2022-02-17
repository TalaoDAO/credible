import 'dart:convert';

import 'package:talao/app/interop/didkit/didkit.dart';

Future<String> CreateCredential(
    {required Map credential, required options, required String key}) async {
  final vc = await DIDKitProvider.instance
      .issueCredential(jsonEncode(credential), jsonEncode(options), key);
  return vc;
}
