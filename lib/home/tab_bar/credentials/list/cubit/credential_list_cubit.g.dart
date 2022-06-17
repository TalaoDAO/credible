// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_list_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialListState _$CredentialListStateFromJson(Map<String, dynamic> json) =>
    CredentialListState(
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      gamingCredentials: (json['gamingCredentials'] as List<dynamic>?)
          ?.map((e) => HomeCredential.fromJson(e as Map<String, dynamic>))
          .toList(),
      communityCredentials: (json['communityCredentials'] as List<dynamic>?)
          ?.map((e) => HomeCredential.fromJson(e as Map<String, dynamic>))
          .toList(),
      identityCredentials: (json['identityCredentials'] as List<dynamic>?)
          ?.map((e) => HomeCredential.fromJson(e as Map<String, dynamic>))
          .toList(),
      othersCredentials: (json['othersCredentials'] as List<dynamic>?)
          ?.map((e) => HomeCredential.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CredentialListStateToJson(
        CredentialListState instance) =>
    <String, dynamic>{
      'status': _$AppStatusEnumMap[instance.status],
      'gamingCredentials': instance.gamingCredentials,
      'communityCredentials': instance.communityCredentials,
      'identityCredentials': instance.identityCredentials,
      'othersCredentials': instance.othersCredentials,
      'message': instance.message,
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
