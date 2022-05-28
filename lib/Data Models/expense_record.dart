import 'package:moneyboi/Data%20Models/expense_category.dart';

class ExpenseRecordItem {
  final String id;
  final ExpenseCategory category;
  final int expense;
  final DateTime createdDate;
  final String remark;

  const ExpenseRecordItem({
    required this.id,
    required this.category,
    required this.expense,
    required this.createdDate,
    required this.remark,
  });
}
