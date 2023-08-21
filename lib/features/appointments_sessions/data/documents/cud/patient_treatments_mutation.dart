class PatientTreatmentsMutation{
  static const createPatientTreatment = '''
  mutation CreatePatientTreatment (\$createPatientTreatmentInput: CreatePatientTreatmentInput!){
    createPatientTreatment(
        createPatientTreatmentInput: \$createPatientTreatmentInput) {
        id
    }
  }
  ''';
}