part of 'recovery_credential_cubit.dart';

enum RecoveryCredentialStatus { idle, loading, success, failure }

@JsonSerializable()
class RecoveryCredentialState extends Equatable {
  RecoveryCredentialState(
      {this.status = RecoveryCredentialStatus.idle,
      this.message,
      this.isTextFieldEdited = false,
      this.isMnemonicValid = false,
      this.recoveredCredentialLength});

  factory RecoveryCredentialState.fromJson(Map<String, dynamic> json) =>
      _$RecoveryCredentialStateFromJson(json);

  final RecoveryCredentialStatus status;
  final StateMessage? message;
  final bool isTextFieldEdited;
  final bool isMnemonicValid;
  final int? recoveredCredentialLength;

  RecoveryCredentialState copyWith({
    RecoveryCredentialStatus? status,
    StateMessage? message,
    bool? isTextFieldEdited,
    bool? isMnemonicValid,
    int? recoveredCredentialLength,
  }) {
    return RecoveryCredentialState(
      status: status ?? this.status,
      message: message ?? this.message,
      isTextFieldEdited: isTextFieldEdited ?? this.isTextFieldEdited,
      isMnemonicValid: isMnemonicValid ?? this.isMnemonicValid,
      recoveredCredentialLength:
          recoveredCredentialLength ?? this.recoveredCredentialLength,
    );
  }

  Map<String, dynamic> toJson() => _$RecoveryCredentialStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        isMnemonicValid,
        isTextFieldEdited,
        message,
        recoveredCredentialLength
      ];
}
