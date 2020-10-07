import "package:flutter/material.dart";
import "package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart";
import "package:groundwater/model/model.dart";
import "package:groundwater/utils/colors.dart";
import "package:groundwater/utils/keys.dart";
import "package:groundwater/utils/strings.dart";

typedef void SensorUuidVerifiedCallback(String sensorUuid, bool verified);

/// Class responsible for verifying the sensor with the backend
class VerifySensor extends StatefulWidget {
  VerifySensor({this.sensorUuidVerifiedCallback});

  final SensorUuidVerifiedCallback sensorUuidVerifiedCallback;

  @override
  State<StatefulWidget> createState() => VerifyState(sensorUuidVerifiedCallback: sensorUuidVerifiedCallback);
}

class VerifyState extends State<VerifySensor> {
  VerifyState({this.sensorUuidVerifiedCallback});

  final SensorUuidVerifiedCallback sensorUuidVerifiedCallback;

  final sensorUuidController = TextEditingController();
  String _sensorUuidErrorText = "";
  bool _keyboardOpen = false;

  @override
  void initState() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardOpen = visible;
        });
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    sensorUuidController.dispose();
    super.dispose();
  }

  void _verifySensor() async {
    try {
      if (await Model().api.verifySensor(sensorUuidController.text)) {
        // Found the sensor, it exists, continue
        sensorUuidVerifiedCallback(sensorUuidController.text, true);
        return;
      }
    } catch (e) {
      // Failed
    }

    setState(() {
      _sensorUuidErrorText = Strings.loginSensorInvalidUuid;
    });

    // If the user changes the value, reset the error text
    void continueTypingListener() {
      setState(() {
        _sensorUuidErrorText = null;
      });
      sensorUuidController.removeListener(continueTypingListener);
    }

    sensorUuidController.addListener(continueTypingListener);
  }

  void _goToAuthentication() {
    sensorUuidVerifiedCallback("", true);
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: deviceWidth * 0.2, right: deviceWidth * 0.2, bottom: 16, top: 16),
                    child: Image(
                      image: AssetImage("assets/graphic-login.png"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      Strings.loginTitle,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                    child: Text(
                      Strings.loginSensorBody,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: GroundColor.subText, height: 1.4),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                    child: TextField(
                      controller: sensorUuidController,
                      onSubmitted: (String text) {
                        _verifySensor();
                      },
                      decoration: InputDecoration(
                          filled: true,
                          contentPadding: const EdgeInsets.all(16),
                          border: InputBorder.none,
                          errorStyle: TextStyle(height: _sensorUuidErrorText == "" ? 0 : null),
                          errorText: _sensorUuidErrorText,
                          hintText: Strings.loginSensorFieldTitle),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 48,
                      child: Text(Strings.loginSensorActionContinue),
                      color: Theme.of(context).buttonColor,
                      onPressed: _verifySensor,
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!_keyboardOpen)
          Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    key: Key(Keys.loginSensorHintTextActionKey),
                    onTap: _goToAuthentication,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: GroundColor.subText, height: 1.4),
                        children: <TextSpan>[
                          TextSpan(text: Strings.loginSensorHintText),
                          TextSpan(
                            text: Strings.loginSensorHintTextAction,
                            style: TextStyle(color: GroundColor.accent),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
