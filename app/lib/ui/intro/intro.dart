import "package:flutter/material.dart";
import "package:groundwater/model/model.dart";
import "package:groundwater/ui/auth/auth.dart";
import "package:groundwater/utils/colors.dart";
import "package:groundwater/utils/strings.dart";

enum Slides { first, second }

/// Class responsible for onboarding the user into the app
class Intro extends StatefulWidget {
  static const routeName = "/intro";

  Intro();

  @override
  State<StatefulWidget> createState() => IntroState();
}

class IntroState extends State<Intro> {
  IntroState();

  Slides currentSlide = Slides.first;

  void _nextSlide() {
    setState(() {
      currentSlide = Slides.values[currentSlide.index + 1];
    });
  }

  void _previousSlide() {
    setState(() {
      currentSlide = Slides.values[currentSlide.index - 1];
    });
  }

  void _chooseSensorRegistration(bool sensorRegistered) async {
    await Model().setIntroDone(true);
    if (sensorRegistered) {
      await Navigator.of(context).pushNamed(Auth.routeName);
    } else {
      // TODO go to sensor registration
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 16, right: 16),
        child: Container(
          height: double.maxFinite,
          child: _buildIntroItem(),
        ),
      ),
    );
  }

  Widget _buildIntroItem() {
    if (currentSlide == Slides.first) {
      return _introItem(
          "assets/graphic-intro-first.png", Strings.introFirstTitle, Strings.introFirstBody, null, Strings.introNext, null, _nextSlide);
    }

    if (currentSlide == Slides.second) {
      return _introItem("assets/graphic-intro-second.png", Strings.introSecondTitle, Strings.introSecondBody, Strings.introPrevious,
          Strings.introNext, _previousSlide, null);
    }

    return Container();
  }

  Widget _introItem(String graphic, String title, String description, String leftActionText, String rightActionText, Function() leftAction,
      Function() rightAction) {
    double _deviceWidth = MediaQuery.of(context).size.width;
    var graphicPadding = _deviceWidth * 0.1;

    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: graphicPadding, right: graphicPadding, bottom: 16, top: graphicPadding),
                    child: Image(
                      image: AssetImage(graphic),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: GroundColor.subText, height: 1.4),
                    ),
                  ),
                  if (currentSlide == Slides.second)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlineButton(
                          child: Text(Strings.introSecondAlreadyRegisteredAction),
                          color: Theme.of(context).buttonColor,
                          onPressed: () {
                            _chooseSensorRegistration(true);
                          },
                          textColor: GroundColor.accent,
                        ),
                      ),
                    ),
                  if (currentSlide == Slides.second)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlineButton(
                          child: Text(Strings.introSecondRegisterNewAction),
                          color: Theme.of(context).buttonColor,
                          onPressed: () {
                            _chooseSensorRegistration(false);
                          },
                          textColor: GroundColor.accent,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  currentSlide == Slides.first
                      ? Container()
                      : FlatButton(
                          child: Text(
                            leftActionText,
                            style: TextStyle(
                              color: GroundColor.subText,
                            ),
                          ),
                          onPressed: leftAction,
                        ),
                  if (currentSlide != Slides.second)
                    FlatButton(
                      child: Text(
                        rightActionText,
                        style: TextStyle(
                          color: GroundColor.accent,
                        ),
                      ),
                      onPressed: rightAction,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
