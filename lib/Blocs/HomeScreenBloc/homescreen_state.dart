part of 'homescreen_bloc.dart';

@immutable
abstract class HomeScreenState {}

class HomeScreenInitial extends HomeScreenState {}

class HomeScreenLoading extends HomeScreenState {}

class HomeScreenLoaded extends HomeScreenState {
  final List<ExpenseRecordItem> expenseRecords;
  final ToggleLabelEnum toggleLabel;
  final int totalExpense;
  HomeScreenLoaded({
    required this.totalExpense,
    required this.expenseRecords,
    required this.toggleLabel,
  });
}
