import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/interop/network/network_client.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/wallet/wallet.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:talao/app/shared/error_handler/error_handler.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

part 'scan_state.dart';

part 'scan_cubit.g.dart';

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
      final key = (await secureStorageProvider.get(keyId))!;
      final did = didKitProvider.keyToDID(Constants.defaultDIDMethod, key);

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
                'Credential verification returned some warnings. '
                'Check the logs for more information.')));
      }

      if (jsonVerification['errors'].isNotEmpty) {
        log.severe('failed to verify credential', jsonVerification['errors']);
        if (jsonVerification['errors'][0] != 'No applicable proof') {
          emit(ScanStateMessage(
              message: StateMessage.error('Failed to verify credential. '
                  'Check the logs for more information.')));
        }
      }

      await walletCubit.insertCredential(CredentialModel.copyWithData(
          oldCredentialModel: credentialModel, newData: jsonCredential));

      // emit(ScanStateMessage(StateMessage.success(
      //     'A new credential has been successfully added!')));

      emit(ScanStateSuccess());
    } catch (e) {
      log.severe('something went wrong', e);
      if (e is ErrorHandler) {
        emit(ScanStateMessage(
            message: StateMessage.error('An error occurred', errorHandler: e)));
      } else {
        emit(ScanStateMessage(
            message: StateMessage.error(
                'Something went wrong, please try again later. '
                'Check the logs for more information.')));
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
      final did = didKitProvider.keyToDID(Constants.defaultDIDMethod, key);
      final verificationMethod = await didKitProvider.keyToVerificationMethod(
          Constants.defaultDIDMethod, key);

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
          message:
              StateMessage.success('Successfully presented your credential!')));

      emit(ScanStateSuccess());
    } catch (e) {
      log.severe('something went wrong', e);
      if (e is ErrorHandler) {
        emit(ScanStateMessage(
            message: StateMessage.error('An error occurred', errorHandler: e)));
      } else {
        emit(ScanStateMessage(
            message: StateMessage.error(
                'Something went wrong, please try again later. '
                'Check the logs for more information.')));
      }
    }
  }

  //
  void store(
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
                'Credential verification returned some warnings. '
                'Check the logs for more information.')));
      }

      if (jsonVerification['errors'].isNotEmpty) {
        log.severe('failed to verify credential', jsonVerification['errors']);

        // done(jsonEncode(jsonVerification['errors']));

        emit(ScanStateMessage(
            message: StateMessage.error('Failed to verify credential. '
                'Check the logs for more information.')));
      }
      await walletCubit.insertCredential(vc);

      done(vcStr);

      // emit(ScanStateMessage(StateMessage.success(
      //     'A new credential has been successfully added!')));
    } catch (e) {
      log.severe('something went wrong', e);

      emit(ScanStateMessage(
          message: StateMessage.error(
              'Something went wrong, please try again later. '
              'Check the logs for more information.')));
    }

    emit(ScanStateSuccess());
  }

  void getDIDAuth(
      {required Uri uri,
      required String keyId,
      required void Function(String) done,
      required String challenge,
      required String domain}) async {
    final log = Logger('talao-wallet/scan/chapi-get-didauth');

    try {
      final key = (await secureStorageProvider.get(keyId))!;
      final did = didKitProvider.keyToDID(Constants.defaultDIDMethod, key);
      final verificationMethod = await didKitProvider.keyToVerificationMethod(
          Constants.defaultDIDMethod, key);

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
            message: StateMessage.success('Successfully presented your DID!')));

        emit(ScanStateSuccess());
      } else {
        emit(ScanStateMessage(
            message: StateMessage.error(
                'Something went wrong, please try again later.')));
      }
    } catch (e) {
      log.severe('something went wrong', e);
      if (e is ErrorHandler) {
        emit(ScanStateMessage(
            message: StateMessage.error('An error occurred', errorHandler: e)));
      } else {
        emit(ScanStateMessage(
            message: StateMessage.error(
                'Something went wrong, please try again later. ')));
      }
    }

    emit(ScanStateSuccess());
  }

  //
  void getQueryByExample({
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
      final did = didKitProvider.keyToDID(Constants.defaultDIDMethod, key);
      final verificationMethod = await didKitProvider.keyToVerificationMethod(
          Constants.defaultDIDMethod, key);

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
              'Successfully presented your credential(s)!')));
    } catch (e) {
      log.severe('something went wrong', e);

      emit(ScanStateMessage(
          message: StateMessage.error(
              'Something went wrong, please try again later. '
              'Check the logs for more information.')));
    }

    emit(ScanStateSuccess());
  }

  //
  void storeQueryByExample(
      {required Map<String, dynamic> data, required Uri uri}) async {
    emit(ScanStateStoreQueryByExample(data: data, uri: uri));
  }

  void askPermissionDIDAuth(
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
}
