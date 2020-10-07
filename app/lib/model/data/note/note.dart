import "package:groundwater/model/data/user/simple_user.dart";

class Note {
  final int id;
  final int dataPointId;
  final int creationDate;
  final int externalMonitoringWellId;
  String description;
  SimpleUser user;

  Note({this.id, this.dataPointId, this.creationDate, this.externalMonitoringWellId, this.description, this.user});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json["id"] as int,
      dataPointId: json["dataPointId"] as int,
      creationDate: json["creationDate"] as int,
      externalMonitoringWellId: json["externalMonitoringWellId"] as int,
      description: json["description"] as String,
      user: SimpleUser.fromJson(json["user"] as Map<String, dynamic>),
    );
  }

  @override
  String toString() {
    return "Note{id: $id, dataPointId: $dataPointId, creationDate: $creationDate, externalMonitoringWellId: $externalMonitoringWellId, description: $description, user: $user}";
  }
}
