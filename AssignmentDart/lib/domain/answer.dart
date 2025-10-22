//import 'package:uuid/uuid.dart';

import 'package:my_first_project/domain/question.dart';

class Answer{
  final String id;
  final String questionId;
  final String answerChoice;
  
  Answer({String? id,required this.questionId, required this.answerChoice}): id = id ?? uuid.v4();

  bool isGood(Question question){
    return this.answerChoice == question.goodChoice;
  }

  Map<String, dynamic> toJson() =>
  {
    'id' : id,
    'questionId' : questionId,
    'answerChoice' : answerChoice,
  };


}
