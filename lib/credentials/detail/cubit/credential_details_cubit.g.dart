// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_details_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialDetailsState _$CredentialDetailsStateFromJson(
        Map<String, dynamic> json) =>
    CredentialDetailsState(
      verificationState: $enumDecodeNullable(
              _$VerificationStateEnumMap, json['verificationState']) ??
          VerificationState.Unverified,
      title: json['title'] as String? ?? '',
    );

Map<String, dynamic> _$CredentialDetailsStateToJson(
        CredentialDetailsState instance) =>
    <String, dynamic>{
      'verificationState':
          _$VerificationStateEnumMap[instance.verificationState],
      'title': instance.title,
    };

const _$VerificationStateEnumMap = {
  VerificationState.Unverified: 'Unverified',
  VerificationState.Verified: 'Verified',
  VerificationState.VerifiedWithWarning: 'VerifiedWithWarning',
  VerificationState.VerifiedWithError: 'VerifiedWithError',
};
