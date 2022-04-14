import 'package:passbase_flutter/passbase_flutter.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/model/email_pass/email_pass.dart';

/// Give user email to KYC. When KYC is successful this email is used to send the over18 credential link to user.
void setKYCEmail(String email) {
  PassbaseSDK.prefillUserEmail = email;
  print(email);
}

/// Give user metadata to KYC. Currently we are just sending user DID.
Future<void> setKYCMetadat(walletCubit) async {
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
      print('AAA${firstEmailPassCredentialSubject.passbaseMetadata}AAA');
      PassbaseSDK.metaData = firstEmailPassCredentialSubject.passbaseMetadata;
    }
  }
}
