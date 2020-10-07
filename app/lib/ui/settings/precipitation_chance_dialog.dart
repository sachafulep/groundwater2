import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:groundwater/model/model.dart";
import "package:groundwater/utils/colors.dart";
import "package:groundwater/utils/strings.dart";

class PrecipitationChanceDialog extends StatefulWidget {
  PrecipitationChanceDialog({Key key}) : super(key: key);

  @override
  _PrecipitationChanceDialogState createState() => _PrecipitationChanceDialogState();
}

class _PrecipitationChanceDialogState extends State<PrecipitationChanceDialog> {
  _PrecipitationChanceDialogState();

  final precipitationChanceController = TextEditingController();
  String _errorText;

  @override
  void initState() {
    super.initState();
    if (Model().getUser().setting.precipitationAmountChance != null) {
      precipitationChanceController.text = Model().getUser().setting.precipitationAmountChance.toString();
    }
  }

  @override
  void dispose() {
    super.dispose();
    precipitationChanceController.dispose();
  }

  void setError({String text}) {
    void continueTypingListener() {
      setState(() {
        _errorText = null;
      });
      precipitationChanceController.removeListener(continueTypingListener);
    }

    setState(() {
      _errorText = text;
    });
    precipitationChanceController.addListener(continueTypingListener);
  }

  void saveGroundWaterLevel() async {
    int precipitationChance = int.tryParse(precipitationChanceController.text);

    if (precipitationChance == null || precipitationChance < 0 || precipitationChance > 100) {
      setError(
          text: precipitationChance == null
              ? Strings.settingsNotificationsPrecipitationChanceDialogError
              : Strings.settingsNotificationsPrecipitationChanceDialogErrorRange);
    } else {
      var currentUser = await Model().getUser();
      currentUser.setting.precipitationAmountChance = precipitationChance;
      currentUser.setting.showPrecipitationChance = true;
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
      title: Text(Strings.settingsNotificationsPrecipitationChanceDialogTitle),
      contentPadding: EdgeInsets.only(left: 16, top: 16, right: 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
            child: Text(
              Strings.settingsNotificationsPrecipitationChanceDialogDescription,
              style: TextStyle(
                color: GroundColor.subText,
              ),
            ),
          ),
          Container(
            width: double.maxFinite,
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(),
              controller: precipitationChanceController,
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
                hintText: Strings.settingsNotificationsPrecipitationChanceDialogInput,
              ),
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
