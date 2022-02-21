import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:talao/app/interop/secure_storage/secure_storage.dart';

part 'onboarding_gen_phrase_state.dart';

part 'onboarding_gen_phrase_cubit.g.dart';

class OnBoardingGenPhraseCubit extends Cubit<OnBoardingGenPhraseState> {
  final SecureStorageProvider secureStorageProvider;

  OnBoardingGenPhraseCubit(this.secureStorageProvider)
      : super(OnBoardingGenPhraseState());

  Future<void> generateKey(BuildContext context) async {
    // final log = Logger('talao-wallet/on-boarding/key-generation');
    // final localizations = AppLocalizations.of(context)!;
    // try {
    //   final mnemonic = (await SecureStorageProvider.instance.get('mnemonic'))!;
    //   final key = await KeyGeneration.privateKey(mnemonic);
    //
    //   await SecureStorageProvider.instance.set('key', key);
    //   context.read<WalletBloc>().readyWalletBlocList();
    //   await Navigator.of(context).pushAndRemoveUntil(
    //       PersonalPage.route(
    //           isFromOnBoarding: true, profileModel: ProfileModel.empty),
    //           (Route<dynamic> route) => false);
    // } catch (error) {
    //   log.severe('something went wrong when generating a key', error);
    //
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     backgroundColor: Theme.of(context).colorScheme.snackBarError,
    //     content: Text(localizations.errorGeneratingKey),
    //   ));
    //   await Navigator.of(context).pushReplacement(OnBoardingKeyPage.route());
    // }

    return;
  }

  Future<void> saveMnemonicKey() async {
    // try {
    //   log.info('will save mnemonic to secure storage');
    //   await SecureStorageProvider.instance.set(
    //     'mnemonic',
    //     mnemonic.join(' '),
    //   );
    //   log.info('mnemonic saved');
    //
    //   await Navigator.of(context)
    //       .pushReplacement(OnBoardingGenPage.route());
    // } catch (error) {
    //   log.severe(
    //       'error ocurred setting mnemonic to secure storate',
    //       error);
    //
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     backgroundColor:
    //         Theme.of(context).colorScheme.snackBarError,
    //     content:
    //         Text('Failed to save mnemonic, please try again'),
    //   ));
    // }
    return;
  }
}
