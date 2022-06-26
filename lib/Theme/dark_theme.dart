import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moneyboi/Constants/colors.dart';

ThemeData darkTheme = ThemeData(
  primaryColor: moneyBoyPurple,
  primaryColorLight: moneyBoyPurpleLight,
  backgroundColor: Colors.black,
  brightness: Brightness.dark,
  highlightColor: Colors.white,
  colorScheme: const ColorScheme.dark(
    secondary: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: const Color(0xFF000000),
    ),
  ),
);
