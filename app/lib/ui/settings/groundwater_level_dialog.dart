import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:groundwater/model/model.dart";
import "package:groundwater/utils/colors.dart";
import "package:groundwater/utils/strings.dart";

class GroundWaterLevelDialog extends StatefulWidget {
  GroundWaterLevelDialog({Key key}) : super(key: key);

  @override
  _GroundWaterLevelDialogState createState() => _GroundWaterLevelDialogState();
}

class _GroundWaterLevelDialogState extends State<GroundWaterLevelDialog> {
  _GroundWaterLevelDialogState();

  final groundWaterLevelController = TextEditingController();
  String _errorText;

  @override
  void initState() {
    super.initState();

    if (Model().getUser().setting.groundWaterLevel != null) {
      groundWaterLevelController.text = Model().getUser().setting.groundWaterLevel.toString();
    }
  }

  void setError({String text}) {
    void continueTypingListener() {
      setState(() {
        _errorText = null;
      });
      groundWaterLevelController.removeListener(continueTypingListener);
    }

    setState(() {
      _errorText = text ?? Strings.settingsNotificationsGroundWaterLevelDialogError;
    });
    groundWaterLevelController.addListener(continueTypingListener);
  }

  void saveGroundWaterLevel() async {
    int groundWaterLevel = int.tryParse(groundWaterLevelController.text);

    if (groundWaterLevel == null) {
      setError();
    } else {
      var currentUser = await Model().getUser();
      currentUser.setting.groundWaterLevel = groundWaterLevel;
      currentUser.setting.showGroundWaterLevel = true;
      var saveSuccess = await Model().setUser(user: currentUser, save: true);

      if (saveSuccess) {
        Navigator.of(context).pop();
      } else {
        setError(text: Strings.saveFailed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      title: Text(Strings.settingsNotificationsGroundWaterLevelDialogTitle),
      contentPadding: EdgeInsets.only(left: 16, top: 16, right: 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
            child: Text(
              Strings.settingsNotificationsGroundWaterLevelDialogDescription,
              style: TextStyle(
                color: GroundColor.subText,
              ),
            ),
          ),
          Container(
            width: double.maxFinite,
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(),
              controller: groundWaterLevelController,
              inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                filled: true,
                errorText: _errorText,
                errorMaxLines: 3,
                suffixIcon: SvgPicture.asset(
                  "assets/icon-water.svg",
                  width: 16,
                  height: 16,
                  fit: BoxFit.none,
                  color: GroundColor.accent,
                ),
                contentPadding: EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                hintText: Strings.settingsNotificationsGroundWaterLevelDialogInput,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: OutlineButton(
              child: Text("Stel diepte in op uw kelder niveau"),
              color: Theme.of(context).buttonColor,
              onPressed: () {
                Model().getMainSensor().then((sensor) => {
                  groundWaterLevelController.text = (sensor?.cellarHeight ?? 0).toString(),
                });
              },
              textColor: GroundColor.accent,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            Strings.cancel,
            style: TextStyle(color: GroundColor.subText),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        Padding(
          padding: EdgeInsets.only(right: 8),
          child: FlatButton(
            child: Text(
              Strings.save,
              style: TextStyle(color: GroundColor.accent),
            ),
            onPressed: saveGroundWaterLevel,
          ),
        ),
      ],
    );
  }
}
