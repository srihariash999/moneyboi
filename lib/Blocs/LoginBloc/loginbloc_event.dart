part of 'login_bloc.dart';

@immutable
abstract class LoginBlocEvent {}

class LoginEvent extends LoginBlocEvent {
  final String email;
  final String password;

  LoginEvent({
    required this.email,
    required this.password,
  });
}

class LogoutEvent extends LoginBlocEvent {
  final BuildContext context;
  LogoutEvent({required this.context});
}
