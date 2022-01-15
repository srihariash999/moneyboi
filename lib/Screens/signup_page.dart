import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneyboi/Blocs/LoginBloc/login_bloc.dart';
import 'package:moneyboi/Constants/colors.dart';
import 'package:moneyboi/Screens/login_page.dart';
import 'package:moneyboi/Widgets/big_bar_button.dart';
import 'package:moneyboi/Widgets/text_field_widget.dart';

class SignupPage extends StatelessWidget {
  SignupPage({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 80.0),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 4.0),
                  child: Text(
                    "Hello there,",
                    style: GoogleFonts.lato(
                      fontSize: 26.0,
                      fontWeight: FontWeight.w600,
                      color: moneyBoyPurple,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 4.0),
                  child: Text(
                    "Enter a few details to create your account",
                    style: GoogleFonts.lato(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: moneyBoyPurple.withOpacity(0.6),
                    ),
                  ),
                ),
                const SizedBox(height: 42.0),
                TextFieldWidget(
                  controller: _nameController,
                  inputType: TextInputType.name,
                  hint: "Enter your full name",
                  label: "Name",
                ),
                const SizedBox(height: 18.0),
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
                const SizedBox(height: 18.0),
                TextFieldWidget(
                  controller: _confirmPasswordController,
                  inputType: TextInputType.visiblePassword,
                  hint: "Enter your password again",
                  label: "Re-Enter Password",
                  obscure: true,
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
                          if (_passwordController.text.trim() ==
                                  _confirmPasswordController.text.trim() &&
                              _nameController.text.trim().isNotEmpty &&
                              _emailController.text.trim().isNotEmpty) {
                            BlocProvider.of<LoginBloc>(context).add(
                              SignupEvent(
                                name: _nameController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                                context: context,
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
                            "SignUp",
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
                      "Already have an account?  ",
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
                            builder: (_) => LoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Login",
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
      ),
    );
  }
}
