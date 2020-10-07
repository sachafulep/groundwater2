class WeatherMeasurement {
  final DateTime time;
  final double precipIntensity;
  final String icon;

  WeatherMeasurement({
    this.time,
    this.precipIntensity,
    this.icon,
  });

  factory WeatherMeasurement.fromJson(dynamic json) {
    int millisecondsSinceEpoch = (int.tryParse(json["time"].toString()) ?? 0) * 1000;
    if (millisecondsSinceEpoch == 0) return null;

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);

    return WeatherMeasurement(
      time: dateTime,
      precipIntensity: double.tryParse(json["precipIntensity"].toString()),
      icon: json["icon"].toString(),
    );
  }
}
