import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
// import 'package:hive/hive.dart';
import 'package:moneyboi/Data%20Models/api_response_model.dart';
import 'package:moneyboi/Data%20Models/repayment_detail.dart';
import 'package:moneyboi/Network/network_service.dart';

class RepaymentsMainController extends GetxController {
  final _apiService = NetworkService();

  final RxBool _isLoading = false.obs;

  final _repaymentAccounts = <RepaymentAccount>[].obs;

  bool get isLoading => _isLoading.value;
  List<RepaymentAccount> get repaymentAccounts => _repaymentAccounts;

  set isLoading(bool value) => _isLoading.value = value;

  Future<void> init() async {
    _repaymentAccounts.clear();
    await _getRepaymentAccs();
  }

  Future<void> _getRepaymentAccs() async {
    isLoading = true;
    update();

    final ApiResponseModel _repayAccsResp =
        await _apiService.getRepaymentAccounts();
    if (_repayAccsResp.statusCode == 200 &&
        _repayAccsResp.responseJson != null) {
      for (final i in _repayAccsResp.responseJson!.data as List<dynamic>) {
        _repaymentAccounts
            .add(RepaymentAccount.fromJson(i as Map<String, dynamic>));
      }
      isLoading = false;
      update();
    } else {
      isLoading = false;
      update();

      debugPrint(_repayAccsResp.specificMessage);
      BotToast.showText(
        text: _repayAccsResp.specificMessage ??
            " Cannot get repayment accounts right now.",
      );
    }
  }

  Future<void> addRepaymentAcc(String email) async {
    Get.back();
    isLoading = true;
    update();

    final ApiResponseModel _result =
        await _apiService.addRepaymentAccount(email);
    if (_result.statusCode == 200 && _result.responseJson != null) {
      _getRepaymentAccs();
    } else {
      isLoading = false;
      update();

      debugPrint(_result.specificMessage);
      BotToast.showText(
        text: _result.specificMessage ??
            " Cannot add repayment account right now.",
      );
    }
  }
}
