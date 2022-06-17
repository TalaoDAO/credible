// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_recovery_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnBoardingRecoveryState _$OnBoardingRecoveryStateFromJson(
        Map<String, dynamic> json) =>
    OnBoardingRecoveryState(
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      isTextFieldEdited: json['isTextFieldEdited'] as bool? ?? false,
      isMnemonicValid: json['isMnemonicValid'] as bool? ?? false,
    );

Map<String, dynamic> _$OnBoardingRecoveryStateToJson(
        OnBoardingRecoveryState instance) =>
    <String, dynamic>{
      'status': _$AppStatusEnumMap[instance.status],
      'message': instance.message,
      'isTextFieldEdited': instance.isTextFieldEdited,
      'isMnemonicValid': instance.isMnemonicValid,
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
