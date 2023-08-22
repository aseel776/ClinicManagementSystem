import 'package:clinic_management_system/features/medicine/data/model/medicine_model.dart';
import 'package:equatable/equatable.dart';

class PatientMedicine extends Equatable {
  int? id;
  String? notes;
  Medicine? medicine;
  String? date;

  bool? controlled;

  PatientMedicine(
      {this.id, this.notes, this.medicine, this.date, this.controlled});

  factory PatientMedicine.fromJson(Map<String, dynamic> json) {
    final medicineJson = json['medicine'];

    return PatientMedicine(
      id: json['id'],
      notes: json['notes'],
      date: json['start_date'],
      medicine: medicineJson != null ? Medicine.fromJson(medicineJson) : null,
      controlled: json['controlled'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'medicine_id': id,
      'notes': notes,
      // 'date': date
      // 'tight': controlled,
    };

    // if (medicine != null) {
    //   json['medicine'] = medicine?.toJson();
    // }

    return json;
  }

  @override
  List<Object?> get props => [id, notes, medicine];
}
