import 'package:equatable/equatable.dart';

class ImplementedStep extends Equatable{
  int? id;
  int? stepId;
  String? notes;

  ImplementedStep({this.id, this.stepId, this.notes});

  ImplementedStep.fromJson(Map<String, dynamic> src){
    id = src['id'];
    stepId = src['step_id'];
    notes = src['notes'];
  }

  @override
  List<Object?> get props => [];
}