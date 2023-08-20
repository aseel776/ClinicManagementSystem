class PatientPaymentsDocsGql {
  static const String createPaymentmutation = '''
    mutation CreatePatientPayment(\$amount: Float!, \$date: String!, \$description: String!, \$patient_id: Int!) {
      createPatientPayment(
          createPatientPaymentInput: {amount: \$amount, date: \$date, description: \$description, patient_id: \$patient_id}
      ) {
          amount
          date
          description
          id
          patient_id
      }
    }
  ''';

  //   final MutationOptions options = MutationOptions(
  //   document: gql(mutation),
  //   variables: <String, dynamic>{
  //     'amount': 100,
  //     'date': '2023-8-16',
  //     'description': 'blablabla',
  //     'patient_id': 1,
  //   },
  // );

  static const String getPatientPaymentsQuery = '''
      query PatientPayments(
        \$itemPerPage: Float!,
        \$page: Float!,
        \$patientId: Int!,
        \$sortField: String!,
        \$sortOrder: String!,
      ) {
        patientPayments(
          item_per_page: \$itemPerPage,
          page: \$page,
          patient_id: \$patientId,
          sort: { field: \$sortField, order: \$sortOrder }
        ) {
          item_per_page
          page
          totalPages
          items {
            amount
            date
            description
            id
            patient_id
          }
        }
      }
    ''';

  // variables: {
  //         'itemPerPage': itemPerPage,
  //         'page': page,
  //         'patientId': patientId,
  //         'sortField': sortField,
  //         'sortOrder': sortOrder,
  //       },
  // );
}
