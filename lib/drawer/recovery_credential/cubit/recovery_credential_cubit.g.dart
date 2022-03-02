// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recovery_credential_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecoveryCredentialState _$RecoveryCredentialStateFromJson(
        Map<String, dynamic> json) =>
    RecoveryCredentialState(
      status: $enumDecodeNullable(
              _$RecoveryCredentialStatusEnumMap, json['status']) ??
          RecoveryCredentialStatus.idle,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      isTextFieldEdited: json['isTextFieldEdited'] as bool? ?? false,
      isMnemonicValid: json['isMnemonicValid'] as bool? ?? false,
      recoveredCredentialLength: json['recoveredCredentialLength'] as int?,
    );

Map<String, dynamic> _$RecoveryCredentialStateToJson(
        RecoveryCredentialState instance) =>
    <String, dynamic>{
      'status': _$RecoveryCredentialStatusEnumMap[instance.status],
      'message': instance.message,
      'isTextFieldEdited': instance.isTextFieldEdited,
      'isMnemonicValid': instance.isMnemonicValid,
      'recoveredCredentialLength': instance.recoveredCredentialLength,
    };

const _$RecoveryCredentialStatusEnumMap = {
  RecoveryCredentialStatus.idle: 'idle',
  RecoveryCredentialStatus.loading: 'loading',
  RecoveryCredentialStatus.success: 'success',
  RecoveryCredentialStatus.invalidJson: 'invalidJson',
  RecoveryCredentialStatus.failure: 'failure',
};
