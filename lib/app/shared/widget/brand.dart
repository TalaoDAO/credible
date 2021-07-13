import 'package:credible/app/shared/widget/hero_workaround.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrandMinimal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        HeroFix(
          tag: 'splash/icon-minimal',
          child: Container(
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.width * 0.2,
            child: Image.asset('assets/brand/logo_talao.png'),
          ),
        ),
      ],
    );
  }
}

class Brand extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          HeroFix(
            tag: 'splash/icon',
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.width * 0.2,
              child: Image.asset('assets/brand/logo_talao.png'),
            ),
          ),
          const SizedBox(height: 32.0),
          HeroFix(
            tag: 'splash/title',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('assets/brand/logo_talao.png'),
                // const SizedBox(height: 16.0),
                // SvgPicture.asset('assets/brand/logo-subtitle.svg'),
              ],
            ),
          ),
        ],
      );
}
