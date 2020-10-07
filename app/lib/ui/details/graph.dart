import "dart:collection";
import "dart:math";
import "dart:ui" as ui;

import "package:charts_flutter/flutter.dart" as charts;
import "package:charts_flutter/flutter.dart";
import "package:flutter/material.dart";
import "package:groundwater/model/data/lectoraat/monitoring_well_measurement.dart";
import "package:groundwater/model/data/sensor/sensor.dart";
import "package:groundwater/model/data/weather/weather_measurement.dart";
import "package:groundwater/utils/strings.dart";

class Graph extends StatelessWidget {
  Graph(
      {this.precipitationEnabled,
      this.graphState,
      this.selectedMeasurement,
      this.monitoringWellMeasurements,
      this.sensorColorPairings,
      this.weatherMeasurements,
      this.onSelectionChanged,
      this.graphReset});

  static const secondaryMeasureAxisId = "secondaryMeasureAxisId";
  final bool precipitationEnabled;
  final String graphState;
  final MonitoringWellMeasurement selectedMeasurement;
  final HashMap<Sensor, List<MonitoringWellMeasurement>> monitoringWellMeasurements;
  final HashMap<Sensor, Color> sensorColorPairings;
  final List<WeatherMeasurement> weatherMeasurements;
  final Function(charts.SelectionModel model) onSelectionChanged;
  final Function() graphReset;

  @override
  Widget build(BuildContext context) {
    List<Series<dynamic, DateTime>> series = [];

    monitoringWellMeasurements.forEach((sensor, measurements) => {
          series.add(Series<MonitoringWellMeasurement, DateTime>(
            id: sensor.externalMonitoringWellId.toString(),
            seriesColor: sensorColorPairings[sensor],
            domainFn: (MonitoringWellMeasurement measurement, _) => measurement.sensorTimestamp,
            measureFn: (MonitoringWellMeasurement measurement, _) => measurement.groundwaterLevel,
            data: measurements,
          ))
        });

    if (precipitationEnabled) {
      series.add(Series<WeatherMeasurement, DateTime>(
        id: "Neerslag",
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        dashPatternFn: (weatherMeasurement, number) => [2, 3],
        domainFn: (WeatherMeasurement measurement, _) => measurement.time,
        measureFn: (WeatherMeasurement measurement, _) => measurement.precipIntensity,
        data: weatherMeasurements,
      )..setAttribute(charts.measureAxisIdKey, secondaryMeasureAxisId));
    }

    return charts.TimeSeriesChart(
        series,
        animate: false,
        primaryMeasureAxis: charts.NumericAxisSpec(
          tickProviderSpec: charts.BasicNumericTickProviderSpec(
            zeroBound: false,
            dataIsInWholeNumbers: false,
          ),
        ),
        secondaryMeasureAxis: charts.NumericAxisSpec(
          tickProviderSpec: charts.BasicNumericTickProviderSpec(
            zeroBound: false,
            dataIsInWholeNumbers: false,
          ),
        ),
        behaviors: [
          charts.ChartTitle(
            Strings.chartTitleLeft,
            behaviorPosition: charts.BehaviorPosition.start,
            titleStyleSpec: charts.TextStyleSpec(
              fontSize: 10,
            ),
          ),
          charts.ChartTitle(
            Strings.chartTitleRight,
            behaviorPosition: charts.BehaviorPosition.end,
            titleStyleSpec: charts.TextStyleSpec(
              fontSize: 10,
            ),
          ),
          if (selectedMeasurement != null)
            charts.InitialSelection(selectedDataConfig: [
              charts.SeriesDatumConfig<DateTime>(
                selectedMeasurement.monitoringWell.toString(),
                selectedMeasurement.sensorTimestamp,
              ),
            ]),
          charts.LinePointHighlighter(
            showHorizontalFollowLine: charts.LinePointHighlighterFollowLineType.none,
            showVerticalFollowLine: charts.LinePointHighlighterFollowLineType.none,
            defaultRadiusPx: 5,
            symbolRenderer: TagRenderer(
              isSolid: false,
              measurement: selectedMeasurement?.groundwaterLevel?.toString() ?? "",
            ),
          ),
        ],
        selectionModels: [
          charts.SelectionModelConfig(
            type: charts.SelectionModelType.info,
            changedListener: onSelectionChanged,
          ),
        ],
      );
  }
}

class TagRenderer extends charts.CircleSymbolRenderer {
  static String _measurement;

  TagRenderer({bool isSolid = true, String measurement = ""}) : super(isSolid: isSolid) {
    _measurement = measurement;
  }

  @override
  void paint(
    charts.ChartCanvas canvas,
    Rectangle<num> bounds, {
    List<int> dashPattern,
    charts.Color fillColor,
    charts.Color strokeColor,
    double strokeWidthPx,
  }) {
    final center = Point(
      bounds.left + (bounds.width / 2),
      bounds.top + (bounds.height / 2),
    );

    final tipOfTag = Point(
      center.x,
      center.y - 15,
    );

    canvas.drawPoint(
      point: center,
      radius: 4,
      fill: getSolidFillColor(fillColor),
      stroke: strokeColor,
      strokeWidthPx: getSolidStrokeWidthPx(strokeWidthPx),
    );

    canvas.drawPolygon(
      points: [
        tipOfTag,
        Point(tipOfTag.x - 18, tipOfTag.y - 11),
        Point(tipOfTag.x + 18, tipOfTag.y - 11),
        tipOfTag,
      ],
      fill: strokeColor,
    );

    canvas.drawRRect(
      Rectangle(tipOfTag.x - 18, tipOfTag.y - 28, 36, 18),
      fill: fillColor,
      patternColor: fillColor,
      fillPattern: charts.FillPatternType.solid,
      patternStrokeWidthPx: 5.0,
      strokeWidthPx: 5.0,
      radius: 3.0,
      roundTopLeft: true,
      roundTopRight: true,
      roundBottomLeft: true,
      roundBottomRight: true,
    );

    var textElement = canvas.graphicsFactory.createTextElement(_measurement.substring(0, min(_measurement.length, 5)));
    var textStyle = canvas.graphicsFactory.createTextPaint();

    textStyle.color = charts.Color.white;
    textStyle.fontSize = 11;
    textStyle.lineHeight = 10;

    textElement.textStyle = textStyle;

    canvas.drawText(textElement, center.x.toInt() - 14, center.y.toInt() - 105);
  }

  @override
  bool shouldRepaint(charts.CircleSymbolRenderer oldRenderer) {
    return true;
  }

  @override
  bool operator ==(Object other) => other is charts.CircleSymbolRenderer && super == (other);

  @override
  int get hashCode {
    int hashcode = super.hashCode;
    hashcode = (hashcode * 37) + runtimeType.hashCode;
    return hashcode;
  }
}

class LegendIconPainter extends CustomPainter {
  bool precipitationEnabled;
  HashMap<Sensor, Color> sensorColorPairings;
  double screenWidth;

  LegendIconPainter({this.precipitationEnabled, this.sensorColorPairings, this.screenWidth});

  int hexToInt(String hex) {
    int val = 0;
    int len = hex.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = hex.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw FormatException("Invalid hexadecimal value");
      }
    }
    return val;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 10;

    TextStyle style = TextStyle(color: Colors.black, fontSize: 14);
    TextSpan span = TextSpan(style: style);
    TextPainter painter = TextPainter();
    painter.maxLines;

    int column = 0;
    int row = 0;

    sensorColorPairings.forEach((sensor, color) => {
          paint.color = ui.Color(hexToInt("FF${color.hexString.substring(1)}")),
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(column * 50.0, row * 25 + 9.0, 15, 3),
              Radius.circular(5.0),
            ),
            paint,
          ),
          span = TextSpan(text: sensor.name.substring(sensor.name.length - 2), style: style),
          painter = TextPainter(text: span, textAlign: TextAlign.left, textDirection: ui.TextDirection.ltr)
            ..layout()
            ..paint(canvas, Offset(column * 50.0 + 20, row * 25 + 2.0)),
          if (column > 4 && precipitationEnabled || column == 6) {row++, column = 0} else {column++}
        });

    if (precipitationEnabled) {
      paint.color = ui.Color(hexToInt("FF${charts.MaterialPalette.blue.shadeDefault.hexString.substring(1)}"));

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(column * 50.0, row * 25 + 9.0, 3, 3),
          Radius.circular(5.0),
        ),
        paint,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(column * 50.0 + 5, row * 25 + 9.0, 3, 3),
          Radius.circular(5.0),
        ),
        paint,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(column * 50.0 + 10, row * 25 + 9.0, 3, 3),
          Radius.circular(5.0),
        ),
        paint,
      );

      span = TextSpan(text: "neerslag", style: style);
      painter = TextPainter(text: span, textAlign: TextAlign.left, textDirection: ui.TextDirection.ltr)
        ..layout()
        ..paint(canvas, Offset(column * 50.0 + 20, row * 25 + 2.0));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

typedef void GraphCallback();

class GraphResetWidget extends StatefulWidget {
  const GraphResetWidget({
    this.graphCallback,
  }) : super();

  final GraphCallback graphCallback;

  @override
  State<StatefulWidget> createState() => GraphResetState(
        testCallback: graphCallback,
      );
}

class GraphResetState extends State<GraphResetWidget> {
  GraphResetState({
    this.testCallback,
  });

  final GraphCallback testCallback;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => testCallback());
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
