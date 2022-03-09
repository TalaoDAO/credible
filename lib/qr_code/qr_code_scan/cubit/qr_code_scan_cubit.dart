import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:talao/app/interop/issuer/check_issuer.dart';
import 'package:talao/app/interop/issuer/models/issuer.dart';
import 'package:talao/app/interop/network/network_client.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:talao/deep_link/cubit/deep_link.dart';
import 'package:talao/drawer/drawer.dart';
import 'package:talao/drawer/profile/cubit/profile_state.dart';
import 'package:talao/qr_code/qr_code_scan/cubit/qr_code_scan_state.dart';
import 'package:talao/scan/bloc/scan.dart';
import 'package:talao/credentials/credentials.dart';
import 'package:talao/app/shared/error_handler/error_handler.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:logging/logging.dart';
import 'package:talao/query_by_example/query_by_example.dart';

class QRCodeScanCubit extends Cubit<QRCodeScanState> {
  final DioClient client;
  final ScanBloc scanBloc;
  final QueryByExampleCubit queryByExampleCubit;
  final ProfileCubit profileCubit;
  final DeepLinkCubit deepLinkCubit;

  QRCodeScanCubit({
    required this.client,
    required this.scanBloc,
    required this.queryByExampleCubit,
    required this.profileCubit,
    required this.deepLinkCubit,
  }) : super(QRCodeScanStateWorking());

  @override
  Future<void> close() async {
    //cancel streams
    return super.close();
  }

  void emitWorkingState() {
    emit(QRCodeScanStateWorking());
  }

  void host(String? url) async {
    try {
      if (url == null) {
        emit(QRCodeScanStateMessage(
            message: StateMessage.error(
                'This QRCode does not contain a valid message.')));
      } else {
        var uri = Uri.parse(url);
        emit(QRCodeScanStateHost(uri: uri));
      }
    } on FormatException {
      emit(QRCodeScanStateMessage(
          message: StateMessage.error(
              'This QRCode does not contain a valid message.')));
    }
  }

  void deepLink() async {
    var url = deepLinkCubit.state;
    if (url != '') {
      deepLinkCubit.resetDeepLink();
      try {
        var uri = Uri.parse(url);
        emit(QRCodeScanStateHost(uri: uri));
      } on FormatException {
        emit(QRCodeScanStateMessage(
            message: StateMessage.error(
                'This url does not contain a valid message.')));
      }
    }
  }

  void accept(Uri uri) async {
    final log = Logger('talao-wallet/qrcode/accept');

    late final data;

    try {
      final response = await client.get(uri.toString());
      data = response is String ? jsonDecode(response) : response;

      scanBloc.add(ScanEventShowPreview(data));
      switch (data['type']) {
        case 'CredentialOffer':
          emit(
              QRCodeScanStateSuccess(route: CredentialsReceivePage.route(uri)));
          break;

        case 'VerifiablePresentationRequest':
          if (data['query'] != null) {
            queryByExampleCubit.setQueryByExampleCubit(data['query'].first);
            if (data['query'].first['type'] == 'DIDAuth') {
              scanBloc.add(ScanEventCHAPIAskPermissionDIDAuth(
                'key',
                (done) {
                  print('done');
                },
                uri,
                challenge: data['challenge'],
                domain: data['domain'],
              ));
              emit(QRCodeScanStateSuccess(
                  route: CredentialsPresentPage.route(
                resource: 'DID',
                yes: 'Accept',
                url: uri,
                onSubmit: (preview, context) {
                  // Navigator.of(context)
                  //     .pushReplacement(CredentialsList.route());
                },
              )));
            } else if (data['query'].first['type'] == 'QueryByExample') {
              emit(QRCodeScanStateSuccess(
                  route: CredentialsPresentPage.route(
                resource: 'credential',
                url: uri,
                onSubmit: (preview, context) {
                  Navigator.of(context)
                      .pushReplacement(CredentialsPickPage.route(uri, preview));
                },
              )));
            } else {
              throw UnimplementedError('Unimplemented Query Type');
            }
          } else {
            emit(QRCodeScanStateSuccess(
                route: CredentialsPresentPage.route(
              resource: 'credential',
              url: uri,
              onSubmit: (preview, context) {
                Navigator.of(context)
                    .pushReplacement(CredentialsPickPage.route(uri, preview));
              },
            )));
          }
          break;

        default:
          emit(QRCodeScanStateUnknown());
          break;
      }
    } catch (e) {
      log.severe('An error occurred while connecting to the server.', e);

      if (e is ErrorHandler) {
        emit(QRCodeScanStateMessage(
            message:
                StateMessage.error('An error occurred ', errorHandler: e)));
      } else {
        emit(QRCodeScanStateMessage(
            message: StateMessage.error(
                'An error occurred while connecting to the server. '
                'Check the logs for more information.')));
      }
    }
  }

  Future<Issuer> isApprovedIssuer(Uri uri, BuildContext context) async {
    if (profileCubit.state is ProfileStateDefault) {
      final isIssuerVerificationSettingTrue =
          profileCubit.state.model!.issuerVerificationSetting;
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
    return Issuer.emptyIssuer();
  }
}
