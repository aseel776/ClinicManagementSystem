class PatientImagesDocsGql {
  static const String createPatientMedicalImageMutation = r'''
  mutation CreatePatientMedicalImage($input: CreatePatientMedicalImageInput!) {
    createPatientMedicalImage(input: $input) {
      created_at
      id
      medical_image_type_id
      patient_id
      src
      title
      imageType {
        id
        name
      }
    }
  }
''';

}
