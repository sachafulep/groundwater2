import "dart:convert";
import "dart:io";

import "package:flutter_auth0/flutter_auth0.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:groundwater/model/data/note/note.dart";
import "package:groundwater/model/data/sensor/sensor.dart";
import "package:groundwater/model/data/user/user.dart";
import "package:groundwater/model/model.dart";
import "package:groundwater/utils/keys.dart";
import "package:http/http.dart" as http;

class Api {
  Auth0 _auth0 = Auth0(baseUrl: "https://${DotEnv().env["OAUTH_DOMAIN"]}", clientId: DotEnv().env["OAUTH_CLIENT_ID"]);

  Future<Map> authorizeOAuth() async {
    return await _auth0.webAuth.authorize({
      "audience": DotEnv().env["OAUTH_AUDIENCE"],
      "scope": DotEnv().env["OAUTH_SCOPE"],
    });
  }

  Future<bool> refreshToken() async {
    Map<String, String> params = {"refreshToken": await Model().getRefreshToken()};
    var response = await _auth0.auth.refreshToken(params);

    if (response["access_token"] != null && response["id_token"] != null) {
      await Model().setAccessToken(response["access_token"] as String);
      await Model().setIdToken(response["id_token"] as String);
      return true;
    }

    return false;
  }

  Future<Map<String, String>> createHeaders() async {
    return {HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: "Bearer ${await Model().getAccessToken()}"};
  }

  Future<bool> checkTokenBeforeEachRequest() async {
    if (await Model().isAuthorized() == false) {
      Model().isAuthorizedRelay.add(false);
      return false;
    }

    return true;
  }

  Future<bool> isTokenExpired() async {
    var accessToken = await Model().preferences.getString(Keys.loginPreferencesKeyAccessToken);

    // Get the expiry time so we can check if the token should be refreshed
    final expiryTime = await getExpiryTimeFromToken(accessToken);
    var currentTime = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    return expiryTime <= currentTime;
  }

  Future<http.Response> loginOrRegister(String accessToken, String idToken, String sensorUuid) async {
    final Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    };

    Map<String, dynamic> body = {"idToken": idToken, "sensorUuid": sensorUuid, "firebaseToken" : await Model().firebaseMessaging.getToken()};

    return http.post("${DotEnv().env["API_URL"]}/users", headers: headers, body: jsonEncode(body));
  }

  Future<User> getCurrentUser() async {
    if (await checkTokenBeforeEachRequest() == false) return null;

    final response = await http.get("${DotEnv().env["API_URL"]}/users/me", headers: await createHeaders());
    if (response.statusCode == 200) {
      await Model().setUser(user: await User.fromJson(json.decode(response.body) as Map<String, dynamic>));
      return Model().getUser();
    } else {
      return null;
    }
  }

  Future<User> updateUser(User user) async {
    if (await checkTokenBeforeEachRequest() == false) return null;

    final response = await http.patch("${DotEnv().env["API_URL"]}/users/me", headers: await createHeaders(), body: jsonEncode(user.toJson()));
    if (response.statusCode == 200) {
      await Model().setUser(user: await User.fromJson(json.decode(response.body) as Map<String, dynamic>));
      return Model().getUser();
    } else {
      return null;
    }
  }

  Future<int> getExpiryTimeFromToken(String token) async {
    if (token != null && token.split(".").length == 3) {
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(token.split(".")[1])));
      return json.decode(payload)["exp"] as int;
    }

    return 0;
  }

  Future<bool> verifySensor(String sensorUuid) async {
    final response = await http.get("${DotEnv().env["API_URL"]}/sensors/verify/${sensorUuid}");
    return response.statusCode == 200 && jsonDecode(response.body)["exists"] == true;
  }

  Future<List<Sensor>> getSensors({String projection = ""}) async {
    if (await checkTokenBeforeEachRequest() == false) return null;

    final response = await http.get("${DotEnv().env["API_URL"]}/sensors?projection=${projection}", headers: await createHeaders());
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List<dynamic>).map((sensor) => Sensor.fromJson(sensor as Map<String, dynamic>)).toList();
    } else {
      return null;
    }
  }

  Future<Sensor> updateSensor(Sensor sensor) async {
    if (await checkTokenBeforeEachRequest() == false) return null;

    Map<String, dynamic> body = sensor.toJson();

    final response = await http.patch("${DotEnv().env["API_URL"]}/sensors/${sensor.internalId}", headers: await createHeaders(), body: jsonEncode(body));
    if (response.statusCode == 200) {
      return Sensor.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<List<Note>> getNotesByDataPointId(int dataPointId) async {
    if (await checkTokenBeforeEachRequest() == false) return null;

    final response = await http.get("${DotEnv().env["API_URL"]}/notes/$dataPointId}", headers: await createHeaders());
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List<dynamic>).map((note) => Note.fromJson(note as Map<String, dynamic>)).toList();
    } else {
      return null;
    }
  }

  Future<List<Note>> getNotesByMonitoringWellId(int monitoringWellId) async {
    if (await checkTokenBeforeEachRequest() == false) return null;

    final response = await http.get("${DotEnv().env["API_URL"]}/notes/monitoring-well/$monitoringWellId}", headers: await createHeaders());
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List<dynamic>).map((note) => Note.fromJson(note as Map<String, dynamic>)).toList();
    } else {
      return null;
    }
  }

  Future<List<Note>> getNotesByMonitoringWellIds(List<int> monitoringWellIds) async {
    if (await checkTokenBeforeEachRequest() == false) return null;

    final response =
        await http.get("${DotEnv().env["API_URL"]}/notes/monitoring-wells/${monitoringWellIds.join(",")}", headers: await createHeaders());
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List<dynamic>).map((note) => Note.fromJson(note as Map<String, dynamic>)).toList();
    } else {
      return null;
    }
  }

  Future<bool> deleteNote(int noteId) async {
    if (await checkTokenBeforeEachRequest() == false) return null;

    final response = await http.delete("${DotEnv().env["API_URL"]}/notes/$noteId", headers: await createHeaders());
    return response.statusCode == 204;
  }

  Future<Note> createNote(int dataPointId, int monitoringWellId, String description) async {
    if (await checkTokenBeforeEachRequest() == false) return null;

    Map<String, dynamic> body = {"dataPointId": dataPointId, "externalMonitoringWellId": monitoringWellId, "description": description};

    final response = await http.post("${DotEnv().env["API_URL"]}/notes", headers: await createHeaders(), body: jsonEncode(body));
    if (response.statusCode == 201) {
      return Note.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<Note> updateNote(int noteId, String description) async {
    if (await checkTokenBeforeEachRequest() == false) return null;

    Map<String, dynamic> body = {"description": description};

    final response = await http.patch("${DotEnv().env["API_URL"]}/notes/$noteId", headers: await createHeaders(), body: jsonEncode(body));
    if (response.statusCode == 201) {
      return Note.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      return null;
    }
  }
}
