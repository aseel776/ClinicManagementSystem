import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class SessionInputModel extends Equatable{
  int? stepId;
  int? treatmentId;
  final notes = TextEditingController(text: '');

  SessionInputModel({this.stepId, this.treatmentId});

  SessionInputModel.fromJson(Map<String, dynamic> src){

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