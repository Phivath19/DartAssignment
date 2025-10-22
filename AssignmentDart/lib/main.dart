 
import 'domain/quiz.dart';
import 'ui/quiz_console.dart';

void main() {

  List<Question> questions = [
    Question(
        title: "Capital of France?",
        choices: ["Paris", "London", "Rome"],
        goodChoice: "Paris", score:  10),
    Question(
        title: "2 + 2 = ?", 
        choices: ["2", "4", "5"], 
        goodChoice: "4", score:  50),
  ];

  Quiz quiz = Quiz(questions: questions);
  QuizConsole console = QuizConsole(question: questions);

  console.startQuiz();

  print(quiz.questions.length);
}
