class Sensor {
  final int internalId;
  final String uuid;
  final int externalSensorId;
  final int externalMonitoringWellId;
  final String name;
  final double latitude;
  final double longitude;
  final String address;
  final int cellarHeight;

  Sensor({
    this.internalId,
    this.uuid,
    this.externalSensorId,
    this.externalMonitoringWellId,
    this.name,
    this.latitude,
    this.longitude,
    this.address,
    this.cellarHeight,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
        internalId: int.tryParse(json["internalId"].toString()),
        uuid: json["uuid"] == null ? null : json["uuid"].toString(),
        externalSensorId: int.tryParse(json["externalSensorId"].toString()),
        externalMonitoringWellId: int.tryParse(json["externalMonitoringWellId"].toString()),
        name: json["name"] == null ? null : json["name"].toString(),
        latitude: double.tryParse(json["latitude"].toString()),
        longitude: double.tryParse(json["longitude"].toString()),
        address: json["address"] == null ? null : json["address"].toString(),
        cellarHeight: int.tryParse(json["cellarHeight"].toString()));
  }

  Map<String, dynamic> toJson() => {
        "internalId": internalId?.toString(),
        "uuid": uuid,
        "externalSensorId": externalSensorId?.toString(),
        "externalMonitoringWellId": externalMonitoringWellId?.toString(),
        "name": name,
        "latitude": latitude?.toString(),
        "longitude": longitude?.toString(),
        "address": address,
        "cellarHeight": cellarHeight
      };

  @override
  String toString() {
    return "Sensor{internalId: $internalId, uuid: $uuid, externalSensorId: $externalSensorId, externalMonitoringWellId: $externalMonitoringWellId, name: $name, latitude: $latitude, longitude: $longitude, address: $address, cellarHeight: $cellarHeight}";
  }
}
