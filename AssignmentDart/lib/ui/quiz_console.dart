import 'dart:io';
import '../domain/quiz.dart';

class QuizConsole {
  List<Question> question;
  List<Player>players = [];

  QuizConsole({required this.question});

  void startQuiz() {
    print('--- Welcome to the Quiz ---\n');
    while(true){
      stdout.write('Your name: ');

      String ? name = stdin.readLineSync();
      if(name == null || name.isEmpty){
        print('--- Quiz Finished --- ');
        break;

      }
      
      Player player = Player(name: name );
      Quiz quiz = Quiz(questions: question);
  

    for (var question in quiz.questions) {
      print('Question: ${question.title} (${question.score} score)');
      print('Choices: ${question.choices}');
      stdout.write('Your answer: ');
      String? userInput = stdin.readLineSync();

      // Check for null input
      if (userInput != null && userInput.isNotEmpty) {
        Answer answer = Answer(question: question, answerChoice: userInput);
        quiz.addAnswer(answer);
      } else {
        print('No answer entered. Skipping question.');
      }

      print('');
    }
    int point = quiz.getTotalScore();
    int score = quiz.getScoreInPercentage();
    player.updatePoint(point);

    
    players.add(player);

    print('--- Quiz Finished ---');
    print('${player.name}, your score in percentage: $score%');
    print('${player.name}, your score in points: $point');

    for(var p in players){
      print('player:${p.name} score:${p.playerScore}');
    }
    print('');
    }
  }
}
 