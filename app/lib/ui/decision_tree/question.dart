import "dart:collection";

import "package:flutter/material.dart";
import "package:groundwater/model/data/decision_tree/answer.dart";
import "package:groundwater/model/data/decision_tree/question.dart";
import "package:groundwater/utils/colors.dart";
import "package:groundwater/utils/strings.dart";

typedef void AnswerClickedCallback(Answer answer);
typedef void PreviousClickedCallback();

/// Displays a question with answers
class QuestionDisplay extends StatelessWidget {
  QuestionDisplay({
    Key key,
    this.question,
    this.selectedLocation,
    this.history,
    this.answerClickedCallback,
    this.previousClickedCallback,
  }) : super(key: key);

  final Question question;

  final String selectedLocation;

  final LinkedHashMap history;

  final AnswerClickedCallback answerClickedCallback;

  final PreviousClickedCallback previousClickedCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, top: 16, right: 16),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    question.question,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                for (var answer in question.answers)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlineButton(
                        child: Text(answer.answer),
                        color: Theme.of(context).buttonColor,
                        onPressed: () {
                          answerClickedCallback(answer);
                        },
                        textColor: GroundColor.accent,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          _buildHistory(),
        ],
      ),
    );
  }

  Widget _buildHistory() {
    List<Widget> previousAnswers = List();

    // Add selected location
    previousAnswers.add(_buildHistoryItem(Strings.location, selectedLocation));

    history.forEach((question, answer) => {
          previousAnswers.add(
            _buildHistoryItem(question.question as String, answer.answer as String),
          ),
        });

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            for (Widget widget in previousAnswers) widget,
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String question, String answer) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          style: TextStyle(
            fontSize: 14,
            height: 1.4,
            color: GroundColor.subText,
          ),
          children: <TextSpan>[
            TextSpan(
              text: "$question ",
            ),
            TextSpan(
              text: "$answer",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
