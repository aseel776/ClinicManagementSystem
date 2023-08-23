import 'package:equatable/equatable.dart';

class PrescriptionInput extends Equatable{
  int? medicineId;
  double? concentration;
  String? medicineName;
  String? form;
  String? desc;
  String? quantity;
  String? repeat;

  PrescriptionInput({this.medicineId, this.medicineName, this.desc, this.quantity, this.repeat});

  PrescriptionInput.fromJson(Map<String, dynamic> src){
    medicineId = src['medicince_id'];
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