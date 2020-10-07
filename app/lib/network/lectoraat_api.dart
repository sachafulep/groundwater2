import "dart:convert";

import "package:groundwater/model/data/lectoraat/monitoring_well.dart";
import "package:groundwater/model/model.dart";
import "package:http/http.dart";
import "package:http/http.dart" as http;
import "package:groundwater/model/data/lectoraat/monitoring_well_measurement.dart";
import "package:groundwater/model/data/lectoraat/sensor_measurement.dart";

class LectoraatApi {
  String _root = "https://cms.smartenschede.nl/_/items";
  String _collectionMonitoringWellMeasurements = "/peilbuismetingen";
  String _collectionSensorMeasurements = "/sensormetingen";
  String _collectionMonitoringWell = "/peilbuizen";
  String token;

  Future<Response> createRequest(String uri) async {
    if (token == null) {
      token = await Model().getLectoraatBearerToken();
    }

    return await http.get(
      uri,
      headers: {
        "Authorization": token,
      },
    );
  }

  /// Gets the latest known sensor measurement of a sensor
  Future<SensorMeasurement> requestLatestSensorMeasurement(int sensorId) async {
    List<String> filters = [];
    filters.add("filter[sensor][eq]=${sensorId}");
    filters.add("sort=-sensor_timestamp&limit=1");

    String uri = "${_root}${_collectionSensorMeasurements}?${filters.join("&")}";

    String body = (await createRequest(uri)).body;

    if (body.isNotEmpty) {
      final parsed = json.decode(body) as Map<String, dynamic>;
      final dataSets = parsed["data"];

      if (dataSets != null && dataSets.length != 0) return SensorMeasurement.fromJson(dataSets[0]);
    }

    return null;
  }

  /// Gets a monitoring well by id
  Future<MonitoringWell> requestMonitoringWell(int monitoringWellId) async {
    List<String> filters = [];
    filters.add("filter[id][eq]=${monitoringWellId}");

    String uri = "${_root}${_collectionMonitoringWell}?${filters.join("&")}";

    String body = (await createRequest(uri)).body;

    if (body.isNotEmpty) {
      final parsed = json.decode(body) as Map<String, dynamic>;
      final dataSets = parsed["data"];

      if (dataSets != null && dataSets.length != 0) return MonitoringWell.fromJson(dataSets[0]);
    }

    return null;
  }

  Future<List<MonitoringWellMeasurement>> requestMonitoringWellMeasurements(startDateTime, endDateTime, int monitoringWellId) async {
    List<String> filters = [];
    filters.add("filter[peilbuis][eq]=${monitoringWellId}");

    endDateTime = endDateTime.add(Duration(days: 1));

    filters.add("filter[sensor_timestamp][between]=${startDateTime.year}-${startDateTime.month}-${startDateTime.day},${endDateTime.year}-${endDateTime.month}-${endDateTime.day}");

    String uri = "${_root}${_collectionMonitoringWellMeasurements}?${filters.join("&")}";

    return _parseMonitoringWellMeasurements((await createRequest(uri)).body);
  }

  Future<List<MonitoringWellMeasurement>> requestCombinedMonitoringWellMeasurements(DateTime startDateTime, DateTime endDateTime, int sensorId) async {
    List<int> months = _getMonths(startDateTime, endDateTime);

    List<MonitoringWellMeasurement> responses = [];

    DateTime start;
    DateTime end;
    int year = startDateTime.year;

    for (var month in months) {
      if (month == startDateTime.month) {
        start = DateTime(year, month, startDateTime.day);
        end = DateTime(year, months[months.indexOf(month) + 1], 0);
      } else if (month == endDateTime.month) {
        start = DateTime(year, month, 1);
        end = DateTime(year, month, endDateTime.day);
      } else {
        start = DateTime(year, month, 1);
        end = DateTime(year, months[months.indexOf(month) + 1], 0);
      }

      List<MonitoringWellMeasurement> response = await requestMonitoringWellMeasurements(start, end, sensorId);
      responses.addAll(response);

      if (month == 12) year++;
    }

    return responses;
  }

  List<MonitoringWellMeasurement> _parseMonitoringWellMeasurements(String body) {
    List<MonitoringWellMeasurement> temp = [];

    if (body.isNotEmpty) {
      final parsed = json.decode(body) as Map<String, dynamic>;
      final dataSets = parsed["data"];

      dataSets.forEach((measurement) => {temp.add(MonitoringWellMeasurement.fromJson(measurement))});
    }

    return temp;
  }

  List<int> _getMonths(DateTime start, DateTime end) {
    List<int> months = [];
    int month = start.month;
    int year = start.year;
    bool endReached = false;

    while (!endReached) {
      months.add(month);

      if (month == 12) {
        month = 1;
        year++;
      } else {
        month++;
      }

      if (year == end.year && month == end.month) endReached = true;
    }

    months.add(end.month);

    return months;
  }
}
