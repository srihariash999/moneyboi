import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:moneyboi/Data%20Models/expense_record.dart';

class ChartScreenController extends GetxController {
  int touchedIndex = -1.obs;
  final List<double> pieData = <double>[].obs;
  Map<String, int> categoryWiseExpenses = {'': 0}.obs;

  void chartScreenControllerInit({
    required List<ExpenseRecordItem> expenseRecordItem,
    required int totalExpense,
  }) {
    categoryWiseExpenses.clear();
    for (int i = 0; i < expenseRecordItem.length; i++) {
      if (categoryWiseExpenses
          .containsKey(expenseRecordItem[i].category.name)) {
        // print("key is there");
        int _val = categoryWiseExpenses[expenseRecordItem[i].category.name]!;
        _val += expenseRecordItem[i].expense;
        categoryWiseExpenses[expenseRecordItem[i].category.name] = _val;
      } else {
        // print(" no key there");
        categoryWiseExpenses[expenseRecordItem[i].category.name] =
            expenseRecordItem[i].expense;
        // print(categoryWiseExpenses);
      }
    }

    // print(categoryWiseExpenses);

    final List<int> _data = categoryWiseExpenses.keys
        .map((key) => categoryWiseExpenses[key]!)
        .toList();

    // print(_data);

    for (int i = 0; i < _data.length; i++) {
      final double _val = _data[i] / totalExpense * 100;
      pieData.add(_val);
    }
    update();
  }

  void updateChartTouch(
      FlTouchEvent event, PieTouchResponse? pieTouchResponse) {
    if (!event.isInterestedForInteractions ||
        pieTouchResponse == null ||
        pieTouchResponse.touchedSection == null) {
      touchedIndex = -1;
      return;
    }
    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
    update();
  }
}
