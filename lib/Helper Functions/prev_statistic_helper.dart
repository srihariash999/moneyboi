String previousStatisticGenerationHelper({
  required int currentExpense,
  required int previousExpense,
  required int days,
  required bool isPrevious,
}) {
  String stat = "";

  stat += "You have spent ₹";

  stat += "${(currentExpense - previousExpense).abs()}";

  if (isPrevious) {
    stat += " in these $days ";

    stat += days > 1 ? "days" : "day";
  } else {
    if (currentExpense > previousExpense) {
      stat += " more ";
    } else {
      stat += " less ";
    }

    stat += "than last $days ";

    stat += days > 1 ? "days" : "day";
  }

  return stat;
}
