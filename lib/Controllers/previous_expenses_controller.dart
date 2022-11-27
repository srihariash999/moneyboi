import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:moneyboi/Constants/enums.dart';
import 'package:moneyboi/Constants/urls.dart';
import 'package:moneyboi/Data%20Models/api_response_model.dart';
import 'package:moneyboi/Data%20Models/expense_record.dart';
import 'package:moneyboi/Helper%20Functions/convert_category.dart';
import 'package:moneyboi/Helper%20Functions/date_operations.dart';
import 'package:moneyboi/Network/network_service.dart';

class PreviousExpensesController extends GetxController {
  final NetworkService _apiService = NetworkService();

  // State variables used by previous_expenses_screen.

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool b) {
    _isLoading.value = b;
    update();
  }

  final _isNewDate = false.obs;
  bool get isNewDate => _isNewDate.value;
  set isNewDate(bool b) {
    _isNewDate.value = b;
    update();
  }

  final _expenses = <ExpenseRecordItem>[].obs;

  List<ExpenseRecordItem> get expenses => _expenses;

  set expenses(List<ExpenseRecordItem> list) {
    _expenses.clear();
    _expenses.addAll([...list]);
    update();
  }

  final _totalExpense = 0.obs;
  int get totalExpense => _totalExpense.value;
  set totalExpense(int i) {
    _totalExpense.value = i;
    update();
  }

  final _startDate = Rxn<DateTime>();
  DateTime? get startDate => _startDate.value;
  set startDate(DateTime? dt) {
    _startDate.value = dt;
    update();
  }

  final _endDate = Rxn<DateTime>();
  DateTime? get endDate => _endDate.value;
  set endDate(DateTime? dt) {
    _endDate.value = dt;
    update();
  }

  void openDatePicker({
    required bool isStart,
    required BuildContext context,
    required ThemeData theme,
  }) {
    DatePicker.showDatePicker(
      context,
      theme: DatePickerTheme(
        backgroundColor: theme.backgroundColor,
        cancelStyle: TextStyle(
          color: theme.colorScheme.secondary.withOpacity(0.6),
          fontSize: 16,
        ),
        doneStyle: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        itemStyle: TextStyle(
          color: theme.colorScheme.secondary.withOpacity(0.85),
          fontSize: 18,
        ),
      ),
      minTime: DateTime(2018, 3, 5),
      maxTime: DateTime.now(),
      onConfirm: (date) {
        if (isStart && date != startDate) {
          isNewDate = true;
          startDate = date;
          return;
        }

        if (date != endDate) {
          isNewDate = true;
          endDate = date;
        }
      },
      currentTime: isStart ? startDate : endDate,
    );
  }

  void init() {
    startDate = getDurationDateTime(ToggleLabelEnum.monthly);
    endDate = DateTime.now();
    searchExpenseRecords();
  }

  ///  Function that will search for expense records with
  ///  valid start and end date ranges. Does nothing if any
  ///  of the dates are null.
  Future<void> searchExpenseRecords() async {
    // Check if both dates are selected.
    if (startDate != null && endDate != null) {
      if (startDate!.isAfter(endDate!)) {
        Get.closeAllSnackbars();
        Get.showSnackbar(
          const GetSnackBar(
            message: "Start Date cannot be after End Date",
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
      isNewDate = false;
      // Put the view in loading.
      isLoading = true;
      // get records.
      await _getExpenseRecords();
      // put view out of loading.
      isLoading = false;
    }
  }

  /// Private function restricted to this page that makes api call and populates data.
  Future<void> _getExpenseRecords() async {
    final ApiResponseModel _expRecsResp;
    try {
      _expRecsResp = await _apiService.networkCall(
        networkCallMethod: NetworkCallMethod.POST,
        endPointUrl: expenseRecordsListingEndPoint,
        authenticated: true,
        bodyParameters: {
          "date_in": startDate?.toUtc().toString(),
          "date_out": endDate?.toUtc().toString(),
        },
      );
      List _exps;
      final List<ExpenseRecordItem> _expenseRecords = [];
      int _totExp = 0;
      if (_expRecsResp.responseJson != null) {
        expenses.clear();
        _exps = _expRecsResp.responseJson!.data as List;

        for (var i in _exps) {
          // _totExp += (i as Map)['amount'] as int;
          i = i as Map;
          _expenseRecords.add(
            ExpenseRecordItem(
              category: getCategoryFromString(i['category'].toString()),
              expense: i['amount'] as int,
              createdDate:
                  DateTime.parse(i['record_date'].toString()).toLocal(),
              id: i['_id'] as String,
              remark: "${i['remarks'] ?? "--"}",
            ),
          );
          _totExp += i['amount'] as int;
        }
        expenses = _expenseRecords;
        totalExpense = _totExp;
      }
    } catch (e) {
      isLoading = false;
    }
  }
}
