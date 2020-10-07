import "package:groundwater/model/data/decision_tree/answer.dart";

class Question {
  Question(this.question, this.answers);

  String question = "";
  List<Answer> answers;
}