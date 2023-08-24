class ReservationDocsGql {
  static const getReservationQuery = '''
            query PatientReservations {
              patientReservations {
                date
                id
                notes
                patient_id
                 patient {
            address
            birth_date
            gender
            id
            job
            main_complaint
            maintal_status
            name
            phone
        }
              }
            }
          ''';

  static const deleteReservations = '''
              mutation RemovePatientReservation {
                removePatientReservation(id: 1) {
                  date
                  id
                  notes
                  patient_id
                }
              }
            ''';
}
