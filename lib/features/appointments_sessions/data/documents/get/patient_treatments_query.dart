class PatientTreatmentsQuery{

  static const getOngoingPatientTreatments = '''
  query PatientTreatments (\$patient_id: Int!, \$status: PatientTreatmentStatuses!){   
    patientTreatments(patient_id: \$patient_id, status: \$status) {
        id
        patient_id
        place
        price
        PatientTreatmentDoneStep {
            id
            note
            step_id
        }
        treatment {
            id
            name
            steps {
                id
                name
                subSteps {
                    name
                }
            }
            treatment_type {
                id
                name
            }
        }
    }
  }
  ''';

  static const getAllPatientTreatments = '''
  query PatientTreatments (\$patient_id: Int!){   
    patientTreatments(patient_id: \$patient_id) {
        id
        patient_id
        place
        price
        PatientTreatmentDoneStep {
            id
            note
            step_id
        }
        treatment {
            id
            name
            steps {
                id
                name
                subSteps {
                    name
                }
            }
            treatment_type {
                id
                name
            }
        }
    }
  }
  ''';

  static const getPatientTreatment = '''
  query PatientTreatment (\$id: Int!){
    patientTreatment(id: \$id) {
        id
        patient_id
        place
        price
        PatientTreatmentDoneStep {
            id
            note
            step_id
        }
        treatment {
            color
            id
            name
            price
            treatment_type_id
            steps {
                id
                name
                subSteps {
                    name
                }
            }
        }
    }
  }
  ''';

}