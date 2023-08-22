class PatientBadHabitsDocsGql {
//   static const String createPatientBadHabitMutation = '''
//   mutation CreatePatientBadHabit(\$input: CreatePatientBadHabitInput!) {
//     createPatientBadHabit(createPatientBadHabitInput: \$input) {
//       id
//       notes
//       patient_id
//       start_date
//       bad_habit {
//         name
//         id
//       }
//     }
//   }
// ''';
  static const String createPatientBadHabitMutation = r'''
  mutation CreatePatientBadHabit(
    $badHabitId: Int!,
    $notes: String!,
    $patientId: Int!,
    $startDate: DateTime!
  ) {
    createPatientBadHabit(
      createPatientBadHabitInput: {
        bad_habet_id: $badHabitId,
        notes: $notes,
        patient_id: $patientId,
        start_date: $startDate
      }
    ) {
      bad_habit_id
      id
      notes
      patient_id
      start_date
    }
  }
''';
// final Map<String, dynamic> variables = {
//   'input': {
//     'bad_habit_id': 12,
//     'notes': 'notes for badHabits', // Provide the actual value
//     'patient_id': 1,                // Provide the actual value
//     'start_date': '2002-2-2',       // Provide the actual value
//   },
// };

  static const String patientBadHabitsQuery = '''
  query PatientBadHabits(\$patient_id: Int!) {
    patientBadHabits(patient_id: \$patient_id) {
      bad_habet_id
      id
      notes
      patient_id
      start_date
      bad_habet {
        id
        name
      }
    }
  }
''';

  // final Map<String, dynamic> variables = {
  //   'patient_id': 1,
  // };
}
