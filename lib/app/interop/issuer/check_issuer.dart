import 'package:talao/app/interop/issuer/models/issuer.dart';
import 'package:talao/app/interop/issuer/models/organization_info.dart';
import 'package:talao/app/interop/network/network_client.dart';
import 'package:talao/app/interop/network/network_exception.dart';
import 'package:talao/app/shared/constants.dart';

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
    if (checkIssuerServerUrl == Constants.checkIssuerEbsiUrl &&
        !didToTest.startsWith('did:ebsi')) {
      return Issuer.emptyIssuer();
    }
    try {
      final response = await client.get('$checkIssuerServerUrl/$didToTest');
      if (checkIssuerServerUrl == Constants.checkIssuerEbsiUrl) {
        return Issuer(
            preferredName: '',
            did: [],
            organizationInfo: OrganizationInfo(
                legalName: 'sdf',
                currentAddress: '',
                id: '',
                issuerDomain: [],
                website: ''));
      }
      final issuer = Issuer.fromJson(response);
      if (issuer.organizationInfo.issuerDomain.contains(uriToCheck.host)) {
        return issuer;
      }
      return Issuer.emptyIssuer();
    } catch (e) {
      if (checkIssuerServerUrl == Constants.checkIssuerEbsiUrl &&
          e is NotFound) {
        return Issuer.emptyIssuer();
      }
      rethrow;
    }
  }
}
