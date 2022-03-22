import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneyboi/Blocs/SignupBloc/signupbloc_bloc.dart';
import 'package:moneyboi/Constants/colors.dart';
import 'package:moneyboi/Widgets/text_field_widget.dart';

class SignupEmailWidget extends StatelessWidget {
  final String name;
  SignupEmailWidget({
    Key? key,
    required this.name,
  }) : super(key: key);

  final TextEditingController _emailController = TextEditingController();

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
              BlocProvider.of<SignupBloc>(context).add(MoveToNameEvent());
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
                "Hey $name",
                style: GoogleFonts.lato(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w600,
                  color: moneyBoyPurple,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4.0),
              child: Text(
                "Tell us your email address",
                style: GoogleFonts.lato(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                  color: moneyBoyPurple,
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
                    final regex = RegExp(
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
                    );
                    if (regex.hasMatch(_emailController.text.trim())) {
                      BlocProvider.of<SignupBloc>(context).add(
                        MoveToPasswordEvent(email: _emailController.text),
                      );
                    } else {}
                  },
                  child: const Icon(
                    Icons.chevron_right,
                    size: 38.0,
                  ),
                ),
                Text(
                  "Next",
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
