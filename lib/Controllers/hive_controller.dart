import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:moneyboi/Constants/box_names.dart';

class HiveService extends GetxController {
  static final Box _generalBox = Hive.box(generalBoxName);

  final Box _themeBox = Hive.box<bool>(themeBoxName);

  /// If true --> show banner on home screen.
  /// If false --> hide banner.
  // ignore: prefer_final_fields
  Rx<bool?> _getBannerDismissable =
      (_generalBox.get('bannerDismissable') as bool?).obs;

  bool get getBannerDismissable => _getBannerDismissable.value ?? true;

  void setBannerDismissable({required bool value}) {
    _generalBox.put('bannerDismissable', value);
    _getBannerDismissable = value.obs;
    update();
  }

  Future clearGeneralBox() async {
    await _generalBox.clear();
    _getBannerDismissable = true.obs;
    update();
  }

  Future clearThemeBox() async {
    await _themeBox.clear();
    _getBannerDismissable = true.obs;
    update();
  }

  /// Getting current theme from box.
  /// true --> light theme.
  /// false --> dark theme.
  /// null --> no saved preference.
  bool? get getCurrentTheme => _themeBox.get('theme') as bool?;

  /// value == true --> light theme.
  /// value == false --> dark theme.
  Future saveTheme({required bool value}) async {
    await _themeBox.put("theme", value);
    return;
  }
}
