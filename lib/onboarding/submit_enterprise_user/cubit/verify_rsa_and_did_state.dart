import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_rsa_and_did_state.freezed.dart';

@freezed
class VerifyRSAAndDIDState with _$VerifyRSAAndDIDState {
  const factory VerifyRSAAndDIDState.initial() = Initial;

  const factory VerifyRSAAndDIDState.loading() = Loading;

  const factory VerifyRSAAndDIDState.verified() = Verified;

  const factory VerifyRSAAndDIDState.error(String message) = Error;
}