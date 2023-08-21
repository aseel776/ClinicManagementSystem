import 'package:clinic_management_system/features/treatments_feature/data/models/treatment_model.dart';
import 'package:equatable/equatable.dart';
import './implemented_step.dart';

class PatientTreatmentModel extends Equatable{
  int? id;
  int? patientId;
  String? place;
  int? price;
  TreatmentModel? treatment;
  List<ImplementedStep>? stepsDone;

  PatientTreatmentModel({this.id, this.patientId, this.place, this.treatment, this.price, this.stepsDone});

  PatientTreatmentModel.fromJson(Map<String, dynamic> src){
    id = src['id'];
    patientId = src['patient_id'];
    place = src['place'];
    price = (src['price'] is int) ? src['price'] : src['price'].toInt();
    treatment = TreatmentModel.fromJson(src['treatment']);
    if(src.containsKey('PatientTreatmentDoneStep') && src['PatientTreatmentDoneStep'] != null){
      List<dynamic> temp = src['PatientTreatmentDoneStep'];
      stepsDone = temp.map((e) => ImplementedStep.fromJson(e)).toList();
    } else{
      stepsDone = [];
    }
  }

  @override
  List<Object?> get props => [id, patientId, place, price];
}