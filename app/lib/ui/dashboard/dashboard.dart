import "dart:math";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:groundwater/model/data/lectoraat/monitoring_well.dart";
import "package:groundwater/model/data/sensor/sensor.dart";
import "package:groundwater/model/data/lectoraat/sensor_measurement.dart";
import "package:groundwater/model/model.dart";
import "package:groundwater/network/lectoraat_api.dart";
import "package:groundwater/network/weather_api.dart";
import "package:groundwater/ui/dashboard/house.dart";
import "package:groundwater/ui/decision_tree/decision_tree.dart";
import "package:groundwater/ui/details/details.dart";
import "package:groundwater/ui/settings/settings.dart";
import "package:groundwater/utils/colors.dart";
import "package:groundwater/utils/strings.dart";

class Dashboard extends StatefulWidget {
  static const routeName = "/dashboard";
  final String title;

  Dashboard({Key key, this.title}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // House
  int cellarHeight = 0;
  int totalGroundHeight = 0;
  int currentWaterLevel = 0;
  int estimatedWaterLevel = 0;
  bool mainSensorSelected = false;
  DateTime serverTimestamp;
  Sensor sensor;

  // Weather
  String _icon;
  AssetImage _weatherIcon;
  DateTime _lastCheckedForecast;

  LectoraatApi lectoraatApi = LectoraatApi();

  void initState() {
    super.initState();

    _requestTomorrowsForecast();
    _getData();
  }

  void onResume() {
    _getData();
  }

  void _getData() async {
    Sensor sensor = await Model().getMainSensor().then((sensor) => sensor);
    if (sensor == null) {
      // Todo let the user select a main sensor
      return;
    }

    List values = await Future.wait([
      lectoraatApi.requestLatestSensorMeasurement(sensor.externalSensorId),
      lectoraatApi.requestMonitoringWell(sensor.externalMonitoringWellId),
    ]).then((List values) => values);

    SensorMeasurement sensorMeasurement = values[0] as SensorMeasurement;
    MonitoringWell monitoringWell = values[1] as MonitoringWell;

    if (sensorMeasurement == null || monitoringWell == null) {
      return;
    }

    // groundLevel - topMonitoringWell is the height in meters that the monitoringWell is under the ground.
    double totalGroundHeightInMeters = monitoringWell.totalLength + (monitoringWell.groundLevel - monitoringWell.topMonitoringWell);

    int totalGroundHeightInCentimeters = (totalGroundHeightInMeters * 100).toInt();

    setState(() {
      this.cellarHeight = min(sensor.cellarHeight ?? 0, totalGroundHeightInCentimeters);
      this.totalGroundHeight = totalGroundHeightInCentimeters;
      this.currentWaterLevel = sensorMeasurement.levelFromGround ~/ 10;
      this.estimatedWaterLevel = totalGroundHeight; // Todo change when we actually predict the level
      this.serverTimestamp = sensorMeasurement.serverTimestamp;
      this.mainSensorSelected = Model().isMainSensorSelected();
    });
  }

  void _navigateTo(String route) {
    Navigator.of(context).pushNamed(route).then((value) {
      onResume();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.dashboardAppBarTitle),
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.device_hub),
            onPressed: () {
              _navigateTo(DecisionTreePage.routeName);
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              _navigateTo(Settings.routeName);
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 16, left: 32, right: 32),
              child: House(
                cellarHeight: cellarHeight,
                totalGroundHeight: totalGroundHeight,
                estimatedWaterLevel: estimatedWaterLevel,
                currentWaterLevel: currentWaterLevel,
                serverTimestamp: serverTimestamp,
                weatherIcon: _weatherIcon,
                mainSensorSelected: mainSensorSelected,
                refreshData: _getData,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: OutlineButton(
              color: Theme.of(context).buttonColor,
              onPressed: () {
                _navigateTo(Details.routeName);
              },
              child: Text(
                Strings.dashboardNavigateToDetails,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: GroundColor.accent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _requestTomorrowsForecast() async {
    if (_lastCheckedForecast == null || _lastCheckedForecast.day != DateTime.now().day) {
      // TODO - remove hardcoded coordinates
      DateTime tomorrow = DateTime.now().add(Duration(days: 1));
      var _forecast = await WeatherApi().requestForecast(tomorrow, tomorrow, 52.22, 6.9);

      if (_forecast.isNotEmpty) {
        if (_icon != _forecast[0].icon) {
          setState(() {
            _icon = _forecast[0].icon.toString();

            switch (_icon) {
              case "rain":
                _weatherIcon = AssetImage("assets/rain.png");
                break;
              case "snow":
                _weatherIcon = AssetImage("assets/snow.png");
                break;
              case "clear":
                _weatherIcon = AssetImage("assets/clear.png");
                break;
              case "partly-cloudy":
                _weatherIcon = AssetImage("assets/partly-cloudy.png");
                break;
              case "partly-cloudy-day":
                _weatherIcon = AssetImage("assets/partly-cloudy.png");
                break;
              case "cloudy":
                _weatherIcon = AssetImage("assets/cloudy.png");
                break;
              default:
                _weatherIcon;
                break;
            }
          });
        }
      }

      _lastCheckedForecast = DateTime.now();
    }
  }
}
