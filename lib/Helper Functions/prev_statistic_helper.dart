String previousStatisticGenerationHelper({
  required int currentExpense,
  required int previousExpense,
  required int days,
}) {
  String stat = "";

  stat += "You have spent ₹";

  stat += "${(currentExpense - previousExpense).abs()}";

  if (currentExpense > previousExpense) {
    stat += " more ";
  } else {
    stat += " less ";
  }

  stat += "than last $days ";

  return stat += days > 1 ? "days" : "day";
}
