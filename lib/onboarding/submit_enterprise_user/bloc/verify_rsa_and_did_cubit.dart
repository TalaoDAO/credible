import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_path/json_path.dart';
import 'package:logging/logging.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';

part 'verify_rsa_and_did_cubit.freezed.dart';

@freezed
class VerifyRSAAndDIDState with _$VerifyRSAAndDIDState {
  const factory VerifyRSAAndDIDState.initial() = Initial;

  const factory VerifyRSAAndDIDState.loading() = Loading;

  const factory VerifyRSAAndDIDState.verified() = Verified;

  const factory VerifyRSAAndDIDState.error(String message) = Error;
}

class VerifyRSAAndDIDCubit extends Cubit<VerifyRSAAndDIDState> {
  VerifyRSAAndDIDCubit() : super(const VerifyRSAAndDIDState.initial());

  Future<void> verify(String did, PlatformFile rsaFile) async {
    final log = Logger('talao-wallet/onBoarding/VerifyRSAAndDIDCubit/verify');
    try {
      emit(const VerifyRSAAndDIDState.loading());

      final resolvedDID = await DIDKitProvider.instance.resolveDID(did, '{}');
      final resolvedDIDJson = jsonDecode(resolvedDID);

      final error = resolvedDIDJson['didResolutionMetadata']['error'];
      if (error == null) {
        //read RSA json file
        if (rsaFile.path == null) {
          emit(const VerifyRSAAndDIDState.error('Please import your RSA key'));
          return;
        }
        final RSAJsonFile = File(rsaFile.path!);
        final RSAJsonString = await RSAJsonFile.readAsString();
        final RSAJson = jsonDecode(RSAJsonString);

        // filter publicKeyJwk objects
        final publicKeyJwks = JsonPath(r'$..publicKeyJwk');
        final RSAKey = publicKeyJwks
            .read(RSAJson)
            .where((element) => element.value['kty'] == 'RSA')
            .toList()
            .first
            .value['n'];

        final filteredPublicKeyJwks = publicKeyJwks
            .read(resolvedDIDJson)
            .where((element) => element.value['kty'] == 'RSA')
            .toList();

        var verified = false;
        //start verifying RSA key
        for (var i = 0; i < filteredPublicKeyJwks.length; i++) {
          final publicKeyJwk = filteredPublicKeyJwks[i].value;
          if (publicKeyJwk['n'] == RSAKey &&
              (resolvedDIDJson['didDocument']['assertionMethod']
                      as List<dynamic>)
                  .contains(publicKeyJwk['kid'])) {
            verified = true;
            break;
          }
        }
        if (verified) {
          await SecureStorageProvider.instance
              .set(SecureStorageKeys.RSAKeyJson, jsonEncode(RSAJson));
          await SecureStorageProvider.instance
              .set(SecureStorageKeys.key, RSAKey);
          await SecureStorageProvider.instance.set(SecureStorageKeys.did, did);
          emit(const VerifyRSAAndDIDState.verified());
        } else {
          emit(const VerifyRSAAndDIDState.error(
              'RSA not matched with your DID key'));
        }
      } else {
        emit(VerifyRSAAndDIDState.error(error));
      }
    } catch (e, s) {
      log.info('error in verifying RSA key :${e.toString()}, s: $s', e, s);
      //TODO translate message
      emit(const VerifyRSAAndDIDState.error(
          'Some error happened when verifying'));
    }
  }
}
