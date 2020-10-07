import "dart:convert";

import "package:groundwater/model/data/weather/weather_measurement.dart";
import "package:groundwater/model/model.dart";
import "package:http/http.dart";
import "package:http/http.dart" as http;

class WeatherApi {
  String _root = "https://api.darksky.net/forecast/";
  String _uri, _token;

  Future<List<WeatherMeasurement>> requestForecast(DateTime startDate, DateTime endDate, double lat, double lon) async {
    if (_token == null) {
      _token = await Model().getWeatherApiToken();
    }

    _uri = "$_root$_token/${lat.toString()},${lon.toString()}";

    Response response = await http.get(_uri);
    return _parseResponse(startDate, endDate, response.body);
  }

  List<WeatherMeasurement> _parseResponse(DateTime startDate, DateTime endDate, String body) {
    List<WeatherMeasurement> temp = [];

    if (body.isNotEmpty) {
      final parsed = json.decode(body);
      final forecasts = parsed["daily"]["data"] as List;

      int millisecondsSinceEpoch;
      DateTime dateTime;

      for (var forecast in forecasts) {
        millisecondsSinceEpoch = (int.tryParse(forecast["time"].toString()) ?? 0) * 1000;
        if (millisecondsSinceEpoch == 0) {
          continue;
        }
        dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
        if (dateTime.isAfter(startDate) && dateTime.isBefore(endDate) || dateTime.day == startDate.day && dateTime.day == endDate.day) {
          final weatherMeasurement = WeatherMeasurement.fromJson(forecast);
          if (weatherMeasurement != null) {
            temp.add(weatherMeasurement);
          }
        }
      }
    }

    return temp;
  }
}
