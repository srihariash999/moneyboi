import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moneyboi/Constants/colors.dart';

ThemeData lightTheme = ThemeData(
  primaryColor: moneyBoyPurple,
  primaryColorLight: moneyBoyPurpleLight,
  backgroundColor: Colors.white,
  brightness: Brightness.light,
  highlightColor: Colors.white,
  colorScheme: const ColorScheme.light(
    secondary: Colors.black,
  ),
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: const Color(0xFFFFFFFF),
    ),
  ),
);
