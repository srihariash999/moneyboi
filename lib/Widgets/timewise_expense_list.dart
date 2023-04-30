import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneyboi/Constants/colors.dart';
import 'package:moneyboi/Controllers/home_screen_controller.dart';
import 'package:moneyboi/Data%20Models/expense_record.dart';
import 'package:moneyboi/Screens/home/new_expense_category_screen.dart';

class TimewiseExpensesList extends StatelessWidget {
  final double height;
  final List<ExpenseRecordItem> listOfExpenses;
  final Future<void> Function() refreshFunction;
  const TimewiseExpensesList({
    Key? key,
    required this.listOfExpenses,
    required this.height,
    required this.refreshFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 12.0, right: 12.0),
      child: Container(
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          boxShadow: [
            if (_theme.brightness == Brightness.light)
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(-2.0, 2.0),
                blurRadius: 5.0,
                spreadRadius: 0.1,
              )
            else
              BoxShadow(
                blurStyle: BlurStyle.inner,
                color: _theme.colorScheme.secondary.withOpacity(0.5),
                blurRadius: 50.0,
                spreadRadius: 1.5,
              ),
          ],
          color: _theme.backgroundColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: RefreshIndicator(
          onRefresh: refreshFunction,
          child: ListView.builder(
            itemCount: listOfExpenses.length,
            itemBuilder: (context, index) {
              final ExpenseRecordItem _eri = listOfExpenses[index];
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: ExpandablePanel(
                  header: Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: _eri.category.categoryImage,
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
                                padding: const EdgeInsets.only(
                                  top: 6.0,
                                  bottom: 4.0,
                                ),
                                child: Text(
                                  _eri.category.name,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                    color: _theme.colorScheme.secondary
                                        .withOpacity(0.8),
                                  ),
                                ),
                              ),
                              Text(
                                DateFormat('yMMMd').format(_eri.createdDate),
                                style: GoogleFonts.montserrat(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w300,
                                  color: _theme.colorScheme.secondary
                                      .withOpacity(0.4),
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.defaultDialog(
                              backgroundColor: _theme.backgroundColor,
                              title: "Expense Details",
                              titleStyle: GoogleFonts.montserrat(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w700,
                                color: _theme.colorScheme.secondary
                                    .withOpacity(0.8),
                              ),
                              content: Container(
                                height: 350.0,
                                color: _theme.backgroundColor,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ExpenseInfoWidget(
                                      title: "Category",
                                      value: "${_eri.category.name} ",
                                      color: _theme.colorScheme.secondary,
                                    ),
                                    ExpenseInfoWidget(
                                      title: "Amount",
                                      value: "₹ ${_eri.expense} ",
                                      color: _theme.colorScheme.secondary,
                                    ),
                                    ExpenseInfoWidget(
                                      title: "Remarks",
                                      value: "${_eri.remark} ",
                                      color: _theme.colorScheme.secondary,
                                    ),
                                    ExpenseInfoWidget(
                                      title: "Added on ",
                                      value: DateFormat('yMMMd')
                                          .format(_eri.createdDate),
                                      color: _theme.colorScheme.secondary,
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewExpenseCategoryScreen(
                                  isUpdate: true,
                                  expenseItem: _eri,
                                ),
                              ),
                            );
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
                                .deleteExpenseRecord(id: _eri.id);
                          },
                          icon: Icon(
                            CupertinoIcons.trash_circle,
                            size: 36.0,
                            color: Colors.red.withOpacity(0.7),
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
    );
  }
}

class ExpenseInfoWidget extends StatelessWidget {
  const ExpenseInfoWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.color,
  }) : super(key: key);
  final String title;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              bottom: 8.0,
            ),
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: color.withOpacity(0.8),
              ),
            ),
          ),
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(14.0),
            ),
            child: Text(
              value,
              maxLines: 3,
              overflow: TextOverflow.fade,
              style: GoogleFonts.montserrat(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: color.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
