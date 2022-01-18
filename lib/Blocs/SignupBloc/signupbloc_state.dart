part of 'signupbloc_bloc.dart';

@immutable
abstract class SignupBlocState {}

class SignupBlocInitial extends SignupBlocState {}

class SignupBlocEmailState extends SignupBlocState {
  final String name;
  SignupBlocEmailState({
    required this.name,
  });
}

class SignupBlocPasswordState extends SignupBlocState {
  final String name;
  final String email;
  SignupBlocPasswordState({
    required this.name,
    required this.email,
  });
}

class SignupBlocLoadingState extends SignupBlocState {}
