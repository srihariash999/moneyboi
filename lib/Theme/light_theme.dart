import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moneyboi/Constants/colors.dart';

ThemeData lightTheme = ThemeData(
  primaryColor: moneyBoyPurple,
  primaryColorLight: moneyBoyPurpleLight,
  brightness: Brightness.light,
  highlightColor: Colors.white,
  colorScheme: const ColorScheme.light(
    secondary: Colors.black,
    background: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: const Color(0xFFFFFFFF),
    ),
  ),
);
