import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppTheme {
  static Color primaryColor = new HexColor('#8E24AA');
  static Color darkPrimaryColor = new HexColor('#6A1B9A');
  static Color accentColor = new HexColor('#E1BEE7');

  static const globalPadding = 20.0;

  static const heading1 = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  static final heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: darkPrimaryColor,
  );

  static const systemUiOverlayConstant = SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      systemNavigationBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark);
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
