// Packages
import 'dart:convert';

//* Get Trivia model from Json
Trivia triviaFromJson(String str) => Trivia.fromJson(json.decode(str));

//* Get Json from Trivia model
String triviaToJson(Trivia data) => json.encode(data.toJson());

class Trivia {
  Trivia({
    required this.id,
    required this.question,
    required this.wrongAnswers,
    required this.rightAnswer,
  });

  String id;
  String question;
  List<String> wrongAnswers;
  String rightAnswer;

  static bool stop = false;

  factory Trivia.fromJson(Map<String, dynamic> json) => Trivia(
    id: json["id"] ?? "",
    question: json["question"] ?? "",
    wrongAnswers: json["wrongAnswers"] ?? "",
    rightAnswer: json["rightAnswer"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "wrongAnswers": wrongAnswers,
    "rightAnswer": rightAnswer,
  };

  bool isRightAnswer(String answer) {
    return rightAnswer == answer;
  }
}
