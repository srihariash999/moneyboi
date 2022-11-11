import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:moneyboi/Constants/enums.dart';
import 'package:moneyboi/Data%20Models/api_response_model.dart';
import 'package:moneyboi/Data%20Models/expense_record.dart';
import 'package:moneyboi/Helper%20Functions/convert_category.dart';
import 'package:moneyboi/Network/network_service.dart';

class HomeScreenController extends GetxController {
  final NetworkService _apiService = NetworkService();
  final RxBool isHomeloading = false.obs;
  final RxBool isCreateLoading = false.obs;
  RxInt totExp = 0.obs;
  List<ExpenseRecordItem> expenseRecords = <ExpenseRecordItem>[].obs;
  final Rx<ToggleLabelEnum> toggleEnum = ToggleLabelEnum.daily.obs;

  Future<void> getFcmToken() async {
    FirebaseMessaging.instance.getToken().then((token) {
      // debugPrint("FCM Token: $token");
      if (token != null) {
        _apiService.saveNotificationToken(token).then(
          (value) {
            // debugPrint(" notification save res: ${value.responseJson}");
          },
        );
      }
    });
  }

  DateTime getDurationDateTime(ToggleLabelEnum t) {
    if (t == ToggleLabelEnum.daily) {
      final now = DateTime.now();
      final today = DateTime(
        now.year,
        now.month,
        now.day,
      ).toUtc();
      return today;
    } else if (t == ToggleLabelEnum.weekly) {
      final d = DateTime.now().subtract(
        Duration(days: DateTime.now().weekday - 1),
      );
      final weekAgo = DateTime(
        d.year,
        d.month,
        d.day,
      ).toUtc();
      return weekAgo;
    } else {
      final d = DateTime.now();
      final monthAgo = DateTime(
        d.year,
        d.month,
      ).toUtc();
      return monthAgo;
    }
  }

  Future<void> getExpenseRecords(
    ToggleLabelEnum newToggleLabel, {
    required bool init,
  }) async {
    if (newToggleLabel == toggleEnum.value && !init) return;
    isHomeloading.value = true;
    update();
    final ApiResponseModel _expRecsResp;

    try {
      _expRecsResp = await _apiService.getExpenseRecords(
        dateIn: getDurationDateTime(
          newToggleLabel,
        ).toIso8601String(),
        dateOut: DateTime.now().toUtc().toIso8601String(),
      );
      List _exps;
      // ignore: prefer_final_locals
      List<ExpenseRecordItem> _expenseRecords = [];
      int _totExp = 0;
      if (_expRecsResp.responseJson != null) {
        _exps = _expRecsResp.responseJson!.data as List;

        for (final i in _exps) {
          _totExp += (i as Map)['amount'] as int;

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
        }
        isHomeloading.value = false;
        toggleEnum.value = newToggleLabel;
        expenseRecords = _expenseRecords;
        totExp.value = _totExp;
        update();
      } else {
        isHomeloading.value = false;

        toggleEnum.value = newToggleLabel;
        expenseRecords = _expenseRecords;
        totExp.value = _totExp;
        update();
      }
    } catch (e) {
      isHomeloading.value = false;

      debugPrint("$e  in get exp records");
      expenseRecords = [];
      totExp.value = 0;
      update();
    }
  }

  Future<void> createExpenseRecord({
    required String recordDate,
    required String category,
    required String remarks,
    required int amount,
    required bool isUpdate,
    String? id,
  }) async {
    final ApiResponseModel _expRecsResp;

    isCreateLoading.value = true;
    update();

    try {
      if (isUpdate) {
        _expRecsResp = await _apiService.updateExpenseRecords(
          recordDate: recordDate,
          amount: amount,
          category: category,
          remarks: remarks,
          id: id!,
        );
      } else {
        _expRecsResp = await _apiService.createExpenseRecords(
          recordDate: recordDate,
          amount: amount,
          category: category,
          remarks: remarks,
        );
      }

      if (_expRecsResp.statusCode == 200) {
        isCreateLoading.value = false;
        update();
        // Navigator.pop(event.context, 'true');
        Get.back(result: true);
        getExpenseRecords(toggleEnum.value, init: true);
        update();
      } else {
        isCreateLoading.value = false;
        update();
        BotToast.showText(text: 'Cannot create expense record right now.');
      }
    } catch (e) {
      debugPrint(e.toString());
      isCreateLoading.value = false;
      update();
      BotToast.showText(text: 'Cannot create expense record right now.');
    }
  }

  Future<void> deleteExpenseRecord({required String id}) async {
    isHomeloading.value = true;
    update();

    final ApiResponseModel _expRecsResp;

    try {
      _expRecsResp = await _apiService.deleteExpenseRecords(
        id: id,
      );

      if (_expRecsResp.statusCode == 200) {
        getExpenseRecords(toggleEnum.value, init: true);
      } else {
        isHomeloading.value = false;
        update();
        BotToast.showText(text: "Cannot delete expense record");
      }
    } catch (e) {
      debugPrint("$e in delete exp records");
      isHomeloading.value = false;
      update();
      BotToast.showText(text: "Cannot delete expense record");
    }
  }
}
