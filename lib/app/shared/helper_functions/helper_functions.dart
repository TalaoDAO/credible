import 'dart:io';

import 'package:altme/dashboard/home/home.dart';

String generateDefaultAccountName(
  int accountIndex,
  List<String> accountNameList,
) {
  final defaultAccountName = 'My account ${accountIndex + 1}';
  final containSameName = accountNameList.contains(defaultAccountName);
  if (containSameName) {
    return generateDefaultAccountName(accountIndex + 1, accountNameList);
  } else {
    return defaultAccountName;
  }
}

bool isAndroid() {
  return Platform.isAndroid;
}

String getIssuerDid({required Uri uriToCheck}) {
  String did = '';
  uriToCheck.queryParameters.forEach((key, value) {
    if (key == 'issuer') {
      did = value;
    }
  });
  return did;
}

bool isEbsiIssuer(CredentialModel credentialModel) {
  return credentialModel.issuer.startsWith('did:ebsi');
}

bool isValidPrivateKey(String value) {
  return value.startsWith('edsk') ||
      value.startsWith('spsk') ||
      value.startsWith('p2sk');
}
