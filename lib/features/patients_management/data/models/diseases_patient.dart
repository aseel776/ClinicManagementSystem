import 'package:clinic_management_system/features/diseases_badHabits/data/models/diseases.dart';
import 'package:equatable/equatable.dart';

class PatientDiseases extends Equatable {
  int? id;
  String? date;
  Disease? disease;

  PatientDiseases({this.id, this.date, this.disease});

  factory PatientDiseases.fromJson(Map<String, dynamic> json) {
    final diseaseJson = json['disease'];

    return PatientDiseases(
      id: json['disease_id'],
      date: json['date'],
      disease: diseaseJson != null ? Disease.fromJson(diseaseJson) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'disease_id': id,
    };

    // if (date != null) {
    //   json['date'] = date;
    // }

    // if (disease != null) {
    //   json['disease'] = disease?.toJson();
    // }

    return json;
  }

  @override
  List<Object?> get props => [id, date, disease];
}
