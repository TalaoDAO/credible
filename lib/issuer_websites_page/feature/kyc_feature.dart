import 'package:passbase_flutter/passbase_flutter.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/model/email_pass/email_pass.dart';

/// Give user metadata to KYC. Currently we are just sending user DID.
bool setKYCMetadat(walletCubit) {
  var selectedCredentials = <CredentialModel>[];
  walletCubit.state.credentials.forEach((CredentialModel credentialModel) {
    final credentialTypeList = credentialModel.credentialPreview.type;

    ///credential and issuer provided in claims
    if (credentialTypeList.contains('EmailPass')) {
      selectedCredentials.add(credentialModel);
    }
  });
  if (selectedCredentials.isNotEmpty) {
    final firstEmailPassCredentialSubject =
        selectedCredentials.first.credentialPreview.credentialSubject;
    if (firstEmailPassCredentialSubject is EmailPass) {
      /// Give user email from first EmailPass to KYC. When KYC is successful this email is used to send the over18 credential link to user.
      PassbaseSDK.prefillUserEmail = firstEmailPassCredentialSubject.email;
      PassbaseSDK.metaData = firstEmailPassCredentialSubject.passbaseMetadata;
      return true;
    }
  }
  return false;
}
