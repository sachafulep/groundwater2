import "dart:collection";

import "package:flutter/material.dart";
import "package:groundwater/model/data/decision_tree/answer.dart";
import "package:groundwater/model/data/decision_tree/solution.dart";
import "package:groundwater/utils/colors.dart";
import "dart:math" show pi;

import "../../utils/colors.dart";
import "../../utils/strings.dart";

class SolutionDisplay extends StatelessWidget {
  SolutionDisplay({
    this.answer,
    this.sectionStates,
    this.toggleStateCallback,
  });

  final Answer answer;
  final HashMap<Solution, bool> sectionStates;
  final Function toggleStateCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 32, top: 16, right: 32),
          child: Column(
            children: <Widget>[
              for (Solution solution in answer.solutions) solutionWidget(solution),
              callToAction(),
            ],
          ),
        ),
      ),
    );
  }

  Widget solutionWidget(Solution solution) {
    return Column(
      children: <Widget>[
        MaterialButton(
          padding: EdgeInsets.all(0),
          onPressed: () => toggleStateCallback(solution),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  solution.title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18, color: GroundColor.icon, fontWeight: FontWeight.w400),
                ),
              ),
              arrowIcon(solution),
            ],
          ),
        ),
        ExpandedSection(
          child: Text(
            solution.description,
            style: TextStyle(
              color: GroundColor.subText,
              height: 1.5,
            ),
          ),
          expand: sectionStates[solution],
        ),
      ],
    );
  }

  Widget arrowIcon(Solution solution) {
    if (!sectionStates[solution]) {
      return Transform.rotate(
        angle: -(pi / 2),
        child: Icon(
          Icons.arrow_drop_down,
          size: 24,
          color: GroundColor.icon,
        ),
      );
    } else {
      return Icon(
        Icons.arrow_drop_down,
        size: 24,
        color: GroundColor.icon,
      );
    }
  }

  Widget callToAction() {
    if (sectionStates.values.every((value) => value == false)) {
      return Padding(
        padding: EdgeInsets.only(left: 16, top: 16, right: 16),
        child: Text(
          Strings.callToAction,
          style: TextStyle(
            color: GroundColor.icon,
            fontSize: 11,
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}

class ExpandedSection extends StatefulWidget {
  final Widget child;
  final bool expand;

  ExpandedSection({this.expand = false, this.child});

  @override
  _ExpandedSectionState createState() => _ExpandedSectionState();
}

class _ExpandedSectionState extends State<ExpandedSection> with SingleTickerProviderStateMixin {
  AnimationController expandController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _runExpandCheck() {
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(ExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(axisAlignment: 1.0, sizeFactor: animation, child: widget.child);
  }
}
