// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'siopv2_credentials_pick_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SIOPV2CredentialPickState _$SIOPV2CredentialPickStateFromJson(
        Map<String, dynamic> json) =>
    SIOPV2CredentialPickState(
      index: json['index'] as int? ?? 0,
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
    );

Map<String, dynamic> _$SIOPV2CredentialPickStateToJson(
        SIOPV2CredentialPickState instance) =>
    <String, dynamic>{
      'index': instance.index,
      'status': _$AppStatusEnumMap[instance.status],
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
