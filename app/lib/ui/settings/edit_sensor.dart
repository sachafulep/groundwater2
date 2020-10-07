import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:groundwater/model/data/sensor/sensor.dart";
import "package:groundwater/model/model.dart";
import "package:groundwater/utils/colors.dart";
import "package:groundwater/utils/strings.dart";
import "package:toast/toast.dart";

class EditSensor extends StatefulWidget {
  static const routeName = "/editSensor";

  EditSensor({Key key}) : super(key: key);

  @override
  _EditSensorState createState() => _EditSensorState();
}

class _EditSensorState extends State<EditSensor> {
  Sensor sensor;
  final cellarHeightController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void initState() {
    Model().getMainSensor().then((sensor) => {
          this.setState(() {
            this.sensor = sensor;
          }),
          cellarHeightController.text = (sensor.cellarHeight ?? 0).toString(),
          addressController.text = sensor.address.toString()
        });
    super.initState();
  }

  void _saveSensor() async {
    Sensor updatedSensor = await Model().api.updateSensor(Sensor(internalId: sensor.internalId, address: addressController.text, cellarHeight: int.tryParse(cellarHeightController.text)));

    if (updatedSensor == null) {
      Toast.show(Strings.editSensorUpdateSensorFailed, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    this.sensor = updatedSensor;
    await Model().setMainSensor(updatedSensor);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.editSensorTitle),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
            child: Text(
              sensor?.name ?? "-",
              style: TextStyle(fontSize: 16, color: GroundColor.accent, fontWeight: FontWeight.w500),
              textAlign: TextAlign.left,
            ),
          ),
          _textField(
            title: Strings.editSensorCellarHeight,
            hintText: Strings.editSensorCellarHeightHint,
            controller: cellarHeightController,
            textInputType: TextInputType.number,
          ),
          _textField(
            title: Strings.editSensorAddress,
            hintText: Strings.editSensorAddressHint,
            controller: addressController,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 16, left: 16, right: 16),
            child: MaterialButton(
              minWidth: double.infinity,
              height: 48,
              child: Text(Strings.editSensorUpdateSensor),
              color: Theme.of(context).buttonColor,
              onPressed: _saveSensor,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _textField({String title, String hintText, TextEditingController controller, TextInputType textInputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 16, color: GroundColor.text, fontWeight: FontWeight.w500),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: TextField(
              keyboardType: textInputType,
              controller: controller,
              inputFormatters: (textInputType == TextInputType.number) ? <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly] : [],
              decoration: InputDecoration(
                filled: true,
                contentPadding: const EdgeInsets.all(16),
                border: InputBorder.none,
                hintText: hintText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
