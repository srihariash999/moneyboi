import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneyboi/Constants/colors.dart';
import 'package:moneyboi/Constants/enums.dart';
import 'package:moneyboi/Controllers/hive_controller.dart';
import 'package:moneyboi/Controllers/home_screen_controller.dart';
import 'package:moneyboi/Controllers/login_controller.dart';
import 'package:moneyboi/Controllers/profile_controller.dart';
import 'package:moneyboi/Screens/home/expense_chart_screen.dart';
import 'package:moneyboi/Screens/home/new_expense_category_screen.dart';
import 'package:moneyboi/Screens/previous/previous_expenses_screen.dart';
import 'package:moneyboi/Screens/profile/profile_page.dart';
import 'package:moneyboi/Screens/repayments/repayments_main_screen.dart';
import 'package:moneyboi/Widgets/timewise_expense_list.dart';
import 'package:moneyboi/Widgets/toggle_label.dart';
import 'package:moneyboi/Widgets/total_expenses_card.dart';

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _hiveService = Get.find<HiveService>();
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _theme.appBarTheme.systemOverlayStyle!,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: _theme.backgroundColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                const HomeScreenTopBar(),
                GetBuilder<HiveService>(
                  builder: (controller) {
                    if (!controller.getBannerDismissable) {
                      return Container();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 4.0,
                        left: 12.0,
                        right: 12.0,
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const RepaymentsMainScreen(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          padding: const EdgeInsets.only(
                            top: 8.0,
                            bottom: 18.0,
                            left: 12.0,
                            right: 12.0,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _hiveService.setBannerDismissable(
                                        value: false,
                                      );
                                    },
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Icon(
                                        Icons.close,
                                        size: 16.0,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      18.0,
                                    ),
                                    child: Image.asset(
                                      "assets/repay_logo.png",
                                      height: 58.0,
                                      width: 64.0,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Introducing Repay by Moneyboi",
                                          overflow: TextOverflow.fade,
                                          softWrap: false,
                                          style: GoogleFonts.lato(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: _theme.colorScheme.secondary
                                                .withOpacity(0.8),
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
                                            color: _theme.colorScheme.secondary
                                                .withOpacity(0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
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
                      color: _theme.colorScheme.secondary.withOpacity(0.8),
                    ),
                  ),
                ),
                GetBuilder<HomeScreenController>(
                  initState: (state) {
                    Get.find<HomeScreenController>().getExpenseRecords(
                      ToggleLabelEnum.daily,
                      init: true,
                    );
                    Get.find<HomeScreenController>().getFcmToken();
                    Get.find<ProfileController>().getUserProfileAndFriendData();
                  },
                  builder: (controller) => Column(
                    children: [
                      if (controller.isHomeloading.value)
                        TotalExpensesCard(
                          height: MediaQuery.of(context).size.height * 0.22,
                          totalExpense: "₹ ---",
                          period: toggleLabelEnumToString(
                            controller.toggleEnum.value,
                          ),
                        ),
                      if (!controller.isHomeloading.value)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExpenseChartScreen(
                                  expenseRecordItems: controller.expenseRecords,
                                  totalExpense: controller.totExp.value,
                                  title: controller.toggleEnum.value,
                                  endDate: DateTime.now(),
                                  startDate: controller.getDurationDateTime(
                                    controller.toggleEnum.value,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: TotalExpensesCard(
                            height: MediaQuery.of(context).size.height * 0.22,
                            totalExpense: "₹ ${controller.totExp}",
                            period: toggleLabelEnumToString(
                              controller.toggleEnum.value,
                            ),
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
            child: Icon(
              Icons.add,
              size: 42.0,
              color: _theme.backgroundColor.withOpacity(0.7),
            ),
          ),
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
              ToggleLabelEnum.daily,
              init: false,
            );
          },
          child: ToggleLabel(
            label: "Daily",
            isActive: toggleLabel == ToggleLabelEnum.daily,
          ),
        ),
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
    final ThemeData _theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GetBuilder<ProfileController>(
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
                          backgroundColor:
                              _theme.colorScheme.secondary.withOpacity(0.1),
                          child: const Icon(
                            Icons.person,
                            color: moneyBoyPurple,
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Text(
                            controller.name(),
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: GoogleFonts.montserrat(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                              color:
                                  _theme.colorScheme.secondary.withOpacity(0.8),
                            ),
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
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PreviousExpensesScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.history,
                  size: 30.0,
                  color: moneyBoyPurple,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RepaymentsMainScreen(),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/repay_logo.png',
                  height: 31.0,
                  width: 31.0,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 16.0,
                left: 8.0,
              ),
              child: IconButton(
                onPressed: () async {
                  Get.find<LoginController>().userLogout();
                },
                icon: const Icon(
                  Icons.logout,
                  color: moneyBoyPurple,
                  size: 30.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
