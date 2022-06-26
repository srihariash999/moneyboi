import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneyboi/Constants/colors.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    Key? key,
    required this.controller,
    this.horizontalMargin,
    this.verticalPadding,
    this.inputType,
    this.hint,
    this.label,
    this.obscure,
    this.fontSize,
    this.hintFontSize,
  }) : super(key: key);
  final TextEditingController controller;
  final double? horizontalMargin;
  final double? verticalPadding;
  final TextInputType? inputType;
  final String? label;
  final String? hint;
  final bool? obscure;
  final double? fontSize;
  final double? hintFontSize;
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: moneyBoyPurpleLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(18.0),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: verticalPadding ?? 0.0,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: horizontalMargin ?? 30.0,
      ),
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
            fontSize: fontSize ?? 18.0,
            fontWeight: FontWeight.w600,
            color: _theme.colorScheme.secondary,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: hint,
            labelText: label,
            labelStyle: GoogleFonts.lato(
              fontWeight: FontWeight.w600,
              color: _theme.colorScheme.secondary.withOpacity(0.5),
            ),
            hintStyle: GoogleFonts.lato(
              fontWeight: FontWeight.w400,
              fontSize: hintFontSize ?? 14.0,
              color: _theme.colorScheme.secondary.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
}
