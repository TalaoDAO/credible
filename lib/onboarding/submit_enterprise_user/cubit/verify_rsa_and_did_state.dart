import 'package:flutter/material.dart' show BuildContext;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:talao/l10n/l10n.dart';

part 'verify_rsa_and_did_state.freezed.dart';

@freezed
class VerifyRSAAndDIDState with _$VerifyRSAAndDIDState {
  const factory VerifyRSAAndDIDState.initial() = Initial;

  const factory VerifyRSAAndDIDState.loading() = Loading;

  const factory VerifyRSAAndDIDState.verified() = Verified;

  const factory VerifyRSAAndDIDState.error(
      VerifyRSAAndDIDErrorState errorState) = Error;
}

@freezed
class VerifyRSAAndDIDErrorState with _$VerifyRSAAndDIDErrorState {
  const VerifyRSAAndDIDErrorState._();
  const factory VerifyRSAAndDIDErrorState.rsaKeyNotImported() =
      RSAKeyNotImported;

  const factory VerifyRSAAndDIDErrorState.didKeyNotEntered() = DIDKeyNotEntered;

  const factory VerifyRSAAndDIDErrorState.rsaNotMatchedWithDIDKey() =
      RSANotMatchedWithDIDKey;

  const factory VerifyRSAAndDIDErrorState.didKeyNotResolved() =
      DIDKeyNotResolved;

  const factory VerifyRSAAndDIDErrorState.unknownError() = UnknownError;

  String getMessage(BuildContext context) {
    final localization = context.l10n;
    return when(
        rsaKeyNotImported: () => localization.pleaseImportYourRSAKey,
        didKeyNotEntered: () => localization.pleaseEnterYourDIDKey,
        rsaNotMatchedWithDIDKey: () => localization.rsaNotMatchedWithDIDKey,
        didKeyNotResolved: () => localization.didKeyNotResolved,
        unknownError: () => localization.anUnknownErrorHappened);
  }
}
