class PatientDiagnosisDocsGql {
  static const String patientDiagnosesQuery = r'''
  query PatientDiagnoses($item_per_page: Float!, $page: Float!, $patient_id: Float!, $problem_type_id: Float!) {
    patientDiagnoses(item_per_page: $item_per_page, page: $page, patient_id: $patient_id, problem_type_id: $problem_type_id) {
      item_per_page
      page
      totalPages
      items {  
        expected_treatment
        id
        patient_id
        place
        problem_id
      }
    }
  }
''';

  // final String patientDiagnosesQuery = '''
  //   query PatientDiagnoses(\$problem_type_id: Int!, \$item_per_page: Int!, \$page: Int!, \$patient_id: Int!) {
  //     patientDiagnoses(problem_type_id: \$problem_type_id, item_per_page: \$item_per_page, page: \$page, patient_id: \$patient_id) {
  //       item_per_page
  //       page
  //       totalPages
  //       items {
  //         expected_treatment
  //         id
  //         patient_id
  //         place
  //         problem_id
  //       }
  //     }
  //   }
  // ''';

  static const String createPatientDiagnosisMutation = '''
    mutation CreatePatientDiagnosis(\$expected_treatment: String!, \$patient_id: Int!, \$place: String!, \$problem_id: Int!) {
      createPatientDiagnosis(
        createPatientDiagnosisInput: {
          expected_treatment: \$expected_treatment,
          patient_id: \$patient_id,
          place: \$place,
          problem_id: \$problem_id
        }
      ) {
        expected_treatment
        id
        patient_id
        place
        problem_id
      }
    }
  ''';
  static const String getProblemTypes = '''
            query ProblemTypes {
              problemTypes {
                id
                name
              }
            }
          ''';

  static const String updatePatientDiagnosisMutation = '''
    mutation UpdatePatientDiagnosis(
      \$expected_treatment: String!,
      \$id: Int!,
      \$patient_id: Int!,
      \$place: String!,
      \$problem_id: Int!
    ) {
      updatePatientDiagnosis(
        updatePatientDiagnoseInput: {
          expected_treatment: \$expected_treatment,
          id: \$id,
          patient_id: \$patient_id,
          place: \$place,
          problem_id: \$problem_id
        }
      ) {
        expected_treatment
        id
        patient_id
        place
        problem_id
      }
    }
  ''';
// variables = {
//                 'expected_treatment': 'saasf',
//                 'id': 1,
//                 'patient_id': 1,
//                 'place': 'dasfa',
//                 'problem_id': 2,
//               };

  static const String removePatientDiagnosisMutation = '''
    mutation RemovePatientDiagnosis(\$id: Int!) {
      removePatientDiagnosis(id: \$id) {
        expected_treatment
        id
        patient_id
        place
        problem_id
      }
    }
  ''';
}
