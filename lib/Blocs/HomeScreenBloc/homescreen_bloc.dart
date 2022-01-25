import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

HomeScreenLoaded _loadedState =
    HomeScreenLoaded(expenseRecords: const [], toggleLabel: _toggleEnum);

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
            _loadedState = HomeScreenLoaded(
              expenseRecords: _expenseRecords,
              toggleLabel: _toggleEnum,
            );
            emit.call(_loadedState);
          } else {
            _loadedState = HomeScreenLoaded(
              expenseRecords: _expenseRecords,
              toggleLabel: _toggleEnum,
            );
            emit.call(_loadedState);
          }
        } catch (e) {
          debugPrint(e.toString());
          _loadedState = HomeScreenLoaded(
            expenseRecords: const [],
            toggleLabel: _toggleEnum,
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
            // ignore: use_build_context_synchronously
            Navigator.pop(event.context, 'true');
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
      }
    });
  }
}
