class AppointmentsMutation{

  static const createAppointment = '''
  mutation CreatePatientAppointment (\$createPatientAppointmentInput: CreatePatientAppointmentInput!){
    createPatientAppointment(createPatientAppointmentInput: \$createPatientAppointmentInput) {
        id
    }
  }
  ''';

  static const updateAppointment = '''
  mutation UpdatePatientAppointment (\$updatePatientAppointmentInput: UpdatePatientAppointmentInput!){
    updatePatientAppointment(
      updatePatientAppointmentInput: \$updatePatientAppointmentInput
      ) {
        id
    }
  }
  ''';

  static const deleteAppointment = '''
  mutation RemovePatientAppointment(\$id: Int!) {
    removePatientAppointment(id: \$id) {
        id
    }
  }
  ''';
}