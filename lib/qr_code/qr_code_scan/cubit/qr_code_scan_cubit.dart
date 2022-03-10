import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/interop/network/network_client.dart';
import 'package:talao/scan/bloc/scan.dart';
import 'package:talao/credentials/credentials.dart';
import 'package:talao/app/shared/error_handler/error_handler.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:logging/logging.dart';
import 'package:talao/query_by_example/query_by_example.dart';

part 'qr_code_scan_state.dart';

part 'qr_code_scan_cubit.g.dart';

class QRCodeScanCubit extends Cubit<QRCodeScanState> {
  final DioClient client;
  final ScanBloc scanBloc;
  final QueryByExampleCubit queryByExampleCubit;

  QRCodeScanCubit({
    required this.client,
    required this.scanBloc,
    required this.queryByExampleCubit,
  }) : super(QRCodeScanStateWorking());

  @override
  Future<void> close() async {
    //cancel streams
    return super.close();
  }

  void emitWorkingState() {
    emit(QRCodeScanStateWorking());
  }

  void promptDeactivate() {
    emit(state.copyWith(promptActive: false));
  }

  void host(String? url, bool isDeepLink) async {
    try {
      if (url == null) {
        emit(QRCodeScanStateMessage(
            isDeepLink: isDeepLink,
            message: StateMessage.error(
                'This QRCode does not contain a valid message.')));
      } else {
        var uri = Uri.parse(url);
        emit(QRCodeScanStateHost(isDeepLink: isDeepLink, uri: uri));
      }
    } on FormatException {
      emit(QRCodeScanStateMessage(
          isDeepLink: isDeepLink,
          message: StateMessage.error(
              'This QRCode does not contain a valid message.')));
    }
  }

  void deepLink(String url) async {
    try {
      var uri = Uri.parse(url);
      emit(QRCodeScanStateHost(uri: uri, isDeepLink: true));
    } on FormatException {
      emit(QRCodeScanStateMessage(
          isDeepLink: true,
          message: StateMessage.error(
              'This url does not contain a valid message.')));
    }
  }

  void accept(Uri uri, bool isDeepLink) async {
    final log = Logger('talao-wallet/qrcode/accept');

    late final data;

    try {
      final response = await client.get(uri.toString());
      data = response is String ? jsonDecode(response) : response;

      scanBloc.add(ScanEventShowPreview(data));
      switch (data['type']) {
        case 'CredentialOffer':
          emit(QRCodeScanStateSuccess(
              isDeepLink: isDeepLink,
              route: CredentialsReceivePage.route(uri)));
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
                  isDeepLink: isDeepLink,
                  route: CredentialsPresentPage.route(
                    resource: 'DID',
                    yes: 'Accept',
                    url: uri,
                    onSubmit: (preview, context) {
                      // Navigator.of(context)
                      //     .pushReplacement(CredentialsListPage.route());
                    },
                  )));
            } else if (data['query'].first['type'] == 'QueryByExample') {
              emit(QRCodeScanStateSuccess(
                  isDeepLink: isDeepLink,
                  route: CredentialsPresentPage.route(
                    resource: 'credential',
                    url: uri,
                    onSubmit: (preview, context) {
                      Navigator.of(context).pushReplacement(
                          CredentialsPickPage.route(uri, preview));
                    },
                  )));
            } else {
              throw UnimplementedError('Unimplemented Query Type');
            }
          } else {
            emit(QRCodeScanStateSuccess(
                isDeepLink: isDeepLink,
                route: CredentialsPresentPage.route(
                  resource: 'credential',
                  url: uri,
                  onSubmit: (preview, context) {
                    Navigator.of(context).pushReplacement(
                        CredentialsPickPage.route(uri, preview));
                  },
                )));
          }
          break;

        default:
          emit(QRCodeScanStateUnknown(isDeepLink: isDeepLink));
          break;
      }
    } catch (e) {
      log.severe('An error occurred while connecting to the server.', e);

      if (e is ErrorHandler) {
        emit(QRCodeScanStateMessage(
            isDeepLink: isDeepLink,
            message:
                StateMessage.error('An error occurred ', errorHandler: e)));
      } else {
        emit(QRCodeScanStateMessage(
            isDeepLink: isDeepLink,
            message: StateMessage.error(
                'An error occurred while connecting to the server. '
                'Check the logs for more information.')));
      }
    }
  }
}
