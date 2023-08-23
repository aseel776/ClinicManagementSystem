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

  Map<String, dynamic> toJson(){
    Map<String, dynamic> map = {};
    if(id != null){
      map.putIfAbsent('id', () => id);
    }
    map.putIfAbsent('patient_id', () => patientId);
    map.putIfAbsent('treatment_id', () => treatment!.id);
    map.putIfAbsent('price', () => price);
    map.putIfAbsent('place', () => place);
    if(RegExp('r^[th]', caseSensitive:false).hasMatch(place!)){
      map.putIfAbsent('type', () => 'teethly');
    }else{
      map.putIfAbsent('type', () => 'unteethly');
    }
    return map;
  }

  @override
  List<Object?> get props => [id, patientId, place, price];
}