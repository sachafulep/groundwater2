import "package:flutter/material.dart";
import "package:groundwater/model/data/setting/precipitation_amount_options.dart";
import "package:groundwater/model/data/setting/precipitation_duration_options.dart";
import "package:groundwater/model/model.dart";
import "package:groundwater/ui/settings/groundwater_level_dialog.dart";
import "package:groundwater/ui/settings/notification_dialog.dart";
import "package:groundwater/ui/settings/precipitation_chance_dialog.dart";
import "package:groundwater/ui/settings/precipitation_dialog.dart";
import "package:groundwater/utils/colors.dart";
import "package:groundwater/utils/keys.dart";
import "package:groundwater/utils/strings.dart";

class SettingsNotifications extends StatefulWidget {
  static const routeName = "/settings-notifications";

  SettingsNotifications({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SettingsNotificationsState createState() => _SettingsNotificationsState();
}

class _SettingsNotificationsState extends State<SettingsNotifications> {
  @override
  void initState() {
    super.initState();

    // Listen to config changes
    Model().settingChanged.stream.listen((value) async {
      if (value == true) {
        setState(() {});
      }
    });
  }

  Widget build(BuildContext context) {
    int showedNotifications = 0;
    if (Model().getUser().setting.showGroundWaterLevel == true) showedNotifications++;
    if (Model().getUser().setting.showPrecipitationAmountAndDuration == true) showedNotifications++;
    if (Model().getUser().setting.showPrecipitationChance == true) showedNotifications++;

    String precipitationText = "" +
        "${PrecipitationAmountOptions.half.option(Model().getUser().setting.precipitationAmount).title}\n" +
        "${PrecipitationDurationOptions.none.option(Model().getUser().setting.precipitationDuration).title}";

    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.settingsNotificationsAppBarTitle),
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(bottom: 16),
              width: double.maxFinite,
              child: Text(
                Strings.settingsNotificationsSubtext,
                style: TextStyle(fontSize: 16, color: GroundColor.subText, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
            _settingsNotificationsItem(
              key: Key(Keys.settingsKeyNotifications),
              title: Strings.settingsNotificationsNotificationsTitle,
              description: Strings.settingsNotificationsNotificationsDescription,
              value: "$showedNotifications / 3",
              onClick: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return NotificationDialog();
                  },
                );
              },
            ),
            _settingsNotificationsItem(
              key: Key(Keys.settingsKeyDialogNotificationPrecipitation),
              title: Strings.settingsNotificationsPrecipitationTitle,
              description: Strings.settingsNotificationsPrecipitationDescription,
              value: precipitationText,
              onClick: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return PrecipitationDialog();
                  },
                );
              },
            ),
            _settingsNotificationsItem(
              key: Key(Keys.settingsKeyDialogNotificationPrecipitationChance),
              title: Strings.settingsNotificationsPrecipitationChanceTitle,
              description: Strings.settingsNotificationsPrecipitationChanceDescription,
              value: Model().getUser().setting.precipitationAmountChance == null ? "-" : "> ${Model().getUser().setting.precipitationAmountChance}%",
              onClick: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return PrecipitationChanceDialog();
                  },
                );
              },
            ),
            _settingsNotificationsItem(
              key: Key(Keys.settingsKeyDialogNotificationGroundWaterLevel),
              title: Strings.settingsNotificationsGroundWaterLevelTitle,
              description: Strings.settingsNotificationsGroundWaterLevelDescription,
              value: Model().getUser().setting.groundWaterLevel == null ? "-" : "> ${Model().getUser().setting.groundWaterLevel}cm",
              onClick: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return GroundWaterLevelDialog();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsNotificationsItem({Key key, String title, String description, String value, Function() onClick}) {
    return InkWell(
      key: key,
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, right: 16, bottom: 8, left: 16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16, color: GroundColor.text, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    description,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: GroundColor.subText,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: GroundColor.subText,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
