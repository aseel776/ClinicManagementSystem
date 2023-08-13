class ActiveMaterialModel{
  int? id;
  String? name;
  //change type into ActiveMaterialModel
  List<String>? antiMaterials;
  //change type into DiseaseModel
  List<String>? antiDiseases;
  //change type into BadHabitModel
  List<String>? antiHabits;


  ActiveMaterialModel({this.id, this.name, this.antiMaterials, this.antiDiseases, this.antiHabits});

  ActiveMaterialModel.fromJson(String source){
    //decoding
  }

  String toJson() {
    String string = "";
    //encoding
    return string;
  }
}