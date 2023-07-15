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
  List<String>? channels;

  TreatmentModel({this.id, this.name, this.price, this.color, this.type, this.steps, this.channels});

  TreatmentModel.fromJson(String source){
    //decoding
  }

  String toJson() {
    String string = "";
    //encoding
    return string;
  }

}