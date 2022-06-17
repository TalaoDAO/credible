// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_enterprise_user_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmitEnterpriseUserState _$SubmitEnterpriseUserStateFromJson(
        Map<String, dynamic> json) =>
    SubmitEnterpriseUserState(
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      did: json['did'] as String? ?? '',
    );

Map<String, dynamic> _$SubmitEnterpriseUserStateToJson(
        SubmitEnterpriseUserState instance) =>
    <String, dynamic>{
      'status': _$AppStatusEnumMap[instance.status],
      'message': instance.message,
      'did': instance.did,
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
