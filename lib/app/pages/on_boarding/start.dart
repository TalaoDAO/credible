import 'dart:ui';

import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/cube_transition/cube_transition.dart';

class OnBoardingStartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final slides = [
      'assets/image/slide_1.png',
      'assets/image/slide_2.png',
      'assets/image/slide_3.png'
    ];
    return BasePage(
      scrollView: true,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200,
              width: 250,
              child: CubePageView.builder(
                itemCount: 3,
                itemBuilder: (context, index, notifier) {
                  final item = slides[index];
                  final transform = Matrix4.identity();
                  final t = (index - notifier).abs();
                  final scale = lerpDouble(1.5, 0, t);
                  transform.scale(scale, scale);
                  return CubeWidget(
                    index: index,
                    pageNotifier: notifier,
                    key: Key('custom_cube_widget$index'),
                    child: Stack(
                      children: [
                        Image.asset(
                          item,
                          height: 200,
                        ),
                      ],
                    ),
                  );
                },
                onPageChanged: (int value) {},
                controller: PageController(),
                key: Key('onPageChanged_controller'),
              ),
            ),
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
