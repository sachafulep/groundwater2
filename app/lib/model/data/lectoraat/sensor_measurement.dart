class SensorMeasurement {
  final int id;
  final int level;
  final int levelFromGround;
  final DateTime sensorTimestamp;
  final DateTime serverTimestamp;
  final double temperature;

  SensorMeasurement({
    this.id,
    this.level,
    this.levelFromGround,
    this.sensorTimestamp,
    this.serverTimestamp,
    this.temperature,
  });

  factory SensorMeasurement.fromJson(dynamic json) {
    return SensorMeasurement(
      id: int.tryParse(json["id"].toString()),
      level: int.tryParse(json["level"].toString()),
      levelFromGround: int.tryParse(json["level_from_ground"].toString()),
      sensorTimestamp: DateTime.tryParse(json["sensor_timestamp"].toString()),
      serverTimestamp: DateTime.tryParse(json["server_timestamp"].toString()),
      temperature: double.tryParse(json["temperature"].toString()),
    );
  }

  @override
  String toString() {
    return "SensorMeasurement{id: $id, level: $level, levelFromGround: $levelFromGround, sensorTimestamp: $sensorTimestamp, serverTimestamp: $serverTimestamp, temperature: $temperature}";
  }
}