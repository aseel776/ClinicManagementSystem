class SessionsMutation{
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
}