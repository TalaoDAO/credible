// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recovery_key_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecoveryKeyState _$RecoveryKeyStateFromJson(Map<String, dynamic> json) =>
    RecoveryKeyState(
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
      mnemonic: (json['mnemonic'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$RecoveryKeyStateToJson(RecoveryKeyState instance) =>
    <String, dynamic>{
      'status': _$AppStatusEnumMap[instance.status],
      'mnemonic': instance.mnemonic,
    };

const _$AppStatusEnumMap = {
  AppStatus.init: 'init',
  AppStatus.fetching: 'fetching',
  AppStatus.loading: 'loading',
  AppStatus.populate: 'populate',
  AppStatus.error: 'error',
  AppStatus.errorWhileFetching: 'errorWhileFetching',
  AppStatus.success: 'success',
};
