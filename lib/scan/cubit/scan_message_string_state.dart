import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:talao/l10n/l10n.dart';

part 'scan_message_string_state.freezed.dart';

@freezed
class ScanMessageStringState with _$ScanMessageStringState {
  const ScanMessageStringState._();

  const factory ScanMessageStringState.credentialVerificationReturnWarning() =
      CredentialVerificationReturnWarning;

  const factory ScanMessageStringState.failedToVerifyCredential() =
      FailedToVerifyCredential;

  const factory ScanMessageStringState.anErrorOccurred() = AnErrorOccurred;

  const factory ScanMessageStringState.somethingsWentWrongTryAgainLater() =
      SomethingsWentWrongTryAgainLater;

  const factory ScanMessageStringState.successfullyPresentedYourCredential() =
      SuccessfullyPresentedYourCredential;

  const factory ScanMessageStringState.successfullyPresentedYourDID() =
      SuccessfullyPresentedYourDID;

  const factory ScanMessageStringState.thisQRCodeDoseNotContainAValidMessage() =
      ThisQRCodeDoseNotContainAValidMessage;

  const factory ScanMessageStringState.thisUrlDoseNotContainAValidMessage() =
      ThisUrlDoseNotContainAValidMessage;

  const factory ScanMessageStringState.anErrorOccurredWhileConnectingToTheServer() =
      AnErrorOccurredWhileConnectingToTheServer;

  const factory ScanMessageStringState.credentialDetailDeleteSuccessMessage() =
      CredentialDetailDeleteSuccessMessage;

  const factory ScanMessageStringState.errorGeneratingKey() =
      ErrorGeneratingKey;

  const factory ScanMessageStringState.failedToSaveMnemonicPleaseTryAgain() =
      FailedToSaveMnemonicPleaseTryAgain;

  const factory ScanMessageStringState.failedToLoadProfile() =
      FailedToLoadProfile;

  const factory ScanMessageStringState.failedToSaveProfile() =
      FailedToSaveProfile;

  const factory ScanMessageStringState.failedToLoadDID() = FailedToLoadDID;

  const factory ScanMessageStringState.scanRefuseHost() = ScanRefuseHost;

  String getMessage(BuildContext context) {
    final localization = context.l10n;
    return when(
        credentialVerificationReturnWarning: () =>
            localization.credentialVerificationReturnWarning,
        failedToVerifyCredential: () => localization.failedToVerifyCredential,
        anErrorOccurred: () => localization.anUnknownErrorHappened,
        somethingsWentWrongTryAgainLater: () =>
            localization.somethingsWentWrongTryAgainLater,
        successfullyPresentedYourCredential: () =>
            localization.successfullyPresentedYourCredential,
        successfullyPresentedYourDID: () =>
            localization.successfullyPresentedYourDID,
        thisQRCodeDoseNotContainAValidMessage: () =>
            localization.thisQRCodeDoseNotContainAValidMessage,
        thisUrlDoseNotContainAValidMessage: () =>
            localization.thisUrlDoseNotContainAValidMessage,
        anErrorOccurredWhileConnectingToTheServer: () =>
            localization.anErrorOccurredWhileConnectingToTheServer,
        credentialDetailDeleteSuccessMessage: () =>
            localization.credentialDetailDeleteSuccessMessage,
        errorGeneratingKey: () => localization.errorGeneratingKey,
        failedToSaveMnemonicPleaseTryAgain: () =>
            localization.failedToSaveMnemonicPleaseTryAgain,
        failedToLoadProfile: () => localization.failedToLoadProfile,
        failedToSaveProfile: () => localization.failedToSaveProfile,
        failedToLoadDID: () => localization.failedToLoadDID,
        scanRefuseHost: () => localization.scanRefuseHost);
  }
}
