import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneyboi/Blocs/SignupBloc/signupbloc_bloc.dart';
import 'package:moneyboi/Constants/colors.dart';
import 'package:moneyboi/Screens/login_page.dart';
import 'package:moneyboi/Widgets/text_field_widget.dart';

class SignupNameWidget extends StatelessWidget {
  SignupNameWidget({
    Key? key,
  }) : super(key: key);

  final TextEditingController _nameController = TextEditingController();

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
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LoginPage(),
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
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4.0),
              child: Text(
                "Hello there,",
                style: GoogleFonts.lato(
                  fontSize: 34.0,
                  fontWeight: FontWeight.w600,
                  color: moneyBoyPurple,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4.0),
              child: Text(
                "What do we call you?",
                style: GoogleFonts.lato(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: moneyBoyPurple,
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
                    BlocProvider.of<SignupBloc>(context)
                        .add(MoveToEmailEvent(name: _nameController.text));
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
