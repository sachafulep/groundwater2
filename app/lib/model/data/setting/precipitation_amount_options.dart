import "package:groundwater/utils/strings.dart";

extension PrecipitationAmountOptionsExtension on PrecipitationAmountOptions {
  static double _value(PrecipitationAmountOptions value) {
    switch (value) {
      case PrecipitationAmountOptions.half:
        return 0.5;
      case PrecipitationAmountOptions.twoAndAHalf:
        return 2.5;
      case PrecipitationAmountOptions.five:
        return 5;
      case PrecipitationAmountOptions.ten:
        return 10;
      case PrecipitationAmountOptions.twenty:
        return 20;
      default:
        return null;
    }
  }

  static PrecipitationAmountOptions _valueToOption(double value) {
    if (value == 0.5) {
      return PrecipitationAmountOptions.half;
    } else if (value == 2.5) {
      return PrecipitationAmountOptions.twoAndAHalf;
    } else if (value == 5) {
      return PrecipitationAmountOptions.five;
    } else if (value == 10) {
      return PrecipitationAmountOptions.ten;
    } else if (value == 20) {
      return PrecipitationAmountOptions.twenty;
    } else {
      return null;
    }
  }

  static String _title(PrecipitationAmountOptions value) {
    switch (value) {
      case PrecipitationAmountOptions.half:
        return Strings.settingsNotificationsPrecipitationDialogAmountOptionOne;
      case PrecipitationAmountOptions.twoAndAHalf:
        return Strings.settingsNotificationsPrecipitationDialogAmountOptionTwo;
      case PrecipitationAmountOptions.five:
        return Strings.settingsNotificationsPrecipitationDialogAmountOptionThree;
      case PrecipitationAmountOptions.ten:
        return Strings.settingsNotificationsPrecipitationDialogAmountOptionFour;
      case PrecipitationAmountOptions.twenty:
        return Strings.settingsNotificationsPrecipitationDialogAmountOptionFive;
      default:
        return Strings.settingsNotificationsPrecipitationDialogAmountOptionOne;
    }
  }

  double get value => _value(this);

  String get title => _title(this);

  PrecipitationAmountOptions option(double value) => _valueToOption(value);
}

enum PrecipitationAmountOptions { half, twoAndAHalf, five, ten, twenty }
