import 'package:moneyboi/Data%20Models/expense_category.dart';

class ExpenseRecordItem {
  final ExpenseCategory category;
  final int expense;
  final DateTime createdDate;

  const ExpenseRecordItem({
    required this.category,
    required this.expense,
    required this.createdDate,
  });
}
