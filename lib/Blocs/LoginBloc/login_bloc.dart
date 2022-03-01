import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:moneyboi/Data%20Models/api_response_model.dart';
import 'package:moneyboi/Network/network_service.dart';
import 'package:moneyboi/Screens/home_page.dart';
// import 'package:moneyboi/Screens/login_page.dart';

part 'loginbloc_event.dart';
part 'loginbloc_state.dart';

final NetworkService _apiService = NetworkService();

class LoginBloc extends Bloc<LoginBlocEvent, LoginBlocState> {
  LoginBloc() : super(LoginBlocInitial()) {
    on<LoginBlocEvent>(
      (event, emit) async {
        if (event is LoginEvent) {
          emit.call(LoginBlocLoading());

          final ApiResponseModel _loginResult = await _apiService.login(
              email: event.email, password: event.password);
          if (_loginResult.statusCode == 200) {
            debugPrint("Login success");
            BotToast.showText(text: "Login Successful");
            emit.call(LoginBlocLoaded());

            Get.off(const HomePage());
          } else {
            emit.call(LoginBlocLoaded());
            debugPrint(_loginResult.specificMessage);
            BotToast.showText(
                text:
                    _loginResult.specificMessage ?? " Cannot login right now.");
          }
        }
      },
    );
  }
}
