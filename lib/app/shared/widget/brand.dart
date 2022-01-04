import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/hero_workaround.dart';
import 'package:flutter/material.dart';

class BrandMinimal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        HeroFix(
          tag: 'splash/icon-minimal',
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.5,
            child: Image.asset('assets/brand/logo_talao.png'),
          ),
        ),
        Text('Talao SSI wallet',
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: UiKit.palette.primary))
      ],
    );
  }
}

class Brand extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          HeroFix(
            tag: 'splash/title',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset('assets/brand/slide_talao.jpeg')),
              ],
            ),
          ),
        ],
      );
}
