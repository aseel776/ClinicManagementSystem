import 'package:equatable/equatable.dart';

class PrescriptionInput extends Equatable{
  int? medicineId;
  double? concentration;
  String? medicineName;
  String? form;
  String? desc;
  String? quantity;
  String? repeat;
  int? id;
  int? presId;

  PrescriptionInput({
    this.medicineId,
    this.medicineName,
    this.desc,
    this.quantity,
    this.repeat,
    this.id,
    this.presId,
  });

  PrescriptionInput.fromJson(Map<String, dynamic> src){
    id = src['id'];
    presId = src['patient_perscrption_id'];
    Map<String, dynamic> temp = src['PatientPerscrptionsMedicince'];
    desc = temp['description'];
    repeat = temp['repetition'];
    quantity = temp['qantity'];
    medicineId = temp['medicince']['id'];
    medicineName = temp['medicince']['name'];
    concentration = temp['medicince']['concentration'];
    form = temp['medicince']['category']['name'];
  }

  Map<String, dynamic> toJson(){
    return {
      'description': desc,
      'medicince_id': medicineId,
      'qantity': quantity,
      'repetition': repeat,
    };
  }

  @override
  List<Object?> get props => [medicineId, medicineName];
}