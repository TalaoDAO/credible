// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_credential_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackupCredentialState _$BackupCredentialStateFromJson(
        Map<String, dynamic> json) =>
    BackupCredentialState(
      status: $enumDecodeNullable(
              _$BackupCredentialStatusEnumMap, json['status']) ??
          BackupCredentialStatus.idle,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      filePath: json['filePath'] as String? ?? '',
      mnemonic: (json['mnemonic'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$BackupCredentialStateToJson(
        BackupCredentialState instance) =>
    <String, dynamic>{
      'status': _$BackupCredentialStatusEnumMap[instance.status],
      'mnemonic': instance.mnemonic,
      'message': instance.message,
      'filePath': instance.filePath,
    };

const _$BackupCredentialStatusEnumMap = {
  BackupCredentialStatus.idle: 'idle',
  BackupCredentialStatus.loading: 'loading',
  BackupCredentialStatus.success: 'success',
  BackupCredentialStatus.permissionDenied: 'permissionDenied',
  BackupCredentialStatus.failure: 'failure',
};
