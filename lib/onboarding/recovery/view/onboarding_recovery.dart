import 'package:bip39/bip39.dart' as bip39;
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/pages/credentials/pages/list.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/base/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/drawer/profile/models/profile.dart';
import 'package:talao/personal/personal.dart';

class OnBoardingRecoveryPage extends StatefulWidget {
  static Route route() => MaterialPageRoute(
        builder: (context) => OnBoardingRecoveryPage(),
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
    final localizations = AppLocalizations.of(context)!;

    return BasePage(
      title: localizations.onBoardingRecoveryTitle,
      titleLeading: BackLeadingButton(),
      scrollView: false,
      padding: EdgeInsets.zero,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          OnBoardingRecoveryPage._padHorizontal(Text(
            localizations.recoveryText,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle1,
          )),
          const SizedBox(height: 24.0),
          BaseTextField(
            label: localizations.recoveryMnemonicHintText,
            controller: mnemonicController,
            error: edited && !buttonEnabled
                ? localizations.recoveryMnemonicError
                : null,
          ),
          const SizedBox(height: 24.0),
          OnBoardingRecoveryPage._padHorizontal(BaseButton.primary(
            context: context,
            onPressed: buttonEnabled
                ? () async {
                    await SecureStorageProvider.instance.set(
                      'mnemonic',
                      mnemonicController.text,
                    );
                    await Navigator.of(context).pushReplacement(
                      PersonalPage.route(
                          isFromOnBoarding: true,
                          profileModel: ProfileModel.empty),
                    );
                  }
                : null,
            child: Text(localizations.onBoardingRecoveryButton),
          )),
          const SizedBox(height: 32.0),
        ],
      ),
    );
  }
}
