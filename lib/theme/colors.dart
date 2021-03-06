import 'package:flutter/material.dart';

const themeAppWhite100 = const Color(0xFFFFFFFF);
const themeAppWhite300 = const Color(0xFFFBB8AC);
const themeAppWhite400 = const Color(0xFFEAA4A4);

const themeAppGrey500 = Colors.grey;
const themeAppGrey600 = const Color(0xFF757575);
const themeAppGrey700 = const Color(0xFF616161);
const themeAppGrey800 = const Color(0xFF424242);

const themeAppBlue500 = Color(0xFF1E88E5);

const themeAppErrorRed = const Color(0xFFC5032B);

const themeAppAccentColor = Colors.cyan;

const themeAppSurfaceWhite = const Color(0xFFFFFBFA);
const themeAppBackgroundWhite = Colors.white;

//Green themes
const greentheme = Color.fromRGBO(0, 128, 0, 1);
// const greentheme100 = Color.fromRGBO(55, 180, 76, 1);
const greentheme100 = Color.fromRGBO(0, 140, 0, 1);
const greentheme200 = Color.fromRGBO(24, 214, 101, 1);
const greentheme300 = Color.fromRGBO(75, 148, 52, 1);
const greentheme400 = Color.fromRGBO(0, 154, 23, 1); //009A17

//Grey themes
const greytheme100 = Color.fromRGBO(170, 170, 170, 1);
const greytheme200 = Color.fromRGBO(58, 63, 67, 0.7);
const greytheme300 = Color.fromRGBO(51, 51, 51, 0.8);
const greytheme400 = Color.fromRGBO(150, 150, 150, 1);
const greytheme500 = Color.fromRGBO(118, 118, 118, 0.8);
const greytheme600 = Color.fromRGBO(213, 213, 213, 1);
const greytheme700 = Color.fromRGBO(64, 64, 64, 1);
const greytheme800 = Color.fromRGBO(170, 170, 170, 0.7);
const greytheme900 = Color.fromRGBO(221, 221, 221, 1);
const greytheme1000 = Color.fromRGBO(118, 118, 118, 1);
const greytheme1100 = Color.fromRGBO(230, 230, 230, 1);
const greytheme1200 = Color.fromRGBO(51, 51, 51, 1);
const greytheme1300 = Color.fromRGBO(237, 237, 237, 1);
const greytheme1400 = Color.fromRGBO(152, 152, 152, 1);
const greytheme1500 = Color.fromRGBO(112, 112, 112, 0.2);

//Orange themes
const orangetheme = Color.fromRGBO(255, 105, 58, 1);
const orangetheme100 = Color.fromRGBO(253, 88, 0, 1);
const orangetheme200 = Color.fromRGBO(236, 116, 67, 1);
const orangetheme300 = Color.fromRGBO(255, 109, 43, 1); //FF6D2B

//Green Themes
//const greentheme = Color.fromRGBO(0, 153, 53, 1);

//Red Theme
const redtheme = Color.fromRGBO(237, 29, 37, 1);

Color getColorByHex(String hex) {
  if (hex != null) {
    return HexColor.fromHex(hex);
  }
  return orangetheme300;
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
