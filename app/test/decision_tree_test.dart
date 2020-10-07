import "dart:collection";
import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:groundwater/main.dart";
import "package:groundwater/model/data/decision_tree/answer.dart";
import "package:groundwater/model/data/decision_tree/decision_tree.dart";
import "package:groundwater/model/data/decision_tree/question.dart";
import "package:groundwater/model/data/decision_tree/solution.dart";
import "package:groundwater/utils/strings.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() {
  LinkedHashMap<Question, Answer> history = LinkedHashMap();

  /// Tests the given question by checking if the answers are shown, clicks a random answer and repeats till there are no more questions left.
  void testQuestion(WidgetTester tester, Question question) async {
    await tester.pumpAndSettle();

    // The question should be displayed
    expect(find.text(question.question), findsOneWidget);

    // Check if all questions are displayed
    for (Answer answer in question.answers) {
      expect(find.text(answer.answer), findsOneWidget);
    }

    // Only previous button should be shown
    expect(find.text(Strings.decisionTreeNext), findsNothing);
    expect(find.text(Strings.decisionTreePrevious), findsOneWidget);

    // Check if question history is shown
    history.forEach((oldQuestion, oldAnswer) => {
          expect(
              find.byWidgetPredicate(
                  (Widget widget) => widget is RichText && widget.text.toPlainText() == "${oldQuestion.question} ${oldAnswer.answer}"),
              findsOneWidget),
        });

    // Choose a random answer from the decision tree
    Answer answer = question.answers[Random().nextInt(question.answers.length)];

    history[question] = answer;

    await tester.tap(find.text(answer.answer));
    await tester.pumpAndSettle();

    if (answer.nextQuestion != null) {
      await testQuestion(tester, answer.nextQuestion);
    } else {
      // Check if all solutions are shown
      for (Solution solution in answer.solutions) {
        expect(find.text(solution.title), findsOneWidget);
      }

      // Previous and finish should be shown
      expect(find.text(Strings.decisionTreeFinish), findsOneWidget);
      expect(find.text(Strings.decisionTreePrevious), findsOneWidget);

      // Click on finish so the screen closes
      await tester.tap(find.text(Strings.decisionTreeFinish));
      await tester.pump(Duration(milliseconds: 200));
    }
  }

  testWidgets("Tests the whole decision tree", (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await initialize();
    await tester.pumpWidget(MyApp(isIntroDone: true, isAuthorized: true));

    HashMap<String, String> neighbourhoods = HashMap();

    neighbourhoods[Strings.east] = Strings.locationEast;
    neighbourhoods[Strings.middle] = Strings.locationMiddle;
    neighbourhoods[Strings.west] = Strings.locationWest;

    for (String key in neighbourhoods.keys) {
      await tester.tap(find.byIcon(Icons.device_hub));
      await tester.pump(Duration(milliseconds: 200));

      await tester.pumpAndSettle();

      // Check if intro is shown
      expect(find.text(Strings.decisionTreeAppBarTitle), findsOneWidget);
      expect(find.text(Strings.decisionTreeExplanationTitle), findsOneWidget);
      expect(find.text(Strings.decisionTreeExplanationBody), findsOneWidget);

      // Previous and next should be hidden
      expect(find.text(Strings.decisionTreeNext), findsNothing);
      expect(find.text(Strings.decisionTreePrevious), findsNothing);

      // Start the decision tree
      await tester.tap(find.text(Strings.decisionTreeStart));
      await tester.pumpAndSettle();

      expect(find.text(Strings.noLocationSelected), findsOneWidget);

      // Only previous button should be shown on the map page
      expect(find.text(Strings.decisionTreeNext), findsNothing);
      expect(find.text(Strings.decisionTreePrevious), findsOneWidget);

      // Select the neighbourhood
      await tester.tap(find.byKey(Key(key)));
      await tester.pumpAndSettle();

      expect(find.text(neighbourhoods[key]), findsOneWidget);

      // Previous and next should be shown
      expect(find.text(Strings.decisionTreeNext), findsOneWidget);
      expect(find.text(Strings.decisionTreePrevious), findsOneWidget);

      await tester.tap(find.text(Strings.decisionTreeNext));
      await tester.pumpAndSettle();

      // Get the decision tree for the selected location so whe can test if the UI corresponds correctly to the decision tree
      Question question = DecisionTree().getQuestionsForLocation(neighbourhoods[key]);

      // Test if the question with answers is shown, click a random answer and repeat till there are no more questions left.
      await testQuestion(tester, question);

      // Clear history because we are going to test another location which means the history is reset.
      history.clear();
    }
  });
}
