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
    medicineId = src['medicince']['id'];
    medicineName = src['medicince']['name'];
    concentration = src['medicince']['concentration'];
    form = src['medicince']['category']['name'];
    desc = src['description'];
    quantity = src['qantity'];
    repeat = src['repetition'];
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