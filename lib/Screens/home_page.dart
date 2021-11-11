import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneyboi/Constants/colors.dart';
import 'package:moneyboi/Widgets/profile_avatar.dart';
import 'package:moneyboi/Widgets/timewise_expense_list.dart';
import 'package:moneyboi/Widgets/toggle_label.dart';
import 'package:moneyboi/Widgets/total_expenses_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const HomeScreenTopBar(),
            TotalExpensesCard(
              height: MediaQuery.of(context).size.height * 0.22,
              totalExpense: "₹ 5000",
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 24.0, top: 20.0),
              child: Text(
                "Expense Summary",
                style: GoogleFonts.montserrat(
                  fontSize: 20.0,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            const ToggleLabelsRow(),
            TimewiseExpensesList(
              height: MediaQuery.of(context).size.height * 0.38,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: moneyBoyPurple,
        elevation: 1.0,
        child: const Icon(
          Icons.add,
          size: 42.0,
        ),
      ),
    );
  }
}

class ToggleLabelsRow extends StatelessWidget {
  const ToggleLabelsRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        ToggleLabel(
          label: "Weekly",
          isActive: true,
        ),
        ToggleLabel(
          label: "Monthly",
          isActive: false,
        ),
        ToggleLabel(
          label: "All Time",
          isActive: false,
        ),
      ],
    );
  }
}

class HomeScreenTopBar extends StatelessWidget {
  const HomeScreenTopBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const ProfileAvatar(
          profileImage:
              "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=580&q=80",
        ),
        Text(
          "Srihari Ayapilla",
          style: GoogleFonts.montserrat(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: Colors.black.withOpacity(0.8),
          ),
        )
      ],
    );
  }
}
