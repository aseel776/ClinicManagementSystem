class PatientTreatmentsMutation{
  static const createPatientTreatment = '''
  mutation CreatePatientTreatment (\$createPatientTreatmentInput: CreatePatientTreatmentInput!){
    createPatientTreatment(
        createPatientTreatmentInput: \$createPatientTreatmentInput) {
        id
    }
  }
  ''';

  static const createSession = '''
    mutation CreatePatientSession (\$createPatientSessionInput: CreatePatientSessionInput!){
    createPatientSession(
        createPatientSessionInput: \$createPatientSessionInput
    ) {
        patient_id
        patiient_appointment_id
    }
  }
  ''';

  /*
  mutation CreatePatientSession {
    createPatientSession(
        createPatientSessionInput: {
            patient_id: 1,
            patiient_appointment_id: 2,
            CreatePatientTreatmentDoneStepFromSessionInput: [
                {
                    step_id: 1,
                    note: "sdsd",
                    patient_treatment_id: 3,
                }
            ],
            createPatientLabOrderFromSessionInput:{
                created_at: "2023-08-21",
                deliver_at: "2023-08-23",
                degree: "white",
                type: "crown",
                directions: "",
                lab_order_id: 3,
                notation: ["11","12"],
                patient_id: 1,
            },
            createPatientPerscrptionFromSessionInput: {
                createPatientPerscrptionsMedicienInput: [
                    {
                        description: "sdsd",
                        medicince_id: 2,
                        qantity: "212",
                        repetition: "dfdf"
                    }
                ]
            }
        }
    ) {
        patient_id
        patiient_appointment_id
    }
  }
   */
}