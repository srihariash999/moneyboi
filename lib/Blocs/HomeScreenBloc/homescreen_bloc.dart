import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
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
          if (_expRecsResp.responseJson != null) {
            _exps = _expRecsResp.responseJson!.data as List;
            for (final i in _exps) {
              _expenseRecords.add(
                ExpenseRecordItem(
                  category: getCategoryFromString(i['category'].toString()),
                  expense: i['amount'] as int,
                  createdDate:
                      DateTime.parse(i['record_date'].toString()).toLocal(),
                ),
              );
            }
            _toggleEnum = event.toggleLabel;
            emit.call(HomeScreenLoaded(
              expenseRecords: _expenseRecords,
              toggleLabel: _toggleEnum,
            ));
          } else {
            emit.call(HomeScreenLoaded(
              expenseRecords: _expenseRecords,
              toggleLabel: _toggleEnum,
            ));
          }
        } catch (e) {
          debugPrint(e.toString());
          emit.call(HomeScreenLoaded(
            expenseRecords: const [],
            toggleLabel: _toggleEnum,
          ));
        }
      }
    });
  }
}
