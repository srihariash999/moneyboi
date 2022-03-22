import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneyboi/Constants/colors.dart';

class TotalExpensesCard extends StatelessWidget {
  final double height;
  final String totalExpense;
  final String period;
  const TotalExpensesCard({
    Key? key,
    required this.height,
    required this.totalExpense,
    required this.period,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
      width: double.maxFinite,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(-3.0, 5.0),
            blurRadius: 10.0,
            spreadRadius: 1.2,
          )
        ],
        borderRadius: BorderRadius.circular(16.0),
        color: moneyBoyPurple,
      ),
      child: Stack(
        children: [
          Container(
            height: height * 0.8,
            width: double.maxFinite,
            alignment: Alignment.topLeft,
            child: Container(
              height: height * 0.9,
              width: height + 24,
              decoration: const BoxDecoration(
                color: moneyBoyPurpleLight,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(38.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          totalExpense,
                          style: GoogleFonts.montserrat(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        "$period Expenses",
                        style: GoogleFonts.montserrat(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Image.asset(
                    "assets/salary.png",
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
