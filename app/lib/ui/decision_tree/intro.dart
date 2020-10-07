import "package:flutter/material.dart";
import "package:groundwater/utils/colors.dart";
import "package:groundwater/utils/strings.dart";

typedef void StartClickedCallback();

/// Displays an introduction which explains the decision tree
class IntroDisplay extends StatelessWidget {
  IntroDisplay({this.startClickedCallback});

  final StartClickedCallback startClickedCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Text(
            Strings.decisionTreeExplanationTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 24,
              left: 16,
              right: 16,
            ),
            child: Text(
              Strings.decisionTreeExplanationBody,
              style: TextStyle(
                color: GroundColor.subText,
                height: 1.4,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: MaterialButton(
              minWidth: double.infinity,
              height: 48,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(Strings.decisionTreeStart),
              color: Theme.of(context).buttonColor,
              onPressed: startClickedCallback,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
