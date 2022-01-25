part of 'homescreen_bloc.dart';

@immutable
abstract class HomeScreenEvent {}

class GetExpenseRecordsEvent extends HomeScreenEvent {
  final ToggleLabelEnum toggleLabel;
  GetExpenseRecordsEvent({
    required this.toggleLabel,
  });
}
