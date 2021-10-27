import 'package:dio/dio.dart';
import 'package:talao/app/interop/check_issuer/models/issuer.dart';

class CheckIssuer {
  final Dio client;
  final String checkIssuerServerUrl;
  final Uri uriToCheck;

  CheckIssuer(
    this.client,
    this.checkIssuerServerUrl,
    this.uriToCheck,
  );

  Future<bool> isIssuerInApprovedList() async {
    var didToTest = '';
    uriToCheck.queryParameters.forEach((key, value) {
      if (key == 'issuer') {
        didToTest = value;
      }
    });
    try {
      final response = await client.get('$checkIssuerServerUrl/$didToTest');
      final issuer = Issuer.fromJson(response.data);
      return issuer.organizationInfo.issuerDomain.contains(uriToCheck.host);
    } catch (e) {
      throw Exception(e);
    }
  }
}
