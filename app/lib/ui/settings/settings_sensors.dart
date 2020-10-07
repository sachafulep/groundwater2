import "package:flutter/material.dart";
import "package:groundwater/model/data/sensor/sensor.dart";
import "package:groundwater/model/model.dart";
import "package:groundwater/ui/settings/edit_sensor.dart";
import "package:groundwater/utils/colors.dart";
import "package:groundwater/utils/strings.dart";

class SettingsSensors extends StatefulWidget {
  static const routeName = "/settings-sensors";

  SettingsSensors({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SettingsSensorsState createState() => _SettingsSensorsState();
}

class _SettingsSensorsState extends State<SettingsSensors> {
  List<Sensor> sensors = [];

  @override
  void initState() {
    super.initState();

    _getData();
  }

  void onResume() {
    _getData();
  }

  void _getData() {
    Model().api.getSensors(projection: "simple").then((sensors) {
      if (sensors == null) return;

      setState(() {
        this.sensors = sensors.where((sensor) => sensor.name != null && sensor.name != "").toList();
        this.sensors.sort((a, b) => a.name.compareTo(b.name));
      });
    });
  }

  void _pickSensor(Sensor sensor) async {
    await Model().setMainSensor(sensor);
    setState(() {});
  }

  Widget build(BuildContext context) {
    bool sensorOfUserSelected = Model().isMainSensorSelected();

    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.settingsSensorsAppBarTitle),
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
              width: double.maxFinite,
              child: Text(
                Strings.settingsSensorsSubtext,
                style: TextStyle(fontSize: 16, color: GroundColor.subText, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 16, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  if (sensorOfUserSelected)
                    Expanded(
                      flex: 1,
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 48,
                        child: Text(
                          Strings.settingsSensorsEditSensor,
                          textAlign: TextAlign.center,
                        ),
                        color: Theme.of(context).buttonColor,
                        onPressed: () {
                          Navigator.of(context).pushNamed(EditSensor.routeName).then((value) {
                            onResume();
                          });
                        },
                        textColor: Colors.white,
                      ),
                    ),
                  if (sensorOfUserSelected)
                    Container(
                      width: 16,
                    ),
                  Expanded(
                    flex: 1,
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 48,
                      child: Text(
                        Strings.settingsSensorsAddSensor,
                        textAlign: TextAlign.center,
                      ),
                      color: Theme.of(context).buttonColor,
                      onPressed: () {
                        // Todo create new sensor
                      },
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            for (var sensor in sensors) listItem(sensor),
          ],
        ),
      ),
    );
  }

  Widget listItem(Sensor sensor) {
    return InkWell(
      onTap: () {
        _pickSensor(sensor);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
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
            if (Model().mainSensor != null && Model().mainSensor.internalId == sensor.internalId)
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Icon(
                  Icons.check,
                  size: 24,
                  color: GroundColor.icon,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
