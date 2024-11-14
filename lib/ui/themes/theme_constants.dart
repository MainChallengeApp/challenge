import 'package:flutter/material.dart';

const Color _themeColor1 = Color.fromRGBO(15, 23, 42, 1);
const Color _themeColor2 = Color.fromRGBO(51, 65, 85, 1);
const Color _themeColor3 = Color.fromRGBO(100, 116, 139, 1);
const Color _themeColor4 = Color.fromRGBO(241, 245, 249, 1);
const Color _themeColor5 = Color.fromRGBO(226, 232, 240, 1);
const Color _green = Color.fromRGBO(174, 218, 176, 1);
const Color _red = Color.fromRGBO(252, 171, 165, 1);

ThemeData lightTheme = ThemeData(
  primaryColor: _themeColor1,
  colorScheme: const ColorScheme.light(
    primary: _themeColor1,
    secondary: _themeColor2,
    tertiary: _themeColor3,
    surface: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
        fontSize: 21, fontWeight: FontWeight.bold, color: Colors.black),
    titleMedium: TextStyle(
        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
    titleSmall: TextStyle(
        fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
    bodyMedium: TextStyle(
        fontSize: 13, fontWeight: FontWeight.normal, color: _themeColor3),
    bodySmall: TextStyle(
        fontSize: 10, fontWeight: FontWeight.normal, color: _themeColor3),
  ),
);

extension CustomTextTheme on TextTheme {
  TextStyle get textInputSmall => const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      );

  TextStyle get textInputHintSmall => const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.normal,
        color: _themeColor3,
      );

  TextStyle get subTitle => const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      );

  TextStyle get bodyMediumBlack => const TextStyle(
      fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black);

  TextStyle get titleMediaNormalTertiary => const TextStyle(
      fontSize: 14, fontWeight: FontWeight.normal, color: _themeColor3);
}

extension CustomColorTheme on ColorScheme {
  Color get linkColor => Colors.blue[500]!;
  Color get themeColor4 => _themeColor4;
  Color get themeColor5 => _themeColor5;
  Color get green => _green;
  Color get red => _red;
}
