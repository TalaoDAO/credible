part of 'onboarding_gen_phrase_cubit.dart';

enum OnBoardingGenPhraseStatus { initial, loading, success, failure }

@JsonSerializable()
class OnBoardingGenPhraseState extends Equatable {
  OnBoardingGenPhraseState({
    this.status = OnBoardingGenPhraseStatus.initial,
    this.errorMessage,
    List<String>? mnemonic,
  }) : mnemonic = mnemonic ?? bip39.generateMnemonic().split(' ');

  factory OnBoardingGenPhraseState.fromJson(Map<String, dynamic> json) =>
      _$OnBoardingGenPhraseStateFromJson(json);

  final OnBoardingGenPhraseStatus status;
  final List<String> mnemonic;
  final String? errorMessage;

  OnBoardingGenPhraseState copyWith(
      {OnBoardingGenPhraseStatus? status,
      List<String>? mnemonic,
      String? errorMessage}) {
    return OnBoardingGenPhraseState(
      status: status ?? this.status,
      mnemonic: mnemonic ?? this.mnemonic,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, dynamic> toJson() => _$OnBoardingGenPhraseStateToJson(this);

  @override
  List<Object?> get props => [status, mnemonic, errorMessage];
}
