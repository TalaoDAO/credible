import 'package:dio/dio.dart';
import 'package:talao/app/interop/check_issuer/models/issuer.dart';
import 'package:talao/app/interop/network/network_client.dart';
import 'package:talao/app/interop/network/network_exceptions.dart';

class CheckIssuer {
  final Dio client;
  final String checkIssuerServerUrl;
  final Uri uriToCheck;

  CheckIssuer(
    this.client,
    this.checkIssuerServerUrl,
    this.uriToCheck,
  );

  Future<Issuer> isIssuerInApprovedList() async {
    final newNetworkClient = DioClient(checkIssuerServerUrl, client);
    var didToTest = '';
    uriToCheck.queryParameters.forEach((key, value) {
      if (key == 'issuer') {
        didToTest = value;
      }
    });
    try {
      final response =
          await newNetworkClient.get('$checkIssuerServerUrl/$didToTest');
      final issuer = Issuer.fromJson(response);
      final exception = NetworkExceptions.getDioException(DioError(
          requestOptions: RequestOptions(path: 'sdoif'),
          type: DioErrorType.connectTimeout));
      throw exception;
      if (issuer.organizationInfo.issuerDomain.contains(uriToCheck.host)) {
        return issuer;
      }
      return Issuer.emptyIssuer();
    } catch (e) {
      rethrow;
    }
  }
}
