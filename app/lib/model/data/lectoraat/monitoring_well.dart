class MonitoringWell {
  final int id;
  final double totalLength;
  final double topMonitoringWell;
  final double groundLevel;

  MonitoringWell({
    this.id,
    this.totalLength,
    this.topMonitoringWell,
    this.groundLevel
  });

  factory MonitoringWell.fromJson(dynamic json) {
    return MonitoringWell(
      id: int.tryParse(json["id"].toString()),
      totalLength: double.tryParse(json["totale_lengte"].toString()),
      topMonitoringWell: double.tryParse(json["bovenkant_peilbuis"].toString()),
      groundLevel: double.tryParse(json["maaiveld"].toString())
    );
  }

  @override
  String toString() {
    return "MonitoringWell{id: $id, totalLength: $totalLength, topMonitoringWell: $topMonitoringWell, groundLevel: $groundLevel}";
  }
}