import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_test/flutter_test.dart";
import "package:groundwater/main.dart";
import "package:groundwater/utils/keys.dart";
import "package:groundwater/utils/strings.dart";

void main() {
  testWidgets("Verify sensor by UUID and continue to OAuth page", (WidgetTester tester) async {
    await DotEnv().load(".env");
    await tester.pumpWidget(MyApp(isIntroDone: true, isAuthorized: false));

    expect(find.text(Strings.loginAppBarTitle), findsOneWidget);
    expect(find.text(Strings.loginTitle), findsOneWidget);
    expect(find.text(Strings.loginSensorBody), findsOneWidget);
    expect(find.text(Strings.loginSensorFieldTitle), findsOneWidget);
    expect(find.text(Strings.loginSensorActionContinue), findsOneWidget);

    final hintText = "${Strings.loginSensorHintText}${Strings.loginSensorHintTextAction}";
    expect(find.byWidgetPredicate((Widget widget) => widget is RichText && widget.text.toPlainText() == hintText), findsOneWidget);

    await tester.tap(find.byType(TextField));
    await tester.enterText(find.byType(TextField), "AAAA-BBBB-CCCC-DDDE");
    await tester.tap(find.text(Strings.loginSensorActionContinue));
    await tester.pumpAndSettle();
    expect(find.text(Strings.loginSensorInvalidUuid), findsOneWidget);
    await tester.tap(find.byType(TextField));
    await tester.enterText(find.byType(TextField), "AAAA-BBBB-CCCC-DDDD");
    await tester.pumpAndSettle();
    await tester.tap(find.text(Strings.loginSensorActionContinue));
    await tester.pumpAndSettle();

    await expect(find.byKey(Key(Keys.loginSensorHintTextActionKey)), findsOneWidget);
    await tester.tap(find.byKey(Key(Keys.loginSensorHintTextActionKey)));
    await tester.pumpAndSettle();

    // Because we can't test a real OAuth flow, the texts are the only thing that will be checked
    expect(find.text(Strings.loginAuthenticateActionGoogle), findsOneWidget);
    expect(find.text(Strings.loginAuthenticateActionGoogle), findsOneWidget);
    expect(find.text(Strings.loginAuthenticateHintText), findsOneWidget);
  });
}
