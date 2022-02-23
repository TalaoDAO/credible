// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_gen_phrase_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnBoardingGenPhraseState _$OnBoardingGenPhraseStateFromJson(
        Map<String, dynamic> json) =>
    OnBoardingGenPhraseState(
      status: $enumDecodeNullable(
              _$OnBoardingGenPhraseStatusEnumMap, json['status']) ??
          OnBoardingGenPhraseStatus.idle,
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
      'status': _$OnBoardingGenPhraseStatusEnumMap[instance.status],
      'mnemonic': instance.mnemonic,
      'message': instance.message,
    };

const _$OnBoardingGenPhraseStatusEnumMap = {
  OnBoardingGenPhraseStatus.idle: 'idle',
  OnBoardingGenPhraseStatus.loading: 'loading',
  OnBoardingGenPhraseStatus.success: 'success',
  OnBoardingGenPhraseStatus.failure: 'failure',
};
