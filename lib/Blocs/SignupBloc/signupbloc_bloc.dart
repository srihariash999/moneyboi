import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
// import 'package:moneyboi/Blocs/LoginBloc/login_bloc.dart';
import 'package:moneyboi/Data%20Models/api_response_model.dart';
import 'package:moneyboi/Network/network_service.dart';
import 'package:moneyboi/Screens/login_page.dart';

part 'signupbloc_event.dart';
part 'signupbloc_state.dart';

final NetworkService _apiService = NetworkService();
String _name = 'sss';
String _email = '';

class SignupBloc extends Bloc<SignupBlocEvent, SignupBlocState> {
  SignupBloc() : super(SignupBlocInitial()) {
    on<SignupBlocEvent>((event, emit) async {
      if (event is MoveToNameEvent) {
        emit.call(SignupBlocInitial());
      } else if (event is MoveToEmailEvent) {
        _name = event.name;
        emit.call(SignupBlocEmailState(name: _name));
      } else if (event is MoveToPasswordEvent) {
        _email = event.email;
        emit.call(SignupBlocPasswordState(email: _email, name: _name));
      } else if (event is SignupEvent) {
        emit.call(SignupBlocLoadingState());
        print("name : $_name, email: $_email password:${event.password}");
        final ApiResponseModel _signUpResult = await _apiService.signup(
            name: _name, email: _email, password: event.password);
        if (_signUpResult.statusCode == 200) {
          debugPrint("signup success");

          emit.call(SignupBlocInitial());
          BotToast.showText(text: "SignUp Successful");
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            event.context,
            MaterialPageRoute(
              builder: (_) => LoginPage(),
            ),
          );
        } else {
          emit.call(SignupBlocInitial());
          debugPrint(_signUpResult.specificMessage);
          BotToast.showText(
              text: _signUpResult.specificMessage ?? " Cannot sign you up");
        }
      }
    });
  }
}
