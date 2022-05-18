part of 'wallet_cubit.dart';

enum WalletStatus { init, idle, insert, delete, update, reset, search }

@JsonSerializable()
class WalletState extends Equatable {
  WalletState({
    this.status = WalletStatus.init,
    List<CredentialModel>? credentials,
    List<CredentialModel>? credentialsFromStorage,
  })  : credentials = credentials ?? [],
        credentialsFromStorage = credentialsFromStorage ?? [];

  factory WalletState.fromJson(Map<String, dynamic> json) =>
      _$WalletStateFromJson(json);

  final WalletStatus status;
  final List<CredentialModel> credentials;
  final List<CredentialModel> credentialsFromStorage;

  WalletState copyWith({
    WalletStatus? status,
    List<CredentialModel>? credentials,
    List<CredentialModel>? credentialsFromStorage,
  }) {
    return WalletState(
      status: status ?? this.status,
      credentials: credentials ?? this.credentials,
      credentialsFromStorage:
          credentialsFromStorage ?? this.credentialsFromStorage,
    );
  }

  Map<String, dynamic> toJson() => _$WalletStateToJson(this);

  @override
  List<Object?> get props => [status, credentials];
}
