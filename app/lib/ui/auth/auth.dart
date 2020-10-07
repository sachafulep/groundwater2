import "package:flutter/material.dart";
import "package:groundwater/ui/auth/login.dart";
import "package:groundwater/ui/auth/verify_sensor.dart";
import "package:groundwater/utils/strings.dart";

/// Class responsible for all auth related stuff, like verifying a sensor and logging in via OAuth
class Auth extends StatefulWidget {
  static const routeName = "/auth";

  Auth({Key key}) : super(key: key);

  @override
  AuthState createState() => AuthState();
}

class AuthState extends State<Auth> {
  AuthState();

  String _sensorUuid = "";
  bool _sensorUuidVerified = false;

  void _sensorUuidVerifiedCallback(String uuid, bool verified) {
    if (verified) {
      setState(() {
        _sensorUuid = uuid;
        _sensorUuidVerified = true;
      });
    } else {
      setState(() {
        _sensorUuidVerified = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(Strings.loginAppBarTitle),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 16, right: 16),
        child: Container(
          height: double.maxFinite,
          child:
              _sensorUuidVerified ? Login(sensorUuid: _sensorUuid) : VerifySensor(sensorUuidVerifiedCallback: _sensorUuidVerifiedCallback),
        ),
      ),
    );
  }
}
