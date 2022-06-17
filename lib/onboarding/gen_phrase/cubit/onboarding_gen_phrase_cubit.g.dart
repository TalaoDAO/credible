// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_gen_phrase_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnBoardingGenPhraseState _$OnBoardingGenPhraseStateFromJson(
        Map<String, dynamic> json) =>
    OnBoardingGenPhraseState(
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      mnemonic: (json['mnemonic'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$OnBoardingGenPhraseStateToJson(
        OnBoardingGenPhraseState instance) =>
    <String, dynamic>{
      'status': _$AppStatusEnumMap[instance.status],
      'mnemonic': instance.mnemonic,
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
