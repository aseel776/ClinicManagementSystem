import 'lab_model.dart';
import 'lab_order_step.dart';

class LabOrder {
  int id;
  int labId;
  String name;
  List<LabOrderStep>? steps;
  Lab lab;

  LabOrder({
    required this.id,
    required this.labId,
    required this.name,
    this.steps,
    required this.lab,
  });

  factory LabOrder.fromJson(Map<String, dynamic> json) {
    List<dynamic> stepsData = json['LabOrderStep'];
    List<LabOrderStep> stepsList =
        stepsData.map((stepData) => LabOrderStep.fromJson(stepData)).toList();

    return LabOrder(
      id: json['id'],
      labId: json['lab_id'],
      name: json['name'],
      steps: stepsList,
      lab: Lab.fromJson(json['lab']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lab_id': labId,
      'name': name,
      'steps': steps!.map((step) => step.toJson()).toList(),
      'lab': lab.toJson(),
    };
  }
}
