import 'dart:ui';
import 'step_entity.dart';
import 'treatment_type_entity.dart';

class TreatmentEntity{

  int? id;
  String? name;
  int? price;
  Color? color;
  TreatmentTypeEntity? type;
  List<StepEntity>? steps;

  TreatmentEntity({this.id, this.name, this.price, this.color, this.type, this.steps});

}