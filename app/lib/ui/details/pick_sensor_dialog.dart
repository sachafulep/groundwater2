import "package:flutter/material.dart";
import "package:groundwater/model/data/sensor/sensor.dart";
import "package:groundwater/model/model.dart";
import "package:groundwater/utils/colors.dart";
import "package:groundwater/utils/strings.dart";

typedef void PickedSensorCallback(List<Sensor> sensors);

/// Pick Sensor dialog
class PickSensorDialog extends StatefulWidget {
  /// Pick Sensor dialog
  PickSensorDialog({Key key, this.title, this.pickedSensorCallback, this.previousPickedSensorIds}) : super(key: key);

  /// Page title
  final String title;
  final PickedSensorCallback pickedSensorCallback;
  final List<int> previousPickedSensorIds;

  @override
  _PickSensorDialogState createState() => _PickSensorDialogState(
        pickedSensorCallback: pickedSensorCallback,
        previousPickedSensorIds: previousPickedSensorIds,
      );
}

class _PickSensorDialogState extends State<PickSensorDialog> {
  _PickSensorDialogState({this.pickedSensorCallback, this.previousPickedSensorIds});

  final PickedSensorCallback pickedSensorCallback;
  List<Sensor> sensors = [];
  List<Sensor> pickedSensors = [];
  List<int> previousPickedSensorIds = [];

  @override
  void initState() {
    super.initState();

    Model().api.getSensors(projection: "simple").then((sensors) {
      if (sensors == null) return;

      setState(() {
        this.sensors = sensors.where((sensor) => sensor.name != null && sensor.name != "").toList();
        this.sensors.sort((a, b) => a.name.compareTo(b.name));
        this.pickedSensors = sensors
            .where((sensor) => previousPickedSensorIds.firstWhere((id) => sensor.internalId == id, orElse: () => null) != null)
            .toList();
      });
    });
  }

  void _pickSensor(Sensor sensor) {
    setState(() {
      if (pickedSensors.contains(sensor)) {
        this.pickedSensors.remove(sensor);
      } else {
        this.pickedSensors.add(sensor);
      }
    });
  }

  void _savePickedSensors() {
    Navigator.of(context).pop();
    pickedSensorCallback(pickedSensors);
  }

  Widget listItem(Sensor sensor) {
    return InkWell(
      onTap: () {
        _pickSensor(sensor);
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
                      child: Text(
                        (sensor.name ?? "-"),
                      ),
                    ),
                    Text(
                      "${sensor.address ?? "-"}",
                      style: TextStyle(color: GroundColor.subText),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Checkbox(
                value: pickedSensors.contains(sensor),
                onChanged: (bool value) {
                  _pickSensor(sensor);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      titlePadding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      title: Text(Strings.detailsChooseSensorDialogTitle),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
              child: Text(
                Strings.detailsChooseSensorDialogBody,
                style: TextStyle(
                  color: GroundColor.subText,
                ),
              ),
            ),
            for (var sensor in sensors) listItem(sensor),
          ],
        ),
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
          padding: const EdgeInsets.only(right: 8),
          child: FlatButton(
            child: Text(
              Strings.save,
              style: TextStyle(color: GroundColor.accent),
            ),
            onPressed: _savePickedSensors,
          ),
        ),
      ],
    );
  }
}
