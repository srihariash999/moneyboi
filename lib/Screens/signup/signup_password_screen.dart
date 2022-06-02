import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneyboi/Blocs/SignupBloc/signupbloc_bloc.dart';
import 'package:moneyboi/Constants/colors.dart';
import 'package:moneyboi/Widgets/text_field_widget.dart';

class SignupPasswordWidget extends StatelessWidget {
  final String name;
  final String email;
  SignupPasswordWidget({
    Key? key,
    required this.name,
    required this.email,
  }) : super(key: key);

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: TextButton(
            style: TextButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: moneyBoyPurple.withOpacity(0.3),
            ),
            onPressed: () {
              BlocProvider.of<SignupBloc>(context).add(
                MoveToEmailEvent(
                  name: name,
                ),
              );
            },
            child: const Icon(
              Icons.chevron_left,
              size: 38.0,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
              child: Text(
                "Set your password",
                style: GoogleFonts.lato(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w600,
                  color: moneyBoyPurple,
                ),
              ),
            ),
            const SizedBox(height: 42.0),
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
              hint: "Confirm your password",
              label: "Confirm Password",
              obscure: true,
            ),
            const SizedBox(height: 52.0),
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Column(
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: moneyBoyPurple.withOpacity(0.3),
                  ),
                  onPressed: () {
                    if (_passwordController.text ==
                            _confirmPasswordController.text &&
                        _passwordController.text.trim().isNotEmpty) {
                      BlocProvider.of<SignupBloc>(context).add(
                        SignupEvent(
                          password: _passwordController.text,
                        ),
                      );
                    }
                  },
                  child: const Icon(
                    Icons.chevron_right,
                    size: 38.0,
                  ),
                ),
                Text(
                  "Submit",
                  style: GoogleFonts.lato(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: moneyBoyPurple,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
