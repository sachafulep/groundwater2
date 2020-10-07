import "package:flutter/material.dart";

/// Class where all colors for the app are stored. It is called GroundColor to avoid
/// collision with the Color class from Flutter.
class GroundColor {
  static final text = Color.fromRGBO(0, 0, 0, 0.87);
  static final subText = Color.fromRGBO(0, 0, 0, 0.6);
  static final primary = Color.fromRGBO(255, 255, 254, 1);
  static final primaryDark = Color.fromRGBO(243, 243, 243, 1);
  static final icon = Color.fromRGBO(0, 0, 0, 0.5);
  static final card = Color.fromRGBO(47, 47, 47, 1);
  static final accent = Color.fromRGBO(59, 141, 187, 1);
  static final border = Color.fromRGBO(0, 0, 0, 0.07);
  static final transparent = Color.fromRGBO(0, 0, 0, 0.0);
  static final error = Color.fromRGBO(211, 48, 48, 1);

  /// Visualisation
  static final cellar = Color.fromRGBO(117, 117, 117, 1);
  static final ground = Color.fromRGBO(132, 91, 45, 1);
  static final darkerGround = Color.fromRGBO(117, 77, 33, 1);
  static final darkestGround = Color.fromRGBO(101, 65, 25, 1);
  static final currentWaterLevel = Color.fromRGBO(59, 141, 187, 0.7);
  static final estimatedWaterLevel = Color.fromRGBO(59, 141, 187, 0.5);
  static final estimatedWaterLevelBelowCurrent = Color.fromRGBO(0, 102, 153, 0.5);
}
