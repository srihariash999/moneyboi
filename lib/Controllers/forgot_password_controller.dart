import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';
import 'package:moneyboi/Constants/enums.dart';
import 'package:moneyboi/Constants/urls.dart';
import 'package:moneyboi/Data%20Models/api_response_model.dart';
import 'package:moneyboi/Network/network_service.dart';

class ForgotPasswordController extends GetxController {
  final _isEmailState = true.obs;
  bool get isEmailState => _isEmailState.value;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final NetworkService _apiService = NetworkService();

  Future generateForgotPasswordOTPEvent({required String email}) async {
    _isLoading.value = true;
    update();
    final ApiResponseModel _otpGenRes = await _apiService.networkCall(
      networkCallMethod: NetworkCallMethod.POST,
      endPointUrl: forgotPasswordOtpGetEndPoint,
      authenticated: true,
      bodyParameters: {
        'email': email,
      },
    );

    if (_otpGenRes.statusCode == 200) {
      try {
        BotToast.showText(text: _otpGenRes.responseJson!.data.toString());
      } catch (e) {
        BotToast.showText(text: "Otp sent to your email");
      }
      _isLoading.value = false;
      _isEmailState.value = false;
      update();
    } else {
      try {
        BotToast.showText(text: _otpGenRes.responseJson!.data.toString());
      } catch (e) {
        BotToast.showText(text: "Invalid email id");
      }
      _isLoading.value = false;
      _isEmailState.value = true;
      update();
    }
  }

  Future verifyForgotPasswordOTPEvent({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    _isLoading.value = true;
    update();
    // final ApiResponseModel _otpVerifyRes =
    //     await _apiService.forgotPasswordOtpVerify(
    //   email: email,
    //   otp: otp,
    //   newPassword: newPassword,
    // );

    final ApiResponseModel _otpVerifyRes = await _apiService.networkCall(
      networkCallMethod: NetworkCallMethod.POST,
      endPointUrl: forgotPasswordOtpVerifyEndPoint,
      authenticated: true,
      bodyParameters: {
        'email': email,
        'otp': otp,
        'new_password': newPassword,
      },
    );

    if (_otpVerifyRes.statusCode == 200) {
      try {
        BotToast.showText(
          text: _otpVerifyRes.responseJson!.data.toString(),
        );
      } catch (e) {
        BotToast.showText(text: "Otp sent to your email");
      }
      _isLoading.value = false;
      update();
      Get.back();
    } else {
      try {
        BotToast.showText(
          text: _otpVerifyRes.responseJson!.data.toString(),
        );
      } catch (e) {
        BotToast.showText(text: "Error changing password");
      }
      _isLoading.value = false;
      update();
    }
  }
}
