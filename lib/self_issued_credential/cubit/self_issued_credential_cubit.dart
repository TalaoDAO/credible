import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:json_path/json_path.dart';
import 'package:logging/logging.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/enum/revokation_status.dart';
import 'package:talao/app/shared/model/credential.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/model/display.dart';
import 'package:talao/self_issued_credential/models/self_issued.dart';
import 'package:talao/self_issued_credential/models/self_issued_credential.dart';
import 'package:talao/self_issued_credential/widget/sef_issued_credential_button.dart';
import 'package:talao/wallet/cubit/wallet_cubit.dart';
import 'package:uuid/uuid.dart';

part 'self_issued_credential_cubit.freezed.dart';

@freezed
class SelfIssuedCredentialState with _$SelfIssuedCredentialState {
  const factory SelfIssuedCredentialState.initial() = Initial;

  const factory SelfIssuedCredentialState.loading() = Loading;

  const factory SelfIssuedCredentialState.error(String message) = Error;

  const factory SelfIssuedCredentialState.warning(String message) = Warning;

  const factory SelfIssuedCredentialState.credentialCreated() =
      CredentialCreated;
}

class SelfIssuedCredentialCubit extends Cubit<SelfIssuedCredentialState> {
  final WalletCubit walletCubit;

  SelfIssuedCredentialCubit(this.walletCubit)
      : super(const SelfIssuedCredentialState.initial());

  Future<void> createSelfIssuedCredential(
      {required SelfIssuedCredentialDataModel
          selfIssuedCredentialDataModel}) async {
    final log = Logger('talao-wallet/sef_issued_credential/create');
    try {
      //show loading
      emit(const SelfIssuedCredentialState.loading());
      await Future.delayed(Duration(milliseconds: 500));

      final isEnterpriseUser = await SecureStorageProvider.instance
          .get(SecureStorageKeys.isEnterpriseUser);

      late final String key, verificationMethod;


      if (isEnterpriseUser == 'true') {
        final RSAJsonString = (await SecureStorageProvider.instance
            .get(SecureStorageKeys.RSAKeyJson)) as String;
        final RSAJson = jsonDecode(RSAJsonString);

        ///
        final publicKeyJwks = JsonPath(r'$..publicKeyJwk');
        final publicKeyJwk = publicKeyJwks
            .read(RSAJson)
            .where((element) => element.value['kty'] == 'RSA')
            .toList()
            .first
            .value;

        ///
        key = publicKeyJwk['n'];
        verificationMethod = publicKeyJwk['kid'];

      } else {
        key = (await SecureStorageProvider.instance.get(SecureStorageKeys.key))!;
        final didMethod = (await SecureStorageProvider.instance
            .get(SecureStorageKeys.DIDMethod))!;
        verificationMethod = await DIDKitProvider.instance
            .keyToVerificationMethod(didMethod, key);
      }

      final did =
          (await SecureStorageProvider.instance.get(SecureStorageKeys.did))!;

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
          address: selfIssuedCredentialDataModel.address,
          familyName: selfIssuedCredentialDataModel.familyName,
          givenName: selfIssuedCredentialDataModel.givenName,
          telephone: selfIssuedCredentialDataModel.telephone,
          email: selfIssuedCredentialDataModel.email,
          companyName: selfIssuedCredentialDataModel.companyName,
          companyWebsite: selfIssuedCredentialDataModel.companyWebsite,
          title: selfIssuedCredentialDataModel.jobTitle);

      final selfIssuedCredential = SelfIssuedCredential(
          id: id,
          issuer: did,
          issuanceDate: issuanceDate,
          credentialSubject: selfIssued);

      await Future.delayed(Duration(milliseconds: 500));
      final vc = await DIDKitProvider.instance.issueCredential(
          jsonEncode(selfIssuedCredential.toJson()), jsonEncode(options), key);
      final result = await DIDKitProvider.instance
          .verifyCredential(vc, jsonEncode(verifyOptions));
      final jsonVerification = jsonDecode(result);

      log.info('vc: $vc');
      log.info('verifyResult: ${jsonVerification.toString()}');

      if (jsonVerification['warnings'].isNotEmpty) {
        log.warning('credential verification return warnings',
            jsonVerification['warnings']);

        emit(SelfIssuedCredentialState.warning(
            'Credential verification returned some warnings. '
            'Check the logs for more information.'));
      }

      if (jsonVerification['errors'].isNotEmpty) {
        log.severe('failed to verify credential', jsonVerification['errors']);
        if (jsonVerification['errors'][0] != 'No applicable proof') {
          emit(SelfIssuedCredentialState.error('Failed to verify credential. '
              'Check the logs for more information.'));
        } else {
          await _recordCredential(vc);
        }
      } else {
        await _recordCredential(vc);
      }
    } catch (e, s) {
      print('e: $e,s: $s');
      log.severe('something went wrong', e, s);

      emit(SelfIssuedCredentialState.error(
          'Failed to create self issued credential. '
          'Check the logs for more information.'));
    }
  }

  Future<void> _recordCredential(String vc) async {
    await Future.delayed(Duration(milliseconds: 500));
    final jsonCredential = jsonDecode(vc);
    final id = 'urn:uuid:' + Uuid().v4();
    final credentialModel = CredentialModel(
      id: id,
      alias: '',
      image: 'image',
      data: jsonCredential,
      display: Display.emptyDisplay()..toJson(),
      shareLink: '',
      credentialPreview: Credential.fromJson(jsonCredential),
      revocationStatus: RevocationStatus.unknown,
    );
    await walletCubit.insertCredential(credentialModel);
    emit(const SelfIssuedCredentialState.credentialCreated());
  }
}
