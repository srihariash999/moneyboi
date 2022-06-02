import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:moneyboi/Data%20Models/api_response_model.dart';
import 'package:moneyboi/Network/network_service.dart';
import 'package:moneyboi/Screens/home/home_page.dart';
import 'package:moneyboi/Screens/login/login_page.dart';

class LoginController extends GetxController {
  final _apiService = NetworkService();

  RxBool isLoginLoading = false.obs;

  final Rx<TextEditingController> emailController = TextEditingController().obs;

  final Rx<TextEditingController> passwordController =
      TextEditingController().obs;

  Future<void> userLogin() async {
    if (emailController.value.text.trim().isNotEmpty &&
        passwordController.value.text.trim().isNotEmpty &&
        isLoginLoading.value != true) {
      isLoginLoading.value = true;
      update();

      final ApiResponseModel _loginResult = await _apiService.login(
        email: emailController.value.text.trim(),
        password: passwordController.value.text.trim(),
      );
      if (_loginResult.statusCode == 200) {
        debugPrint("Login success");
        BotToast.showText(text: "Login Successful");
        isLoginLoading.value = false;
        update();

        Get.off(const HomePage());
      } else {
        isLoginLoading.value = false;
        update();

        debugPrint(_loginResult.specificMessage);
        BotToast.showText(
          text: _loginResult.specificMessage ?? " Cannot login right now.",
        );
      }
    }
  }

  Future<void> userLogout() async {
    emailController.value.text = '';
    passwordController.value.text = '';
    update();
    final Box _authBox = Hive.box('authBox');
    await _authBox.clear();
    Get.off(LoginPage());
  }
}
