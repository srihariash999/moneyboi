import 'package:moneyboi/Constants/categories.dart';
import 'package:moneyboi/Data%20Models/expense_category.dart';

ExpenseCategory getCategoryFromString(String catString) {
  if (catString == 'Alcohol') {
    return catAlcohol;
  } else if (catString == 'Books') {
    return catBooks;
  } else if (catString == 'Car') {
    return catCar;
  } else if (catString == 'Cigarette') {
    return catCigarette;
  } else if (catString == 'Clothes') {
    return catClothes;
  } else if (catString == 'Education') {
    return catEducation;
  } else if (catString == 'Food') {
    return catFood;
  } else if (catString == 'Groceries') {
    return catGroceries;
  } else if (catString == 'Home') {
    return catHome;
  } else if (catString == 'Movie') {
    return catMovie;
  } else if (catString == 'Pets') {
    return catPets;
  } else if (catString == 'Phone') {
    return catPhone;
  } else if (catString == 'Rent') {
    return catRent;
  } else if (catString == 'Sports') {
    return catSports;
  } else if (catString == 'Travel') {
    return catTravel;
  } else {
    return catMisc;
  }
}
