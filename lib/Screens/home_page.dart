import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:moneyboi/Blocs/HomeScreenBloc/homescreen_bloc.dart';
import 'package:moneyboi/Blocs/ProfileBloc/profile_bloc.dart';
import 'package:moneyboi/Constants/colors.dart';
import 'package:moneyboi/Constants/enums.dart';
import 'package:moneyboi/Screens/expense_chart_screen.dart';
import 'package:moneyboi/Screens/login_page.dart';
import 'package:moneyboi/Screens/new_expense_category_screen.dart';
import 'package:moneyboi/Screens/profile_page.dart';
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
    BlocProvider.of<ProfileBloc>(context).add(GetUserProfileEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const HomeScreenTopBar(),
            BlocBuilder<HomeScreenBloc, HomeScreenState>(
              builder: (context, state) {
                if (state is HomeScreenLoaded) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(ExpenseChartScreen(
                        expenseRecordItem: state.expenseRecords,
                        totalExpense: state.totalExpense,
                        title: state.toggleLabel.name == 'weekly'
                            ? 'Weekly'
                            : state.toggleLabel.name == 'monthly'
                                ? 'Monthly'
                                : 'All Time',
                      ));
                    },
                    child: TotalExpensesCard(
                      height: MediaQuery.of(context).size.height * 0.22,
                      totalExpense: "₹ ${state.totalExpense}",
                      period: state.toggleLabel.name == 'weekly'
                          ? 'Weekly'
                          : state.toggleLabel.name == 'monthly'
                              ? 'Monthly'
                              : 'All Time',
                    ),
                  );
                } else {
                  return TotalExpensesCard(
                    height: MediaQuery.of(context).size.height * 0.22,
                    totalExpense: "₹ 0",
                    period: ' -- ',
                  );
                }
              },
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
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.38,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      color: moneyBoyPurple,
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewExpenseCategoryScreen(),
            ),
          );
        },
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
        BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoaded) {
              return Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        child: const Icon(
                          Icons.person,
                          color: moneyBoyPurple,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        state.name,
                        style: GoogleFonts.montserrat(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Container(
                margin: const EdgeInsets.only(left: 20.0),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.3,
                child: const LinearProgressIndicator(
                  color: moneyBoyPurple,
                ),
              );
            }
          },
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
