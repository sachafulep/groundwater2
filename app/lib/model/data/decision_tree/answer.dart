import "package:groundwater/model/data/decision_tree/question.dart";
import "package:groundwater/model/data/decision_tree/solution.dart";

class Answer {
  Answer.withQuestion(this.answer, this.nextQuestion);

  Answer.withSolution(this.answer, this.solutions);

  String answer;

  Question nextQuestion;

  List<Solution> solutions;
}