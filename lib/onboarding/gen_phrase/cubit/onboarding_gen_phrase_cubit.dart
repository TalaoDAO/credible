import 'package:bip39/bip39.dart' as bip39;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/interop/key_generation.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:talao/did/cubit/did_cubit.dart';

part 'onboarding_gen_phrase_state.dart';
import 'package:talao/scan/cubit/scan_message_string_state.dart';

part 'onboarding_gen_phrase_cubit.g.dart';

class OnBoardingGenPhraseCubit extends Cubit<OnBoardingGenPhraseState> {
  final SecureStorageProvider secureStorageProvider;
  final KeyGeneration keyGeneration;
  final DIDKitProvider didKitProvider;
  final DIDCubit didCubit;

  OnBoardingGenPhraseCubit({
    required this.secureStorageProvider,
    required this.keyGeneration,
    required this.didKitProvider,
    required this.didCubit,
  }) : super(OnBoardingGenPhraseState());

  final log = Logger('talao-wallet/on-boarding/key-generation');

  Future<void> generateKey(BuildContext context, List<String> mnemonic) async {
    try {
      emit(state.copyWith(status: OnBoardingGenPhraseStatus.loading));
      final mnemonicFormatted = mnemonic.join(' ');
      await saveMnemonicKey(mnemonicFormatted);
      final key = await keyGeneration.privateKey(mnemonicFormatted);
      await secureStorageProvider.set(SecureStorageKeys.key, key);

      final didMethod = Constants.defaultDIDMethod;
      final did = didKitProvider.keyToDID(didMethod, key);

      didCubit.set(
        did: did,
        didMethod: didMethod,
        didMethodName: Constants.defaultDIDMethodName,
      );

      emit(state.copyWith(status: OnBoardingGenPhraseStatus.success));
    } catch (error) {
      log.severe('something went wrong when generating a key', error);
      emit(
        state.copyWith(
          status: OnBoardingGenPhraseStatus.failure,
          message:
              StateMessage.error(message: ScanMessageStringState.errorGeneratingKey()),
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
        message: StateMessage.error(message:
        ScanMessageStringState.failedToSaveMnemonicPleaseTryAgain()),
      ));
    }
  }
}
