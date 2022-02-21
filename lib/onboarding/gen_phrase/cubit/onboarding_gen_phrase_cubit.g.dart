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
          OnBoardingGenPhraseStatus.initial,
      errorMessage: json['errorMessage'] as String?,
      mnemonic: (json['mnemonic'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$OnBoardingGenPhraseStateToJson(
        OnBoardingGenPhraseState instance) =>
    <String, dynamic>{
      'status': _$OnBoardingGenPhraseStatusEnumMap[instance.status],
      'mnemonic': instance.mnemonic,
      'errorMessage': instance.errorMessage,
    };

const _$OnBoardingGenPhraseStatusEnumMap = {
  OnBoardingGenPhraseStatus.initial: 'initial',
  OnBoardingGenPhraseStatus.loading: 'loading',
  OnBoardingGenPhraseStatus.success: 'success',
  OnBoardingGenPhraseStatus.failure: 'failure',
};
