class StepModel{

  int? id;
  String? name;
  //String? notes;
  List<String>? channels;

  StepModel({this.id, this.name, this.channels});

  StepModel.fromJson(String source){
    //decoding
  }

  String toJson() {
    String string = "";
    //encoding
    return string;
  }

}