class PatientImagesDocsGql {
  static const String createPatientMedicalImageMutation = '''
    mutation CreatePatientMedicalImage(
      \$image: Upload!,
      \$medical_image_type_id: Int!,
      \$patient_id: Int!,
      \$title: String!
    ) {
      createPatientMedicalImage(
        createPatientMedicalImageInput: {
          image: \$image,
          medical_image_type_id: \$medical_image_type_id,
          patient_id: \$patient_id,
          title: \$title
        }
      ) {
        created_at
        id
        medical_image_type_id
        patient_id
        src
        title
      }
    }
  ''';

  static const String patientMedicalImagesQuery = r'''
  query PatientMedicalImages($medical_image_type_id: Int!, $patient_id: Int!) {
    patientMedicalImages(medical_image_type_id: $medical_image_type_id, patient_id: $patient_id) {
      created_at
      id
      medical_image_type_id
      patient_id
      src
      title
    }
  }
''';
}
