class PatientDiseasesDocsGql {
  static const String createPatientDiseaseMutation = '''
  mutation CreatePatientDisease(
    \$disease_id: Int!,
    \$notes: String!,
    \$patient_id: Int!,
  \$start_date: String!,
    \$tight: Boolean!
  ) {
    createPatientDisease(
      createPatientDiseaseInput: {
        disease_id: \$disease_id,
        notes:\$notes,
        patient_id: \$patient_id,
        start_date: \$start_date,
        tight: \$tight
      }
    ) {
      disease_id
      id
      notes
      patient_id
      start_date
      tight
    }
  }
''';

  // final MutationOptions mutationOptions = MutationOptions(
  //   document: gql(createPatientDiseaseMutation),
  //   variables: <String, dynamic>{
  //     'disease_id': 23,
  //     'notes': 'notes for diseases1',
  //     'patient_id': 1,
  //     'start_date': '2002-2-2',
  //     'tight': true,
  //   },
  // );
  static const String patientDiseasesQuery = '''
  query PatientDiseases(\$patient_id: Int!) {
    patientDiseases(patient_id: \$patient_id) {
      disease_id
      id
      notes
      patient_id
      start_date
      tight
      disease {
        id
        name
      }
    }
  }
''';

  // final QueryOptions queryOptions = QueryOptions(
  //   document: gql(patientDiseasesQuery),
  //   variables: <String, dynamic>{
  //     'patient_id': 1, // Replace with your actual patient_id
  //   },
  // );
}
