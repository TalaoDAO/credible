import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:talao/app/pages/credentials/blocs/scan.dart';
import 'package:talao/app/pages/credentials/pages/list.dart';
import 'package:talao/app/pages/credentials/pick.dart';
import 'package:talao/app/pages/credentials/present.dart';
import 'package:talao/app/pages/credentials/receive.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:talao/query_by_example/query_by_example.dart';

abstract class QRCodeEvent {}

class QRCodeEventHost extends QRCodeEvent {
  final String? data;

  QRCodeEventHost(this.data);
}

class QRCodeEventDeepLink extends QRCodeEvent {
  final String data;

  QRCodeEventDeepLink(this.data);
}

class QRCodeEventAccept extends QRCodeEvent {
  final Uri uri;

  QRCodeEventAccept(this.uri);
}

abstract class QRCodeState {}

class QRCodeStateWorking extends QRCodeState {}

class QRCodeStateHost extends QRCodeState {
  final Uri uri;

  QRCodeStateHost(this.uri);
}

class QRCodeStateSuccess extends QRCodeState {
  final Route route;

  QRCodeStateSuccess(this.route);
}

class QRCodeStateUnknown extends QRCodeState {}

class QRCodeStateMessage extends QRCodeState {
  final StateMessage message;

  QRCodeStateMessage(this.message);
}

class QRCodeBloc extends Bloc<QRCodeEvent, QRCodeState> {
  final Dio client;
  final ScanBloc scanBloc;
  final QueryByExampleCubit queryByExampleCubit;

  QRCodeBloc(
    this.client,
    this.scanBloc,
    this.queryByExampleCubit,
  ) : super(QRCodeStateWorking()){
    on<QRCodeEventHost>(_host);
    on<QRCodeEventAccept>(_accept);
    on<QRCodeEventDeepLink>(_deepLink);
  }

  @override
  Future<void> close() async {
    //cancel streams
    return super.close();
  }

  void _host(
    QRCodeEventHost event, Emitter<QRCodeState> emit,
  ) async {
    late final uri;

    try {
      final url = event.data;
      if (url == null) {
      emit(QRCodeStateMessage(
          StateMessage.error('This QRCode does not contain a valid message.')));
      } else {
        uri = Uri.parse(url);
      }
    } on FormatException catch (e) {
      print(e.message);

      emit(QRCodeStateMessage(
          StateMessage.error('This QRCode does not contain a valid message.')));
    }

    emit(QRCodeStateHost(uri));
  }

  void _deepLink(
    QRCodeEventDeepLink event, Emitter<QRCodeState> emit,
  ) async {
    late final uri;

    try {
      uri = Uri.parse(event.data);
    } on FormatException catch (e) {
      print(e.message);

      emit(QRCodeStateMessage(
          StateMessage.error('This url does not contain a valid message.')));
    }

    emit(QRCodeStateHost(uri));
  }

  void _accept(
    QRCodeEventAccept event, Emitter<QRCodeState> emit,
  ) async {
    final log = Logger('credible/qrcode/accept');

    late final data;

    try {
      final url = event.uri.toString();
      final response = await client.get(url);
      data =
          response.data is String ? jsonDecode(response.data) : response.data;
    } on DioError catch (e) {
      log.severe('An error occurred while connecting to the server.', e);

      emit(QRCodeStateMessage(StateMessage.error(
          'An error occurred while connecting to the server. '
          'Check the logs for more information.')));
    }

    scanBloc.add(ScanEventShowPreview(data));

    switch (data['type']) {
      case 'CredentialOffer':
        emit(QRCodeStateSuccess(CredentialsReceivePage.route(event.uri)));
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
              event.uri,
              challenge: data['challenge'],
              domain: data['domain'],
            ));
            emit(QRCodeStateSuccess(CredentialsPresentPage.route(
              resource: 'DID',
              yes: 'Accept',
              url: event.uri,
              onSubmit: (preview, context) {
                Navigator.of(context).pushReplacement(CredentialsList.route());
              },
            )));
          } else if (data['query'].first['type'] == 'QueryByExample') {
            emit(QRCodeStateSuccess(CredentialsPresentPage.route(
              resource: 'credential',
              url: event.uri,
              onSubmit: (preview, context) {
                Navigator.of(context).pushReplacement(
                    CredentialsPickPage.route(event.uri, preview));
              },
            )));
          } else {
            throw UnimplementedError('Unimplemented Query Type');
          }
        } else {
          emit(QRCodeStateSuccess(CredentialsPresentPage.route(
            resource: 'credential',
            url: event.uri,
            onSubmit: (preview, context) {
              Navigator.of(context).pushReplacement(
                  CredentialsPickPage.route(event.uri, preview));
            },
          )));
        }
        break;

      default:
        emit(QRCodeStateUnknown());
        break;
    }
  }
}
