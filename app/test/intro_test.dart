import "package:flutter_test/flutter_test.dart";
import "package:groundwater/main.dart";
import "package:groundwater/utils/strings.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() {
  testWidgets("Go through the onboarding and explore every possible option", (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await initialize();
    await tester.pumpWidget(MyApp(isIntroDone: false, isAuthorized: false));

    expect(find.text(Strings.introFirstTitle), findsOneWidget);
    expect(find.text(Strings.introFirstBody), findsOneWidget);
    expect(find.text(Strings.introNext), findsOneWidget);

    await tester.tap(find.text(Strings.introNext));
    await tester.pumpAndSettle();

    expect(find.text(Strings.introSecondTitle), findsOneWidget);
    expect(find.text(Strings.introSecondBody), findsOneWidget);
    expect(find.text(Strings.introPrevious), findsOneWidget);
    expect(find.text(Strings.introSecondAlreadyRegisteredAction), findsOneWidget);
    expect(find.text(Strings.introSecondRegisterNewAction), findsOneWidget);

    await tester.tap(find.text(Strings.introSecondAlreadyRegisteredAction));
    await tester.pumpAndSettle();

    // Let's make sure that we have arrived at the login page, just a small check
    expect(find.text(Strings.loginAppBarTitle), findsOneWidget);
    expect(find.text(Strings.loginTitle), findsOneWidget);
    expect(find.text(Strings.loginSensorBody), findsOneWidget);

    await tester.tap(find.byTooltip("Terug"));

    await tester.pumpAndSettle();
    await tester.tap(find.text(Strings.introSecondRegisterNewAction));
    await tester.pumpAndSettle();
    // TODO test if sensor registration page shows up, can only be tested when it has been created
  });
}
