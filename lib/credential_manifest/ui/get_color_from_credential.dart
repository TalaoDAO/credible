import 'package:flutter/material.dart';
import 'package:talao/app/shared/model/credential_manifest/color_object.dart';

Color? getColorFromCredential(ColorObject? colorCode, Color fallbackColor) {
  var color = colorCode != null
      ? Color(int.parse('FF${colorCode.color!.substring(1)}', radix: 16))
      : fallbackColor;
  return color;
}
