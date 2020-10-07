import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:groundwater/model/model.dart";
import "package:groundwater/ui/auth/auth.dart";
import "package:groundwater/ui/dashboard/dashboard.dart";
import "package:groundwater/ui/decision_tree/decision_tree.dart";
import "package:groundwater/ui/details/details.dart";
import "package:groundwater/ui/intro/intro.dart";
import "package:groundwater/ui/settings/edit_sensor.dart";
import "package:groundwater/ui/settings/settings.dart";
import "package:groundwater/ui/settings/settings_notifications.dart";
import "package:groundwater/ui/settings/settings_sensors.dart";
import "package:groundwater/utils/colors.dart";
import "package:groundwater/utils/keys.dart";
import "package:groundwater/utils/strings.dart";

Future initialize({bool enableNotifications = false}) async {
  await DotEnv().load(".env");
  await Model().initialize();

  if (enableNotifications) {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettings = InitializationSettings(AndroidInitializationSettings("notification_icon"), IOSInitializationSettings());
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    Model().firebaseMessaging.requestNotificationPermissions();
    Model().firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) async {
      // Android
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        Keys.notificationChannelGeneralKey,
        Strings.notificationChannelGeneralTitle,
        Strings.notificationChannelGeneralDescription,
        importance: Importance.Max,
        priority: Priority.High,
      );

      if (message["notification"]["title"] == null) return;

      // iOS
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();

      // Notification
      var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,
        message["notification"]["title"].toString(),
        message["notification"]["body"].toString() ?? "-",
        platformChannelSpecifics,
      );
    });
  }
}

Future main() async {
  await initialize(enableNotifications: true);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MyApp(
      isIntroDone: await Model().getIntroDone().then((done) => done) == true,
      isAuthorized: await Model().isAuthorized(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key key, this.isIntroDone, this.isAuthorized}) : super(key: key);

  final bool isIntroDone;
  final bool isAuthorized;

  @override
  MyAppState createState() => MyAppState(isIntroDone: isIntroDone, isAuthorized: isAuthorized);
}

class MyAppState extends State<MyApp> {
  MyAppState({this.isIntroDone, this.isAuthorized});

  bool isIntroDone = false;
  bool isAuthorized = false;

  @override
  void initState() {
    super.initState();

    // Listen to authorisation changes
    Model().isAuthorizedRelay.stream.listen((value) async {
      if (value == true) {
        userAuthorized(value, await Model().getIntroDone().then((done) => done));
      }
    });
  }

  void userAuthorized(bool isAuthorized, bool introDone) async {
    setState(() {
      this.isAuthorized = isAuthorized;
      this.isIntroDone = introDone;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Widget initialRoute = Dashboard();
    if (isIntroDone == false) {
      initialRoute = Intro();
    } else if (isAuthorized == false) {
      initialRoute = Auth();
    }

    return MaterialApp(
      title: "GroundWater",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: GroundColor.primary,
        accentColor: GroundColor.accent,
        buttonColor: GroundColor.accent,
        scaffoldBackgroundColor: GroundColor.primary,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("nl", "NL"),
      ],
      debugShowCheckedModeBanner: false,
      home: initialRoute,
      routes: <String, WidgetBuilder>{
        Dashboard.routeName: (BuildContext context) => Dashboard(),
        DecisionTreePage.routeName: (BuildContext context) => DecisionTreePage(),
        Details.routeName: (BuildContext context) => Details(),
        Auth.routeName: (BuildContext context) => Auth(),
        Intro.routeName: (BuildContext context) => Intro(),
        Settings.routeName: (BuildContext context) => Settings(),
        SettingsSensors.routeName: (BuildContext context) => SettingsSensors(),
        SettingsNotifications.routeName: (BuildContext context) => SettingsNotifications(),
        EditSensor.routeName: (BuildContext context) => EditSensor(),
      },
    );
  }
}
