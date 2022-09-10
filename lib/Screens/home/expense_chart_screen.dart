import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneyboi/Constants/colors.dart';
import 'package:moneyboi/Constants/enums.dart';
import 'package:moneyboi/Controllers/chart_screen_controller.dart';
import 'package:moneyboi/Data%20Models/expense_record.dart';

class ExpenseChartScreen extends StatelessWidget {
  const ExpenseChartScreen({
    required this.expenseRecordItems,
    required this.totalExpense,
    required this.title,
    required this.endDate,
    required this.startDate,
    this.isPrevious = false,
    this.titleText,
    this.days,
  });
  final List<ExpenseRecordItem> expenseRecordItems;
  final ToggleLabelEnum title;
  final String? titleText;
  final int? days;
  final int totalExpense;
  final DateTime startDate;
  final DateTime endDate;
  final bool isPrevious;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      backgroundColor: _theme.backgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: _theme.colorScheme.secondary),
        backgroundColor: _theme.backgroundColor,
        title: Text(
          titleText != null ? titleText! : toggleLabelEnumToString(title),
          style: GoogleFonts.montserrat(
            fontSize: 20.0,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w500,
            color: _theme.colorScheme.secondary.withOpacity(0.8),
          ),
        ),
        elevation: 0.0,
      ),
      body: GetBuilder<ChartScreenController>(
        initState: (state) {
          Get.find<ChartScreenController>().chartScreenControllerInit(
            totalExpense: totalExpense,
            expenseRecordItem: expenseRecordItems,
            startDate: startDate,
            days: days != null ? days! : toggleLabelEnumToNumber(title),
            isPrevious: isPrevious,
          );
        },
        builder: (_controller) => expenseRecordItems.isEmpty
            ? Container(
                alignment: Alignment.center,
                child: Text(
                  'No Expenses',
                  style: GoogleFonts.montserrat(
                    fontSize: 16.0,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                    color: _theme.colorScheme.secondary.withOpacity(0.5),
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 16.0),
                    if (!_controller.previousLoading)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 28.0),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color:
                                _theme.colorScheme.secondary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Text(
                            _controller.previousStatisticString,
                            style: GoogleFonts.inter(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color:
                                  _theme.colorScheme.secondary.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    if (!isPrevious)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "${DateFormat('E').format(startDate)}, ${DateFormat('d MMM').format(startDate)}",
                            style: GoogleFonts.montserrat(
                              fontSize: 16.0,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w700,
                              color:
                                  _theme.colorScheme.secondary.withOpacity(0.5),
                            ),
                          ),
                          Text(
                            " to ",
                            style: GoogleFonts.montserrat(
                              fontSize: 16.0,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w700,
                              color:
                                  _theme.colorScheme.secondary.withOpacity(0.5),
                            ),
                          ),
                          Text(
                            "${DateFormat('E').format(endDate)}, ${DateFormat('d MMM').format(endDate)}",
                            style: GoogleFonts.montserrat(
                              fontSize: 16.0,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w700,
                              color:
                                  _theme.colorScheme.secondary.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.30,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              _controller.updateChartTouch(
                                event,
                                pieTouchResponse,
                              );
                            },
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: showingSections(
                            _controller,
                            _theme.backgroundColor,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children:
                          _controller.categoryWiseExpenses.keys.map((key) {
                        final List<String> _data = _controller
                            .categoryWiseExpenses.keys
                            .map((key) => key)
                            .toList();

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.36,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    width: _controller.touchedIndex ==
                                            _data.indexOf(key)
                                        ? 26.0
                                        : 16.0,
                                    height: _controller.touchedIndex ==
                                            _data.indexOf(key)
                                        ? 26.0
                                        : 16.0,
                                    decoration: BoxDecoration(
                                      color:
                                          listOfChartColors[_data.indexOf(key)],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "$key (${_controller.pieData[_data.indexOf(key)].toInt()}%)",
                                    style: TextStyle(
                                      fontSize: _controller.touchedIndex ==
                                              _data.indexOf(key)
                                          ? 24
                                          : 16,
                                      fontWeight: FontWeight.bold,
                                      color: _theme.colorScheme.secondary
                                          .withOpacity(0.6),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(
    ChartScreenController controller,
    Color color,
  ) {
    final List<PieChartSectionData> _list = [];

    for (int i = 0; i < controller.pieData.length; i++) {
      final isTouched = i == controller.touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      _list.add(
        PieChartSectionData(
          color: listOfChartColors[i],
          value: controller.pieData[i],
          title: "",
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          borderSide: BorderSide(
            color: color,
          ),
        ),
      );
    }
    return _list;
  }
}
