import 'package:uuid/uuid.dart';

var uuid = uUid();
class Question{
  final String id;
  final String title;
  final List<String> choices;
  final String goodChoice;
  final int point;

  Question({String ? id,required this.title, required this.choices, required this.goodChoice, required this.point}): id = id ?? uuid.v4();


  //convert to JSON file
  Map<String, dynamic> toJson() =>
  {
    'id' : id,
    'title' : title,
    'choices' : choices,
    'goodChoice' : goodChoice,
    'point' : point,
  };

 
  

}