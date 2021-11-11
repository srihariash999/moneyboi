import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneyboi/Constants/colors.dart';

class ToggleLabel extends StatelessWidget {
  final bool isActive;
  final String label;
  const ToggleLabel({Key? key, required this.isActive, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isActive ? _ActiveLabel(label: label) : _InactiveLabel(label: label);
  }
}

class _ActiveLabel extends StatelessWidget {
  final String label;
  const _ActiveLabel({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
      decoration: BoxDecoration(
        color: moneyBoyPurple,
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 8.0,
            width: 8.0,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InactiveLabel extends StatelessWidget {
  final String label;
  const _InactiveLabel({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Text(
        label,
        style: GoogleFonts.montserrat(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
    );
  }
}
