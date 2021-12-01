import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:talao/app/pages/credentials/blocs/scan.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

abstract class QRCodeEvent {}

class QRCodeEventHost extends QRCodeEvent {
  final String data;

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
  final String route;
  final Uri uri;
  final Map<String, dynamic>? data;

  QRCodeStateSuccess(this.route, this.uri, [this.data]);
}

class QRCodeStateUnknown extends QRCodeState {}

class QRCodeStateMessage extends QRCodeState {
  final StateMessage message;

  QRCodeStateMessage(this.message);
}

class QRCodeBloc extends Bloc<QRCodeEvent, QRCodeState> {
  final Dio client;
  final ScanBloc scanBloc;

  QRCodeBloc(
    this.client,
    this.scanBloc,
  ) : super(QRCodeStateWorking());

  @override
  Future<void> close() async {
    //cancel streams
    return super.close();
  }

  @override
  Stream<QRCodeState> mapEventToState(QRCodeEvent event) async* {
    if (event is QRCodeEventHost) {
      yield* _host(event);
    } else if (event is QRCodeEventAccept) {
      yield* _accept(event);
    } else if (event is QRCodeEventDeepLink) {
      yield* _deepLink(event);
    }
  }

  Stream<QRCodeState> _host(
    QRCodeEventHost event,
  ) async* {
    late final uri;

    try {
      uri = Uri.parse(event.data);
    } on FormatException catch (e) {
      print(e.message);

      yield QRCodeStateMessage(
          StateMessage.error('This QRCode does not contain a valid message.'));
    }

    yield QRCodeStateHost(uri);
  }

  Stream<QRCodeState> _deepLink(
    QRCodeEventDeepLink event,
  ) async* {
    late final uri;

    try {
      uri = Uri.parse(event.data);
    } on FormatException catch (e) {
      print(e.message);

      yield QRCodeStateMessage(
          StateMessage.error('This url does not contain a valid message.'));
    }

    yield QRCodeStateHost(uri);
  }

  Stream<QRCodeState> _accept(
    QRCodeEventAccept event,
  ) async* {
    final log = Logger('credible/qrcode/accept');

    late final data;

    try {
      final url = event.uri.toString();
      final response = await client.get(url);
      data =
          response.data is String ? jsonDecode(response.data) : response.data;
    } on DioError catch (e) {
      log.severe('An error occurred while connecting to the server.', e);

      yield QRCodeStateMessage(StateMessage.error(
          'An error occurred while connecting to the server. '
          'Check the logs for more information.'));
    }

    scanBloc.add(ScanEventShowPreview(data));

    switch (data['type']) {
      case 'CredentialOffer':
        yield QRCodeStateSuccess('/credentials/receive', event.uri);
        break;

      case 'VerifiablePresentationRequest':
        if (data['query'] != null) {

        yield QRCodeStateSuccess('/credentials/chapi-present', event.uri, data);
        } else {
          yield QRCodeStateSuccess('/credentials/present', event.uri);
        }
        break;

      default:
        yield QRCodeStateUnknown();
        break;
    }

    // yield QRCodeStateWorking();
  }
}
