import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/brand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnBoardingStartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BasePage(
      scrollView: true,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Brand(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              localizations.appPresentation,
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.justify,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BaseButton.primary(
              onPressed: () {
                Modular.to.pushReplacementNamed('/on-boarding/tos');
              },
              child: Text(localizations.onBoardingStartButton),
            ),
          ),
        ],
      ),
    );
  }
}
