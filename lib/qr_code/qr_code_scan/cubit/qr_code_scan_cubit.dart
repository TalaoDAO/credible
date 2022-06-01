import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:json_path/json_path.dart';
import 'package:talao/app/interop/jwt_decode/jwt_decode.dart';
import 'package:logging/logging.dart';
import 'package:talao/app/interop/network/network_client.dart';
import 'package:talao/app/shared/error_handler/error_handler.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:talao/credentials/pick/credential_manifest/view/credential_manifest_presentation_pick_page.dart';
import 'package:talao/qr_code/qr_code_scan/model/siopv2_param.dart';
import 'package:talao/credentials/credentials.dart';
import 'package:talao/deep_link/cubit/deep_link.dart';
import 'package:talao/query_by_example/query_by_example.dart';
import 'package:talao/scan/cubit/scan_message_string_state.dart';
import 'package:talao/scan/scan.dart';

part 'qr_code_scan_cubit.g.dart';

part 'qr_code_scan_state.dart';

class QRCodeScanCubit extends Cubit<QRCodeScanState> {
  final DioClient client;
  final DioClient requestClient;
  final ScanCubit scanCubit;
  final QueryByExampleCubit queryByExampleCubit;
  final DeepLinkCubit deepLinkCubit;
  final JWTDecode jwtDecode;

  QRCodeScanCubit({
    required this.client,
    required this.requestClient,
    required this.scanCubit,
    required this.queryByExampleCubit,
    required this.deepLinkCubit,
    required this.jwtDecode,
  }) : super(QRCodeScanStateWorking());

  @override
  Future<void> close() async {
    //cancel streams
    return super.close();
  }

  void emitWorkingState() {
    emit(QRCodeScanStateWorking(isDeepLink: state.isDeepLink));
  }

  void host({required String? url, required bool isDeepLink}) async {
    try {
      if (url == null) {
        emit(QRCodeScanStateMessage(
            isDeepLink: isDeepLink,
            message: StateMessage.error(
                message: ScanMessageStringState
                    .thisQRCodeDoseNotContainAValidMessage())));
      } else {
        var uri = Uri.parse(url);

        /// current QRCodeScanStateMessage may already be the QRCodeScanStateHost we want to emit and nothing will happen if that's the case.
        /// In order to avoid this, we emit QRCodeScanStateWorking which don't trigger any action.
        emit(QRCodeScanStateWorking(isDeepLink: isDeepLink));
        emit(QRCodeScanStateHost(isDeepLink: isDeepLink, uri: uri));
      }
    } on FormatException {
      emit(QRCodeScanStateMessage(
          isDeepLink: isDeepLink,
          message: StateMessage.error(
              message: ScanMessageStringState
                  .thisQRCodeDoseNotContainAValidMessage())));
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
                message: ScanMessageStringState
                    .thisUrlDoseNotContainAValidMessage())));
      }
    }
  }

  void accept({required Uri uri}) async {
    final log = Logger('talao-wallet/qrcode/accept');

    late final data;

    try {
      final response = await client.get(uri.toString());
      data = response is String ? jsonDecode(response) : response;

      scanCubit.emitScanStatePreview(preview: data);
      switch (data['type']) {
        case 'CredentialOffer':
          emit(QRCodeScanStateSuccess(
              isDeepLink: state.isDeepLink,
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
                  isDeepLink: state.isDeepLink,
                  route: CredentialsPresentPage.route(uri: uri)));
            } else {
              throw UnimplementedError('Unimplemented Query Type');
            }
          }

          if (data?['credential_manifest']?['presentation_definition'] !=
              null) {
            emit(QRCodeScanStateSuccess(
                isDeepLink: state.isDeepLink,
                route: CredentialManifestPickPage.route(
                  uri,
                  data,
                )));
          } else {
            emit(QRCodeScanStateSuccess(
                isDeepLink: state.isDeepLink,
                route: CredentialsPresentPage.route(uri: uri)));
          }
          break;

        default:
          emit(QRCodeScanStateUnknown(
              isDeepLink: state.isDeepLink, uri: state.uri!));
          break;
      }
    } catch (e) {
      log.severe('An error occurred while connecting to the server.', e);

      if (e is ErrorHandler) {
        emit(QRCodeScanStateMessage(
            isDeepLink: state.isDeepLink,
            message: StateMessage.error(
                message: ScanMessageStringState.anErrorOccurred(),
                errorHandler: e)));
      } else {
        emit(QRCodeScanStateMessage(
            isDeepLink: state.isDeepLink,
            message: StateMessage.error(
                message: ScanMessageStringState
                    .anErrorOccurredWhileConnectingToTheServer())));
      }
    }
  }

  bool isOpenIdUrl() {
    var condition = false;
    if (state.uri?.queryParameters['scope'] == 'openid') {
      condition = true;
    }
    return condition;
  }

  bool requestAttributeExists() {
    var condition = false;
    state.uri!.queryParameters.forEach((key, value) {
      if (key == 'request') {
        condition = true;
      }
    });
    return condition;
  }

  bool requestUriAttributeExists() {
    var condition = false;
    state.uri!.queryParameters.forEach((key, value) {
      if (key == 'request_uri') {
        condition = true;
      }
    });
    return condition;
  }

  Future<SIOPV2Param> getSIOPV2Parameters({required bool isDeepLink}) async {
    var nonce;
    var redirect_uri;
    var request_uri;
    var claims;
    var requestUriPayload;

    state.uri!.queryParameters.forEach((key, value) {
      if (key == 'nonce') {
        nonce = value;
      }
      if (key == 'redirect_uri') {
        redirect_uri = value;
      }
      if (key == 'claims') {
        claims = value;
      }
      if (key == 'request_uri') {
        request_uri = value;
      }
    });

    if (request_uri != null) {
      var encodedData = await fetchRequestUriPayload(url: request_uri);
      if (encodedData != null) {
        requestUriPayload = decoder(token: encodedData);
      }
    }
    return SIOPV2Param(
      claims: claims,
      nonce: nonce,
      redirect_uri: redirect_uri,
      request_uri: request_uri,
      requestUriPayload: requestUriPayload,
    );
  }

  Future<dynamic> fetchRequestUriPayload({required String url}) async {
    final log = Logger('talao-wallet/qrcode/fetchRequestUriPayload');
    late final data;

    try {
      final response = await requestClient.get(url);
      data = response.toString();
    } catch (e) {
      log.severe('An error occurred while connecting to the server.', e);
    }
    return data;
  }

  String decoder({required String token}) {
    final log = Logger('talao-wallet/qrcode/jwtDecode');
    late final data;

    try {
      final payload = jwtDecode.parseJwt(token);
      data = payload.toString();
    } catch (e) {
      log.severe('An error occurred while decoding.', e);
    }
    return data;
  }

  String getCredential(String claims) {
    final claimsJson = jsonDecode(claims);
    final fieldsPath = JsonPath(r'$..fields');
    var credentialField = fieldsPath
        .read(claimsJson)
        .first
        .value
        .where((e) =>
            e['path'].toString() == '[\$.credentialSubject.type]'.toString())
        .toList()
        .first;
    return credentialField['filter']['pattern'];
  }

  String getIssuer(String claims) {
    final claimsJson = jsonDecode(claims);
    final fieldsPath = JsonPath(r'$..fields');
    var issuerField = fieldsPath
        .read(claimsJson)
        .first
        .value
        .where((e) => e['path'].toString() == '[\$.issuer]'.toString())
        .toList()
        .first;
    return issuerField['filter']['pattern'];
  }

  void emitQRCodeScanStateUnknown() {
    emit(QRCodeScanStateUnknown(isDeepLink: state.isDeepLink, uri: state.uri!));
  }

  void emitQRCodeScanStateMessage({required ScanMessageStringState message}) {
    emit(QRCodeScanStateMessage(
        isDeepLink: state.isDeepLink,
        message: StateMessage.error(message: message)));
  }
}
