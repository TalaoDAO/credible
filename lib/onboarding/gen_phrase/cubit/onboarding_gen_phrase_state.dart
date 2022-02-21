part of 'onboarding_gen_phrase_cubit.dart';

enum OnBoardingGenPhraseStatus { idle, loading, success, failure }

@JsonSerializable()
class OnBoardingGenPhraseState extends Equatable {
  OnBoardingGenPhraseState({
    this.status = OnBoardingGenPhraseStatus.idle,
    this.message,
    List<String>? mnemonic,
  }) : mnemonic = mnemonic ?? bip39.generateMnemonic().split(' ');

  factory OnBoardingGenPhraseState.fromJson(Map<String, dynamic> json) =>
      _$OnBoardingGenPhraseStateFromJson(json);

  final OnBoardingGenPhraseStatus status;
  final List<String> mnemonic;
  final StateMessage? message;

  OnBoardingGenPhraseState copyWith(
      {OnBoardingGenPhraseStatus? status,
      List<String>? mnemonic,
      StateMessage? message}) {
    return OnBoardingGenPhraseState(
      status: status ?? this.status,
      mnemonic: mnemonic ?? this.mnemonic,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toJson() => _$OnBoardingGenPhraseStateToJson(this);

  @override
  List<Object?> get props => [status, mnemonic, message];
}
