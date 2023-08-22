class PatientDiagnosis {
  String? expectedTreatment;
  int? id;
  int? patientId;
  String? place;
  int? problemId;

  PatientDiagnosis({
    this.expectedTreatment,
    this.id,
    this.patientId,
    this.place,
    this.problemId,
  });

  factory PatientDiagnosis.fromJson(Map<String, dynamic> json) {
    return PatientDiagnosis(
      expectedTreatment: json['expected_treatment'],
      id: json['id'],
      patientId: json['patient_id'],
      place: json['place'],
      problemId: json['problem_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expected_treatment': expectedTreatment,
      'id': id,
      'patient_id': patientId,
      'place': place,
      'problem_id': problemId,
    };
  }
}
