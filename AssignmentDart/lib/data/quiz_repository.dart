import 'dart:convert';
import 'dart:io';
import '../domain/question.dart';
import '../domain/quiz.dart';
import '../domain/answer.dart';
import '../domain/submission.dart';

class QuizRepository {
  final String quizFilePath;
  final String submissionsFilePath;

  QuizRepository(this.quizFilePath, this.submissionsFilePath);

  Quiz readQuizWithSubmissions() {
    // --- Load quiz questions ---
    final quizFile = File(quizFilePath);
    if (!quizFile.existsSync()) {
      throw Exception('Quiz data file not found: $quizFilePath');
    }

    final quizContent = quizFile.readAsStringSync();
    final Map<String, dynamic> quizData =
        jsonDecode(quizContent) as Map<String, dynamic>;

    final questionJson = (quizData['questions'] as List<dynamic>?) ?? <dynamic>[];
    final questions = questionJson.map((q) {
      final qMap = q as Map<String, dynamic>;
      // point may be int or double in JSON -> normalize to int
      final point = (qMap['point'] is num) ? (qMap['point'] as num).toInt() : (qMap['point'] ?? 0);
      return Question(
        id: qMap['id'] as String?,
        title: qMap['title'] as String? ?? '',
        choices: List<String>.from(qMap['choices'] ?? <String>[]),
        goodChoice: qMap['goodChoice'] as String? ?? '',
        point: point as int,
      );
    }).toList();

    final quiz = Quiz(
      id: quizData['id'] as String?,
      questions: questions,
    );

    // --- Load old submissions (if file exists) ---
    final submissionFile = File(submissionsFilePath);
    if (submissionFile.existsSync()) {
      final content = submissionFile.readAsStringSync();
      if (content.trim().isNotEmpty) {
        final submissionList = jsonDecode(content) as List<dynamic>;
        for (var s in submissionList) {
          final sMap = s as Map<String, dynamic>;
          final answers = (sMap['answers'] as List<dynamic>?)
                  ?.map((a) {
                    final aMap = a as Map<String, dynamic>;
                    return Answer(
                      id: aMap['id'] as String?,
                      questionId: aMap['questionId'] as String? ?? '',
                      answerChoice: aMap['answerChoice'] as String? ?? '',
                    );
                  })
                  .toList() ??
              <Answer>[];

          final score = (sMap['score'] is num) ? (sMap['score'] as num).toInt() : (sMap['score'] ?? 0);

          // Create submission using the Submission constructor in lib/domain/submission.dart
          final submission = Submission(
            id: sMap['id'] as String?,
            playerName: sMap['playerName'] as String? ?? '',
            quizId: sMap['quizId'] as String? ?? '',
            answers: answers,
            score: score as int,
          );

          quiz.addSubmission(submission);
        }
      }
    }

    return quiz;
  }

  void writeSubmissions(Quiz quiz) {
    final file = File(submissionsFilePath);

    final parent = file.parent;
    if (!parent.existsSync()) {
      parent.createSync(recursive: true);
    }

    final newOnes = quiz.submissions.map((s) => s.toJson()).toList();
    file.writeAsStringSync(jsonEncode(newOnes), flush: true);
  }
}
