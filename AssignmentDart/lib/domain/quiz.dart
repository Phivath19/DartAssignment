

class Question{
  final String title;
  final List<String> choices;
  final String goodChoice;
  final int score;
   

  Question({required this.title, required this.choices, required this.goodChoice, required this.score});
}

class Answer{
  final Question question;
  final String answerChoice;


  Answer({required this.question, required this.answerChoice,});

  bool isGood(){
    return this.answerChoice == question.goodChoice;
  }
}

class Player{
  String name;
  int playerScore;
  Player({required this.name, this.playerScore = 0});

  void updatePoint(int newScore){
    playerScore = newScore;
  }
}

class Quiz{
  List<Question> questions;
  List <Answer> answers =[];

  Quiz({required this.questions});

  void addAnswer(Answer answer) {
     this.answers.add(answer);
  }

  int getTotalScore(){
    int totalSCore = 0;
    for(Answer answer in answers){
        if(answer.isGood()){
          totalSCore+= answer.question.score;
        }
    }
    return totalSCore;
  }

  int getScoreInPercentage(){
    int total = 0;
    if(questions.isEmpty){
      return 0;
    }
    for(Answer answer in answers)
    {
      total +=answer.question.score;
    }
    int percentage = getTotalScore();

    return((percentage * 100)/total).toInt();
    
  }
}