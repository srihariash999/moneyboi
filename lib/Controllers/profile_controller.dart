import 'package:get/get.dart';
import 'package:moneyboi/Data%20Models/api_response_model.dart';
import 'package:moneyboi/Network/network_service.dart';

class ProfileController extends GetxController {
  final NetworkService _apiService = NetworkService();

  RxBool isProfileLoading = false.obs;

  final RxString name = ''.obs;
  final RxString email = ''.obs;

  Future<void> getUserProfile() async {
    final ApiResponseModel _profRes = await _apiService.getUserProfile();
    isProfileLoading.value = true;
    update();
    if (_profRes.statusCode == 200) {
      final _res = _profRes.responseJson!.data as Map;
      // print(_res['name']);
      isProfileLoading.value = false;
      name.value = _res['name'].toString();
      email.value = _res['email'].toString();
      update();
    } else {
      isProfileLoading.value = false;
      update();
    }
  }
}
