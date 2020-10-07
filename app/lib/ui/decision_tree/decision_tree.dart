import "dart:collection";

import "package:flutter/material.dart";
import "package:groundwater/model/data/decision_tree/answer.dart";
import "package:groundwater/model/data/decision_tree/decision_tree.dart";
import "package:groundwater/model/data/decision_tree/question.dart";
import "package:groundwater/ui/decision_tree/intro.dart";
import "package:groundwater/ui/decision_tree/map.dart";
import "package:groundwater/ui/decision_tree/question.dart";
import "package:groundwater/ui/decision_tree/solution.dart";
import "package:groundwater/utils/colors.dart";
import "package:groundwater/utils/strings.dart";

import "../../model/data/decision_tree/solution.dart";

enum Page { intro, map, questions, solution }

/// Controls the introduction, the questions with answers and the solution
class DecisionTreePage extends StatefulWidget {
  static const routeName = "/decision-tree";

  DecisionTreePage({Key key}) : super(key: key);

  @override
  _DecisionTreePageState createState() => _DecisionTreePageState();
}

class _DecisionTreePageState extends State<DecisionTreePage> {
  Page _currentPage = Page.intro;

  // Map variables
  String _location = Strings.noLocationSelected;
  AssetImage _mapImage = AssetImage("assets/EnschedeBase.png");
  bool mapImageBuilt = false;

  // Question variables
  Question _nextQuestion;
  LinkedHashMap _history = LinkedHashMap<Question, Answer>();

  // Solution variables
  Answer _finalAnswer;
  HashMap<Solution, bool> _sectionStates = HashMap();

  /// Introduction

  void _startClicked() {
    setState(() {
      _currentPage = Page.map;
    });
  }

  /// Map

  void _selectLocation(String location) {
    setState(() {
      _location = location;

      switch (location) {
        case Strings.locationEast:
          _mapImage = AssetImage("assets/EnschedeBaseOost.png");
          break;
        case Strings.locationWest:
          _mapImage = AssetImage("assets/EnschedeBaseWest.png");
          break;
        case Strings.locationMiddle:
          _mapImage = AssetImage("assets/EnschedeBaseMidden.png");
          break;
      }
    });
  }

  void _mapImageBuilt() {
    if (!mapImageBuilt) {
      setState(() {
        mapImageBuilt = true;
      });
    }
  }

  /// Questions

  void _answerClicked(Answer answer) {
    _history[_nextQuestion] = answer;
    if (answer.nextQuestion != null) {
      setState(() {
        _nextQuestion = answer.nextQuestion;
      });
    } else if (answer.solutions.isNotEmpty) {
      setState(() {
        _nextQuestion = null;
        _finalAnswer = answer;
        _currentPage = Page.solution;
      });
    }
  }

  /// Navigates to the previous question.
  /// Returns true if succeeded.
  /// Returns false if there is no previous question to go to.
  bool _goToPreviousQuestion() {
    if (_history.isEmpty) return false;

    var previous = _history.entries.last.key as Question;
    _history.remove(previous);

    setState(() {
      _history = _history;
      _nextQuestion = previous;
    });

    return true;
  }

  /// Global

  void _previousClicked() {
    if (_currentPage == Page.map) {
      // Go back to intro and reset map variables
      setState(() {
        _currentPage = Page.intro;
        _location = Strings.noLocationSelected;
        _mapImage = AssetImage("assets/EnschedeBase.png");
      });
      return;
    }

    if (_currentPage == Page.questions) {
      if (!_goToPreviousQuestion()) {
        // There was no previous question to go to,
        // go back to map and reset question variables
        setState(() {
          _currentPage = Page.map;
          _nextQuestion = null;
        });
      }
      return;
    }

    if (_currentPage == Page.solution) {
      _goToPreviousQuestion();
      setState(() {
        _finalAnswer = null;
        _currentPage = Page.questions;
      });
      return;
    }
  }

  void _nextClicked() {
    if (_currentPage == Page.map) {
      setState(() {
        _currentPage = Page.questions;
        _nextQuestion = DecisionTree().getQuestionsForLocation(_location);
      });
      return;
    }

    if (_currentPage == Page.solution) {
      // Go back to dashboard
      Navigator.of(context).pop();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.decisionTreeAppBarTitle),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 400),
              child: _buildPage(),
            ),
          ),
          if (_currentPage != Page.intro) _buildBottom(),
        ],
      ),
    );
  }

  Widget _buildPage() {
    if (_currentPage == Page.map) {
      return MapDisplay(
        nextClickedCallback: _nextClicked,
        selectLocationCallback: _selectLocation,
        mapImageBuiltCallback: _mapImageBuilt,
        location: _location,
        mapImage: _mapImage,
        mapImageBuilt: mapImageBuilt,
      );
    }

    // If there is no question or answer available, the intro should be shown
    if (_currentPage == Page.intro) {
      return IntroDisplay(
        startClickedCallback: _startClicked,
      );
    }

    // If there is a question show it
    if (_currentPage == Page.questions && _nextQuestion != null && _nextQuestion.answers.isNotEmpty) {
      return QuestionDisplay(
        key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
        question: _nextQuestion,
        selectedLocation: _location,
        history: _history,
        answerClickedCallback: _answerClicked,
        previousClickedCallback: _previousClicked,
      );
    }

    void _toggleSectionState(Solution solution) {
      _sectionStates[solution] = !_sectionStates[solution];
      setState(() {});
    }

    // If the final answer is filled, the solutions of it should be shown
    if (_currentPage == Page.solution && _finalAnswer != null) {
      if (_sectionStates.isEmpty) {
        _finalAnswer.solutions.forEach((solution) => {_sectionStates[solution] = false});
      }

      return SolutionDisplay(
        answer: _finalAnswer,
        sectionStates: _sectionStates,
        toggleStateCallback: (Solution solution) => _toggleSectionState(solution),
      );
    }

    // Null represents an empty widget
    return null;
  }

  Widget _buildBottom() {
    return Padding(
      padding: EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            child: Text(
              Strings.decisionTreePrevious,
              style: TextStyle(
                color: GroundColor.subText,
              ),
            ),
            onPressed: _previousClicked,
          ),
          if ((_currentPage == Page.map && _location != Strings.noLocationSelected) || _currentPage == Page.solution)
            FlatButton(
              child: Text(
                (_currentPage == Page.solution) ? Strings.decisionTreeFinish : Strings.decisionTreeNext,
                style: TextStyle(
                  color: GroundColor.accent,
                ),
              ),
              onPressed: _nextClicked,
            ),
        ],
      ),
    );
  }
}
