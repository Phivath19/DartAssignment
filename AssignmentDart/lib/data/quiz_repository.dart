import 'dart:convert';
import 'dart:io';
import '../domain/question.dart';
import '../domain/quiz.dart';


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
      return Question(
        id: qMap['id'],
        title: qMap['title'],
        choices: List<String>.from(qMap['choices'] ?? []),
        goodChoice: qMap['goodChoice'],
        point: qMap['point'],
      );
    }).toList();

    final quiz = Quiz(
      id: quizData['id'],
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
                      questionId: aMap['questionId'],
                      answerChoice: aMap['answerChoice'],
                    );
                  })
                  .toList() ??
              <Answer>[];

          quiz.addSubmission(
            Submission(
              playerName: sMap['playerName'],
              quizId: sMap['quizId'],
              score: sMap['score'],
              answers: answers,
            ),
          );
        }
      }
    }

    return quiz;
  }

  void writeSubmissions(Quiz quiz) {
    final file = File(submissionsFilePath);

    // Ensure parent directory exists
    final parent = file.parent;
    if (!parent.existsSync()) {
      parent.createSync(recursive: true);
    }

    // Overwrite file with current quiz submissions to avoid duplicate appends.
    final newOnes = quiz.submissions.map((s) => s.toJson()).toList();
    file.writeAsStringSync(jsonEncode(newOnes), flush: true);
  }
}
