import 'package:equatable/equatable.dart';

class ProblemTypeModel extends Equatable{
  int? id;
  String? name;

  ProblemTypeModel({this.id, this.name});

  ProblemTypeModel.fromJson(Map<String, dynamic> source){
    id = source['id'];
    name = source['name'];
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  List<Object?> get props => [id, name];

}