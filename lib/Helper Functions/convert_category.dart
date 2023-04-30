import 'package:get/get.dart';
import 'package:moneyboi/Controllers/categories_controller.dart';
import 'package:moneyboi/Data%20Models/expense_category.dart';

final CategoriesController _categoriesController =
    Get.find<CategoriesController>();

ExpenseCategory getCategoryFromString(String catString) {
  for (var i in _categoriesController.categories) {
    if (i.name == catString) return i;
  }
  print(" category requested for : $catString which is unkown");
  return ExpenseCategory(
      name: "Unkown Category",
      categoryImage:
          "https://firebasestorage.googleapis.com/v0/b/moneyboi-3c667.appspot.com/o/warning.png?alt=media");

  // if (catString == 'Alcohol') {
  //   return catAlcohol;
  // } else if (catString == 'Books') {
  //   return catBooks;
  // } else if (catString == 'Car') {
  //   return catCar;
  // } else if (catString == 'Cigarette') {
  //   return catCigarette;
  // } else if (catString == 'Clothes') {
  //   return catClothes;
  // } else if (catString == 'Education') {
  //   return catEducation;
  // } else if (catString == 'Food') {
  //   return catFood;
  // } else if (catString == 'Groceries') {
  //   return catGroceries;
  // } else if (catString == 'Home') {
  //   return catHome;
  // } else if (catString == 'Movie') {
  //   return catMovie;
  // } else if (catString == 'Pets') {
  //   return catPets;
  // } else if (catString == 'Phone') {
  //   return catPhone;
  // } else if (catString == 'Rent') {
  //   return catRent;
  // } else if (catString == 'Sports') {
  //   return catSports;
  // } else if (catString == 'Travel') {
  //   return catTravel;
  // } else {
  //   return catMisc;
  // }
}
