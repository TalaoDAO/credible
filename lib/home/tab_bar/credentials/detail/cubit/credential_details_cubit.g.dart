// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_details_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialDetailsState _$CredentialDetailsStateFromJson(
        Map<String, dynamic> json) =>
    CredentialDetailsState(
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
      verificationState: $enumDecodeNullable(
              _$VerificationStateEnumMap, json['verificationState']) ??
          VerificationState.Unverified,
      title: json['title'] as String? ?? '',
    );

Map<String, dynamic> _$CredentialDetailsStateToJson(
        CredentialDetailsState instance) =>
    <String, dynamic>{
      'status': _$AppStatusEnumMap[instance.status],
      'verificationState':
          _$VerificationStateEnumMap[instance.verificationState],
      'title': instance.title,
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

const _$VerificationStateEnumMap = {
  VerificationState.Unverified: 'Unverified',
  VerificationState.Verified: 'Verified',
  VerificationState.VerifiedWithWarning: 'VerifiedWithWarning',
  VerificationState.VerifiedWithError: 'VerifiedWithError',
};
