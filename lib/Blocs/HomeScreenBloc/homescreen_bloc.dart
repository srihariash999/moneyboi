// import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import 'package:moneyboi/Constants/enums.dart';
// import 'package:meta/meta.dart';
import 'package:moneyboi/Data%20Models/api_response_model.dart';
import 'package:moneyboi/Data%20Models/expense_record.dart';
import 'package:moneyboi/Helper%20Functions/convert_category.dart';
import 'package:moneyboi/Network/network_service.dart';
part 'homescreen_event.dart';
part 'homescreen_state.dart';

final NetworkService _apiService = NetworkService();

ToggleLabelEnum _toggleEnum = ToggleLabelEnum.weekly;

HomeScreenLoaded _loadedState = HomeScreenLoaded(
    expenseRecords: const [], totalExpense: 0, toggleLabel: _toggleEnum);

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc() : super(HomeScreenInitial()) {
    on<HomeScreenEvent>((event, emit) async {
      if (event is GetExpenseRecordsEvent) {
        emit.call(HomeScreenLoading());

        final ApiResponseModel _expRecsResp;

        try {
          _expRecsResp = await _apiService.getExpenseRecords(
              dateIn: event.toggleLabel == ToggleLabelEnum.weekly
                  ? DateTime.now()
                      .toUtc()
                      .subtract(const Duration(days: 7))
                      .toString()
                  : event.toggleLabel == ToggleLabelEnum.monthly
                      ? DateTime.now()
                          .toUtc()
                          .subtract(const Duration(days: 30))
                          .toString()
                      : null,
              dateOut: DateTime.now().toUtc().toString());
          List _exps;
          // ignore: prefer_final_locals
          List<ExpenseRecordItem> _expenseRecords = [];
          int _totExp = 0;
          if (_expRecsResp.responseJson != null) {
            _exps = _expRecsResp.responseJson!.data as List;

            for (final i in _exps) {
              _totExp += i['amount'] as int;

              _expenseRecords.add(
                ExpenseRecordItem(
                  category: getCategoryFromString(i['category'].toString()),
                  expense: i['amount'] as int,
                  createdDate:
                      DateTime.parse(i['record_date'].toString()).toLocal(),
                  id: i['_id'] as String,
                ),
              );
            }
            _toggleEnum = event.toggleLabel;
            _loadedState = HomeScreenLoaded(
              expenseRecords: _expenseRecords,
              toggleLabel: _toggleEnum,
              totalExpense: _totExp,
            );
            emit.call(_loadedState);
          } else {
            _loadedState = HomeScreenLoaded(
              expenseRecords: _expenseRecords,
              toggleLabel: _toggleEnum,
              totalExpense: _totExp,
            );
            emit.call(_loadedState);
          }
        } catch (e) {
          debugPrint("$e  in get exp records");
          _loadedState = HomeScreenLoaded(
            expenseRecords: const [],
            toggleLabel: _toggleEnum,
            totalExpense: 0,
          );
          emit.call(_loadedState);
        }
      } else if (event is CreateExpenseRecordEvent) {
        emit.call(HomeScreenLoading());

        final ApiResponseModel _expRecsResp;

        try {
          _expRecsResp = await _apiService.createExpenseRecords(
            recordDate: event.recordDate,
            amount: event.amount,
            category: event.category,
            remarks: event.remarks,
          );

          if (_expRecsResp.statusCode == 200) {
            emit.call(_loadedState);
            // Navigator.pop(event.context, 'true');
            Get.back(result: true);
            // ignore: use_build_context_synchronously
            BlocProvider.of<HomeScreenBloc>(event.context)
                .add(GetExpenseRecordsEvent(
              toggleLabel: ToggleLabelEnum.weekly,
            ));
          } else {
            // ignore: use_build_context_synchronously
            emit.call(_loadedState);
          }
        } catch (e) {
          debugPrint(e.toString());
          emit.call(_loadedState);
        }
      } else if (event is UpdateExpenseRecordEvent) {
        emit.call(HomeScreenLoading());

        final ApiResponseModel _expRecsResp;

        try {
          _expRecsResp = await _apiService.updateExpenseRecords(
            recordDate: event.recordDate,
            amount: event.amount,
            category: event.category,
            remarks: event.remarks,
            id: event.id,
          );

          if (_expRecsResp.statusCode == 200) {
            emit.call(_loadedState);
            // Navigator.pop(event.context, 'true');
            Get.back(result: true);
            // ignore: use_build_context_synchronously
            BlocProvider.of<HomeScreenBloc>(event.context)
                .add(GetExpenseRecordsEvent(
              toggleLabel: ToggleLabelEnum.weekly,
            ));
          } else {
            // ignore: use_build_context_synchronously
            emit.call(_loadedState);
          }
        } catch (e) {
          debugPrint(e.toString());
          emit.call(_loadedState);
        }
      } else if (event is DeleteExpenseRecordEvent) {
        emit.call(HomeScreenLoading());

        final ApiResponseModel _expRecsResp;

        try {
          _expRecsResp = await _apiService.deleteExpenseRecords(
            id: event.id,
          );

          if (_expRecsResp.statusCode == 200) {
            

            final ApiResponseModel _expRecsResp;

            try {
              _expRecsResp = await _apiService.getExpenseRecords(
                  dateIn: _loadedState.toggleLabel == ToggleLabelEnum.weekly
                      ? DateTime.now()
                          .toUtc()
                          .subtract(const Duration(days: 7))
                          .toString()
                      : _loadedState.toggleLabel == ToggleLabelEnum.monthly
                          ? DateTime.now()
                              .toUtc()
                              .subtract(const Duration(days: 30))
                              .toString()
                          : null,
                  dateOut: DateTime.now().toUtc().toString());
              List _exps;
              // ignore: prefer_final_locals
              List<ExpenseRecordItem> _expenseRecords = [];
              int _totExp = 0;
              if (_expRecsResp.responseJson != null) {
                _exps = _expRecsResp.responseJson!.data as List;

                for (final i in _exps) {
                  _totExp += i['amount'] as int;

                  _expenseRecords.add(
                    ExpenseRecordItem(
                      category: getCategoryFromString(i['category'].toString()),
                      expense: i['amount'] as int,
                      createdDate:
                          DateTime.parse(i['record_date'].toString()).toLocal(),
                      id: i['_id'] as String,
                    ),
                  );
                }
                _toggleEnum = _loadedState.toggleLabel;
                _loadedState = HomeScreenLoaded(
                  expenseRecords: _expenseRecords,
                  toggleLabel: _toggleEnum,
                  totalExpense: _totExp,
                );
                emit.call(_loadedState);
              } else {
                _loadedState = HomeScreenLoaded(
                  expenseRecords: _expenseRecords,
                  toggleLabel: _toggleEnum,
                  totalExpense: _totExp,
                );
                emit.call(_loadedState);
              }
            } catch (e) {
              debugPrint("$e  in get exp records");
              _loadedState = HomeScreenLoaded(
                expenseRecords: const [],
                toggleLabel: _toggleEnum,
                totalExpense: 0,
              );
              emit.call(_loadedState);
            }
          } else {
            BotToast.showText(text: "Cannot delete expense record");
            emit.call(_loadedState);
          }
        } catch (e) {
          debugPrint("$e in delete exp records");
          BotToast.showText(text: "Cannot delete expense record");
          emit.call(_loadedState);
        }
      }
    });
  }
}
