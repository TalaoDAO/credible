import 'package:google_fonts/google_fonts.dart';
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
        Text(
          'Talao SSI wallet',
          style: GoogleFonts.montserrat(
            color: const Color(0xFFFFFFFF),
            fontSize: 28.0,
            fontWeight: FontWeight.w400,
          ),
        )
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
