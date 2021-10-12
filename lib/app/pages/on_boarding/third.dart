import 'dart:ui';

import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnBoardingThirdPage extends StatelessWidget {
  var animate = true;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        Modular.to.pop();
      },
      onHorizontalDragUpdate: (drag) async {
        if (animate && drag.delta.dx > 2) {
          Modular.to.pop();
          disableAnimation();
        }
      },
      child: BasePage(
          scrollView: true,
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/image/slide_3.png',
                  height: 200,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  localizations.appPresentation3,
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
          navigation: BottomAppBar(
            child: Container(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BaseButton.primary(
                  onPressed: () {
                    Modular.to.pushReplacementNamed('/on-boarding/tos');
                  },
                  child: Text(localizations.onBoardingStartButton),
                ),
              ),
            ),
          )),
    );
  }

  void disableAnimation() {
    animate = false;
    Future.delayed(Duration(seconds: 1), () {
      animate = true;
    });
  }
}
