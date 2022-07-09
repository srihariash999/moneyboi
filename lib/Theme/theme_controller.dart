import 'package:get/get.dart';
import 'package:moneyboi/Controllers/hive_controller.dart';

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
    // Get.changeTheme(_currentTheme ? lightTheme : darkTheme);
    _currentTheme = !_currentTheme;
    update();
    await _hiveService.saveTheme(
      value: _currentTheme,
    );
  }
}
