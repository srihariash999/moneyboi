import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneyboi/Controllers/forgot_password_controller.dart';
import 'package:moneyboi/Widgets/big_bar_button.dart';
import 'package:moneyboi/Widgets/text_field_widget.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordConfirmController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: GetBuilder<ForgotPasswordController>(
        builder: (controller) {
          if (controller.isLoading == false) {
            if (controller.isEmailState) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 42.0),
                      Text(
                        "Forgot your password?",
                        style: GoogleFonts.sen(
                          fontSize: 28.0,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w700,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 42.0),
                      Text(
                        "Don't worry, happens to the best of us.Tell us your registered email address and we'll help you reset it.",
                        style: GoogleFonts.sen(
                          fontSize: 18.0,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      TextFieldWidget(
                        horizontalMargin: 0,
                        controller: _emailController,
                        inputType: TextInputType.emailAddress,
                        hint: "Enter your email address",
                        label: "Email",
                      ),
                      const SizedBox(height: 46.0),
                      GestureDetector(
                        onTap: () async {
                          if (_emailController.text.trim().isNotEmpty) {
                            final regex = RegExp(
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
                            );
                            if (regex.hasMatch(_emailController.text.trim())) {
                              controller.generateForgotPasswordOTPEvent(
                                email: _emailController.text.trim(),
                              );
                              // context.read<ForgotPasswordBloc>().add(
                              //       GenerateForgotPasswordOTPEvent(
                              //         email: _emailController.text.trim(),
                              //       ),
                              //     );
                            } else {
                              BotToast.showText(
                                text: "Fill in a valid email address",
                              );
                            }
                          } else {
                            BotToast.showText(
                              text: "Fill in a valid email address",
                            );
                          }
                        },
                        child: BigBarButtonBody(
                          horizontalPadding: 60.0,
                          borderRadius: 30.0,
                          child: Text(
                            "Submit",
                            style: GoogleFonts.lato(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 42.0),
                      Text(
                        "Check your email ${_emailController.text.trim()} for a One-Time Passcode.",
                        style: GoogleFonts.sen(
                          fontSize: 18.0,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      TextFieldWidget(
                        horizontalMargin: 0,
                        controller: _otpController,
                        inputType: TextInputType.number,
                        hint: "Enter the OTP sent to your email",
                        label: "OTP",
                      ),
                      const SizedBox(height: 28.0),
                      TextFieldWidget(
                        horizontalMargin: 0,
                        controller: _newPasswordController,
                        inputType: TextInputType.visiblePassword,
                        hint: "Enter a new password",
                        label: "New Password",
                        obscure: true,
                      ),
                      const SizedBox(height: 28.0),
                      TextFieldWidget(
                        horizontalMargin: 0,
                        controller: _newPasswordConfirmController,
                        inputType: TextInputType.visiblePassword,
                        hint: "Confirm your new password",
                        label: "Confirm New Password",
                        obscure: true,
                      ),
                      const SizedBox(height: 46.0),
                      GestureDetector(
                        onTap: () async {
                          if (_newPasswordController.text.trim().isNotEmpty &&
                              _otpController.text.trim().isNotEmpty &&
                              _newPasswordConfirmController.text.trim() ==
                                  _newPasswordController.text.trim()) {
                            controller.verifyForgotPasswordOTPEvent(
                              email: _emailController.text.trim(),
                              otp: _otpController.text.trim(),
                              newPassword: _newPasswordController.text.trim(),
                            );
                            // context.read<ForgotPasswordBloc>().add(
                            //       VerifyForgotPasswordOTPEvent(
                            //         email: _emailController.text.trim(),
                            //         otp: _otpController.text.trim(),
                            //         newPassword:
                            //             _newPasswordController.text.trim(),
                            //       ),
                            //     );
                          } else {
                            BotToast.showText(
                              text: "Fill in all required fields",
                            );
                          }
                        },
                        child: BigBarButtonBody(
                          horizontalPadding: 60.0,
                          borderRadius: 30.0,
                          child: Text(
                            "Submit",
                            style: GoogleFonts.lato(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
