import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneyboi/Constants/colors.dart';
import 'package:moneyboi/Constants/enums.dart';
import 'package:moneyboi/Controllers/home_screen_controller.dart';
import 'package:moneyboi/Controllers/login_controller.dart';
import 'package:moneyboi/Controllers/profile_controller.dart';
import 'package:moneyboi/Screens/home/expense_chart_screen.dart';
import 'package:moneyboi/Screens/home/new_expense_category_screen.dart';
import 'package:moneyboi/Screens/profile/profile_page.dart';
import 'package:moneyboi/Screens/repayments/repayments_main_screen.dart';
import 'package:moneyboi/Widgets/timewise_expense_list.dart';
import 'package:moneyboi/Widgets/toggle_label.dart';
import 'package:moneyboi/Widgets/total_expenses_card.dart';

class HomePage extends StatelessWidget {
  const HomePage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const HomeScreenTopBar(),
              Padding(
                padding: const EdgeInsets.only(
                  top: 4.0,
                  left: 12.0,
                  right: 12.0,
                ),
                child: GestureDetector(
                  onTap: () {
                    Get.to(
                      const RepaymentsMainScreen(),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/repay_logo.png",
                          height: 64.0,
                          width: MediaQuery.of(context).size.width * 0.2,
                          fit: BoxFit.contain,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Introducing Repay by Moneyboi",
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                "Now keep track of all your exchanges with your friends at one place.",
                                maxLines: 3,
                                softWrap: true,
                                overflow: TextOverflow.fade,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 24.0, top: 12.0),
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
              GetBuilder<HomeScreenController>(
                initState: (state) {
                  Get.find<HomeScreenController>().getExpenseRecords(
                    ToggleLabelEnum.weekly,
                    init: true,
                  );
                  Get.find<ProfileController>().getUserProfileAndFriendData();
                },
                builder: (controller) => Column(
                  children: [
                    if (controller.isHomeloading.value)
                      TotalExpensesCard(
                        height: MediaQuery.of(context).size.height * 0.22,
                        totalExpense: "₹ ---",
                        period: controller.toggleEnum.value.name == 'weekly'
                            ? 'Weekly'
                            : controller.toggleEnum.value.name == 'monthly'
                                ? 'Monthly'
                                : 'All Time',
                      ),
                    if (!controller.isHomeloading.value)
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            ExpenseChartScreen(
                              expenseRecordItem: controller.expenseRecords,
                              totalExpense: controller.totExp.value,
                              title:
                                  controller.toggleEnum.value.name == 'weekly'
                                      ? 'Weekly'
                                      : controller.toggleEnum.value.name ==
                                              'monthly'
                                          ? 'Monthly'
                                          : 'All Time',
                            ),
                          );
                        },
                        child: TotalExpensesCard(
                          height: MediaQuery.of(context).size.height * 0.22,
                          totalExpense: "₹ ${controller.totExp}",
                          period: controller.toggleEnum.value.name == 'weekly'
                              ? 'Weekly'
                              : controller.toggleEnum.value.name == 'monthly'
                                  ? 'Monthly'
                                  : 'All Time',
                        ),
                      ),
                    if (!controller.isHomeloading.value)
                      ToggleLabelsRow(
                        toggleLabel: controller.toggleEnum.value,
                      ),
                    if (!controller.isHomeloading.value)
                      TimewiseExpensesList(
                        height: MediaQuery.of(context).size.height * 0.38,
                        listOfExpenses: controller.expenseRecords,
                        refreshFunction: () async {
                          controller.getExpenseRecords(
                            controller.toggleEnum.value,
                            init: true,
                          );
                        },
                      ),
                    if (controller.isHomeloading.value)
                      Container(
                        height: MediaQuery.of(context).size.height * 0.38,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          color: moneyBoyPurple,
                        ),
                      )
                  ],
                ),
              ),
              const SizedBox(height: 12.0),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewExpenseCategoryScreen(
                isUpdate: false,
              ),
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
            Get.find<HomeScreenController>().getExpenseRecords(
              ToggleLabelEnum.weekly,
              init: false,
            );
          },
          child: ToggleLabel(
            label: "Weekly",
            isActive: toggleLabel == ToggleLabelEnum.weekly,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.find<HomeScreenController>().getExpenseRecords(
              ToggleLabelEnum.monthly,
              init: false,
            );
          },
          child: ToggleLabel(
            label: "Monthly",
            isActive: toggleLabel == ToggleLabelEnum.monthly,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.find<HomeScreenController>().getExpenseRecords(
              ToggleLabelEnum.allTime,
              init: false,
            );
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
        GetBuilder<ProfileController>(
          builder: (controller) {
            if (!controller.isProfileLoading.value) {
              return Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(),
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
                        controller.name(),
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
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.to(
                  const RepaymentsMainScreen(),
                );
              },
              child: Image.asset(
                'assets/repay_logo.png',
                height: 32.0,
                width: 64.0,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                onPressed: () async {
                  Get.find<LoginController>().userLogout();
                },
                icon: const Icon(
                  Icons.logout,
                  color: moneyBoyPurple,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
