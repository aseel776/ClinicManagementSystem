import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class SessionInputModel extends Equatable{
  int? id;
  int? stepId;
  int? treatmentId;
  final notes = TextEditingController(text: '');

  SessionInputModel({this.stepId, this.treatmentId});

  SessionInputModel.fromJson(Map<String, dynamic> src){
    id = src['id'];
    stepId = src['step_id'];
    treatmentId = src['patient_treatment_id'];
    notes.text = src['notes'];
  }

  Map<String, dynamic> toJson(){
    return {
      'step_id': stepId,
      'patient_treatment_id': treatmentId,
      'note': notes.text
    };
  }

  @override
  List<Object?> get props => [stepId, treatmentId, notes];
}