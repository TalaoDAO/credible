part of 'backup_credential_cubit.dart';

enum BackupCredentialStatus { idle, loading, success, failure }

@JsonSerializable()
class BackupCredentialState extends Equatable {
  BackupCredentialState({
    this.status = BackupCredentialStatus.idle,
    this.message,
    List<String>? mnemonic,
  }) : mnemonic = mnemonic ?? bip39.generateMnemonic().split(' ');

  factory BackupCredentialState.fromJson(Map<String, dynamic> json) =>
      _$BackupCredentialStateFromJson(json);

  final BackupCredentialStatus status;
  final List<String> mnemonic;
  final StateMessage? message;

  BackupCredentialState copyWith(
      {BackupCredentialStatus? status,
      List<String>? mnemonic,
      StateMessage? message}) {
    return BackupCredentialState(
      status: status ?? this.status,
      mnemonic: mnemonic ?? this.mnemonic,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toJson() => _$BackupCredentialStateToJson(this);

  @override
  List<Object?> get props => [status, mnemonic, message];
}
