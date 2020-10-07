class MonitoringWellMeasurement {
  final int id;
  final DateTime sensorTimestamp;
  final DateTime serverTimestamp;
  final double groundwaterLevel;
  final int monitoringWell;
  final int sensorMeting;

  MonitoringWellMeasurement({
    this.id,
    this.sensorTimestamp,
    this.serverTimestamp,
    this.groundwaterLevel,
    this.monitoringWell,
    this.sensorMeting,
  });

  factory MonitoringWellMeasurement.fromJson(dynamic json) {
    return MonitoringWellMeasurement(
      id: int.tryParse(json["id"].toString()),
      sensorTimestamp: DateTime.tryParse(json["sensor_timestamp"].toString()),
      serverTimestamp: DateTime.tryParse(json["server_timestamp"].toString()),
      groundwaterLevel: double.tryParse(json["groundwater_level"].toString()),
      monitoringWell: int.tryParse(json["peilbuis"].toString()),
      sensorMeting: int.tryParse(json["sensormeting"].toString()),
    );
  }

  @override
  String toString() {
    return "MonitoringWellMeasurement{id: $id, sensorTimestamp: $sensorTimestamp, serverTimestamp: $serverTimestamp, groundwaterLevel: $groundwaterLevel, monitoringWell: $monitoringWell, sensorMeting: $sensorMeting}";
  }
}
