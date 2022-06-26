import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:moneyboi/Controllers/hive_controller.dart';
import 'package:moneyboi/Theme/dark_theme.dart';
import 'package:moneyboi/Theme/light_theme.dart';

import '../Constants/colors.dart';

class ThemeController extends GetxController {
  /// Actual variable holding the value of current theme.
  /// defaulting this to light theme.
  bool _currentTheme = true;

  final HiveService _hiveService = Get.find<HiveService>();

  /// Observable variable that holds value of current selected
  /// theme data.
  Rx<bool> get currentTheme => _currentTheme.obs;

  @override
  void onInit() {
    // Get and populate the themedata from storage.
    _getThemeFromStorage();
    super.onInit();
  }

  /// Local method to get saved theme from storage and populate `_currentThemeData`
  void _getThemeFromStorage() {
    final bool? _theme = _hiveService.getCurrentTheme;
    if (_theme == null || _theme == true) {
      _currentTheme = true;
    } else {
      _currentTheme = false;
    }
  }

  Future toggleTheme() async {
    _currentTheme = !_currentTheme;
    await _hiveService.saveTheme(
      value: _currentTheme,
    );
    // SystemChrome.setSystemUIOverlayStyle(
    //   _currentTheme
    //       ? SystemUiOverlayStyle(
    //           statusBarColor: Colors.white,
    //           statusBarIconBrightness: Brightness.dark,
    //         )
    //       : SystemUiOverlayStyle(
    //           statusBarColor: Colors.black,
    //           statusBarIconBrightness: Brightness.light,
    //         ),
    // );
    Get.changeTheme(_currentTheme ? lightTheme : darkTheme);

    update();
  }
}
