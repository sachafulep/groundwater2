import "package:flutter/material.dart";
import "package:groundwater/model/model.dart";
import "package:groundwater/ui/settings/settings_notifications.dart";
import "package:groundwater/ui/settings/settings_sensors.dart";
import "package:groundwater/utils/colors.dart";
import "package:groundwater/utils/strings.dart";
import "package:toast/toast.dart";

class Settings extends StatefulWidget {
  static const routeName = "/settings";

  Settings({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final profileNameController = TextEditingController();
  final profileEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Model().api.getCurrentUser().then((user) {
      if (user != null) {
        profileNameController.text = user.name;
        profileEmailController.text = user.username;
      }
      Model().getMainSensor().then((sensor) {
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    profileNameController.dispose();
    profileEmailController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    var currentUser = await Model().getUser();
    currentUser.name = profileNameController.text;
    currentUser.username = profileEmailController.text;
    var saveSuccess = await Model().setUser(user: currentUser, save: true);

    String message = saveSuccess == null ? Strings.settingsProfileSaveFailed : Strings.settingsProfileSaveSuccess;
    Toast.show(message, context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.settingsAppBarTitle),
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
              child: Text(
                Strings.settingsHeaderGeneral,
                style: TextStyle(fontSize: 16, color: GroundColor.accent, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
            _settingsRedirectItem(
              title: Strings.settingsGoToNotificationsTitle,
              description: Strings.settingsGoToNotificationsDescription,
              onClick: () {
                Navigator.of(context).pushNamed(SettingsNotifications.routeName);
              },
            ),
            _settingsRedirectItem(
              title: Strings.settingsGoToSensorsTitle,
              description: Model().mainSensor != null ? Model().mainSensor.name ?? "-" : Strings.settingsGoToSensorsDescription,
              onClick: () {
                Navigator.of(context).pushNamed(SettingsSensors.routeName);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
              child: Text(
                Strings.settingsHeaderProfile,
                style: TextStyle(fontSize: 16, color: GroundColor.accent, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
            _textField(
              hintText: Strings.settingsProfileName,
              controller: profileNameController,
            ),
            _textField(
              hintText: Strings.settingsProfileEmail,
              controller: profileEmailController,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 16, left: 16, right: 16),
              child: MaterialButton(
                minWidth: double.infinity,
                height: 48,
                child: Text(Strings.settingsProfileSaveChanges),
                color: Theme.of(context).buttonColor,
                onPressed: _saveProfile,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsRedirectItem({String title, String description, Function() onClick}) {
    return InkWell(
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
              padding: const EdgeInsets.only(left: 16),
              child: Icon(
                Icons.chevron_right,
                size: 24,
                color: GroundColor.icon,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField({String hintText, TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          contentPadding: const EdgeInsets.all(16),
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    );
  }
}
