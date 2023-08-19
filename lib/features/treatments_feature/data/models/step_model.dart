import 'package:equatable/equatable.dart';

class StepModel extends Equatable{

  int? id;
  String? name;
  List<String>? subSteps;

  StepModel({this.id, this.name, this.subSteps});

  StepModel.fromJson(Map<String, dynamic> source){
    id = source['id'];
    name = source['name'];
    if(source['subSteps'] != null){
      final temp = source['subSteps'] as List<dynamic>;
      subSteps = temp.map((e) => e['name'] as String).toList();
    } else{
      subSteps = [];
    }
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> subStepsJson = [];
    if(subSteps != null){
      subStepsJson = subSteps!.map((e) => _subStepToMap(e)).toList();
    }
    Map<String, dynamic> map = {
      'name': name,
      'subSteps': subStepsJson,
    };
    return map;
  }

  Map<String, dynamic> _subStepToMap(String subStep){
    return {
      'name': subStep
    };
  }

  @override
  List<Object?> get props => [id, name];
}