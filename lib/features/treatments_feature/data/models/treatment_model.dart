import 'dart:ui';

import 'package:equatable/equatable.dart';

import './step_model.dart';
import 'treatment_type_model.dart';

class TreatmentModel extends Equatable{

  int? id;
  String? name;
  int? price;
  Color? color;
  TreatmentTypeModel? type;
  List<StepModel>? steps;
  List<String>? channels;

  TreatmentModel({this.id, this.name, this.price, this.color, this.type, this.steps, this.channels});

  TreatmentModel.fromJson(Map<String, dynamic> source){
    id = source['id'];
    name = source['name'];
    color = _generateColor(source['color']);
    type = TreatmentTypeModel.fromJson(source['treatment_type']);
    if(source['price'] != null){
      price = source['price'];
      final tempSteps = source['steps'] as List<dynamic>;
      steps = tempSteps.map((e) => StepModel.fromJson(e)).toList();
      channels = steps![0].subSteps?? [];
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'name': name,
      'color': color.toString(),
      'price': price,
      'treatment_type_id': type!.id,
      'steps': steps!.map((s) => s.toJson()).toList(),
    };
    return map;
  }

  Color _generateColor(String inputColor){
    int colorHash = inputColor.hashCode;
    int colorValue = colorHash & 0x00FFFFFF;
    return Color(colorValue).withOpacity(1);
  }

  @override
  List<Object?> get props => [id, name, color];
}