import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:groundwater/main.dart";
import "package:groundwater/model/data/setting/precipitation_amount_options.dart";
import "package:groundwater/model/data/setting/precipitation_duration_options.dart";
import "package:groundwater/utils/keys.dart";
import "package:groundwater/utils/strings.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() {
  testWidgets("Test the settings screen", (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      Keys.userPreferencesKey: " {\"id\":1,\"oauthProvider\":\"google-oauth2\",\"oauthId\":\"109215440856031989120\",\"username\":\"groundwater.aad@gmail.com\",\"name\":\"Ground Water\",\"sensors\":[{\"internalId\":\"1\",\"uuid\":\"Test123\",\"externalSensorId\":\"1\",\"externalMonitoringWellId\":\"4\",\"name\":null,\"latitude\":\"52.4302\",\"longitude\":\"6.88174\",\"address\":\"Straat 6\",\"cellarHeight\":null}],\"firebaseToken\":\"djr4xSM-MUw:APA91bGUppHpDuNvIy4kQjXmEBE0Lf-aql2T3xYhzW3I9io2NxT3LcwAcHN54yu_tfUyapfbe0E1EOBBp3pkvuA6zUjRx6hn-9FmijlDiB3oz6YnlxcUjHjlhmujB45uARat8MQOrm60\",\"setting\":{\"precipitationAmount\":null,\"precipitationDuration\":null,\"precipitationAmountChance\":null,\"groundWaterLevel\":null,\"basementDepth\":null,\"showPrecipitationAmountAndDuration\":false,\"showPrecipitationChance\":false,\"showGroundWaterLevel\":false}}"
    });

    await initialize();
    await tester.pumpWidget(MyApp(isIntroDone: true, isAuthorized: true));

    // Go to settings
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.text(Strings.settingsAppBarTitle), findsOneWidget);
    expect(find.text(Strings.settingsHeaderGeneral), findsOneWidget);

    final notificationsAction = find.text(Strings.settingsGoToNotificationsTitle);
    expect(notificationsAction, findsOneWidget);
    expect(find.text(Strings.settingsGoToNotificationsDescription), findsOneWidget);

    await tester.tap(notificationsAction);
    await tester.pumpAndSettle();

    // Let's make sure that we have arrived at the notifications screen, just a small check
    expect(find.text(Strings.settingsNotificationsAppBarTitle), findsOneWidget);
    expect(find.text(Strings.settingsNotificationsSubtext), findsOneWidget);

    await tester.tap(find.byTooltip("Terug"));
    await tester.pumpAndSettle();

    final sensorsAction = find.text(Strings.settingsGoToSensorsTitle);
    expect(sensorsAction, findsOneWidget);
    expect(find.text(Strings.settingsGoToSensorsDescription), findsOneWidget);

    // TODO test sensor, currently in other branch
    //await tester.tap(sensorsAction);
    //await tester.pumpAndSettle();

    // Let's make sure that we have arrived at the sensors screen, just a small check
    //expect(find.text(Strings.), findsOneWidget);
    //expect(find.text(Strings.), findsOneWidget);

    //await tester.pageBack();
    //await tester.pumpAndSettle();

    expect(find.text(Strings.settingsHeaderProfile), findsOneWidget);
    expect(find.text(Strings.settingsProfileName), findsOneWidget);
    expect(find.text(Strings.settingsProfileEmail), findsOneWidget);
    expect(find.text(Strings.settingsProfileSaveChanges), findsOneWidget);

    // TODO real check that changing works, impossible due to no network calls
    //expect(find.text(Strings.settingsProfileSaveFailed), findsOneWidget);
    //expect(find.text(Strings.settingsProfileSaveSuccess), findsOneWidget);
  });

  testWidgets("Test the notification settings screen", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(isIntroDone: true, isAuthorized: true));

    // Go to settings
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    // Click notifications option
    final settingsNotificationsAction = find.text(Strings.settingsGoToNotificationsTitle);
    expect(settingsNotificationsAction, findsOneWidget);
    expect(find.text(Strings.settingsGoToNotificationsDescription), findsOneWidget);

    await tester.tap(settingsNotificationsAction);
    await tester.pumpAndSettle();

    expect(find.text(Strings.settingsNotificationsAppBarTitle), findsOneWidget);
    expect(find.text(Strings.settingsNotificationsSubtext), findsOneWidget);

    expect(find.text(Strings.settingsNotificationsNotificationsTitle), findsOneWidget);
    expect(find.text(Strings.settingsNotificationsNotificationsDescription), findsOneWidget);

    // Nothing is enabled by default
    expect(find.text("0 / 3"), findsOneWidget);

    expect(find.text(Strings.settingsNotificationsPrecipitationTitle), findsOneWidget);
    expect(find.text(Strings.settingsNotificationsPrecipitationDescription), findsOneWidget);

    // Nothing is selected by default
    expect(
        find.text("${Strings.settingsNotificationsPrecipitationDialogAmountOptionOne}" +
            "\n${Strings.settingsNotificationsPrecipitationDialogDurationOptionOne}"),
        findsOneWidget);

    expect(find.text(Strings.settingsNotificationsPrecipitationChanceTitle), findsOneWidget);
    expect(find.text(Strings.settingsNotificationsPrecipitationChanceDescription), findsOneWidget);

    expect(find.text(Strings.settingsNotificationsGroundWaterLevelTitle), findsOneWidget);
    expect(find.text(Strings.settingsNotificationsGroundWaterLevelDescription), findsOneWidget);

    // Precipitation chance and groundwater level both default to "-"
    expect(find.text("-"), findsNWidgets(2));
  });

  testWidgets("Test the notification settings screen notification dialog", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(isIntroDone: true, isAuthorized: true));

    // Go to settings
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    // Click notifications option
    final settingsNotificationsAction = find.text(Strings.settingsGoToNotificationsTitle);
    expect(settingsNotificationsAction, findsOneWidget);
    expect(find.text(Strings.settingsGoToNotificationsDescription), findsOneWidget);

    await tester.tap(settingsNotificationsAction);
    await tester.pumpAndSettle();

    final notificationsAction = find.byKey(Key(Keys.settingsKeyNotifications));
    expect(notificationsAction, findsOneWidget);
    expect(find.text(Strings.settingsNotificationsNotificationsDescription), findsOneWidget);

    // Nothing is enabled by default
    expect(find.text("0 / 3"), findsOneWidget);

    await tester.tap(notificationsAction);
    await tester.pumpAndSettle();

    expect(find.text(Strings.settingsNotificationsNotificationsDialogTitle), findsNWidgets(2));
    expect(find.text(Strings.settingsNotificationsNotificationsDialogDescription), findsNWidgets(2));

    final dialogNotificationPrecipitationAction = find.byKey(Key(Keys.settingsKeyDialogNotificationPrecipitation));
    expect(dialogNotificationPrecipitationAction, findsOneWidget);
    await tester.tap(dialogNotificationPrecipitationAction);
    await tester.pumpAndSettle();

    expect(find.text(Strings.settingsNotificationsNotificationsDialogPrecipitationDescription), findsOneWidget);
    final dialogNotificationPrecipitationChanceAction = find.byKey(Key(Keys.settingsKeyDialogNotificationPrecipitationChance));
    expect(dialogNotificationPrecipitationChanceAction, findsOneWidget);
    await tester.tap(dialogNotificationPrecipitationChanceAction);
    await tester.pumpAndSettle();

    expect(find.text(Strings.settingsNotificationsNotificationsDialogPrecipitationChanceDescription), findsOneWidget);
    expect(find.text(Strings.settingsNotificationsNotificationsDialogGroundWaterLevelDescription), findsOneWidget);
    final dialogNotificationGroundWaterLevelAction = find.byKey(Key(Keys.settingsKeyDialogNotificationGroundWaterLevel));
    expect(dialogNotificationGroundWaterLevelAction, findsOneWidget);
    await tester.tap(dialogNotificationGroundWaterLevelAction);
    await tester.pumpAndSettle();

    expect(find.text(Strings.cancel), findsOneWidget);

    final dialogNotificationSave = find.text(Strings.save);
    expect(dialogNotificationSave, findsOneWidget);
    // Unfortunately network requests are not possible so this cannot be done
    // await tester.tap(dialogNotificationSave);
    // await tester.pumpAndSettle();

    // Unfortunately, due to some issue with relays, the tests can't find this
    // expect(find.text("3 / 3"), findsOneWidget);
  });

  testWidgets("Test the notification settings screen precipitation dialog", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(isIntroDone: true, isAuthorized: true));

    // Go to settings
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    // Click notifications option
    final settingsNotificationsAction = find.text(Strings.settingsGoToNotificationsTitle);
    expect(settingsNotificationsAction, findsOneWidget);
    expect(find.text(Strings.settingsGoToNotificationsDescription), findsOneWidget);

    await tester.tap(settingsNotificationsAction);
    await tester.pumpAndSettle();

    final precipitationAction = find.text(Strings.settingsNotificationsPrecipitationTitle);
    expect(precipitationAction, findsOneWidget);
    expect(find.text(Strings.settingsNotificationsPrecipitationDescription), findsOneWidget);

    // Nothing is selected by default
    expect(
        find.text("${Strings.settingsNotificationsPrecipitationDialogAmountOptionOne}" +
            "\n${Strings.settingsNotificationsPrecipitationDialogDurationOptionOne}"),
        findsOneWidget);

    await tester.tap(precipitationAction);
    await tester.pumpAndSettle();

    final amountOneAction = find.byKey(Key(Keys.settingsKeyDialogPrecipitationAmountOptionsNoneRadio));
    final amountOneText = find.byKey(Key(Keys.settingsKeyDialogPrecipitationAmountOptionsNoneText));
    expect(amountOneAction, findsWidgets);
    expect(amountOneText, findsWidgets);
    final amountTwoAction = find.byKey(Key(Keys.settingsKeyDialogPrecipitationAmountOptionsTwoAndAHalfRadio));
    final amountTwoText = find.byKey(Key(Keys.settingsKeyDialogPrecipitationAmountOptionsTwoAndAHalfText));
    expect(amountTwoAction, findsOneWidget);
    expect(amountTwoText, findsOneWidget);
    final amountThreeAction = find.byKey(Key(Keys.settingsKeyDialogPrecipitationAmountOptionsFiveRadio));
    final amountThreeText = find.byKey(Key(Keys.settingsKeyDialogPrecipitationAmountOptionsFiveText));
    expect(amountThreeAction, findsOneWidget);
    expect(amountThreeText, findsOneWidget);
    final amountFourAction = find.byKey(Key(Keys.settingsKeyDialogPrecipitationAmountOptionsTenRadio));
    final amountFourText = find.byKey(Key(Keys.settingsKeyDialogPrecipitationAmountOptionsTenText));
    expect(amountFourAction, findsOneWidget);
    expect(amountFourText, findsOneWidget);
    final amountFiveAction = find.byKey(Key(Keys.settingsKeyDialogPrecipitationAmountOptionsTwentyRadio));
    final amountFiveText = find.byKey(Key(Keys.settingsKeyDialogPrecipitationAmountOptionsTwentyText));
    expect(amountFiveAction, findsOneWidget);
    expect(amountFiveText, findsOneWidget);
    final durationOneAction = find.byKey(Key(Keys.settingsKeyDialogPrecipitationDurationOptionsNoneRadio));
    final durationOneText = find.byKey(Key(Keys.settingsKeyDialogPrecipitationDurationOptionsNoneText));
    expect(durationOneAction, findsWidgets);
    expect(durationOneText, findsWidgets);
    final durationTwoAction = find.byKey(Key(Keys.settingsKeyDialogPrecipitationDurationOptionsHalfHourRadio));
    final durationTwoText = find.byKey(Key(Keys.settingsKeyDialogPrecipitationDurationOptionsHalfHourText));
    expect(durationTwoAction, findsOneWidget);
    expect(durationTwoText, findsOneWidget);
    final durationThreeAction = find.byKey(Key(Keys.settingsKeyDialogPrecipitationDurationOptionsOneHourRadio));
    final durationThreeText = find.byKey(Key(Keys.settingsKeyDialogPrecipitationDurationOptionsOneHourText));
    expect(durationThreeAction, findsOneWidget);
    expect(durationThreeText, findsOneWidget);
    final durationFourAction = find.byKey(Key(Keys.settingsKeyDialogPrecipitationDurationOptionsTwoHoursRadio));
    final durationFourText = find.byKey(Key(Keys.settingsKeyDialogPrecipitationDurationOptionsTwoHoursText));
    expect(durationFourAction, findsOneWidget);
    expect(durationFourText, findsOneWidget);
    final durationFiveAction = find.byKey(Key(Keys.settingsKeyDialogPrecipitationDurationOptionsFourHoursRadio));
    final durationFiveText = find.byKey(Key(Keys.settingsKeyDialogPrecipitationDurationOptionsFourHoursText));
    expect(durationFiveAction, findsOneWidget);
    expect(durationFiveText, findsOneWidget);

    final amountOptionsTexts = [amountOneText, amountTwoText, amountThreeText, amountFourText, amountFiveText];
    final amountOptionsActions = [amountOneAction, amountTwoAction, amountThreeAction, amountFourAction, amountFiveAction];
    final durationOptionsTexts = [durationOneText, durationTwoText, durationThreeText, durationFourText, durationFiveText];
    final durationOptionsActions = [durationOneAction, durationTwoAction, durationThreeAction, durationFourAction, durationFiveAction];

    for (int i = 0; i < amountOptionsTexts.length; i++) {
      final amountOptionText = amountOptionsTexts[i];
      final amountOptionAction = amountOptionsActions[i];
      await tester.tap(amountOptionAction);
      await tester.pumpAndSettle();

      for (int i = 0; i < durationOptionsTexts.length; i++) {
        final durationOptionText = durationOptionsTexts[i];
        final durationOptionAction = durationOptionsActions[i];
        await tester.tap(durationOptionAction);
        await tester.pumpAndSettle();

        PrecipitationAmountOptions precipitationAmountOption = PrecipitationAmountOptions.half;
        PrecipitationDurationOptions precipitationDurationOption = PrecipitationDurationOptions.none;

        PrecipitationAmountOptions.values.forEach((option) {
          if (option.title == (amountOptionText.evaluate().first.widget as Text).data) {
            precipitationAmountOption = option;
          }
        });

        PrecipitationDurationOptions.values.forEach((option) {
          if (option.title == (durationOptionText.evaluate().first.widget as Text).data) {
            precipitationDurationOption = option;
          }
        });

        expect(
            find.text(Strings.settingsNotificationsPrecipitationDialogDescription(precipitationAmountOption, precipitationDurationOption)),
            findsOneWidget);
      }
    }

    expect(find.text(Strings.cancel), findsOneWidget);

    final dialogNotificationSave = find.text(Strings.save);
    expect(dialogNotificationSave, findsOneWidget);
    // Unfortunately network requests are not possible so this cannot be done
    // await tester.tap(dialogNotificationSave);
    // await tester.pumpAndSettle();

    // Unfortunately, due to some issue with relays, the tests can't find this
    // expect(find.text("${PrecipitationAmountOptions.twenty.title}\n${PrecipitationDurationOptions.fourHours.title}"), findsOneWidget);
  });

  testWidgets("Test the notification settings screen precipitation chance dialog", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(isIntroDone: true, isAuthorized: true));

    // Go to settings
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    // Click notifications option
    final settingsNotificationsAction = find.text(Strings.settingsGoToNotificationsTitle);
    expect(settingsNotificationsAction, findsOneWidget);
    expect(find.text(Strings.settingsGoToNotificationsDescription), findsOneWidget);

    await tester.tap(settingsNotificationsAction);
    await tester.pumpAndSettle();

    expect(find.text(Strings.settingsNotificationsPrecipitationChanceDescription), findsOneWidget);
    final dialogNotificationPrecipitationChanceAction = find.byKey(Key(Keys.settingsKeyDialogNotificationPrecipitationChance));
    expect(dialogNotificationPrecipitationChanceAction, findsOneWidget);
    await tester.tap(dialogNotificationPrecipitationChanceAction);
    await tester.pumpAndSettle();

    // Nothing is entered by default
    expect(find.text("-"), findsNWidgets(2));

    await tester.tap(dialogNotificationPrecipitationChanceAction);
    await tester.pumpAndSettle();

    expect(find.text(Strings.settingsNotificationsPrecipitationChanceDialogTitle), findsOneWidget);
    expect(find.text(Strings.settingsNotificationsPrecipitationChanceDialogDescription), findsNWidgets(2));

    final inputField = find.byType(TextField);
    expect(inputField, findsOneWidget);

    final dialogNotificationSave = find.text(Strings.save);
    expect(dialogNotificationSave, findsOneWidget);
    expect(find.text(Strings.cancel), findsOneWidget);

    // Try to enter an value outside the range of 0 - 100
    await tester.tap(inputField);
    await tester.enterText(inputField, "200");
    await tester.pumpAndSettle();

    await tester.tap(dialogNotificationSave);
    await tester.pumpAndSettle();
    expect(find.text(Strings.settingsNotificationsPrecipitationChanceDialogErrorRange), findsOneWidget);

    // Try to enter an invalid value
    await tester.tap(inputField);
    await tester.enterText(inputField, "");
    await tester.pumpAndSettle();

    await tester.tap(dialogNotificationSave);
    await tester.pumpAndSettle();
    expect(find.text(Strings.settingsNotificationsPrecipitationChanceDialogError), findsOneWidget);

    // Try to enter an correct value
    await tester.tap(inputField);
    await tester.enterText(inputField, "50");
    await tester.pumpAndSettle();

    // Unfortunately network requests are not possible so this cannot be done
    // await tester.tap(dialogNotificationSave);
    // await tester.pumpAndSettle();

    // Unfortunately, due to some issue with relays, the tests can't find this
    // expect(find.text("50"), findsOneWidget);
  });

  testWidgets("Test the notification settings screen ground water level dialog", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(isIntroDone: true, isAuthorized: true));

    // Go to settings
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    // Click notifications option
    final settingsNotificationsAction = find.text(Strings.settingsGoToNotificationsTitle);
    expect(settingsNotificationsAction, findsOneWidget);
    expect(find.text(Strings.settingsGoToNotificationsDescription), findsOneWidget);

    await tester.tap(settingsNotificationsAction);
    await tester.pumpAndSettle();

    expect(find.text(Strings.settingsNotificationsGroundWaterLevelDescription), findsOneWidget);
    final dialogNotificationGroundWaterLevelAction = find.byKey(Key(Keys.settingsKeyDialogNotificationGroundWaterLevel));
    expect(dialogNotificationGroundWaterLevelAction, findsOneWidget);
    await tester.tap(dialogNotificationGroundWaterLevelAction);
    await tester.pumpAndSettle();

    // Nothing is entered by default
    expect(find.text("-"), findsNWidgets(2));

    await tester.tap(dialogNotificationGroundWaterLevelAction);
    await tester.pumpAndSettle();

    expect(find.text(Strings.settingsNotificationsGroundWaterLevelDialogTitle), findsOneWidget);
    expect(find.text(Strings.settingsNotificationsGroundWaterLevelDialogDescription), findsNWidgets(2));

    final inputField = find.byType(TextField);
    expect(inputField, findsOneWidget);

    final dialogNotificationSave = find.text(Strings.save);
    expect(dialogNotificationSave, findsOneWidget);
    expect(find.text(Strings.cancel), findsOneWidget);

    // Try to enter an invalid value
    await tester.tap(inputField);
    await tester.enterText(inputField, "");
    await tester.pumpAndSettle();

    await tester.tap(dialogNotificationSave);
    await tester.pumpAndSettle();
    expect(find.text(Strings.settingsNotificationsGroundWaterLevelDialogError), findsOneWidget);

    // Try to enter an correct value
    await tester.tap(inputField);
    await tester.enterText(inputField, "50");
    await tester.pumpAndSettle();

    // Unfortunately network requests are not possible so this cannot be done
    // await tester.tap(dialogNotificationSave);
    // await tester.pumpAndSettle();

    // Unfortunately, due to some issue with relays, the tests can't find this
    // expect(find.text("50"), findsOneWidget);
  });
}
