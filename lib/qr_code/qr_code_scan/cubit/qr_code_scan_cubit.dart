import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/interop/network/network_client.dart';
import 'package:talao/deep_link/cubit/deep_link.dart';
import 'package:talao/credentials/credentials.dart';
import 'package:talao/app/shared/error_handler/error_handler.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:logging/logging.dart';
import 'package:talao/query_by_example/query_by_example.dart';
import 'package:talao/scan/scan.dart';

part 'qr_code_scan_state.dart';

part 'qr_code_scan_cubit.g.dart';

class QRCodeScanCubit extends Cubit<QRCodeScanState> {
  final DioClient client;
  final ScanCubit scanCubit;
  final QueryByExampleCubit queryByExampleCubit;
  final DeepLinkCubit deepLinkCubit;

  QRCodeScanCubit({
    required this.client,
    required this.scanCubit,
    required this.queryByExampleCubit,
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

  void deepLink() async {
    final deepLinkUrl = deepLinkCubit.state;
    if (deepLinkUrl != '') {
      deepLinkCubit.resetDeepLink();
      try {
        var uri = Uri.parse(deepLinkUrl);
        emit(QRCodeScanStateHost(uri: uri, isDeepLink: true));
      } on FormatException {
        emit(QRCodeScanStateMessage(
            isDeepLink: true,
            message: StateMessage.error(
                'This url does not contain a valid message.')));
      }
    }
  }

  void accept(Uri uri, bool isDeepLink) async {
    final log = Logger('talao-wallet/qrcode/accept');

    late final data;

    try {
      final response = await client.get(uri.toString());
      data = response is String ? jsonDecode(response) : response;

      scanCubit.emitScanStatePreview(preview: data);
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
              scanCubit.askPermissionDIDAuthCHAPI(
                keyId: 'key',
                done: (done) {
                  print('done');
                },
                uri: uri,
                challenge: data['challenge'],
                domain: data['domain'],
              );
            } else if (data['query'].first['type'] == 'QueryByExample') {
              emit(QRCodeScanStateSuccess(
                  isDeepLink: isDeepLink,
                  route: CredentialsPresentPage.route(uri: uri)));
            } else {
              throw UnimplementedError('Unimplemented Query Type');
            }
          } else {
            emit(QRCodeScanStateSuccess(
                isDeepLink: isDeepLink,
                route: CredentialsPresentPage.route(uri: uri)));
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

  bool isOpenIdUrl(Uri uri) {
    var condition = false;
    uri.queryParameters.forEach((key, value) {
      if (key == 'scope' && value == 'openid') {
        condition = true;
      }
    });
    return condition;
  }

  bool requestAttributeExists(Uri uri) {
    var condition = false;
    uri.queryParameters.forEach((key, value) {
      if (key == 'request') {
        condition = true;
      }
    });
    return condition;
  }

  bool requestUrlAttributeExists(Uri uri) {
    var condition = false;
    uri.queryParameters.forEach((key, value) {
      if (key == 'request_uri') {
        condition = true;
      }
    });
    return condition;
  }


}
