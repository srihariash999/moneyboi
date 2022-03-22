import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneyboi/Constants/colors.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    Key? key,
    required this.controller,
    this.horizontalPadding,
    this.inputType,
    this.hint,
    this.label,
    this.obscure,
  }) : super(key: key);
  final TextEditingController controller;
  final double? horizontalPadding;
  final TextInputType? inputType;
  final String? label;
  final String? hint;
  final bool? obscure;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: moneyBoyPurpleLight.withOpacity(0.2),
        borderRadius: BorderRadius.circular(18.0),
      ),
      padding: const EdgeInsets.only(left: 12.0),
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 30.0),
      child: Theme(
        data: ThemeData(
          primaryColor: moneyBoyPurple,
        ),
        child: TextField(
          controller: controller,
          keyboardType: inputType,
          obscureText: obscure ?? false,
          obscuringCharacter: "*",
          style: GoogleFonts.lato(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: moneyBoyPurple.withOpacity(0.8),
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: hint,
            labelText: label,
            labelStyle: GoogleFonts.lato(
              fontWeight: FontWeight.w600,
              color: moneyBoyPurple.withOpacity(0.8),
            ),
            hintStyle: GoogleFonts.lato(
              fontWeight: FontWeight.w400,
              fontSize: 14.0,
              color: moneyBoyPurple.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
}
