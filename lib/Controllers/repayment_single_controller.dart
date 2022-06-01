import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
// import 'package:hive/hive.dart';
import 'package:moneyboi/Data%20Models/api_response_model.dart';
import 'package:moneyboi/Data%20Models/repayment_detail.dart';
import 'package:moneyboi/Data%20Models/repayment_transaction.dart';
import 'package:moneyboi/Network/network_service.dart';

class RepaymentsSingleController extends GetxController {
  final _apiService = NetworkService();

  final RxBool _isLoading = false.obs;

  final _repayTransactions = <RepaymentTransaction>[].obs;

  bool get isLoading => _isLoading.value;
  List<RepaymentTransaction> get repayTransactions => _repayTransactions;

  set isLoading(bool value) => _isLoading.value = value;

  Future<void> init(String id) async {
    await _getRepaymentTransactions(id);
  }

  Future<void> _getRepaymentTransactions(String id) async {
    isLoading = true;
    update();

    final ApiResponseModel _repayTransactionsResult =
        await _apiService.getRepaymentTransactions(id);
    if (_repayTransactionsResult.statusCode == 200 &&
        _repayTransactionsResult.responseJson != null) {
      for (final i
          in _repayTransactionsResult.responseJson!.data as List<dynamic>) {
        _repayTransactions
            .add(RepaymentTransaction.fromJson(i as Map<String, dynamic>));
      }
      isLoading = false;
      update();
    } else {
      isLoading = false;
      update();

      debugPrint(_repayTransactionsResult.specificMessage);
      BotToast.showText(
        text: _repayTransactionsResult.specificMessage ??
            " Cannot get repayment transactions right now.",
      );
    }
  }
}
