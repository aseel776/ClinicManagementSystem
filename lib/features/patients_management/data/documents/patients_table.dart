class PatientsTableDocsGql {
  static const patientsDataTable = '''
            query Patients(\$itemPerPage: Float!, \$page: Float!) {
              patients(item_per_page: \$itemPerPage, page: \$page) {
                item_per_page
                page
                totalPages
                items {
                    gender
                    id
                    name
                    phone
                }
              }
            }
          ''';

  static const getPatientSearch =
      ''' query GetPatients(\$itemPerPage: Float!, \$page: Float!, \$search: String!) {
    patients(item_per_page: \$itemPerPage, page: \$page, search: \$search) {
      item_per_page
      page
      totalPages
      items {
        gender
        id
        job
        name
        phone
      }
    }
  }
''';
}
