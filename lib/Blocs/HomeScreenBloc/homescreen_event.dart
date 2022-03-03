part of 'homescreen_bloc.dart';

@immutable
abstract class HomeScreenEvent {}

class GetExpenseRecordsEvent extends HomeScreenEvent {
  final ToggleLabelEnum toggleLabel;
  GetExpenseRecordsEvent({
    required this.toggleLabel,
  });
}

class CreateExpenseRecordEvent extends HomeScreenEvent {
  final String recordDate;
  final String category;
  final String remarks;
  final BuildContext context;
  final int amount;
  CreateExpenseRecordEvent({
    required this.recordDate,
    required this.category,
    required this.remarks,
    required this.amount,
    required this.context,
  });
}

class UpdateExpenseRecordEvent extends HomeScreenEvent {
  final String recordDate;
  final String category;
  final String remarks;
  final BuildContext context;
  final int amount;
  final String id;
  UpdateExpenseRecordEvent({
    required this.recordDate,
    required this.category,
    required this.remarks,
    required this.amount,
    required this.context,
    required this.id,
  });
}

class DeleteExpenseRecordEvent extends HomeScreenEvent {
  final String id;
  final BuildContext context;
  DeleteExpenseRecordEvent({required this.id, required this.context});
}
