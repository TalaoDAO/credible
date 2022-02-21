import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/self_issued_credential/models/self_issued.dart';
import 'package:talao/self_issued_credential/models/self_issued_credential.dart';
import 'package:uuid/uuid.dart';

part 'self_issued_credential.freezed.dart';

@freezed
class SelfIssuedCredentialState with _$SelfIssuedCredentialState {
  const factory SelfIssuedCredentialState.initial() = Initial;

  const factory SelfIssuedCredentialState.loading() = Loading;

  const factory SelfIssuedCredentialState.error(String message) = Error;

  const factory SelfIssuedCredentialState.credentialCreated() =
      CredentialCreated;
}

class SelfIssuedCredentialCubit extends Cubit<SelfIssuedCredentialState> {
  SelfIssuedCredentialCubit()
      : super(const SelfIssuedCredentialState.initial());

  void createSelfIssuedCredential(
      {required String givenName,
      required String familyName,
      required String telephone,
      required String email,
      required String address}) async {
    final log = Logger('talao-wallet/sef_issued_credential/create');
    try {
      //show loading
      emit(const SelfIssuedCredentialState.loading());

      final key = (await SecureStorageProvider.instance.get('key'))!;
      final did = DIDKitProvider.instance.keyToDID('key', key);
      final verificationMethod =
          await DIDKitProvider.instance.keyToVerificationMethod('key', key);
      final options = {
        'proofPurpose': 'assertionMethod',
        'verificationMethod': verificationMethod
      };
      final verifyOptions = {'proofPurpose': 'assertionMethod'};
      final id = 'urn:uuid:' + Uuid().v4();
      final formatter = DateFormat('yyyy-MM-ddTHH:mm:ss');
      final issuanceDate = formatter.format(DateTime.now()) + 'Z';

      final selfIssued = SelfIssued(
          id: did,
          address: address,
          familyName: familyName,
          givenName: givenName,
          telephone: telephone,
          email: email);

      final selfIssuedCredential = SelfIssuedCredential(
          id: id,
          issuer: did,
          issuanceDate: issuanceDate,
          credentialSubject: selfIssued);

      final verifyResult = await _createCredential(
          credential: selfIssuedCredential.toJson(),
          options: options,
          verifyOptions: verifyOptions,
          key: key);

      log.info('verifyResult:' + verifyResult);

      emit(const SelfIssuedCredentialState.credentialCreated());
    } catch (e, s) {
      print('e: $e,s: $s');
      log.severe('something went wrong', e, s);

      emit(SelfIssuedCredentialState.error(
          'Failed to create self issued credential. '
          'Check the logs for more information.'));
    }
  }

  Future<dynamic> _createCredential(
      {required Map credential,
      required Map options,
      required Map verifyOptions,
      required String key}) async {
    final vc = await DIDKitProvider.instance
        .issueCredential(jsonEncode(credential), jsonEncode(options), key);
    final result = await DIDKitProvider.instance
        .verifyCredential(vc, jsonEncode(verifyOptions));
    final verifyResult = jsonDecode(result);
    return verifyResult;
  }
}
