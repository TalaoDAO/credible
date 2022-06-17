// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'self_issued_credential_button_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelfIssuedCredentialButtonState _$SelfIssuedCredentialButtonStateFromJson(
        Map<String, dynamic> json) =>
    SelfIssuedCredentialButtonState(
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SelfIssuedCredentialButtonStateToJson(
        SelfIssuedCredentialButtonState instance) =>
    <String, dynamic>{
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
