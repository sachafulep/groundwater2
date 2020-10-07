import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:groundwater/model/data/user/user.dart";
import "package:groundwater/model/model.dart";
import "package:groundwater/utils/colors.dart";
import "package:groundwater/utils/strings.dart";

typedef void LoginCallback();

/// Class responsible for handling the OAuth login and the eventual login / register with the backend
class Login extends StatefulWidget {
  Login({this.sensorUuid});

  final String sensorUuid;

  @override
  State<StatefulWidget> createState() => LoginState(sensorUuid: sensorUuid);
}

class LoginState extends State<Login> {
  LoginState({this.sensorUuid});

  final String sensorUuid;
  bool _oauthFailed = false;

  void _authenticate({bool google = false, bool facebook = false}) async {
    try {
      var oAuthResponse = await Model().api.authorizeOAuth();

      // Successful response
      if (oAuthResponse["token_type"] == "Bearer") {
        var idToken = oAuthResponse["id_token"] as String;
        var accessToken = oAuthResponse["access_token"] as String;
        var refreshToken = oAuthResponse["refresh_token"] as String;

        // Create an account or log in
        final apiResponse = await Model().api.loginOrRegister(accessToken, idToken, sensorUuid);
        if (apiResponse.statusCode == 200 || apiResponse.statusCode == 201) {
          // 200 = We already have an account, we are logged in
          // 201 = We have created an account
          await Model().setUser(user: await User.fromJson(json.decode(apiResponse.body) as Map<String, dynamic>));
          await Model().setMainSensor((await Model().getUser()).sensors[0]);
          await Model().setAccessToken(accessToken);
          await Model().setIdToken(idToken);
          await Model().setRefreshToken(refreshToken);
          await Model().setExpiryTime(await Model().getExpiryTime());
          await Model().isAuthorizedRelay.add(true);
          await Navigator.of(context).pop();
          // Successful, let's return because OAuth didn't fail
          return;
        }
      }
    } catch (e) {
      // Something went wrong
    }

    setState(() {
      _oauthFailed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Column(
      children: <Widget>[
        SingleChildScrollView(
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
                    Strings.loginAuthenticateBody,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: GroundColor.subText, height: 1.4),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: MaterialButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SvgPicture.asset("assets/Facebook.svg", height: 24, width: 24),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 32, right: 16),
                              child: Text(
                                Strings.loginAuthenticateActionFacebook,
                                textAlign: TextAlign.left,
                                style: TextStyle(color: GroundColor.primary),
                              ),
                            ),
                          ),
                        ],
                      ),
                      color: Color.fromRGBO(59, 89, 153, 1),
                      onPressed: () {
                        _authenticate(facebook: true);
                      }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlineButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SvgPicture.asset("assets/Google.svg", height: 24, width: 24),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 32, right: 24),
                                child: Text(
                                  Strings.loginAuthenticateActionGoogle,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: GroundColor.accent),
                                ),
                              ),
                            ),
                          ],
                        ),
                        color: Theme.of(context).buttonColor,
                      onPressed: () {
                        _authenticate(google: true);
                      }),
                  ),
                ),
                if (_oauthFailed)
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16, left: 24, right: 16),
                      child: Text(
                        Strings.loginAuthenticateFailedToLogin,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 10, color: GroundColor.error),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16, top: 16),
              child: Text(
                Strings.loginAuthenticateHintText,
                style: TextStyle(color: GroundColor.subText, height: 1.4, fontSize: 12),
              ),
            ),
          ),
        )
      ],
    );
  }
}
