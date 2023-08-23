class AppointmentsQuery{
  static const getAppointments = '''
  query PatientAppointments (\$date: DateTime){
    patientAppointments(date: \$date) {
        date
        id
        notes
        phase
        place
        state
        type
        patient {
            id
            name
        }
    }
  }
  ''';

  static const getAppointment = '''
  query PatientAppointment (\$id: Int!){
    patientAppointment(id: \$id) {
        date
        id
        notes
        patient_id
        phase
        place
        state
        type
    }
  }
  ''';
}