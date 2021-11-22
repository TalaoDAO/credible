import 'package:dio/dio.dart';
import 'package:talao/app/interop/check_issuer/check_issuer.dart';
import 'package:talao/app/interop/check_issuer/models/issuer.dart';
import 'package:talao/app/pages/profile/blocs/profile.dart';
import 'package:talao/app/shared/constants.dart';

Future<Issuer> ApprovedIssuer(Uri uri) async {
  final client = Dio();
  final profilBloc = ProfileBloc();
  profilBloc.add(ProfileEventLoad());
  await Future.delayed(Duration(milliseconds: 500));
  final profil = profilBloc.state;
  if (profil is ProfileStateDefault) {
    final isIssuerVerificationSettingTrue =
        profil.model.issuerVerificationSetting;
    if (isIssuerVerificationSettingTrue) {
      try {
        return await CheckIssuer(client, Constants.checkIssuerServerUrl, uri)
            .isIssuerInApprovedList();
      } catch (e) {
        return Issuer.emptyIssuer();
      }
    }
  }
  await profilBloc.close();
  return Issuer.emptyIssuer();
}
