import 'package:freezed_annotation/freezed_annotation.dart';

part 'self_issued_credential_state.freezed.dart';

@freezed
class SelfIssuedCredentialState with _$SelfIssuedCredentialState {
  const factory SelfIssuedCredentialState.initial() = Initial;

  const factory SelfIssuedCredentialState.loading() = Loading;

  const factory SelfIssuedCredentialState.error(String message) = Error;

  const factory SelfIssuedCredentialState.warning(String message) = Warning;

  const factory SelfIssuedCredentialState.credentialCreated() =
  CredentialCreated;
}