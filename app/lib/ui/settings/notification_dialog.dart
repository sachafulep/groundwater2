import "package:flutter/material.dart";
import "package:groundwater/model/data/setting/setting.dart";
import "package:groundwater/model/model.dart";
import "package:groundwater/utils/colors.dart";
import "package:groundwater/utils/strings.dart";

class NotificationDialog extends StatefulWidget {
  NotificationDialog({Key key}) : super(key: key);

  @override
  _NotificationDialogState createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> {
  _NotificationDialogState();

  Setting changeConfig = Setting();

  @override
  void initState() {
    super.initState();
    changeConfig.showPrecipitationAmountAndDuration = Model().getUser().setting.showPrecipitationAmountAndDuration;
    changeConfig.showPrecipitationChance = Model().getUser().setting.showPrecipitationChance;
    changeConfig.showGroundWaterLevel = Model().getUser().setting.showGroundWaterLevel;
  }

  void _saveVisibility() async {
    var currentUser = await Model().getUser();
    currentUser.setting.showPrecipitationAmountAndDuration = changeConfig.showPrecipitationAmountAndDuration;
    currentUser.setting.showPrecipitationChance = changeConfig.showPrecipitationChance;
    currentUser.setting.showGroundWaterLevel = changeConfig.showGroundWaterLevel;
    var saveSuccess = await Model().setUser(user: currentUser, save: true);

    if (saveSuccess) {
      Navigator.of(context).pop();
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
      title: Text(Strings.settingsNotificationsNotificationsDialogTitle),
      contentPadding: EdgeInsets.only(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 24, right: 24, top: 16),
            child: Text(
              Strings.settingsNotificationsNotificationsDialogDescription,
              style: TextStyle(
                color: GroundColor.subText,
              ),
            ),
          ),
          Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                listItem(
                  title: Strings.settingsNotificationsNotificationsDialogPrecipitationTitle,
                  description: Strings.settingsNotificationsNotificationsDialogPrecipitationDescription,
                  switched: changeConfig.showPrecipitationAmountAndDuration == true,
                  onSwitch: (bool value) {
                    setState(() {
                      changeConfig.showPrecipitationAmountAndDuration = value;
                    });
                  },
                ),
                listItem(
                  title: Strings.settingsNotificationsNotificationsDialogPrecipitationChanceTitle,
                  description: Strings.settingsNotificationsNotificationsDialogPrecipitationChanceDescription,
                  switched: changeConfig.showPrecipitationChance == true,
                  onSwitch: (bool value) {
                    setState(() {
                      changeConfig.showPrecipitationChance = value;
                    });
                  },
                ),
                listItem(
                  title: Strings.settingsNotificationsNotificationsDialogGroundWaterLevelTitle,
                  description: Strings.settingsNotificationsNotificationsDialogGroundWaterLevelDescription,
                  switched: changeConfig.showGroundWaterLevel == true,
                  onSwitch: (bool value) {
                    setState(() {
                      changeConfig.showGroundWaterLevel = value;
                    });
                  },
                ),
              ],
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
            onPressed: _saveVisibility,
          ),
        ),
      ],
    );
  }

  Widget listItem({String title, String description, bool switched, Function(bool value) onSwitch}) {
    return InkWell(
      onTap: () {
        onSwitch(!switched);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 4, bottom: 4),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(title),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        color: GroundColor.subText,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Switch(
                value: switched,
                onChanged: onSwitch,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
