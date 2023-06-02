import 'dart:ui';
import './step_model.dart';
import 'treatment_type_model.dart';

class TreatmentModel{

  int? id;
  String? name;
  int? price;
  Color? color;
  TreatmentTypeModel? type;
  List<StepModel>? steps;

  TreatmentModel({this.id, this.name, this.price, this.color, this.type, this.steps});

  TreatmentModel.fromJson(String source){
    //decoding
  }

  String toJson() {
    String string = "";
    //encoding
    return string;
  }

}