part of 'forgotpassword_bloc.dart';

@immutable
abstract class ForgotPasswordEvent {}

class GenerateForgotPasswordOTPEvent extends ForgotPasswordEvent {
  final String email;
  GenerateForgotPasswordOTPEvent({required this.email});
}

class VerifyForgotPasswordOTPEvent extends ForgotPasswordEvent {
  final String email;
  final String otp;
  final String newPassword;
  VerifyForgotPasswordOTPEvent({
    required this.email,
    required this.newPassword,
    required this.otp,
  });
}
