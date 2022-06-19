enum ToggleLabelEnum {
  daily,
  weekly,
  monthly,
}

String toggleLabelEnumToString(ToggleLabelEnum en) {
  switch (en) {
    case ToggleLabelEnum.daily:
      return "Daily";
    case ToggleLabelEnum.weekly:
      return "Weekly";
    case ToggleLabelEnum.monthly:
      return "Monthly";
    default:
      return "";
  }
}
