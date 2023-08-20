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
}
