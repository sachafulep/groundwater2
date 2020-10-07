import "package:groundwater/utils/strings.dart";

extension PrecipitationDurationOptionsExtension on PrecipitationDurationOptions {
  static double _value(PrecipitationDurationOptions value) {
    switch (value) {
      case PrecipitationDurationOptions.none:
        return null;
      case PrecipitationDurationOptions.halfHour:
        return 0.5;
      case PrecipitationDurationOptions.oneHour:
        return 1;
      case PrecipitationDurationOptions.twoHours:
        return 2;
      case PrecipitationDurationOptions.fourHours:
        return 4;
      default:
        return null;
    }
  }

  static PrecipitationDurationOptions _valueToOption(double value) {
    if (value == 0.5) {
      return PrecipitationDurationOptions.halfHour;
    } else if (value == 1) {
      return PrecipitationDurationOptions.oneHour;
    } else if (value == 2) {
      return PrecipitationDurationOptions.twoHours;
    } else if (value == 4) {
      return PrecipitationDurationOptions.fourHours;
    } else {
      return PrecipitationDurationOptions.none;
    }
  }

  static String _title(PrecipitationDurationOptions value) {
    switch (value) {
      case PrecipitationDurationOptions.none:
        return Strings.settingsNotificationsPrecipitationDialogDurationOptionOne;
      case PrecipitationDurationOptions.halfHour:
        return Strings.settingsNotificationsPrecipitationDialogDurationOptionTwo();
      case PrecipitationDurationOptions.oneHour:
        return Strings.settingsNotificationsPrecipitationDialogDurationOptionThree();
      case PrecipitationDurationOptions.twoHours:
        return Strings.settingsNotificationsPrecipitationDialogDurationOptionFour();
      case PrecipitationDurationOptions.fourHours:
        return Strings.settingsNotificationsPrecipitationDialogDurationOptionFive();
      default:
        return Strings.settingsNotificationsPrecipitationDialogDurationOptionOne;
    }
  }

  double get value => _value(this);

  String get title => _title(this);

  PrecipitationDurationOptions option(double value) => _valueToOption(value);
}

enum PrecipitationDurationOptions { none, halfHour, oneHour, twoHours, fourHours }
