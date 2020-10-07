import "package:groundwater/model/data/setting/setting.dart";
import "package:groundwater/model/data/sensor/sensor.dart";

class User {
  final int id;
  final String oauthProvider;
  final String oauthId;
  String username;
  String name;
  final List<Sensor> sensors;
  final String firebaseToken;
  Setting setting = Setting();

  User({this.id, this.oauthProvider, this.oauthId, this.username, this.name, this.sensors, this.firebaseToken, this.setting});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: int.tryParse(json["id"].toString()),
        oauthProvider: json["oauthProvider"].toString(),
        oauthId: json["oauthId"].toString(),
        username: json["username"].toString(),
        name: json["name"].toString(),
        sensors: (json["sensors"] as List<dynamic>).map((sensor) => Sensor.fromJson(sensor as Map<String, dynamic>)).toList(),
        firebaseToken: json["firebaseToken"].toString(),
        setting: Setting.fromJson(json["setting"] as Map<String, dynamic>));
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "oauthProvider": oauthProvider,
        "oauthId": oauthId,
        "username": username,
        "name": name,
        "sensors": sensors,
        "firebaseToken": firebaseToken,
        "setting": setting.toJson()
      };

  @override
  String toString() {
    return "User{id: $id, oauthProvider: $oauthProvider, oauthId: $oauthId, username: $username, name: $name, sensors: $sensors, firebaseToken: $firebaseToken, setting: $setting}";
  }
}
