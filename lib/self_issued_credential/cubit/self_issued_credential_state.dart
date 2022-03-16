import 'package:flutter/material.dart' show BuildContext;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:talao/l10n/l10n.dart';

part 'self_issued_credential_state.freezed.dart';

@freezed
class SelfIssuedCredentialState with _$SelfIssuedCredentialState {
  const factory SelfIssuedCredentialState.initial() = Initial;

  const factory SelfIssuedCredentialState.loading() = Loading;

  const factory SelfIssuedCredentialState.error(SelfIssuedCredentialErrorState errorState) = Error;

  const factory SelfIssuedCredentialState.credentialCreated() =
  CredentialCreated;
}

@freezed
class SelfIssuedCredentialErrorState with _$SelfIssuedCredentialErrorState {
  const SelfIssuedCredentialErrorState._();
  const factory SelfIssuedCredentialErrorState.failedToVerifySelfIssuedCredential() = FailedToVerifySelfIssuedCredential;
  const factory SelfIssuedCredentialErrorState.failedToCreateSelfIssuedCredential() = FailedToCreateSelfIssuedCredential;

  String getMessage(BuildContext context) {
    final localization = context.l10n;
    return when(
        failedToVerifySelfIssuedCredential: () => localization.failedToVerifySelfIssuedCredential,
        failedToCreateSelfIssuedCredential: () => localization.failedToCreateSelfIssuedCredential,
    );
  }
}