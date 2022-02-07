import 'package:flutter/material.dart';

///todo light and dark
class UiPalette {
  UiPalette._();

  static const blue = Color(0xff37436b);
  static const text = Color(0xff324854);

  static const lightGrey = Color(0xffF6F7FA);

  static const gradientBlue = Color(0xff50a7d9);

  static Gradient pageBackground = LinearGradient(
    colors: [lightGrey, lightGrey],
  );

  static Gradient splashBackground = LinearGradient(
    colors: [blue, gradientBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Gradient buttonBackground = LinearGradient(
    colors: [blue, blue],
  );
}
