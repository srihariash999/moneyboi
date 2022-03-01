import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneyboi/Blocs/LoginBloc/login_bloc.dart';
import 'package:moneyboi/Constants/colors.dart';
import 'package:moneyboi/Screens/forgot_password_screen.dart';
import 'package:moneyboi/Screens/signup/signup_page.dart';
import 'package:moneyboi/Widgets/big_bar_button.dart';
import 'package:moneyboi/Widgets/text_field_widget.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginBloc(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4.0),
                child: Text(
                  "Welcome Back",
                  style: GoogleFonts.lato(
                    fontSize: 26.0,
                    fontWeight: FontWeight.w600,
                    color: moneyBoyPurple,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4.0),
                child: Text(
                  "Login to your account",
                  style: GoogleFonts.lato(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: moneyBoyPurple.withOpacity(0.6),
                  ),
                ),
              ),
              const SizedBox(height: 42.0),
              TextFieldWidget(
                controller: _emailController,
                inputType: TextInputType.emailAddress,
                hint: "Enter your email address",
                label: "Email",
              ),
              const SizedBox(height: 18.0),
              TextFieldWidget(
                controller: _passwordController,
                inputType: TextInputType.visiblePassword,
                hint: "Enter your password",
                label: "Password",
                obscure: true,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(ForgotPasswordScreen());
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 30.0, top: 12.0),
                    child: Text(
                      "Forgot password?",
                      style: GoogleFonts.lato(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: moneyBoyPurple.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 52.0),
              BlocBuilder<LoginBloc, LoginBlocState>(
                builder: (context, state) {
                  if (state is LoginBlocLoading) {
                    return const BigBarButtonBody(
                      horizontalPadding: 60.0,
                      borderRadius: 30.0,
                      child: LinearProgressIndicator(
                        color: Colors.white,
                        backgroundColor: moneyBoyPurple,
                      ),
                    );
                  } else {
                    return GestureDetector(
                      onTap: () async {
                        if (_emailController.text.trim().isNotEmpty &&
                            _passwordController.text.trim().isNotEmpty) {
                          BlocProvider.of<LoginBloc>(context).add(
                            LoginEvent(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            ),
                          );
                        } else {
                          BotToast.showText(
                              text: "Fill in all the details properly");
                        }
                      },
                      child: BigBarButtonBody(
                        horizontalPadding: 60.0,
                        borderRadius: 30.0,
                        child: Text(
                          "Login",
                          style: GoogleFonts.lato(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account ?  ",
                    style: GoogleFonts.lato(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: moneyBoyPurpleLight.withOpacity(0.7),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignupPage(),
                        ),
                      );
                    },
                    child: Text(
                      "SignUp",
                      style: GoogleFonts.lato(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: moneyBoyPurple.withOpacity(.8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
