import 'package:my_first_project/domain/question.dart';

class Player
{
  final String id;
  final String name;
  Player({String? id,required this.name}): id = id ?? uuid.v4();

  Map<String, dynamic> toJson() =>
  {
    'id' : id,
    'name' : name,
  };


}
