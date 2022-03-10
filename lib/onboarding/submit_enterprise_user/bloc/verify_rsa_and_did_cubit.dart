import 'dart:convert';

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
    emit(const VerifyRSAAndDIDState.loading());
    final log = Logger('talao-wallet/onBoarding/VerifyRSAAndDIDCubit/verify');

    final resolvedDID = await DIDKitProvider.instance.resolveDID(did, '{}');
    final resolvedDIDJson = jsonDecode(resolvedDID);

    log.info('resolvedDIDJson: $resolvedDIDJson');
    final error = resolvedDIDJson['didResolutionMetadata']['error'];
    if (error == null) {
      //read RSA json file
      final rsaJson = jsonDecode(rsaFile.bytes.toString());
      final rsaKey = rsaJson['verificationMethod']['publicKeyJwk']['n'];

      // filter publicKeyJwk objects inside resolvedDIDJson json
      final publicKeyJwks = JsonPath(r'$..publicKeyJwk');
      final filteredPublicKeyJwks = publicKeyJwks
          .read(resolvedDID)
          .where((element) => element.value['kty'] == 'RSA')
          .toList();
      log.info('filtered: ${filteredPublicKeyJwks.length}');
      var verified = false;
      //start verifying RSA key
      for (var i = 0; i < filteredPublicKeyJwks.length; i++) {
        final publicKeyJwk = filteredPublicKeyJwks[i].value;
        if (publicKeyJwk['n'] == rsaKey) {
          verified = true;
          break;
        }
      }
      if (verified) {
        await SecureStorageProvider.instance
            .set(SecureStorageKeys.RSAKeyJson, jsonEncode(rsaJson));
        await SecureStorageProvider.instance.set(SecureStorageKeys.did, did);
        emit(const VerifyRSAAndDIDState.verified());
      } else {
        emit(const VerifyRSAAndDIDState.error(
            'RSA not matched with your DID key'));
      }
    } else {
      emit(VerifyRSAAndDIDState.error(error));
    }
  }
}
