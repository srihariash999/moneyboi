import 'package:get/get.dart';
import 'package:hive/hive.dart';

class HiveService extends GetxController {
  static final Box _generalBox = Hive.box('generalBox');

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
}
