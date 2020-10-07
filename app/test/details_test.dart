import "package:flutter/cupertino.dart";
import "package:flutter_test/flutter_test.dart";
import "package:groundwater/main.dart";
import "package:groundwater/utils/keys.dart";
import "package:groundwater/utils/strings.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() {
  String sensorName = "Test123";

  testWidgets("Go from Dashboard to Details and select two dates in the date range picker", (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      Keys.sensorPreferencesKeyMainSensor: "{\"internalId\":\"14\",\"uuid\":\"0000807D3AC5A8B0\",\"externalSensorId\":\"17\",\"externalMonitoringWellId\":\"4\",\"name\":\"$sensorName\",\"latitude\":\"52.93202\",\"longitude\":\"6.88624\",\"address\":\"Minister Teststraat 6\"}"
    });
    await initialize();
    await tester.pumpWidget(MyApp(isIntroDone: true, isAuthorized: true));

    final goToDetailsButton = find.text(Strings.dashboardNavigateToDetails);
    var title = find.text(Strings.dashboardAppBarTitle);
    expect(goToDetailsButton, findsOneWidget);
    expect(title, findsOneWidget);

    await tester.tap(goToDetailsButton);
    await tester.pumpAndSettle();

    title = find.text(Strings.detailsAppBarTitle);
    final dateRange = find.byKey(Key(Keys.detailsSelectDateButton));

    expect(title, findsOneWidget);
    expect(dateRange, findsOneWidget);

    await tester.tap(dateRange);
    await tester.pumpAndSettle();

    final firstDate = DateTime.now().subtract(Duration(days: 1)).day.toString();
    final endDate = DateTime.now().day.toString();
    final ok = find.text("OK");

    expect(find.text(firstDate), findsOneWidget);
    expect(find.text(endDate), findsOneWidget);
    expect(ok, findsOneWidget);

    await tester.tap(find.text(firstDate));
    await tester.pump();
    await tester.tap(find.text(endDate));
    await tester.pump();
    await tester.tap(ok);
    await tester.pump();

    final year = DateTime.now().year;
    final month = DateTime.now().month;
    final dateText = "$firstDate-$month-$year / $endDate-$month-$year";
    final newDateRange = find.text(dateText);

    expect(newDateRange, findsOneWidget);
  });

  testWidgets("Go from Dashboard to Details and select a sensor", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(isIntroDone: true, isAuthorized: true));

    final goToDetailsButton = find.text(Strings.dashboardNavigateToDetails);
    var title = find.text(Strings.dashboardAppBarTitle);
    expect(goToDetailsButton, findsOneWidget);
    expect(title, findsOneWidget);

    await tester.tap(goToDetailsButton);
    await tester.pumpAndSettle();

    final sensorPicker = await find.text(sensorName);
    expect(sensorPicker, findsOneWidget);

    expect(find.text(Strings.detailsAppBarTitle), findsOneWidget);

    await tester.tap(sensorPicker);
    await tester.pumpAndSettle();

    expect(find.text(Strings.detailsChooseSensorDialogTitle), findsOneWidget);
    expect(find.text(Strings.detailsChooseSensorDialogBody), findsOneWidget);

    // TODO select sensor, we need to figure out how to test app with backend. Probably use a staging backend on a
    // VPS and use a script that moves the .env.test to .env so it will use the staging backend.
    await tester.tap(find.text(Strings.save));
    await tester.pumpAndSettle();
  });
}
