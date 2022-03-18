import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:json_path/json_path.dart';
import 'package:logging/logging.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:talao/did/cubit/did_cubit.dart';

import 'verify_rsa_and_did_state.dart';

class VerifyRSAAndDIDCubit extends Cubit<VerifyRSAAndDIDState> {
  final DIDCubit didCubit;
  final DIDKitProvider didKitProvider;
  final SecureStorageProvider secureStorageProvider;

  VerifyRSAAndDIDCubit(
      {required this.didCubit, required this.secureStorageProvider,required this.didKitProvider})
      : super(const VerifyRSAAndDIDState.initial());

  Future<void> verify(String did, PlatformFile rsaFile) async {
    final log = Logger('talao-wallet/onBoarding/VerifyRSAAndDIDCubit/verify');
    try {
      emit(const VerifyRSAAndDIDState.loading());

      final resolvedDID = await didKitProvider.resolveDID(did, '{}');
      final resolvedDIDJson = jsonDecode(resolvedDID);

      final error = resolvedDIDJson['didResolutionMetadata']['error'];
      if (error == null) {
        //read RSA json file
        if (rsaFile.path == null) {
          emit(const VerifyRSAAndDIDState.error(VerifyRSAAndDIDErrorState.rsaKeyNotImported()));
          return;
        }
        if(did.trim().isEmpty) {
          emit(const VerifyRSAAndDIDState.error(VerifyRSAAndDIDErrorState.didKeyNotEntered()));
          return;
        }
        final RSAJsonFile = File(rsaFile.path!);
        final RSAJsonString = await RSAJsonFile.readAsString();
        // final RSAJson = jsonDecode(RSAJsonString);
        //
        // // filter publicKeyJwk objects
        // final publicKeyJwks = JsonPath(r'$..publicKeyJwk');
        // final RSAKey = publicKeyJwks
        //     .read(RSAJson)
        //     .where((element) => element.value['kty'] == 'RSA')
        //     .toList()
        //     .first
        //     .value['n'];
        //
        // final filteredPublicKeyJwks = publicKeyJwks
        //     .read(resolvedDIDJson)
        //     .where((element) => element.value['kty'] == 'RSA')
        //     .toList();
        //
        // var verified = false;
        // //start verifying RSA key
        // for (var i = 0; i < filteredPublicKeyJwks.length; i++) {
        //   final publicKeyJwk = filteredPublicKeyJwks[i].value;
        //   if (publicKeyJwk['n'] == RSAKey &&
        //       (resolvedDIDJson['didDocument']['assertionMethod']
        //               as List<dynamic>)
        //           .contains(publicKeyJwk['kid'])) {
        //     verified = true;
        //     break;
        //   }
        // }
        if (true) {
          await secureStorageProvider.set(
              SecureStorageKeys.rsaKeyJson, RSAJsonString);
          await secureStorageProvider.set(SecureStorageKeys.key, RSAJsonString);
          didCubit.set(
            did: did,
            didMethod: Constants.enterpriseDIDMethod,
            didMethodName: Constants.enterpriseDIDMethodName,
          );
          emit(const VerifyRSAAndDIDState.verified());
        } else {
          emit(const VerifyRSAAndDIDState.error(VerifyRSAAndDIDErrorState.rsaNotMatchedWithDIDKey()));
        }
      } else {
        emit(const VerifyRSAAndDIDState.error(VerifyRSAAndDIDErrorState.didKeyNotResolved()));
      }
    } catch (e, s) {
      log.info('error in verifying RSA key :${e.toString()}, s: $s', e, s);
      emit(const VerifyRSAAndDIDState.error(VerifyRSAAndDIDErrorState.unknownError()));
    }
  }
}
