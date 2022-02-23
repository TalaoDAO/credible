import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:logging/logging.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/interop/key_handler.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:talao/l10n/l10n.dart';

part 'onboarding_gen_phrase_state.dart';

part 'onboarding_gen_phrase_cubit.g.dart';

class OnBoardingGenPhraseCubit extends Cubit<OnBoardingGenPhraseState> {
  final SecureStorageProvider secureStorageProvider;
  final KeyHandler keyHandler;

  OnBoardingGenPhraseCubit(
      {required this.secureStorageProvider, required this.keyHandler})
      : super(OnBoardingGenPhraseState());

  final log = Logger('talao-wallet/on-boarding/key-generation');

  Future<void> generateKey(BuildContext context, List<String> mnemonic) async {
    try {
      emit(state.copyWith(status: OnBoardingGenPhraseStatus.loading));
      final mnemonicFormatted = mnemonic.join(' ');
      await saveMnemonicKey(mnemonicFormatted);
      final key = await keyHandler.generatePrivateKey(mnemonicFormatted);
      await secureStorageProvider.set('key', key);
      emit(state.copyWith(status: OnBoardingGenPhraseStatus.success));
    } catch (error) {
      log.severe('something went wrong when generating a key', error);
      emit(
        state.copyWith(
          status: OnBoardingGenPhraseStatus.failure,
          message: StateMessage.error(context.l10n.errorGeneratingKey),
        ),
      );
    }
  }

  Future<void> saveMnemonicKey(String mnemonic) async {
    try {
      log.info('will save mnemonic to secure storage');
      await secureStorageProvider.set('mnemonic', mnemonic);
      log.info('mnemonic saved');
    } catch (error) {
      log.severe('error ocurred setting mnemonic to secure storate', error);
      emit(state.copyWith(
        status: OnBoardingGenPhraseStatus.failure,
        message:
            StateMessage.error('Failed to save mnemonic, please try again'),
      ));
    }
  }
}
