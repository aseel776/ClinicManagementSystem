class PatientCostsDocsGql {
  static const String createCosts = '''
      mutation CreatePatientCost(\$input: CreatePatientCostInput!) {
        createPatientCost(createPatientCostInput: \$input) {
          amount
          date
          description
          id
          patient_id
          treatment_id
        }
      }
    ''';
  //   variables: <String, dynamic>{
  //   'input': {
  //     'amount': amount,
  //     'date': date,
  //     'description': description,
  //     'patient_id': patientId,
  //     'treatment_id': treatmentId,
  //   },
  // },

  //       variables: <String, dynamic>{
  //   'amount': 100,
  //   'date': '2023-08-16',
  //   'description': 'blablabla',
  //   'patient_id': 1,
  //   'treatment_id': 2,
  // },

  static const getPatientCostsQuery = '''
    query GetPatientCosts(
      \$itemPerPage: Float!
      \$page: Float!
      \$patientId: Int!
      \$sortField: String!
      \$sortOrder: String!
    ) {
      patientCosts(
        item_per_page: \$itemPerPage
        page: \$page
        patient_id: \$patientId
        sort: {field: \$sortField, order: \$sortOrder}
      ) {
        item_per_page
        page
        totalPages
         meta {
            total
           }
        items {
          amount
          date
          id
          patient_id
          treatment {
            id
            name
            treatment_type_id
            color
          }
        }
      }
    }
  ''';
}
