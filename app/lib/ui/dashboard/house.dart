import "package:flutter/material.dart";
import "package:groundwater/ui/settings/edit_sensor.dart";
import "package:groundwater/utils/colors.dart";
import "package:groundwater/utils/strings.dart";
import "package:intl/intl.dart" as formatter;

typedef void RefreshData();

class House extends StatelessWidget {
  House({this.cellarHeight, this.totalGroundHeight, this.estimatedWaterLevel, this.currentWaterLevel, this.serverTimestamp, this.weatherIcon, this.mainSensorSelected, this.refreshData});

  final int cellarHeight;
  final int totalGroundHeight;
  final int estimatedWaterLevel;
  final int currentWaterLevel;
  final DateTime serverTimestamp;
  final AssetImage weatherIcon;
  final bool mainSensorSelected;
  final RefreshData refreshData;

  static final TextStyle textStyle = TextStyle(color: Colors.white, fontSize: 12);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Image(
                image: AssetImage("assets/House.png"),
              ),
              if (weatherIcon != null) _getWeatherIcon(),
            ],
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => {
                if (cellarHeight == 0 && mainSensorSelected) {
                    Navigator.of(context).pushNamed(EditSensor.routeName).then((value) {
                      refreshData();
                    })
                  }
              },
              child: Stack(
                children: <Widget>[
                  CustomPaint(
                    size: Size.infinite,
                    painter: GroundPainter(),
                  ),
                  if (cellarHeight != 0 || mainSensorSelected)
                    CustomPaint(
                      size: Size.infinite,
                      painter: CellarPainter(
                        cellarHeight: cellarHeight,
                        totalGroundHeight: totalGroundHeight,
                      ),
                    ),
                  if (cellarHeight != 0 || cellarHeight == 0 && !mainSensorSelected)
                    (totalGroundHeight != 0)
                        ? CustomPaint(
                            size: Size.infinite,
                            painter: WaterLevelPainter(
                              totalGroundHeight: totalGroundHeight,
                              cellarHeight: cellarHeight,
                              currentWaterLevel: currentWaterLevel,
                              estimatedWaterLevel: estimatedWaterLevel,
                              serverTimestamp: serverTimestamp,
                            ),
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              Strings.maximumExpectedNextDay,
              style: TextStyle(color: GroundColor.subText),
            ),
          ),
        ],
      ),
    );
  }

  Image _getWeatherIcon() {
    return Image(
      image: weatherIcon,
      height: 40,
    );
  }
}

/// Paints the water levels
class WaterLevelPainter extends CustomPainter {
  int totalGroundHeight;
  int cellarHeight;
  int currentWaterLevel;
  int estimatedWaterLevel;
  DateTime serverTimestamp;

  double currentWaterHeightPercentage;
  double estimatedWaterHeightPercentage;

  final double textPadding = 12;

  WaterLevelPainter({this.totalGroundHeight, this.cellarHeight, this.currentWaterLevel, this.estimatedWaterLevel, this.serverTimestamp}) {
    this.currentWaterHeightPercentage = 1 - (currentWaterLevel.abs() / totalGroundHeight.abs());
    this.estimatedWaterHeightPercentage = 1 - (estimatedWaterLevel.abs() / totalGroundHeight.abs());
  }

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;

    final double top = height - currentWaterHeightPercentage * height;

    // Current level rectangle
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTRB(0, top, width, height),
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
        topLeft: top != 0 ? Radius.circular(0) : Radius.circular(12),
        topRight: top != 0 ? Radius.circular(0) : Radius.circular(12),
      ),
      Paint()..color = GroundColor.currentWaterLevel,
    );

    // Estimated level rectangle
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTRB(0, height - estimatedWaterHeightPercentage * height, width, height),
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
      ),
      Paint()..color = (estimatedWaterLevel > currentWaterLevel) ? GroundColor.estimatedWaterLevel : GroundColor.estimatedWaterLevelBelowCurrent,
    );

    double currentHeightOffset = height - currentWaterHeightPercentage * height + textPadding;
    double estimatedHeightOffset = height - estimatedWaterHeightPercentage * height + textPadding;

    // Current level text
    TextSpan currentLevelSpan = TextSpan(style: House.textStyle, text: Strings.amountOfCm(currentWaterLevel));
    TextPainter currentLevelTextPainter = TextPainter(text: currentLevelSpan, textAlign: TextAlign.right, textDirection: TextDirection.ltr)..layout();
    double textHeight = currentLevelTextPainter.height;

    // If difference is less then 50, the highest level should display its text above the rectangle instead of inside
    if ((estimatedWaterLevel - currentWaterLevel).abs() < 50) {
      if (currentWaterLevel > estimatedWaterLevel) {
        currentHeightOffset = currentHeightOffset - textPadding * 2 - textHeight;
      } else {
        estimatedHeightOffset = estimatedHeightOffset - textPadding * 2 - textHeight;
      }
    }

    currentLevelTextPainter.paint(canvas, Offset(width - currentLevelTextPainter.width - textPadding, currentHeightOffset));

    TextSpan currentSpan = TextSpan(style: House.textStyle, text: Strings.currentWaterLevel);
    TextPainter(text: currentSpan, textAlign: TextAlign.left, textDirection: TextDirection.ltr)
      ..layout()
      ..paint(canvas, Offset(textPadding, currentHeightOffset));

    // Estimated level text
    TextSpan estimatedSpan = TextSpan(style: House.textStyle, text: Strings.estimatedWaterLevel);
    TextPainter(text: estimatedSpan, textAlign: TextAlign.left, textDirection: TextDirection.ltr)
      ..layout()
      ..paint(canvas, Offset(textPadding, estimatedHeightOffset));

    TextSpan estimatedLevelSpan = TextSpan(style: House.textStyle, text: Strings.amountOfCm(estimatedWaterLevel));
    TextPainter estimatedLevelTextPainter = TextPainter(text: estimatedLevelSpan, textAlign: TextAlign.right, textDirection: TextDirection.ltr)..layout();
    estimatedLevelTextPainter.paint(canvas, Offset(width - estimatedLevelTextPainter.width - textPadding, estimatedHeightOffset));

    // Last updated text
    TextSpan lastUpdatedSpan = TextSpan(style: House.textStyle, text: Strings.lastUpdated(formatter.DateFormat("HH:mm - d MMMM y", "nl_NL").format(serverTimestamp)));
    TextPainter lastUpdatedPainter = TextPainter(text: lastUpdatedSpan, textAlign: TextAlign.center, textDirection: TextDirection.ltr)..layout();

    lastUpdatedPainter.paint(canvas, Offset(width / 2 - lastUpdatedPainter.width / 2, height - textPadding - lastUpdatedPainter.height));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

/// Paints the cellar
class CellarPainter extends CustomPainter {
  int totalGroundHeight;
  int cellarHeight;
  double cellarHeightPercentage;

  final double textSpacing = 16;

  CellarPainter({this.totalGroundHeight, this.cellarHeight}) {
    this.cellarHeightPercentage = cellarHeight.abs() / totalGroundHeight.abs();
  }

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;

    Paint paint = Paint()..color = GroundColor.cellar;

    Rect rect = Rect.fromLTRB(width * 0.25, 0, width * 0.75, cellarHeight == 0 ? 100 : height * cellarHeightPercentage);
    canvas.drawRRect(RRect.fromRectAndCorners(rect, bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)), paint);

    TextStyle textStyle = TextStyle(color: House.textStyle.color, fontSize: 20);

    if (cellarHeight == 0) {
      // Question mark
      TextSpan questionMarkSpan = TextSpan(style: textStyle, text: "?");
      TextPainter questionMarkPainter = TextPainter(text: questionMarkSpan, textAlign: TextAlign.center, textDirection: TextDirection.ltr)..layout();

      questionMarkPainter.paint(canvas, Offset(width / 2 - questionMarkPainter.width / 2, textSpacing));

      // Text
      TextSpan hintSpan = TextSpan(style: House.textStyle, text: Strings.setCellarLevel);
      TextPainter hintPainter = TextPainter(text: hintSpan, textAlign: TextAlign.center, textDirection: TextDirection.ltr)..layout();

      hintPainter.paint(canvas, Offset(width / 2 - hintPainter.width / 2, textSpacing + questionMarkPainter.height + textSpacing));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

/// Paints the ground layer with the different brown tints
class GroundPainter extends CustomPainter {
  GroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;

    Paint paint = Paint()..color = GroundColor.ground;

    Rect rect = Rect.fromLTRB(0, 0, width, height);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(12)), paint);

    int parts = 9;
    double circleRadius = 100;

    canvas.drawPath(createPath(height * 0.3, circleRadius, parts, width), Paint()..color = GroundColor.darkerGround);
    canvas.drawPath(createPath(height * 0.15, circleRadius, parts, width), Paint()..color = GroundColor.darkestGround);
  }

  Path createPath(double bottomHeight, double circleRadius, int parts, double width) {
    double part = width / parts;

    Path path = Path();

    path.moveTo(0, bottomHeight);

    for (int i = 0; i <= parts; i++) {
      if (i % 2 == 0) {
        path.arcToPoint(
          Offset(part * i, bottomHeight),
          radius: Radius.circular(circleRadius),
        );
      } else {
        path.arcToPoint(
          Offset(part * i, bottomHeight),
          radius: Radius.circular(circleRadius),
          clockwise: false,
        );
      }
    }

    // Rounded top right
    path.lineTo(width, 12);
    path.arcToPoint(Offset(width - 24, 12), radius: Radius.circular(1), clockwise: false);
    path.lineTo(width - 12, 0);

    // Rounded top left
    path.lineTo(12, 0);
    path.arcToPoint(Offset(12, 24), radius: Radius.circular(1), clockwise: false);

    path.lineTo(0, 12);

    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
