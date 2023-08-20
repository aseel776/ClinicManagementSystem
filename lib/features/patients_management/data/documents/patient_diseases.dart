class PatientDiseasesDocsGql {
  static const String createPatientDiseaseMutation = '''
  mutation CreatePatientDisease(\$input: CreatePatientDiseaseInput!) {
    createPatientDisease(createPatientDiseaseInput: \$input) {
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
