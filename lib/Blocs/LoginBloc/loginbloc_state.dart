part of 'login_bloc.dart';

@immutable
abstract class LoginBlocState {}

class LoginBlocInitial extends LoginBlocState {}

class LoginBlocLoading extends LoginBlocState {}

class LoginBlocLoaded extends LoginBlocState {}

class LoginBlocError extends LoginBlocState {}

