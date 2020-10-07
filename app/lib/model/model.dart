import "dart:async";
import "dart:convert";

import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:groundwater/model/data/sensor/sensor.dart";
import "package:groundwater/model/data/user/user.dart";
import "package:groundwater/network/api.dart";
import "package:groundwater/utils/keys.dart";
import "package:shared_preferences/shared_preferences.dart";

class Model {
  static final Model _model = Model._internal();
  factory Model() {
    return _model;
  }

  Model._internal();

  SharedPreferences preferences;
  Api api;
  User _user;
  Sensor mainSensor;
  FirebaseMessaging firebaseMessaging;
  StreamController<bool> isAuthorizedRelay = StreamController.broadcast();
  StreamController<bool> settingChanged = StreamController.broadcast();

  Future initialize() async {
    api = Api();
    preferences = await SharedPreferences.getInstance();

    if (preferences.containsKey(Keys.userPreferencesKey)) {
      _user = await User.fromJson(json.decode(preferences.getString(Keys.userPreferencesKey)) as Map<String, dynamic>);
    }

    firebaseMessaging = FirebaseMessaging();
  }

  // Make sure the user is logged in, and when the token is expired, refresh it
  Future<bool> isAuthorized() async {
    bool isAuthorized = true;
    if (await preferences.containsKey(Keys.loginPreferencesKeyAccessToken) == false) {
      isAuthorized = false;
    } else if (await api.isTokenExpired()) {
      isAuthorized = await api.refreshToken();
    }

    return isAuthorized;
  }

  Future<bool> getIntroDone() async => await preferences.getBool(Keys.introPreferencesKeyIntroDone);
  Future<String> getAccessToken() async => await preferences.getString(Keys.loginPreferencesKeyAccessToken);
  Future<String> getIdToken() async => await preferences.getString(Keys.loginPreferencesKeyIdToken);
  Future<String> getRefreshToken() async => await preferences.getString(Keys.loginPreferencesKeyRefreshToken);
  Future<int> getExpiryTime() async => await preferences.getInt(Keys.loginPreferencesKeyAccessTokenExpiryTime);
  Future<String> getWeatherApiToken() async => await DotEnv().env[Keys.weatherApiKey];
  Future<String> getLectoraatBearerToken() async => "Bearer ${await DotEnv().env[Keys.lectoraatBearerToken]}";
  void setIntroDone(bool introDone) async => await preferences.setBool(Keys.introPreferencesKeyIntroDone, introDone);
  void setAccessToken(String accessToken) async => await preferences.setString(Keys.loginPreferencesKeyAccessToken, accessToken);
  void setIdToken(String idToken) async => await preferences.setString(Keys.loginPreferencesKeyIdToken, idToken);
  void setRefreshToken(String refreshToken) async => await preferences.setString(Keys.loginPreferencesKeyRefreshToken, refreshToken);
  void setExpiryTime(int expiryTime) async => await preferences.setInt(Keys.loginPreferencesKeyAccessTokenExpiryTime, expiryTime);

  Future<Sensor> getMainSensor() async {
    if (mainSensor == null) {
      if (preferences.containsKey(Keys.sensorPreferencesKeyMainSensor)) {
        mainSensor = Sensor.fromJson(json.decode(preferences.getString(Keys.sensorPreferencesKeyMainSensor)) as Map<String, dynamic>);
      } else {
        // No sensor currently or cached
        return null;
      }
    }

    return mainSensor;
  }

  void setMainSensor(Sensor sensor) async {
    await preferences.setString(Keys.sensorPreferencesKeyMainSensor, json.encode(sensor.toJson()));
    mainSensor = sensor;
  }

  User getUser() => User.fromJson(json.decode(json.encode(_user.toJson())) as Map<String, dynamic>);

  Future<bool> setUser({User user, bool save = false}) async {
    if (save) {
      return await api.updateUser(user) != null;
    } else {
      await preferences.setString(Keys.userPreferencesKey, json.encode(user.toJson()));
      _user = user;
      settingChanged.add(true);
      return true;
    }
  }

  bool isMainSensorSelected() => (mainSensor != null && getUser().sensors.firstWhere((sensor) => sensor.internalId == mainSensor.internalId, orElse: () => null) != null);
}
