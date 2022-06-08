import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/interop/key_generation.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/base/text_field.dart';
import 'package:flutter/material.dart';
import 'package:talao/did/cubit/did_cubit.dart';
import 'package:talao/drawer/profile/models/profile.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:talao/onboarding/onboarding.dart';
import 'package:talao/personal/personal.dart';

class OnBoardingRecoveryPage extends StatefulWidget {
  static Route route() => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => OnBoardingGenPhraseCubit(
            secureStorageProvider: SecureStorageProvider.instance,
            didCubit: context.read<DIDCubit>(),
            didKitProvider: DIDKitProvider.instance,
            keyGeneration: KeyGeneration(),
          ),
          child: OnBoardingRecoveryPage(),
        ),
        settings: RouteSettings(name: '/onBoardingKeyPage'),
      );

  static const _padding = EdgeInsets.symmetric(
    horizontal: 16.0,
  );

  static Widget _padHorizontal(Widget child) => Padding(
        padding: _padding,
        child: child,
      );

  @override
  _OnBoardingRecoveryPageState createState() => _OnBoardingRecoveryPageState();
}

class _OnBoardingRecoveryPageState extends State<OnBoardingRecoveryPage> {
  late TextEditingController mnemonicController;
  late bool buttonEnabled;
  late bool edited;

  @override
  void initState() {
    super.initState();

    mnemonicController = TextEditingController();
    mnemonicController.addListener(() {
      setState(() {
        edited = mnemonicController.text.isNotEmpty;
        buttonEnabled = bip39.validateMnemonic(mnemonicController.text);
      });
    });

    edited = false;
    buttonEnabled = false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      title: l10n.onBoardingRecoveryTitle,
      titleLeading: BackLeadingButton(),
      scrollView: false,
      padding: EdgeInsets.zero,
      body: BlocConsumer<OnBoardingGenPhraseCubit, OnBoardingGenPhraseState>(
        listener: (context, state) async {
          if (state.status == OnBoardingGenPhraseStatus.success) {
            await Navigator.of(context).pushReplacement(
              PersonalPage.route(
                  isFromOnBoarding: true, profileModel: ProfileModel.empty()),
            );
          }
          if (state.status == OnBoardingGenPhraseStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: state.message!.color!,
              content: Text(state.message?.getMessage(context) ?? ''),
            ));
          }
        },
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              OnBoardingRecoveryPage._padHorizontal(Text(
                l10n.recoveryText,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1,
              )),
              const SizedBox(height: 24.0),
              BaseTextField(
                label: l10n.recoveryMnemonicHintText,
                controller: mnemonicController,
                error: edited && !buttonEnabled
                    ? l10n.recoveryMnemonicError
                    : null,
              ),
              const SizedBox(height: 24.0),
              OnBoardingRecoveryPage._padHorizontal(BaseButton.primary(
                context: context,
                onPressed: buttonEnabled
                    ? () async {
                        await context
                            .read<OnBoardingGenPhraseCubit>()
                            .generateKey(context, state.mnemonic);
                      }
                    : null,
                child: Text(l10n.onBoardingRecoveryButton),
              )),
              const SizedBox(height: 32.0),
            ],
          );
        },
      ),
    );
  }
}
