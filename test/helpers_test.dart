import 'package:flutter_test/flutter_test.dart';
import 'package:moneyboi/Helper%20Functions/prev_statistic_helper.dart';

void main() {
  test('Test previousStatisticGenerationHelper function', () {
    // Test case 1: currentExpense is greater than previousExpense
    String expectedStat1 = "You have spent ₹200 more than last 7 days";
    String actualStat1 = previousStatisticGenerationHelper(
        currentExpense: 1500,
        previousExpense: 1300,
        days: 7,
        isPrevious: false);
    expect(actualStat1, expectedStat1);

    // Test case 2: currentExpense is less than previousExpense
    String expectedStat2 = "You have spent ₹200 less than last 7 days";
    String actualStat2 = previousStatisticGenerationHelper(
        currentExpense: 1100,
        previousExpense: 1300,
        days: 7,
        isPrevious: false);
    expect(actualStat2, expectedStat2);

    // Test case 3: isPrevious is true
    String expectedStat3 = "You have spent ₹200 in these 7 days";
    String actualStat3 = previousStatisticGenerationHelper(
        currentExpense: 1500, previousExpense: 1300, days: 7, isPrevious: true);
    expect(actualStat3, expectedStat3);

    // Test case 4: days is 1
    String expectedStat4 = "You have spent ₹200 more than last 1 day";
    String actualStat4 = previousStatisticGenerationHelper(
        currentExpense: 1500,
        previousExpense: 1300,
        days: 1,
        isPrevious: false);
    expect(actualStat4, expectedStat4);
  });
}
