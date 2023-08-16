import 'dart:convert';

class ActiveMaterialModel{
  int? id;
  String? name;
  //change type into ActiveMaterialModel
  List<ActiveMaterialModel>? antiMaterials;
  //change type into DiseaseModel
  List<String>? antiDiseases;
  //change type into BadHabitModel
  List<String>? antiHabits;


  ActiveMaterialModel({this.id, this.name, this.antiMaterials, this.antiDiseases, this.antiHabits});

  ActiveMaterialModel.fromJson(Map<String, dynamic> source){
    id = source['id'];
    name = source['name'];
    if(source['conflicts'] != null){
      List<dynamic> conflicts = source['conflicts'];
      antiMaterials = conflicts.map((c) => ActiveMaterialModel.fromJson(c)).toList();
    }
  }

  String toJson() {
    String string = "";
    //encoding
    return string;
  }
}