class ExpenseCategory {
  final String name;
  final String categoryImage;

  const ExpenseCategory({required this.name, required this.categoryImage});

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) =>
      ExpenseCategory(name: json['name'], categoryImage: json['url']);
}
