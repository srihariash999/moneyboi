import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:moneyboi/Constants/enums.dart';
import 'package:moneyboi/Constants/urls.dart';
import 'package:moneyboi/Data%20Models/expense_record.dart';
import 'package:moneyboi/Helper%20Functions/prev_statistic_helper.dart';
import 'package:moneyboi/Network/network_service.dart';

class ChartScreenController extends GetxController {
  final NetworkService _apiService = NetworkService();

  int touchedIndex = -1.obs;
  final List<double> pieData = <double>[].obs;
  Map<String, int> categoryWiseExpenses = {'': 0}.obs;

  final _previousLoading = false.obs;

  bool get previousLoading => _previousLoading.value;

  set previousLoading(bool b) {
    _previousLoading.value = b;
  }

  final _previousStatisticString = "".obs;

  String get previousStatisticString => _previousStatisticString.value;

  set previousStatisticString(String str) {
    _previousStatisticString.value = str;
    update();
  }

  void chartScreenControllerInit({
    required List<ExpenseRecordItem> expenseRecordItem,
    required int totalExpense,
    required DateTime startDate,
    required int days,
    required bool isPrevious,
  }) {
    previousLoading = true;
    categoryWiseExpenses.clear();
    pieData.clear();
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

    _getPreviousData(
      startDate,
      days,
      totalExpense,
      isPrevious,
    );
  }

  Future _getPreviousData(
    DateTime startDate,
    int days,
    int tot,
    bool isPrevious,
  ) async {
    final dt = startDate.subtract(Duration(days: days)).toString();

    final _expRecsResp = await _apiService.networkCall(
      networkCallMethod: NetworkCallMethod.POST,
      endPointUrl: expenseRecordsListingEndPoint,
      authenticated: true,
      bodyParameters: {
        "date_in": dt,
        "date_out": startDate.toString(),
      },
    );
    if (_expRecsResp.statusCode == 200 || _expRecsResp.statusCode == 201) {
      List _exps;
      int _prevExp = 0;
      if (_expRecsResp.responseJson != null) {
        _exps = _expRecsResp.responseJson!.data as List;
        for (final i in _exps) {
          _prevExp += (i as Map)['amount'] as int;
        }
        previousLoading = false;
        previousStatisticString = previousStatisticGenerationHelper(
          currentExpense: tot,
          previousExpense: _prevExp,
          days: days,
          isPrevious: isPrevious,
        );
      }
    } else {
      previousLoading = false;
      previousStatisticString = " Cannot fetch previous statistics right now.";
    }
  }

  void updateChartTouch(
    FlTouchEvent event,
    PieTouchResponse? pieTouchResponse,
  ) {
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
