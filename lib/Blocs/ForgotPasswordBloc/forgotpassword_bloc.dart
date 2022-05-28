// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:moneyboi/Data%20Models/api_response_model.dart';
import 'package:moneyboi/Network/network_service.dart';

part 'forgotpassword_event.dart';
part 'forgotpassword_state.dart';

NetworkService _apiService = NetworkService();

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordLoaded(isEmailState: true)) {
    on<ForgotPasswordEvent>((event, emit) async {
      if (event is GenerateForgotPasswordOTPEvent) {
        emit(ForgotPasswordLoading());
        final ApiResponseModel _otpGenRes =
            await _apiService.forgotPasswordOtpGenerate(email: event.email);

        if (_otpGenRes.statusCode == 200) {
          try {
            BotToast.showText(text: _otpGenRes.responseJson!.data.toString());
          } catch (e) {
            BotToast.showText(text: "Otp sent to your email");
          }
          emit(ForgotPasswordLoaded(isEmailState: false));
        } else {
          try {
            BotToast.showText(text: _otpGenRes.responseJson!.data.toString());
          } catch (e) {
            BotToast.showText(text: "Invalid email id");
          }
          emit(ForgotPasswordLoaded(isEmailState: true));
        }
      } else if (event is VerifyForgotPasswordOTPEvent) {
        emit(ForgotPasswordLoading());
        final ApiResponseModel _otpVerifyRes =
            await _apiService.forgotPasswordOtpVerify(
          email: event.email,
          otp: event.otp,
          newPassword: event.newPassword,
        );

        if (_otpVerifyRes.statusCode == 200) {
          try {
            BotToast.showText(
              text: _otpVerifyRes.responseJson!.data.toString(),
            );
          } catch (e) {
            BotToast.showText(text: "Otp sent to your email");
          }
          emit(ForgotPasswordLoaded(isEmailState: false));
          Get.back();
        } else {
          try {
            BotToast.showText(
              text: _otpVerifyRes.responseJson!.data.toString(),
            );
          } catch (e) {
            BotToast.showText(text: "Error changing password");
          }
          emit(ForgotPasswordLoaded(isEmailState: false));
        }
      }
    });
  }
}
