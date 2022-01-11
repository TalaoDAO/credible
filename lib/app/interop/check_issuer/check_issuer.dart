import 'package:talao/app/interop/check_issuer/models/issuer.dart';
import 'package:talao/app/interop/network/network_client.dart';
import 'package:talao/app/interop/network/network_exception.dart';

class CheckIssuer {
  final DioClient client;
  final String checkIssuerServerUrl;
  final Uri uriToCheck;

  CheckIssuer(
    this.client,
    this.checkIssuerServerUrl,
    this.uriToCheck,
  );

  Future<Issuer> isIssuerInApprovedList() async {
    var didToTest = '';
    uriToCheck.queryParameters.forEach((key, value) {
      if (key == 'issuer') {
        didToTest = value;
      }
    });
    try {
      final response = await client.get('$checkIssuerServerUrl/$didToTest');
      final issuer = Issuer.fromJson(response);
      if (issuer.organizationInfo.issuerDomain.contains(uriToCheck.host)) {
        return issuer;
      }
      return Issuer.emptyIssuer();
    } catch (e) {
      throw (NetworkException.getDioException(e));
    }
  }
}
