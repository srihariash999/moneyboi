import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneyboi/Constants/colors.dart';
import 'package:moneyboi/Controllers/chart_screen_controller.dart';
import 'package:moneyboi/Data%20Models/expense_record.dart';

class ExpenseChartScreen extends StatelessWidget {
  const ExpenseChartScreen({
    required this.expenseRecordItem,
    required this.totalExpense,
    required this.title,
  });
  final List<ExpenseRecordItem> expenseRecordItem;
  final String title;
  final int totalExpense;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 20.0,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w500,
            color: Colors.black.withOpacity(0.8),
          ),
        ),
        elevation: 0.0,
      ),
      body: GetBuilder<ChartScreenController>(
        initState: (state) {
          Get.find<ChartScreenController>().chartScreenControllerInit(
            totalExpense: totalExpense,
            expenseRecordItem: expenseRecordItem,
          );
        },
        builder: (_controller) => expenseRecordItem.isEmpty
            ? Container(
                alignment: Alignment.center,
                child: Text(
                  'No Expenses',
                  style: GoogleFonts.montserrat(
                    fontSize: 16.0,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              )
            : Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
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
                        sections: showingSections(_controller),
                      ),
                    ),
                  ),
                  Column(
                    children: _controller.categoryWiseExpenses.keys.map((key) {
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
                                  key,
                                  style: TextStyle(
                                    fontSize: _controller.touchedIndex ==
                                            _data.indexOf(key)
                                        ? 24
                                        : 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xff505050),
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
    );
  }

  List<PieChartSectionData> showingSections(ChartScreenController controller) {
    final List<PieChartSectionData> _list = [];

    for (int i = 0; i < controller.pieData.length; i++) {
      final isTouched = i == controller.touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      _list.add(
        PieChartSectionData(
          color: listOfChartColors[i],
          value: controller.pieData[i],
          title: '${controller.pieData[i].toInt()}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          borderSide: const BorderSide(color: Colors.white),
        ),
      );
    }
    return _list;
  }
}
