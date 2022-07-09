import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:moneyboi/Constants/box_names.dart';
import 'package:moneyboi/Controllers/hive_controller.dart';
import 'package:moneyboi/Data%20Models/api_response_model.dart';
import 'package:moneyboi/Network/network_service.dart';
import 'package:moneyboi/Screens/home/home_page.dart';
import 'package:moneyboi/Screens/login/login_page.dart';

class LoginController extends GetxController {
  final _apiService = NetworkService();
  final _hiveService = Get.find<HiveService>();

  RxBool isLoginLoading = false.obs;

  final Rx<TextEditingController> emailController = TextEditingController().obs;

  final Rx<TextEditingController> passwordController =
      TextEditingController().obs;

  Future<void> userLogin(BuildContext context) async {
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
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomePage(),
          ),
        );
        // Get.off(const HomePage());
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
    final Box _authBox = Hive.box(authBoxName);
    await _authBox.clear();
    await _hiveService.clearGeneralBox();
    await _hiveService.clearThemeBox();
    await Get.off(LoginPage());
  }
}
