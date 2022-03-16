import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:logging/logging.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/interop/key_generation.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:talao/did/cubit/did_cubit.dart';
import 'package:talao/l10n/l10n.dart';

part 'onboarding_gen_phrase_state.dart';

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
      await secureStorageProvider.set('mnemonic', mnemonicFormatted);
      final key = await keyGeneration.privateKey(mnemonicFormatted);
      await secureStorageProvider.set('key', key);

      final didMethod = Constants.defaultDIDMethod;
      final did = didKitProvider.keyToDID(didMethod, key);

      didCubit.set(
        did: did,
        didMethod: didMethod,
        didMethodName: Constants.defaultDIDMethodName,
      );

      emit(state.copyWith(status: OnBoardingGenPhraseStatus.success));
    } catch (error) {
      print(error);
      log.severe('something went wrong when generating a key', error);
      emit(
        state.copyWith(
          status: OnBoardingGenPhraseStatus.failure,
          message: StateMessage.error(context.l10n.errorGeneratingKey),
        ),
      );
    }
  }
}
