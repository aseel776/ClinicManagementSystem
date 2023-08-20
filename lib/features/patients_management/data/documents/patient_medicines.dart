class PatientMedicineDocsGql {
  static const String createPatientMedicineMutation = r'''
  mutation CreatePatientMedicine(
    $medicine_id: Int!,
    $notes: String!,
    $patient_id: Int!,
    $start_date: String!
  ) {
    createPatientMedicine(
      createPatientMedicineInput: {
        medicine_id: $medicine_id,
        notes: $notes,
        patient_id: $patient_id,
        start_date: $start_date
      }
    ) {
      id
      medicine {
        category_id
        concentration
        id
        name
      }
      notes
      patient_id
      start_date
    }
  }
''';

// final MutationOptions mutationOptions = MutationOptions(
//   document: gql(createPatientMedicineMutation),
//   variables: <String, dynamic>{
//     'medicine_id': 5,             // Replace with your actual medicine_id
//     'notes': 'notes for medicine2',
//     'patient_id': 1,              // Replace with your actual patient_id
//     'start_date': '2022-2-2',
//   },
// );

  static const String patientMedicinesQuery = r'''
  query PatientMedicines($patient_id: Int!) {
    patientMedicines(patient_id: $patient_id) {
      id
      medicine_id
      notes
      patient_id
      start_date
      medicine {
        category_id
        concentration
        id
        name
      }
    }
  }
''';

// final QueryOptions queryOptions = QueryOptions(
//   document: gql(patientMedicinesQuery),
//   variables: <String, dynamic>{
//     'patient_id': 1,  // Replace with your actual patient_id
//   },
// );
}
