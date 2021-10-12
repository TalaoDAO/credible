import 'dart:ui';

import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnBoardingStartPage extends StatefulWidget {
  @override
  State<OnBoardingStartPage> createState() => _OnBoardingStartPageState();
}

class _OnBoardingStartPageState extends State<OnBoardingStartPage> {
  var animate = true;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 4), () async {
      if (animate) {
        await Modular.to.pushNamed('/on-boarding/second');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () async {
        await Modular.to.pushNamed('/on-boarding/second');
      },
      onHorizontalDragUpdate: (drag) async {
        if (animate && drag.delta.dx < -2) {
          disableAnimation();
          await Modular.to.pushNamed('/on-boarding/second');
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
                'assets/image/slide_1.png',
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                localizations.appPresentation1,
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
        ),
      ),
    );
  }

  void disableAnimation() {
    animate = false;
    Future.delayed(Duration(seconds: 1), () {
      animate = true;
    });
  }
}
