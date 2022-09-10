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
  final RxBool _isSubmitLoading = false.obs;

  final Rx<ScrollController> _scrollController = ScrollController().obs;

  late Rx<RepaymentAccount> repayAccount;

  // ignore: prefer_final_fields
  var _repayTransactions = <RepaymentTransaction>[].obs;

  bool get isLoading => _isLoading.value;
  bool get isSubmitLoading => _isSubmitLoading.value;
  ScrollController get scrollController => _scrollController.value;

  List<RepaymentTransaction> get repayTransactions => _repayTransactions;

  set isLoading(bool value) => _isLoading.value = value;
  set isSubmitLoading(bool value) => _isSubmitLoading.value = value;

  Future<void> init(RepaymentAccount account) async {
    repayAccount = account.obs;
    _repayTransactions.clear();
    await _getRepaymentTransactions(account.id);
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
      _repayTransactions.value = _repayTransactions.reversed.toList();
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

  Future<void> addNewTransaction(
    String id,
    int amount,
    BuildContext context,
    String? note,
  ) async {
    isSubmitLoading = true;
    update();
    final ApiResponseModel _result =
        await _apiService.newRepaymentTransaction(id, amount, note);
    if (_result.statusCode == 200 && _result.responseJson != null) {
      final RepaymentTransaction _newTransaction =
          RepaymentTransaction.fromJson(
        _result.responseJson!.data as Map<String, dynamic>,
      );
      final _oldList = repayTransactions.reversed.toList();
      _oldList.add(_newTransaction);
      _repayTransactions.value = _oldList.reversed.toList();

      isSubmitLoading = false;
      update();
      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      if (amount < 0) {
        isLoading = true;
        update();
        final _old = repayAccount.value;
        repayAccount.value = RepaymentAccount(
          id: _old.id,
          friend: _old.friend,
          balance: _old.balance + amount,
          createdAt: _old.createdAt,
        );
        isLoading = false;
        update();
      }
    } else {
      isSubmitLoading = false;
      update();

      debugPrint(_result.specificMessage);
      BotToast.showText(
        text: _result.specificMessage ??
            " Cannot add a newrepayment transaction right now.",
      );
    }
  }

  Future<void> consentToTransaction({
    required String id,
  }) async {
    isLoading = true;
    update();
    final ApiResponseModel _result =
        await _apiService.consentRepaymentTransaction(id);
    if (_result.statusCode == 200) {
      for (final i in _repayTransactions) {
        if (i.id == id) {
          if (i.user1Accepted == false) {
            i.user1Accepted = true;
            final _old = repayAccount.value;
            repayAccount.value = RepaymentAccount(
              id: _old.id,
              friend: _old.friend,
              balance: _old.balance + i.user1Transaction,
              createdAt: _old.createdAt,
            );
          }
          if (i.user2Accepted == false) {
            i.user2Accepted = true;
            final _old = repayAccount.value;
            repayAccount.value = RepaymentAccount(
              id: _old.id,
              friend: _old.friend,
              balance: _old.balance + i.user2Transaction,
              createdAt: _old.createdAt,
            );
          }
        }
      }

      isLoading = false;
      update();
    } else {
      isSubmitLoading = false;
      update();

      debugPrint(_result.specificMessage);
      BotToast.showText(
        text: _result.specificMessage ??
            " Cannot consent the transaction right now.",
      );
    }
  }
}
