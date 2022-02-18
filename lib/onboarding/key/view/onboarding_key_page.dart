import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:talao/onboarding/gen_phrase/view/onboarding_gen_phrase.dart';
import 'package:talao/onboarding/recovery/view/onboarding_recovery.dart';

class OnBoardingKeyPage extends StatelessWidget {
  static Route route() => MaterialPageRoute(
        builder: (context) => OnBoardingKeyPage(),
        settings: RouteSettings(name: '/onBoardingKeyPage'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return WillPopScope(
      onWillPop: () async => false,
      child: BasePage(
        title: l10n.onBoardingKeyTitle,
        scrollView: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    l10n.keyRecoveryTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(height: 32.0),
                  Text(
                    l10n.keyRecoveryText,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 20.0),
                  BaseButton.primary(
                    context: context,
                    onPressed: () {
                      Navigator.of(context)
                          .push(OnBoardingRecoveryPage.route());
                    },
                    child: Text(l10n.onBoardingKeyRecover),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    l10n.keyGenerateTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(height: 32.0),
                  Text(
                    l10n.keyGenerateText,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 20.0),
                  BaseButton.primary(
                    context: context,
                    onPressed: () {
                      Navigator.of(context)
                          .push(OnBoardingGenPhrasePage.route());
                    },
                    child: Text(l10n.onBoardingKeyGenerate),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
