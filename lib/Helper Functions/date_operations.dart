import 'package:moneyboi/Constants/enums.dart';

DateTime getDurationDateTime(ToggleLabelEnum t) {
  if (t == ToggleLabelEnum.daily) {
    final now = DateTime.now().toUtc();
    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );
    return today;
  } else if (t == ToggleLabelEnum.weekly) {
    final d = DateTime.now().toUtc().subtract(
          Duration(days: DateTime.now().weekday - 1),
        );
    final weekAgo = DateTime(
      d.year,
      d.month,
      d.day,
    );
    return weekAgo;
  } else {
    final d = DateTime.now().toUtc();
    final monthAgo = DateTime(
      d.year,
      d.month,
    );
    return monthAgo;
  }
}
