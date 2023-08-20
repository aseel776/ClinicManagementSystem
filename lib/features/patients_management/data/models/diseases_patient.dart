import 'package:equatable/equatable.dart';

import '../../../diseases_badHabits/data/models/diseases.dart';

class PatientDiseases extends Equatable {
  int? id;
  String? date;
  Disease? disease;
  bool? controlled;

  PatientDiseases({this.id, this.date, this.disease, this.controlled});

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
      'disease_id': disease!.id,
      'tight': controlled
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
