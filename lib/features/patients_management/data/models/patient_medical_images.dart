class PatientMedicalImage {
  String? createdAt;
  int? id;
  int? medicalImageTypeId;
  int? patientId;
  String? src;
  String? title;

  PatientMedicalImage({
    this.createdAt,
    this.id,
    this.medicalImageTypeId,
    this.patientId,
    this.src,
    this.title,
  });

  factory PatientMedicalImage.fromJson(Map<String, dynamic> json) {
    return PatientMedicalImage(
      createdAt: json['created_at'],
      id: json['id'],
      medicalImageTypeId: json['medical_image_type_id'],
      patientId: json['patient_id'],
      src: json['src'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'created_at': createdAt,
      'id': id,
      'medical_image_type_id': medicalImageTypeId,
      'patient_id': patientId,
      'src': src,
      'title': title,
    };
  }
}
