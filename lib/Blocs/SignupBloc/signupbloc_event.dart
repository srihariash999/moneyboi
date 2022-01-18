part of 'signupbloc_bloc.dart';

@immutable
abstract class SignupBlocEvent {}

class MoveToNameEvent extends SignupBlocEvent {}

class MoveToEmailEvent extends SignupBlocEvent {
  final String name;

  MoveToEmailEvent({required this.name});
}

class MoveToPasswordEvent extends SignupBlocEvent {
  final String email;

  MoveToPasswordEvent({required this.email});
}

class SignupEvent extends SignupBlocEvent {
  final String password;
  final BuildContext context;
  SignupEvent({required this.password, required this.context});
}
