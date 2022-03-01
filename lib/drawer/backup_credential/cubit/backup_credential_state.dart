part of 'backup_credential_cubit.dart';

enum BackupCredentialStatus {
  idle,
  loading,
  success,
  permissionDenied,
  failure
}

@JsonSerializable()
class BackupCredentialState extends Equatable {
  BackupCredentialState({
    this.status = BackupCredentialStatus.idle,
    this.message,
    this.filePath = '',
    List<String>? mnemonic,
  }) : mnemonic = mnemonic ?? bip39.generateMnemonic().split(' ');

  factory BackupCredentialState.fromJson(Map<String, dynamic> json) =>
      _$BackupCredentialStateFromJson(json);

  final BackupCredentialStatus status;
  final List<String> mnemonic;
  final StateMessage? message;
  final String filePath;

  BackupCredentialState copyWith(
      {BackupCredentialStatus? status,
      List<String>? mnemonic,
      StateMessage? message,
      String? filePath}) {
    return BackupCredentialState(
      status: status ?? this.status,
      mnemonic: mnemonic ?? this.mnemonic,
      message: message ?? this.message,
      filePath: filePath ?? this.filePath,
    );
  }

  Map<String, dynamic> toJson() => _$BackupCredentialStateToJson(this);

  @override
  List<Object?> get props => [status, mnemonic, message];
}
