import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneyboi/Constants/enums.dart';
import 'package:moneyboi/Constants/urls.dart';
import 'package:moneyboi/Data%20Models/api_response_model.dart';
import 'package:moneyboi/Network/network_service.dart';
import 'package:moneyboi/Screens/login/login_page.dart';

enum SignupState { loading, initial, name, email, password }

class SignupController extends GetxController {
  final NetworkService _apiService = NetworkService();

  final _name = "".obs;
  String get name => _name.value;

  final _email = "".obs;
  String get email => _email.value;

  final _signupState = SignupState.initial.obs;
  SignupState get signupState => _signupState.value;

  void moveToName() {
    _signupState.value = SignupState.name;
    update();
  }

  void moveToEmail({required String name}) {
    _name.value = name;
    _signupState.value = SignupState.email;
    update();
  }

  void moveToPassword({required String email}) {
    _email.value = email;
    _signupState.value = SignupState.password;
    update();
  }

  Future<void> signup({required String password}) async {
    _signupState.value = SignupState.loading;
    update();
    debugPrint("name : $name, email: $email password:$password");
    final ApiResponseModel _signUpResult = await _apiService.networkCall(
      networkCallMethod: NetworkCallMethod.POST,
      endPointUrl: signupEndPoint,
      authenticated: false,
      bodyParameters: {
        'name': name,
        'email': email,
        'password': password,
      },
    );
    // print(
    //     "${_signUpResult.endPoint} ${_signUpResult.responseJson}  ${_signUpResult.statusCode}  ${_signUpResult.specificMessage} ");
    if (_signUpResult.statusCode == 200) {
      debugPrint("signup success");

      _signupState.value = SignupState.initial;
      BotToast.showText(text: "SignUp Successful");

      Get.back();
      Get.off(LoginPage());
    } else {
      _signupState.value = SignupState.initial;
      debugPrint(_signUpResult.specificMessage);
      BotToast.showText(
        text: _signUpResult.specificMessage ?? " Cannot sign you up",
      );
    }
  }
}
