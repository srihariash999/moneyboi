import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneyboi/Constants/colors.dart';
import 'package:moneyboi/Constants/enums.dart';
import 'package:moneyboi/Controllers/home_screen_controller.dart';
import 'package:moneyboi/Controllers/previous_expenses_controller.dart';
import 'package:moneyboi/Data%20Models/expense_record.dart';
import 'package:moneyboi/Screens/home/expense_chart_screen.dart';
import 'package:moneyboi/Screens/home/new_expense_category_screen.dart';
import 'package:moneyboi/Widgets/timewise_expense_list.dart';

class PreviousExpensesScreen extends StatelessWidget {
  PreviousExpensesScreen({Key? key}) : super(key: key);
  final controller = Get.find<PreviousExpensesController>();
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _theme.appBarTheme.systemOverlayStyle!,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: _theme.colorScheme.background,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: _theme.colorScheme.background,
            iconTheme: IconThemeData(color: _theme.colorScheme.secondary),
            title: Text(
              'PREVIOUS RECORDS',
              style: GoogleFonts.inter(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: moneyBoyPurple,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  final String st =
                      "${DateFormat('d MMM').format(controller.startDate!)} '${DateFormat('yy').format(controller.startDate!)}";
                  final String end =
                      "${DateFormat('d MMM').format(controller.endDate!)} '${DateFormat('yy').format(controller.endDate!)}";
                  final days =
                      controller.endDate!.difference(controller.startDate!);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExpenseChartScreen(
                        expenseRecordItems: controller.expenses,
                        totalExpense: controller.totalExpense,
                        title: ToggleLabelEnum.monthly,
                        titleText: "$st to $end",
                        days: days.inDays,
                        endDate: controller.endDate!,
                        startDate: controller.startDate!,
                        isPrevious: true,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.pie_chart,
                  color: moneyBoyPurple,
                ),
              ),
              const SizedBox(width: 12.0),
            ],
          ),
          body: GetBuilder<PreviousExpensesController>(
            initState: (state) {
              controller.init();
            },
            builder: (controller) {
              if (controller.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: moneyBoyPurple,
                  ),
                );
              }
              return Column(
                children: [
                  if (controller.startDate != null &&
                      controller.endDate != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "From",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                  color: _theme.colorScheme.secondary
                                      .withOpacity(0.5),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => controller.openDatePicker(
                                  context: context,
                                  theme: _theme,
                                  isStart: true,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: moneyBoyPurple,
                                ),
                                child: Text(
                                  "${DateFormat('d MMM').format(controller.startDate!)} '${DateFormat('yy').format(controller.startDate!)}",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16.0,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.w700,
                                    color: _theme.highlightColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              " <--> ",
                              style: GoogleFonts.montserrat(
                                fontSize: 16.0,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w700,
                                color: _theme.colorScheme.secondary
                                    .withOpacity(0.5),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                "To",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                  color: _theme.colorScheme.secondary
                                      .withOpacity(0.5),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => controller.openDatePicker(
                                  context: context,
                                  theme: _theme,
                                  isStart: false,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: moneyBoyPurple,
                                ),
                                child: Text(
                                  "${DateFormat('d MMM').format(controller.endDate!)} '${DateFormat('yy').format(controller.endDate!)}",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16.0,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.w700,
                                    color: _theme.highlightColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  if (controller.isNewDate)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: ElevatedButton(
                        onPressed: () {
                          controller.searchExpenseRecords();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: moneyBoyPurple,
                        ),
                        child: Text(
                          "Get Records",
                          style: GoogleFonts.montserrat(
                            fontSize: 16.0,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w700,
                            color: _theme.highlightColor,
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: controller.expenses.isEmpty
                        ? Container(
                            alignment: Alignment.center,
                            child: Text(
                              "No Expenses between these days.",
                              style: TextStyle(
                                color: _theme.colorScheme.secondary
                                    .withOpacity(0.7),
                                fontSize: 16.0,
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: controller.searchExpenseRecords,
                            child: ListView.builder(
                              itemCount: controller.expenses.length,
                              itemBuilder: (context, index) {
                                final ExpenseRecordItem _eri =
                                    controller.expenses[index];
                                return Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: ExpandablePanel(
                                    header: Row(
                                      children: [
                                        Image.network(
                                          _eri.category.categoryImage,
                                          height: 45.0,
                                          width: 45.0,
                                          fit: BoxFit.cover,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 18.0,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 6.0,
                                                    bottom: 4.0,
                                                  ),
                                                  child: Text(
                                                    _eri.category.name,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: _theme
                                                          .colorScheme.secondary
                                                          .withOpacity(0.8),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  DateFormat('yMMMd')
                                                      .format(_eri.createdDate),
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w300,
                                                    color: _theme
                                                        .colorScheme.secondary
                                                        .withOpacity(0.4),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 16.0,
                                          ),
                                          child: Text(
                                            "₹ ${_eri.expense}",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w700,
                                              color: moneyBoyPurple,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    collapsed: Container(),
                                    expanded: Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Get.defaultDialog(
                                                backgroundColor: _theme
                                                    .colorScheme.background,
                                                title: "Expense Details",
                                                titleStyle:
                                                    GoogleFonts.montserrat(
                                                  fontSize: 22.0,
                                                  fontWeight: FontWeight.w700,
                                                  color: _theme
                                                      .colorScheme.secondary
                                                      .withOpacity(0.8),
                                                ),
                                                content: Container(
                                                  height: 350.0,
                                                  color: _theme
                                                      .colorScheme.background,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      ExpenseInfoWidget(
                                                        title: "Category",
                                                        value:
                                                            "${_eri.category.name} ",
                                                        color: _theme
                                                            .colorScheme
                                                            .secondary,
                                                      ),
                                                      ExpenseInfoWidget(
                                                        title: "Amount",
                                                        value:
                                                            "₹ ${_eri.expense} ",
                                                        color: _theme
                                                            .colorScheme
                                                            .secondary,
                                                      ),
                                                      ExpenseInfoWidget(
                                                        title: "Remarks",
                                                        value:
                                                            "${_eri.remark} ",
                                                        color: _theme
                                                            .colorScheme
                                                            .secondary,
                                                      ),
                                                      ExpenseInfoWidget(
                                                        title: "Added on ",
                                                        value: DateFormat(
                                                          'yMMMd',
                                                        ).format(
                                                          _eri.createdDate,
                                                        ),
                                                        color: _theme
                                                            .colorScheme
                                                            .secondary,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              CupertinoIcons.info,
                                              size: 36.0,
                                              color: moneyBoyPurple,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      NewExpenseCategoryScreen(
                                                    isUpdate: true,
                                                    expenseItem: _eri,
                                                  ),
                                                ),
                                              );
                                              controller.searchExpenseRecords();
                                            },
                                            icon: const Icon(
                                              CupertinoIcons.pencil_circle,
                                              size: 36.0,
                                              color: moneyBoyPurpleLight,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Get.find<HomeScreenController>()
                                                  .deleteExpenseRecord(
                                                id: _eri.id,
                                              );
                                            },
                                            icon: Icon(
                                              CupertinoIcons.trash_circle,
                                              size: 36.0,
                                              color:
                                                  Colors.red.withOpacity(0.7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
