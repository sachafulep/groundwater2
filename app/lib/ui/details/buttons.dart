import "package:flutter/material.dart";
import "package:groundwater/model/data/sensor/sensor.dart";
import "package:groundwater/utils/colors.dart";
import "package:groundwater/utils/keys.dart";
import "package:groundwater/utils/strings.dart";

class Buttons extends StatelessWidget {
  Buttons({
    this.precipitationEnabled,
    this.toggleGraphState,
    this.graphReset,
    this.dateRange,
    this.pickDate,
    this.pickedSensors,
    this.showSensorDialog,
  });

  static const secondaryMeasureAxisId = "secondaryMeasureAxisId";
  final bool precipitationEnabled;
  final Function() toggleGraphState;
  final Function() graphReset;
  final Function() showSensorDialog;
  final String dateRange;
  final Function pickDate;
  final List<Sensor> pickedSensors;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      _datePickerButton(),
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: _sensorDropDown(),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: _precipitationButton(),
      ),
    ]);
  }

  MaterialButton _sensorDropDown() {
    return MaterialButton(
      color: GroundColor.primaryDark,
      elevation: 0,
      height: 56,
      onPressed: () => showSensorDialog(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                pickedSensors.isEmpty ? Strings.detailsChooseSensorAction : pickedSensors.map((sensor) => sensor.name).join(", "),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18, color: GroundColor.icon, fontWeight: FontWeight.w400),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              size: 24,
              color: GroundColor.icon,
            ),
          ],
        ),
      ),
    );
  }

  MaterialButton _precipitationButton() {
    return MaterialButton(
      color: GroundColor.primaryDark,
      elevation: 0,
      height: 56,
      onPressed: () {
        toggleGraphState();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                Strings.togglePrecipitation,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  color: GroundColor.icon,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Checkbox(onChanged: (boolean) => toggleGraphState(), value: precipitationEnabled)
          ],
        ),
      ),
    );
  }

  MaterialButton _datePickerButton() {
    return MaterialButton(
      key: Key(Keys.detailsSelectDateButton),
      color: GroundColor.primaryDark,
      elevation: 0,
      height: 56,
      onPressed: () {
        pickDate();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                dateRange,
                style: TextStyle(fontSize: 18, color: GroundColor.icon, fontWeight: FontWeight.w400),
              ),
            ),
            Icon(
              Icons.calendar_today,
              size: 24,
              color: GroundColor.icon,
            ),
          ],
        ),
      ),
    );
  }
}
