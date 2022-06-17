// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'did_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DIDState _$DIDStateFromJson(Map<String, dynamic> json) => DIDState(
      did: json['did'] as String? ?? '',
      didMethod: json['didMethod'] as String? ?? '',
      didMethodName: json['didMethodName'] as String? ?? '',
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DIDStateToJson(DIDState instance) => <String, dynamic>{
      'did': instance.did,
      'didMethod': instance.didMethod,
      'didMethodName': instance.didMethodName,
      'status': _$AppStatusEnumMap[instance.status],
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
