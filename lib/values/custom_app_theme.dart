import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppTheme {
  static Color primaryColor = new HexColor('#29B6F6');
  static Color darkPrimaryColor = new HexColor('#0288D1');
  static Color accentColor = new HexColor('#8FE2EC');

  static const globalPadding = 20.0;

  static const heading1 = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
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
