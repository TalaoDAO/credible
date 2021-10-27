import 'package:dio/dio.dart';
import 'package:talao/app/interop/check_issuer/check_issuer.dart';
import 'package:talao/app/pages/profile/blocs/profile.dart';
import 'package:talao/app/shared/constants.dart';

Future<bool> isIssuerApproved(Uri uri) async {
  final client = Dio();
  final profilBloc = ProfileBloc();
  profilBloc.add(ProfileEventLoad());
  await Future.delayed(Duration(milliseconds: 100));
  final profil = profilBloc.state;
  if (profil is ProfileStateDefault) {
    final isIssuerVerificationSettingTrue =
        profil.model.issuerVerificationSetting;
    if (isIssuerVerificationSettingTrue) {
      try {
        return await CheckIssuer(client, Constants.checkIssuerServerUrl, uri)
            .isIssuerInApprovedList();
      } catch (e) {
        return false;
      }
    }
  }
  await profilBloc.close();
  return false;
}
