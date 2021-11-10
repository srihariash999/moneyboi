import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneyboi/Data%20Models/expense_record.dart';
import 'package:moneyboi/Mock%20Data/mock_expense_record.dart';

class TimewiseExpensesList extends StatelessWidget {
  const TimewiseExpensesList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 12.0, right: 12.0),
        child: ListView.builder(
            itemCount: listOfExpenses.length,
            itemBuilder: (context, index) {
              final ExpenseRecordItem _eri = listOfExpenses[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image.asset(
                      _eri.category.categoryImage,
                      height: 45.0,
                      width: 45.0,
                      fit: BoxFit.cover,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 6.0, bottom: 4.0),
                              child: Text(
                                _eri.category.name,
                                style: GoogleFonts.montserrat(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                            ),
                            Text(
                              DateFormat('yMMMd').format(_eri.createdDate),
                              style: GoogleFonts.montserrat(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w300,
                                color: Colors.black.withOpacity(0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text(
                        "₹ ${_eri.expense}",
                        style: GoogleFonts.montserrat(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF7A69EA),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
