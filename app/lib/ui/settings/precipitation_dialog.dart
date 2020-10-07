import "package:flutter/material.dart";
import "package:groundwater/model/data/setting/precipitation_amount_options.dart";
import "package:groundwater/model/data/setting/precipitation_duration_options.dart";
import "package:groundwater/model/model.dart";
import "package:groundwater/utils/colors.dart";
import "package:groundwater/utils/keys.dart";
import "package:groundwater/utils/strings.dart";

class PrecipitationDialog extends StatefulWidget {
  PrecipitationDialog({Key key}) : super(key: key);

  @override
  _PrecipitationDialogState createState() => _PrecipitationDialogState();
}

class _PrecipitationDialogState extends State<PrecipitationDialog> {
  _PrecipitationDialogState();

  PrecipitationAmountOptions precipitationAmountOptions = PrecipitationAmountOptions.half;
  PrecipitationDurationOptions precipitationDurationOptions = PrecipitationDurationOptions.none;

  @override
  void initState() {
    super.initState();
    precipitationAmountOptions = precipitationAmountOptions.option(Model().getUser().setting.precipitationAmount);
    precipitationDurationOptions = precipitationDurationOptions.option(Model().getUser().setting.precipitationDuration);
  }

  void _savePrecipitation() async {
    var currentUser = await Model().getUser();
    currentUser.setting.precipitationAmount = precipitationAmountOptions.value;
    currentUser.setting.precipitationDuration = precipitationDurationOptions.value;
    currentUser.setting.showPrecipitationAmountAndDuration = true;
    var saveSuccess = await Model().setUser(user: currentUser, save: true);

    if (saveSuccess) {
      Navigator.of(context).pop();
    }
  }

  void _changeAmountOptions(dynamic value) {
    setState(() {
      precipitationAmountOptions = value as PrecipitationAmountOptions;
    });
  }

  void _changeDurationOptions(dynamic value) async {
    setState(() {
      precipitationDurationOptions = value as PrecipitationDurationOptions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      title: Text(Strings.settingsNotificationsPrecipitationDialogTitle),
      contentPadding: EdgeInsets.only(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 24, right: 24, top: 16),
              child: Text(
                Strings.settingsNotificationsPrecipitationDialogDescription(
                  precipitationAmountOptions,
                  precipitationDurationOptions,
                ),
                style: TextStyle(
                  color: GroundColor.subText,
                ),
              ),
            ),
          ),
          Container(
            width: double.maxFinite,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      listItem(
                        radioKey: Key(Keys.settingsKeyDialogPrecipitationAmountOptionsNoneRadio),
                        textKey: Key(Keys.settingsKeyDialogPrecipitationAmountOptionsNoneText),
                        title: PrecipitationAmountOptions.half.title,
                        value: PrecipitationAmountOptions.half,
                        groupValue: precipitationAmountOptions,
                        onChanged: _changeAmountOptions,
                      ),
                      listItem(
                        radioKey: Key(Keys.settingsKeyDialogPrecipitationAmountOptionsTwoAndAHalfRadio),
                        textKey: Key(Keys.settingsKeyDialogPrecipitationAmountOptionsTwoAndAHalfText),
                        title: PrecipitationAmountOptions.twoAndAHalf.title,
                        value: PrecipitationAmountOptions.twoAndAHalf,
                        groupValue: precipitationAmountOptions,
                        onChanged: _changeAmountOptions,
                      ),
                      listItem(
                        radioKey: Key(Keys.settingsKeyDialogPrecipitationAmountOptionsFiveRadio),
                        textKey: Key(Keys.settingsKeyDialogPrecipitationAmountOptionsFiveText),
                        title: PrecipitationAmountOptions.five.title,
                        value: PrecipitationAmountOptions.five,
                        groupValue: precipitationAmountOptions,
                        onChanged: _changeAmountOptions,
                      ),
                      listItem(
                        radioKey: Key(Keys.settingsKeyDialogPrecipitationAmountOptionsTenRadio),
                        textKey: Key(Keys.settingsKeyDialogPrecipitationAmountOptionsTenText),
                        title: PrecipitationAmountOptions.ten.title,
                        value: PrecipitationAmountOptions.ten,
                        groupValue: precipitationAmountOptions,
                        onChanged: _changeAmountOptions,
                      ),
                      listItem(
                        radioKey: Key(Keys.settingsKeyDialogPrecipitationAmountOptionsTwentyRadio),
                        textKey: Key(Keys.settingsKeyDialogPrecipitationAmountOptionsTwentyText),
                        title: PrecipitationAmountOptions.twenty.title,
                        value: PrecipitationAmountOptions.twenty,
                        groupValue: precipitationAmountOptions,
                        onChanged: _changeAmountOptions,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      listItem(
                        radioKey: Key(Keys.settingsKeyDialogPrecipitationDurationOptionsNoneRadio),
                        textKey: Key(Keys.settingsKeyDialogPrecipitationDurationOptionsNoneText),
                        title: PrecipitationDurationOptions.none.title,
                        value: PrecipitationDurationOptions.none,
                        groupValue: precipitationDurationOptions,
                        onChanged: _changeDurationOptions,
                      ),
                      listItem(
                        radioKey: Key(Keys.settingsKeyDialogPrecipitationDurationOptionsHalfHourRadio),
                        textKey: Key(Keys.settingsKeyDialogPrecipitationDurationOptionsHalfHourText),
                        title: PrecipitationDurationOptions.halfHour.title,
                        value: PrecipitationDurationOptions.halfHour,
                        groupValue: precipitationDurationOptions,
                        onChanged: _changeDurationOptions,
                      ),
                      listItem(
                        radioKey: Key(Keys.settingsKeyDialogPrecipitationDurationOptionsOneHourRadio),
                        textKey: Key(Keys.settingsKeyDialogPrecipitationDurationOptionsOneHourText),
                        title: PrecipitationDurationOptions.oneHour.title,
                        value: PrecipitationDurationOptions.oneHour,
                        groupValue: precipitationDurationOptions,
                        onChanged: _changeDurationOptions,
                      ),
                      listItem(
                        radioKey: Key(Keys.settingsKeyDialogPrecipitationDurationOptionsTwoHoursRadio),
                        textKey: Key(Keys.settingsKeyDialogPrecipitationDurationOptionsTwoHoursText),
                        title: PrecipitationDurationOptions.twoHours.title,
                        value: PrecipitationDurationOptions.twoHours,
                        groupValue: precipitationDurationOptions,
                        onChanged: _changeDurationOptions,
                      ),
                      listItem(
                        radioKey: Key(Keys.settingsKeyDialogPrecipitationDurationOptionsFourHoursRadio),
                        textKey: Key(Keys.settingsKeyDialogPrecipitationDurationOptionsFourHoursText),
                        title: PrecipitationDurationOptions.fourHours.title,
                        value: PrecipitationDurationOptions.fourHours,
                        groupValue: precipitationDurationOptions,
                        onChanged: _changeDurationOptions,
                      ),
                    ],
                  ),
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
            onPressed: _savePrecipitation,
          ),
        ),
      ],
    );
  }

  Widget listItem({Key radioKey, Key textKey, String title, dynamic value, dynamic groupValue, Function(dynamic value) onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: <Widget>[
          Radio(
            key: radioKey,
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      onChanged(value);
                    },
                    child: Text(
                      title,
                      key: textKey,
                      style: TextStyle(color: GroundColor.subText),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
