import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneyboi/Data%20Models/expense_record.dart';

const List<Color> _listOfColors = [
  Color(0xFF4b0082),
  Color(0xFFa0522d),
  Color(0xFF1e90ff),
  Color(0xFFa52a2a),
  Color(0xFF000080),
  Color(0xFFbdb76b),
  Color(0xFF2f4f4f),
  Color(0xFF000000),
  Color(0xFF7f0000),
  Color(0xFF191970),
  Color(0xFF006400),
  Color(0xFF0000cd),
  Color(0xFFff69b4),
  Color(0xFFcd5c5c),
  Color(0xFFdda0dd),
  Color(0xFFff1493),
];

class ExpenseChartScreen extends StatefulWidget {
  const ExpenseChartScreen({
    Key? key,
    required this.expenseRecordItem,
    required this.totalExpense,
    required this.title,
  }) : super(key: key);
  final List<ExpenseRecordItem> expenseRecordItem;
  final int totalExpense;
  final String title;

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<ExpenseChartScreen> {
  int touchedIndex = -1;
  final List<double> _pieData = [];
  final Map<String, int> _categoryWiseExpenses = {};

  @override
  void initState() {
    for (int i = 0; i < widget.expenseRecordItem.length; i++) {
      if (_categoryWiseExpenses
          .containsKey(widget.expenseRecordItem[i].category.name)) {
        // print("key is there");
        int _val =
            _categoryWiseExpenses[widget.expenseRecordItem[i].category.name]!;
        _val += widget.expenseRecordItem[i].expense;
        _categoryWiseExpenses[widget.expenseRecordItem[i].category.name] = _val;
      } else {
        // print(" no key there");
        _categoryWiseExpenses[widget.expenseRecordItem[i].category.name] =
            widget.expenseRecordItem[i].expense;
      }
    }

    // print(_categoryWiseExpenses);

    final List<int> _data = _categoryWiseExpenses.keys
        .map((key) => _categoryWiseExpenses[key]!)
        .toList();

    // print(_data);

    for (int i = 0; i < _data.length; i++) {
      final double _val = _data[i] / widget.totalExpense * 100;
      _pieData.add(_val);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          widget.title,
          style: GoogleFonts.montserrat(
            fontSize: 20.0,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w500,
            color: Colors.black.withOpacity(0.8),
          ),
        ),
        elevation: 0.0,
      ),
      body: widget.expenseRecordItem.isEmpty
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
                      pieTouchData: PieTouchData(touchCallback:
                          (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: showingSections(),
                    ),
                  ),
                ),
                Column(
                    children: _categoryWiseExpenses.keys.map((key) {
                  final List<String> _data =
                      _categoryWiseExpenses.keys.map((key) => key).toList();

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
                              width: touchedIndex == _data.indexOf(key)
                                  ? 26.0
                                  : 16.0,
                              height: touchedIndex == _data.indexOf(key)
                                  ? 26.0
                                  : 16.0,
                              decoration: BoxDecoration(
                                color: _listOfColors[_data.indexOf(key)],
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              key,
                              style: TextStyle(
                                  fontSize: touchedIndex == _data.indexOf(key)
                                      ? 24
                                      : 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff505050)),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList()),
              ],
            ),
    );
  }

  List<PieChartSectionData> showingSections() {
    final List<PieChartSectionData> _list = [];

    for (int i = 0; i < _pieData.length; i++) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      _list.add(
        PieChartSectionData(
          color: _listOfColors[i],
          value: _pieData[i],
          title: '${_pieData[i].toInt()}%',
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
