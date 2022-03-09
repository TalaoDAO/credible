import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:talao/app/interop/network/network_client.dart';
import 'package:talao/qr_code/qr_code_scan/cubit/qr_code_state.dart';
import 'package:talao/scan/bloc/scan.dart';
import 'package:talao/credentials/credentials.dart';
import 'package:talao/app/shared/error_handler/error_handler.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:logging/logging.dart';
import 'package:talao/query_by_example/query_by_example.dart';

class QRCodeCubit extends Cubit<QRCodeState> {
  final DioClient client;
  final ScanBloc scanBloc;
  final QueryByExampleCubit queryByExampleCubit;

  QRCodeCubit(
    this.client,
    this.scanBloc,
    this.queryByExampleCubit,
  ) : super(QRCodeStateWorking());

  @override
  Future<void> close() async {
    //cancel streams
    return super.close();
  }

  void host(String? url) async {
    late final uri;

    try {
      if (url == null) {
        emit(QRCodeStateMessage(
            message: StateMessage.error(
                'This QRCode does not contain a valid message.')));
      } else {
        uri = Uri.parse(url);
      }
    } on FormatException catch (e) {
      print(e.message);

      emit(QRCodeStateMessage(
          message: StateMessage.error(
              'This QRCode does not contain a valid message.')));
    }

    emit(QRCodeStateHost(uri: uri));
  }

  void deepLink(String data) async {
    late final uri;

    try {
      uri = Uri.parse(data);
    } on FormatException catch (e) {
      print(e.message);

      emit(QRCodeStateMessage(
          message: StateMessage.error(
              'This url does not contain a valid message.')));
    }

    emit(QRCodeStateHost(uri: uri));
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
          emit(QRCodeStateSuccess(route: CredentialsReceivePage.route(uri)));
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
              emit(QRCodeStateSuccess(
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
              emit(QRCodeStateSuccess(
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
            emit(QRCodeStateSuccess(
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
          emit(QRCodeStateUnknown());
          break;
      }
    } catch (e) {
      log.severe('An error occurred while connecting to the server.', e);

      if (e is ErrorHandler) {
        emit(QRCodeStateMessage(
            message:
                StateMessage.error('An error occurred ', errorHandler: e)));
      } else {
        emit(QRCodeStateMessage(
            message: StateMessage.error(
                'An error occurred while connecting to the server. '
                'Check the logs for more information.')));
      }
    }
  }
}
