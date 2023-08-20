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
  
  ''';
}