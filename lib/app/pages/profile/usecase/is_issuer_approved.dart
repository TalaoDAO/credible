import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:talao/app/interop/check_issuer/check_issuer.dart';
import 'package:talao/app/interop/check_issuer/models/issuer.dart';
import 'package:talao/app/interop/network/network_client.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:talao/app/shared/error_handler/error_handler.dart';
import 'package:talao/profile/profile.dart';

Future<Issuer> ApprovedIssuer(Uri uri, BuildContext context) async {
  final client = DioClient(Constants.checkIssuerServerUrl, Dio());
  final profileBloc = context.read<ProfileBloc>();
  final profile = profileBloc.state;
  if (profile is ProfileStateDefault) {
    final isIssuerVerificationSettingTrue =
        profile.model.issuerVerificationSetting;
    if (isIssuerVerificationSettingTrue) {
      try {
        return await CheckIssuer(client, Constants.checkIssuerServerUrl, uri)
            .isIssuerInApprovedList();
      } catch (e) {
        if (e is ErrorHandler) {
          e.displayError(context, e, Theme.of(context).colorScheme.error);
        }
        return Issuer.emptyIssuer();
      }
    }
  }
  await profileBloc.close();
  return Issuer.emptyIssuer();
}
