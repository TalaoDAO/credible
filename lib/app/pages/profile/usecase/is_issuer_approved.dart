import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/src/provider.dart';
import 'package:talao/app/interop/check_issuer/check_issuer.dart';
import 'package:talao/app/interop/check_issuer/models/issuer.dart';
import 'package:talao/app/pages/profile/blocs/profile.dart';
import 'package:talao/app/shared/constants.dart';

Future<Issuer> ApprovedIssuer(Uri uri, BuildContext context) async {
  final client = Dio();
  final profilBloc = context.read<ProfileBloc>();
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
