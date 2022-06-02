import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyboi/Blocs/SignupBloc/signupbloc_bloc.dart';
import 'package:moneyboi/Constants/colors.dart';
import 'package:moneyboi/Screens/signup/signup_email_screen.dart';
import 'package:moneyboi/Screens/signup/signup_name_screen.dart';
import 'package:moneyboi/Screens/signup/signup_password_screen.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _confirmPasswordController =
  //     TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<SignupBloc, SignupBlocState>(
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: state is SignupBlocInitial
                  ? SignupNameWidget()
                  : state is SignupBlocEmailState
                      ? SignupEmailWidget(name: state.name)
                      : state is SignupBlocPasswordState
                          ? SignupPasswordWidget(
                              name: state.name,
                              email: state.email,
                            )
                          : state is SignupBlocLoadingState
                              ? Container(
                                  alignment: Alignment.center,
                                  child: const CircularProgressIndicator(
                                    color: moneyBoyPurple,
                                  ),
                                )
                              : Container(),
            );
          },
        ),
      ),
    );
  }
}

  //  BlocBuilder<LoginBloc, LoginBlocState>(
  //           builder: (context, state) {
  //             if (state is LoginBlocLoading) {
  //               return const BigBarButtonBody(
  //                 horizontalPadding: 60.0,
  //                 borderRadius: 30.0,
  //                 child: LinearProgressIndicator(
  //                   color: Colors.white,
  //                   backgroundColor: moneyBoyPurple,
  //                 ),
  //               );
  //             } else {
  //               return GestureDetector(
  //                 onTap: () async {
  //                   if (_passwordController.text.trim() ==
  //                           _confirmPasswordController.text.trim() &&
  //                       _nameController.text.trim().isNotEmpty &&
  //                       _emailController.text.trim().isNotEmpty) {
  //                     BlocProvider.of<LoginBloc>(context).add(
  //                       SignupEvent(
  //                         name: _nameController.text.trim(),
  //                         email: _emailController.text.trim(),
  //                         password: _passwordController.text.trim(),
  //                         context: context,
  //                       ),
  //                     );
  //                   } else {
  //                     BotToast.showText(
  //                         text: "Fill in all the details properly");
  //                   }
  //                 },
  //                 child: BigBarButtonBody(
  //                   horizontalPadding: 60.0,
  //                   borderRadius: 30.0,
  //                   child: Text(
  //                     "SignUp",
  //                     style: GoogleFonts.lato(
  //                       fontSize: 20.0,
  //                       fontWeight: FontWeight.w600,
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             }
  //           },
  //         ),


//  const SizedBox(height: 16.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Already have an account?  ",
//                     style: GoogleFonts.lato(
//                       fontSize: 14.0,
//                       fontWeight: FontWeight.w600,
//                       color: moneyBoyPurpleLight.withOpacity(0.7),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () async {
//                       Navigator.pop(context);
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => LoginPage(),
//                         ),
//                       );
//                     },
//                     child: Text(
//                       "Login",
//                       style: GoogleFonts.lato(
//                         fontSize: 14.0,
//                         fontWeight: FontWeight.w700,
//                         color: moneyBoyPurple.withOpacity(.8),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
