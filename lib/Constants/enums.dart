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

int toggleLabelEnumToNumber(ToggleLabelEnum en) {
  switch (en) {
    case ToggleLabelEnum.daily:
      return 1;
    case ToggleLabelEnum.weekly:
      return 7;
    case ToggleLabelEnum.monthly:
      return 30;
    default:
      return 0;
  }
}

// ignore: constant_identifier_names
enum NetworkCallMethod { GET, POST, PUT, DELETE }
