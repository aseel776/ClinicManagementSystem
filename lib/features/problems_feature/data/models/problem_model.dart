import 'package:equatable/equatable.dart';
import './problem_type_model.dart';

class ProblemModel extends Equatable{

  int? id;
  String? name;
  ProblemTypeModel? type;

  ProblemModel({this.id, this.name});

  ProblemModel.fromJson(Map<String, dynamic> source){
    id = source['id'];
    name = source['name'];
    type = ProblemTypeModel.fromJson(source['Problem_type']);
  }

  Map<String, dynamic> toJson(){
    return {
      'name': name,
      'problem_type_id': type!.id,
    };
  }

  @override
  List<Object?> get props => throw UnimplementedError();

}