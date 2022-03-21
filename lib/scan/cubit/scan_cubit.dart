import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:jose/jose.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/interop/network/network_client.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/error_handler/error_handler.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:talao/qr_code/qr_code_scan/model/siopv2_param.dart';
import 'package:talao/scan/cubit/scan_message_string_state.dart';
import 'package:talao/wallet/wallet.dart';
import 'package:uuid/uuid.dart';

part 'scan_cubit.g.dart';

part 'scan_state.dart';

class ScanCubit extends Cubit<ScanState> {
  final DioClient client;
  final WalletCubit walletCubit;
  final DIDKitProvider didKitProvider;
  final SecureStorageProvider secureStorageProvider;

  ScanCubit({
    required this.client,
    required this.walletCubit,
    required this.didKitProvider,
    required this.secureStorageProvider,
  }) : super(ScanStateIdle());

  void emitScanStatePreview({Map<String, dynamic>? preview}) {
    emit(ScanStatePreview(preview: preview));
  }

  void credentialOffer(
      {required String url,
      required CredentialModel credentialModel,
      required String keyId}) async {
    final log = Logger('talao-wallet/scan/credential-offer');

    try {
      final did = (await secureStorageProvider.get(SecureStorageKeys.did))!;

      final credential = await client.post(
        url,
        data: FormData.fromMap(<String, dynamic>{'subject_id': did}),
      );

      final jsonCredential =
          credential is String ? jsonDecode(credential) : credential;

      final vcStr = jsonEncode(jsonCredential);
      final optStr = jsonEncode({'proofPurpose': 'assertionMethod'});
      final verification = await didKitProvider.verifyCredential(vcStr, optStr);

      print('[credible/credential-offer/verify/vc] $vcStr');
      print('[credible/credential-offer/verify/options] $optStr');
      print('[credible/credential-offer/verify/result] $verification');

      final jsonVerification = jsonDecode(verification);

      if (jsonVerification['warnings'].isNotEmpty) {
        log.warning('credential verification return warnings',
            jsonVerification['warnings']);

        emit(ScanStateMessage(
            message: StateMessage.warning(
                message: ScanMessageStringState
                    .credentialVerificationReturnWarning())));
      }

      if (jsonVerification['errors'].isNotEmpty) {
        log.severe('failed to verify credential', jsonVerification['errors']);
        if (jsonVerification['errors'][0] != 'No applicable proof') {
          emit(ScanStateMessage(
              message: StateMessage.error(
                  message: ScanMessageStringState.failedToVerifyCredential())));
          return emit(ScanStateIdle());
        }
      }

      await walletCubit.insertCredential(CredentialModel.copyWithData(
          oldCredentialModel: credentialModel, newData: jsonCredential));

      emit(ScanStateSuccess());
    } catch (e) {
      log.severe('something went wrong', e);
      if (e is ErrorHandler) {
        emit(ScanStateMessage(
            message: StateMessage.error(
                message: ScanMessageStringState.anErrorOccurred(),
                errorHandler: e)));
      } else {
        emit(ScanStateMessage(
            message: StateMessage.error(
                message: ScanMessageStringState
                    .somethingsWentWrongTryAgainLater())));
      }
      emit(ScanStateIdle());
    }
  }

  void verifiablePresentationRequest(
      {required String url,
      required String keyId,
      required List<CredentialModel> credentials,
      required String challenge,
      required String domain}) async {
    final log = Logger('talao-wallet/scan/verifiable-presentation-request');

    try {
      final key = (await secureStorageProvider.get(keyId))!;
      final did = await secureStorageProvider.get(SecureStorageKeys.did);
      final verificationMethod =
          await secureStorageProvider.get(SecureStorageKeys.verificationMethod);

      final presentationId = 'urn:uuid:' + Uuid().v4();
      final presentation = await didKitProvider.issuePresentation(
        jsonEncode({
          '@context': ['https://www.w3.org/2018/credentials/v1'],
          'type': ['VerifiablePresentation'],
          'id': presentationId,
          'holder': did,
          'verifiableCredential': credentials.length == 1
              ? credentials.first.data
              : credentials.map((c) => c.data).toList(),
        }),
        jsonEncode({
          'verificationMethod': verificationMethod,
          'proofPurpose': 'authentication',
          'challenge': challenge,
          'domain': domain,
        }),
        key,
      );

      await client.post(
        url.toString(),
        data: FormData.fromMap(<String, dynamic>{
          'presentation': presentation,
        }),
      );

      emit(ScanStateMessage(
          message: StateMessage.success(
              message: ScanMessageStringState
                  .successfullyPresentedYourCredential())));

      emit(ScanStateSuccess());
    } catch (e) {
      log.severe('something went wrong', e);
      if (e is ErrorHandler) {
        emit(ScanStateMessage(
            message: StateMessage.error(
                message: ScanMessageStringState.anErrorOccurred(),
                errorHandler: e)));
      } else {
        emit(ScanStateMessage(
            message: StateMessage.error(
                message: ScanMessageStringState
                    .somethingsWentWrongTryAgainLater())));
      }
    }
  }

  //
  void storeCHAPI(
      {required Map<String, dynamic> data,
      required void Function(String) done}) async {
    final log = Logger('talao-wallet/scan/chapi-store');

    try {
      late final type;

      if (data['type'] is List<dynamic>) {
        type = data['type'].first;
      } else {
        type = data['type'];
      }

      late final vc;

      switch (type) {
        case 'VerifiablePresentation':
          vc = data['verifiableCredential'];
          break;

        case 'VerifiableCredential':
          vc = data;
          break;

        default:
          throw UnimplementedError('Unsupported dataType: $type');
      }

      final vcStr = jsonEncode(vc);
      final optStr = jsonEncode({'proofPurpose': 'assertionMethod'});
      final verification = await didKitProvider.verifyCredential(vcStr, optStr);

      print('[credible/chapi-store/verify/vc] $vcStr');
      print('[credible/chapi-store/verify/options] $optStr');
      print('[credible/chapi-store/verify/result] $verification');

      final jsonVerification = jsonDecode(verification);

      if (jsonVerification['warnings'].isNotEmpty) {
        log.warning('credential verification return warnings',
            jsonVerification['warnings']);

        emit(ScanStateMessage(
            message: StateMessage.warning(
                message: ScanMessageStringState
                    .credentialVerificationReturnWarning())));
      }

      if (jsonVerification['errors'].isNotEmpty) {
        log.severe('failed to verify credential', jsonVerification['errors']);

        // done(jsonEncode(jsonVerification['errors']));

        emit(ScanStateMessage(
            message: StateMessage.error(
                message: ScanMessageStringState.failedToVerifyCredential())));
      }
      await walletCubit.insertCredential(vc);

      done(vcStr);

      // emit(ScanStateMessage(StateMessage.success(
      //     'A new credential has been successfully added!')));
    } catch (e) {
      log.severe('something went wrong', e);

      emit(ScanStateMessage(
          message: StateMessage.error(
              message:
                  ScanMessageStringState.somethingsWentWrongTryAgainLater())));
    }

    emit(ScanStateSuccess());
  }

  void getDIDAuthCHAPI(
      {required Uri uri,
      required String keyId,
      required void Function(String) done,
      required String challenge,
      required String domain}) async {
    final log = Logger('talao-wallet/scan/chapi-get-didauth');

    try {
      final key = (await secureStorageProvider.get(keyId))!;
      final did = await secureStorageProvider.get(SecureStorageKeys.did);
      final verificationMethod =
          await secureStorageProvider.get(SecureStorageKeys.verificationMethod);

      if (did != null) {
        final presentation = await didKitProvider.DIDAuth(
          did,
          jsonEncode({
            'verificationMethod': verificationMethod,
            'proofPurpose': 'authentication',
            'challenge': challenge,
            'domain': domain,
          }),
          key,
        );
        final credential = await client.post(
          uri.toString(),
          data: FormData.fromMap(<String, dynamic>{
            'presentation': presentation,
          }),
        );
        if (credential == 'ok') {
          done(presentation);

          emit(ScanStateMessage(
              message: StateMessage.success(
                  message:
                      ScanMessageStringState.successfullyPresentedYourDID())));

          emit(ScanStateSuccess());
        } else {
          emit(ScanStateMessage(
              message: StateMessage.error(
                  message: ScanMessageStringState
                      .somethingsWentWrongTryAgainLater())));
        }
      } else {
        throw Exception('DID is not set. It is required to present DIDAuth');
      }
    } catch (e) {
      log.severe('something went wrong', e);
      if (e is ErrorHandler) {
        emit(ScanStateMessage(
            message: StateMessage.error(
                message: ScanMessageStringState.anErrorOccurred(),
                errorHandler: e)));
      } else {
        emit(ScanStateMessage(
            message: StateMessage.error(
                message: ScanMessageStringState
                    .somethingsWentWrongTryAgainLater())));
      }
    }
  }

  void presentCredentialToSiopV2Request(
      {required credential, required sIOPV2Param}) async {
    final log =
        Logger('talao-wallet/scan/present-credential-to-siop-v2-request');

    try {
      final vpToken = await createVpToken(
          credential: credential, challenge: sIOPV2Param.nonce);
      final idToken = await createIdToken(nonce: sIOPV2Param.nonce);
// prepare the post request
// Content-Type: application/x-www-form-urlencoded
// data =
// id_token=encoded_jwt&vp_token=verifiable_presentation
// There is a stackoverflow question about How to post x-www-form-urlencoded in Flutter
// execute the request
// Request is sent to redirect_uri.
      client
          .changeHeaders({'Content-Type': 'application/x-www-form-urlencoded'});
      final result = await client.post(
        sIOPV2Param.redirect_uri,
        data: FormData.fromMap(<String, dynamic>{
          'vp_token': vpToken,
          'id_token': idToken,
        }),
      );

      client.changeHeaders({'Content-Type': 'application/json; charset=UTF-8'});

      if (result == 'ok') {
        emit(ScanStateMessage(
            message: StateMessage.success(
                message:
                    ScanMessageStringState.successfullyPresentedYourDID())));

        emit(ScanStateSuccess());
      } else {
        emit(ScanStateMessage(
            message: StateMessage.error(
                message: ScanMessageStringState
                    .somethingsWentWrongTryAgainLater())));
      }
    } catch (e) {
      log.severe('something went wrong', e);
      if (e is ErrorHandler) {
        emit(ScanStateMessage(
            message: StateMessage.error(
                message: ScanMessageStringState.anErrorOccurred(),
                errorHandler: e)));
      } else {
        emit(ScanStateMessage(
            message: StateMessage.error(
                message: ScanMessageStringState
                    .somethingsWentWrongTryAgainLater())));
      }
    }
  }

  //
  void getQueryByExampleCHAPI({
    required String keyId,
    required List<CredentialModel> credentials,
    required String? challenge,
    required String? domain,
    required void Function(String) done,
    required Uri uri,
  }) async {
    final log = Logger('talao-wallet/scan/chapi-get-querybyexample');

    try {
      final key = (await secureStorageProvider.get(keyId))!;
      final did = await secureStorageProvider.get(SecureStorageKeys.did);
      final verificationMethod =
          await secureStorageProvider.get(SecureStorageKeys.verificationMethod);

      final presentationId = 'urn:uuid:' + Uuid().v4();
      final presentation = await didKitProvider.issuePresentation(
        jsonEncode({
          '@context': ['https://www.w3.org/2018/credentials/v1'],
          'type': ['VerifiablePresentation'],
          'id': presentationId,
          'holder': did,
          'verifiableCredential': credentials.length == 1
              ? credentials.first.toJson()
              : credentials.map((c) => c.toJson()).toList(),
        }),
        jsonEncode({
          'verificationMethod': verificationMethod,
          'proofPurpose': 'authentication',
          'challenge': challenge,
          'domain': domain,
        }),
        key,
      );

      done(presentation);

      emit(ScanStateMessage(
          message: StateMessage.success(
              message: ScanMessageStringState
                  .successfullyPresentedYourCredential())));
    } catch (e) {
      log.severe('something went wrong', e);

      emit(ScanStateMessage(
          message: StateMessage.error(
              message:
                  ScanMessageStringState.somethingsWentWrongTryAgainLater())));
    }

    emit(ScanStateSuccess());
  }

  //
  void storeQueryByExampleCHAPI(
      {required Map<String, dynamic> data, required Uri uri}) async {
    emit(ScanStateStoreQueryByExample(data: data, uri: uri));
  }

  void askPermissionDIDAuthCHAPI(
      {required String keyId,
      String? challenge,
      String? domain,
      required Uri uri,
      required void Function(String) done}) async {
    emit(ScanStateAskPermissionDIDAuth(
        keyId: keyId,
        done: done,
        uri: uri,
        challenge: challenge,
        domain: domain));
  }

  void pickCredentialToPresentToSIOPV2Request(
      {credentials, sIOPV2Param}) async {
    emit(ScanStateStoreSIOPV2(
        credentials: credentials, sIOPV2Param: sIOPV2Param));
  }

  Future<String> createVpToken({challenge, credential}) async {
    final key = await secureStorageProvider.get(SecureStorageKeys.key);
    final did = await secureStorageProvider.get(SecureStorageKeys.did);
    final options = jsonEncode({
      'verificationMethod':
          await secureStorageProvider.get(SecureStorageKeys.verificationMethod),
      'proofPurpose': 'authentication',
      'challenge': challenge
    });
    final presentationId = 'urn:uuid:' + Uuid().v4();
    final vpToken = await DIDKitProvider.instance.issuePresentation(
        jsonEncode({
          '@context': ['https://www.w3.org/2018/credentials/v1'],
          'type': ['VerifiablePresentation'],
          'id': presentationId,
          'holder': did,
          'verifiableCredential': credential.data,
        }),
        options,
        key!);
    return vpToken;
  }

  Future<String> createIdToken({nonce}) async {
    final key = await secureStorageProvider.get(SecureStorageKeys.key);
    final did = await secureStorageProvider.get(SecureStorageKeys.did);

    final timeStamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    var claims = JsonWebTokenClaims.fromJson({
      'exp': timeStamp + 600,
      'iat': timeStamp,
      'i_am_siop': true,
      'sub': did,
      'nonce': nonce,
    });

    // create a builder, decoding the JWT in a JWS, so using a
    // JsonWebSignatureBuilder
    var builder = JsonWebSignatureBuilder();

    // set the content
    builder.jsonContent = claims.toJson();

    // add a key to sign, can only add one for JWT
    builder.addRecipient(JsonWebKey.fromJson(jsonDecode(key!)),
        algorithm: 'RS256');

    // build the jws
    var jws = builder.build();

    // output the compact serialization
    print('jwt compact serialization: ${jws.toCompactSerialization()}');

    return jws.toCompactSerialization();
  }
}
