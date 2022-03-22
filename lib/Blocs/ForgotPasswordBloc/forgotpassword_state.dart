part of 'forgotpassword_bloc.dart';

@immutable
abstract class ForgotPasswordState {}

class ForgotPasswordLoaded extends ForgotPasswordState {
  final bool isEmailState;
  ForgotPasswordLoaded({required this.isEmailState});
}

class ForgotPasswordLoading extends ForgotPasswordState {}
