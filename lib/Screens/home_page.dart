import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:moneyboi/Blocs/HomeScreenBloc/homescreen_bloc.dart';
import 'package:moneyboi/Constants/colors.dart';
import 'package:moneyboi/Constants/enums.dart';
import 'package:moneyboi/Screens/login_page.dart';
import 'package:moneyboi/Widgets/profile_avatar.dart';
import 'package:moneyboi/Widgets/timewise_expense_list.dart';
import 'package:moneyboi/Widgets/toggle_label.dart';
import 'package:moneyboi/Widgets/total_expenses_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    BlocProvider.of<HomeScreenBloc>(context).add(GetExpenseRecordsEvent(
      toggleLabel: ToggleLabelEnum.weekly,
    ));
    super.initState();
  }

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
            BlocBuilder<HomeScreenBloc, HomeScreenState>(
              builder: (context, state) {
                if (state is HomeScreenLoaded) {
                  return Column(
                    children: [
                      ToggleLabelsRow(
                        toggleLabel: state.toggleLabel,
                      ),
                      TimewiseExpensesList(
                        height: MediaQuery.of(context).size.height * 0.38,
                        listOfExpenses: state.expenseRecords,
                        refreshFunction: () async {
                          BlocProvider.of<HomeScreenBloc>(context)
                              .add(GetExpenseRecordsEvent(
                            toggleLabel: state.toggleLabel,
                          ));
                        },
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              },
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
  final ToggleLabelEnum toggleLabel;
  const ToggleLabelsRow({
    Key? key,
    required this.toggleLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            BlocProvider.of<HomeScreenBloc>(context).add(GetExpenseRecordsEvent(
              toggleLabel: ToggleLabelEnum.weekly,
            ));
          },
          child: ToggleLabel(
            label: "Weekly",
            isActive: toggleLabel == ToggleLabelEnum.weekly,
          ),
        ),
        GestureDetector(
          onTap: () {
            BlocProvider.of<HomeScreenBloc>(context).add(GetExpenseRecordsEvent(
              toggleLabel: ToggleLabelEnum.monthly,
            ));
          },
          child: ToggleLabel(
            label: "Monthly",
            isActive: toggleLabel == ToggleLabelEnum.monthly,
          ),
        ),
        GestureDetector(
          onTap: () {
            BlocProvider.of<HomeScreenBloc>(context).add(GetExpenseRecordsEvent(
              toggleLabel: ToggleLabelEnum.allTime,
            ));
          },
          child: ToggleLabel(
            label: "All Time",
            isActive: toggleLabel == ToggleLabelEnum.allTime,
          ),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
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
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            onPressed: () async {
              final Box _authBox = Hive.box('authBox');
              await _authBox.clear();
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
              // ignore: use_build_context_synchronously
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LoginPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.logout,
              color: moneyBoyPurple,
            ),
          ),
        ),
      ],
    );
  }
}
