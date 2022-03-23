import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/enum/revokation_status.dart';
import 'package:talao/app/shared/model/credential.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/model/display.dart';
import 'package:talao/did/cubit/did_cubit.dart';
import 'package:talao/self_issued_credential/models/self_issued.dart';
import 'package:talao/self_issued_credential/models/self_issued_credential.dart';
import 'package:talao/wallet/cubit/wallet_cubit.dart';
import 'package:uuid/uuid.dart';

import '../view/models/self_issued_credential_model.dart';
import 'self_issued_credential_state.dart';

class SelfIssuedCredentialCubit extends Cubit<SelfIssuedCredentialState> {
  final WalletCubit walletCubit;
  final DIDCubit didCubit;
  final SecureStorageProvider secureStorageProvider;
  final DIDKitProvider didKitProvider;

  SelfIssuedCredentialCubit(
      {required this.walletCubit,
      required this.secureStorageProvider,
      required this.didCubit,
      required this.didKitProvider})
      : super(const SelfIssuedCredentialState.initial());

  Future<void> createSelfIssuedCredential(
      {required SelfIssuedCredentialDataModel
          selfIssuedCredentialDataModel}) async {
    final log = Logger('talao-wallet/sef_issued_credential/create');
    try {
      //show loading
      emit(const SelfIssuedCredentialState.loading());
      await Future.delayed(Duration(milliseconds: 500));

      final key = (await secureStorageProvider.get(SecureStorageKeys.key))!;
      final verificationMethod =
          await secureStorageProvider.get(SecureStorageKeys.verificationMethod);

      final did = didCubit.state.did!;

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
          workFor: selfIssuedCredentialDataModel.companyName,
          companyWebsite: selfIssuedCredentialDataModel.companyWebsite,
          jobTitle: selfIssuedCredentialDataModel.jobTitle);

      final selfIssuedCredential = SelfIssuedCredential(
          id: id,
          issuer: did,
          issuanceDate: issuanceDate,
          credentialSubject: selfIssued);

      await Future.delayed(Duration(milliseconds: 500));
      final vc = await didKitProvider.issueCredential(
          jsonEncode(selfIssuedCredential.toJson()), jsonEncode(options), key);
      final result =
          await didKitProvider.verifyCredential(vc, jsonEncode(verifyOptions));
      final jsonVerification = jsonDecode(result);

      log.info('vc: $vc');
      log.info('verifyResult: ${jsonVerification.toString()}');

      if (jsonVerification['warnings'].isNotEmpty) {
        log.warning('credential verification return warnings',
            jsonVerification['warnings']);
      }

      if (jsonVerification['errors'].isNotEmpty) {
        log.severe('failed to verify credential', jsonVerification['errors']);
        if (jsonVerification['errors'][0] != 'No applicable proof') {
          emit(const SelfIssuedCredentialState.error(
              SelfIssuedCredentialErrorState
                  .failedToVerifySelfIssuedCredential()));
        } else {
          await _recordCredential(vc);
        }
      } else {
        await _recordCredential(vc);
      }
    } catch (e, s) {
      print('e: $e,s: $s');
      log.severe('something went wrong', e, s);

      emit(const SelfIssuedCredentialState.error(
          SelfIssuedCredentialErrorState.failedToCreateSelfIssuedCredential()));
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
