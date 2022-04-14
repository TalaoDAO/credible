import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:passbase_flutter/passbase_flutter.dart';
import 'package:pointycastle/asymmetric/api.dart';

/// Give user email to KYC. When KYC is successful this email is used to send the over18 credential link to user.
void setKYCEmail(String email) {
  PassbaseSDK.prefillUserEmail = email;
  print(email);
}

/// Give user metadata to KYC. Currently we are just sending user DID.
Future<void> setKYCMetadat(did) async {
  final parser = RSAKeyParser();

  /// prepare metadata in json file
  final json = {'did': '$did'};

  /// get the private key
  final privateKeyString = '''-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAp60ZrqHOU3uyG9Sgkv2B/NKUO09ezC9qWJztLmVODwLu86nk
LyACvL+23SKhF2pOmoQmydET/zsXURwDME9rxaVLOnUKNi+/jYwm9AzqtPgYXaig
65CHqjbhmzpkSNUJLk+fD3oRok3LABhksGoYVD+CQa8D1/s/uWiGi0i8JvnoIcx0
bN7TF/X1E4t3Ml4oMeYTCG5UQoQrScZDBkOBG5GWHXIndddrwuhlB1G+m6veAaM+
eHgZ7cbsrQj1mzZMC79ER5CCYSE+yZft7AMjUBtx2ZGNzFhQMp6STGmv4dSwtEGa
t8/DUlDIPdV60SkZR5QDS+oEs0wkTjgjm2YYvQIDAQABAoIBABEATytSwq3aS+vg
ekuNIsH0xAzjdlQzto+3kaDzqp+BB6NzJWzVzRFASxVO7pCGOeQW5CvwZBur7ShP
M8+RLfdDVEZgGaH243BBtq1mJeIliartbyuTYv4SRHvNxt9PonesoQ8brHANfTjM
QGFW0JKyQc3RJg2fLw3omEPFIza8VBYyfVg59MX5XQpsr7KDF9OQx96aGFLA7kIx
N3qu7g2cl6xVkzMGkvpuvQ6QASxQzTHR2ysjFy8Ns2M8Cjo+YFBhMzlZWeUVC9mw
NInOyv99yTlVhFNXi1DwW+a6YFkGMuD7vl61psdtohtOzHOKD7k7hxGnyUQXZs3y
Bnk/9E0CgYEA0GV5day0r17m9syAQXnkrG3mInEZJUDWXNg1fRj20KDTA0TMq0fy
eiKgPkbNpC7SwHY08nRYDAwcDaqAOq4pwcfCkfw0kRKPuID/YwPIu++GW/Akk1jg
9byCaBIh2QXNkOEL8OvMPsAltDXcvwfuE7DwfJWJXfjhbtNkUwjOo0cCgYEAzfpn
ldGkug0JyrNPZQ94+DcW9gwG5z1r92Qj87y99rCno+CSs+bwii+Hi4W5ZM4WMlzj
9BA2Tzb3exP4NE7XWpStdyMUAbOzC0hmrqh0xuipZjt0skx71eClDRlobb9ONQHD
OtOt7z6DoIjrTCpfEkB8mqlStUuhkqO/azPDvdsCgYEAjfQxckj8o2D/7ymKTA+e
Bx6tXtSvjkLGQmQ8u0QgDCkg098vk5TkxPGFOia8uZPzl4ptsqIxv7MYAO8dfdtZ
MljCXvLvU8rS/5lPXcEcIXidi07fe0dVpc6M/hsr10supfvGSIw2iqAUjtcJ0U6z
i9JBXnv2IH8CAJ4afr1HFM0CgYBsPUUHxrYAiu91VErJeZsBHLn1LBbIl09QHpCB
+dH9e5FsnYuZ/Ca1Bwr8d5YX8fBaINQtIgPYFrNwOus4WaHzWKPbMlTGHC9fI3nK
GH3dNNAoB+Bn/acpmjZBrvNgkKJBWp7EIA6L5Vb4GltDmBSDm92ezJHI8WiDjYb+
h6I59wKBgHDDeppcgCdgY62SWxbXFKMkAGK+CptKsoEKxjP+4pn6c4nWQlxsJhKa
4KhPDdi4BentF45OWuUYU3mKKklhZXk+EiX0aWS2CklUH5dvjxhnkNKlQI9azNYt
0VSaM3KAsfgvGDpoUCMSBo27Y/3U3X90MRWJrYnPxxl7T3e05m2I
-----END RSA PRIVATE KEY-----''';

  final publicKeyString = '''-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAp60ZrqHOU3uyG9Sgkv2B
/NKUO09ezC9qWJztLmVODwLu86nkLyACvL+23SKhF2pOmoQmydET/zsXURwDME9r
xaVLOnUKNi+/jYwm9AzqtPgYXaig65CHqjbhmzpkSNUJLk+fD3oRok3LABhksGoY
VD+CQa8D1/s/uWiGi0i8JvnoIcx0bN7TF/X1E4t3Ml4oMeYTCG5UQoQrScZDBkOB
G5GWHXIndddrwuhlB1G+m6veAaM+eHgZ7cbsrQj1mzZMC79ER5CCYSE+yZft7AMj
UBtx2ZGNzFhQMp6STGmv4dSwtEGat8/DUlDIPdV60SkZR5QDS+oEs0wkTjgjm2YY
vQIDAQAB
-----END PUBLIC KEY-----''';
  final privateKey = parser.parse(privateKeyString) as RSAPrivateKey;
  final publicKey = parser.parse(publicKeyString) as RSAPublicKey;

  /// encrypt metadata
  // final encrypter = Encrypter(RSA(
  //   publicKey: publicKey,
  //   privateKey: privateKey,
  // ));
  // final jsonString = jsonEncode(json);
  // print(jsonString);
  // final encrypted = encrypter.encrypt(jsonString);
  // final toto = encrypted.base64;

// sign metadata
  final jsonString = jsonEncode(json);
  final signer = Signer(RSASigner(RSASignDigest.SHA256,
      publicKey: publicKey, privateKey: privateKey));
  final metadata = signer.sign(jsonString).base64;

  /// give encoded metadata to KYC
  PassbaseSDK.metaData = metadata;
  print(jsonString);
  print(metadata);
  print('line space');
  print(signer.verify64(jsonString, metadata));
}
