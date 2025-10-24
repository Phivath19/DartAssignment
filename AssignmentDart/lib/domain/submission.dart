import 'package:uuid/uuid.dart';
import 'question.dart';
import 'answer.dart';

final _uuid = Uuid();

class Submission {
  final String id;
  final String playerName;
  final String quizId;
  final List<Answer> answers;
  int score ;

  Submission({
    String? id,
    required this.playerName,
    required this.quizId,
    required this.answers,
    this.score = 0,
  }) : id = id ?? _uuid.v4();

  /// Calculate total score (sum of points for correct answers)
  int calculateScore(List<Question> allQuestions) {
    score = 0;

    for (Answer answer in answers) {
      // Find question that matches answer.questionId
      Question? question =
          allQuestions.firstWhere((q) => q.id == answer.questionId, orElse: () => Question(
            id: '',
            title: '',
            choices: [],
            goodChoice: '',
            point: 0,
          ));

      if (question.id.isNotEmpty && answer.isGood(question)) {
        score += question.point;
      }
    }

    return score;
  }

  /// Calculate percentage of correct answers
  int calculateScoreInPercentage(List<Question> allQuestions) {
    if (allQuestions.isEmpty) return 0;

    int correctCount = 0;

    for (Answer answer in answers) {
      Question? question =
          allQuestions.firstWhere((q) => q.id == answer.questionId, orElse: () => Question(
            id: '',
            title: '',
            choices: [],
            goodChoice: '',
            point: 0,
          ));

      if (question.id.isNotEmpty && answer.isGood(question)) {
        correctCount++;
      }
    }

    return ((correctCount / allQuestions.length) * 100).toInt();
  }

  /// Retrieve an answer by its ID
  Answer? getAnswerById(String answerId) {
    for (var ans in answers) {
      if (ans.id == answerId) {
        return ans;
      }
    }
    return null;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'playerName': playerName,
        'quizId': quizId,
        'answers': answers.map((a) => a.toJson()).toList(),
        'score': score,
      };
}
