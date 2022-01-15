part of 'login_bloc.dart';

@immutable
abstract class LoginBlocEvent {}

class LoginEvent extends LoginBlocEvent {
  final String email;
  final String password;
  final BuildContext context;
  LoginEvent(
      {required this.email, required this.password, required this.context});
}

class SignupEvent extends LoginBlocEvent {
  final String name;
  final String email;
  final String password;
  final BuildContext context;
  SignupEvent(
      {required this.name,
      required this.email,
      required this.password,
      required this.context});
}

class LogoutEvent extends LoginBlocEvent {
  final BuildContext context;
  LogoutEvent({required this.context});
}
