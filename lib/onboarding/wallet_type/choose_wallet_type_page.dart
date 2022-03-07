import 'package:flutter/material.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/onboarding/key/view/onboarding_key_page.dart';

class ChooseWalletType extends StatefulWidget {
  static Route route() => MaterialPageRoute(
        builder: (context) => ChooseWalletType(),
        settings: RouteSettings(name: '/onBoardingChooseWalletTypePage'),
      );

  const ChooseWalletType({Key? key}) : super(key: key);

  @override
  _ChooseWalletTypeState createState() => _ChooseWalletTypeState();
}

class _ChooseWalletTypeState extends State<ChooseWalletType> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Wallet Type',
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose your wallet type',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            DropdownButton<String>(
              items: [
                DropdownMenuItem(
                  value: 'personal-wallet',
                  child: Text(
                    'Personal Wallet',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                DropdownMenuItem(
                  value: 'enterprise-wallet',
                  child: Text(
                    'Enterprise Wallet',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
              onChanged: (String? value) {
                //todo change the value in variable
              },
            )
          ],
        ),
      ),
      navigation: BaseButton.primary(
          context: context,
          child: const Text('Continue'),
          onPressed: () {
            //todo save wallet type
            Navigator.of(context).pushReplacement(OnBoardingKeyPage.route());
          },
      ),
    );
  }
}
