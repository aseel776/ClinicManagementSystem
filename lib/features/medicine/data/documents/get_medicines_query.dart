class MedicineDocsGql {
  static const getMedicines = '''
  query Medicines(\$itemPerPage: Float!, \$page: Float!) {
    medicines(item_per_page: \$itemPerPage, page: \$page) {
      item_per_page
      page
      totalPages
      items {
        category_id
        concentration
        id
        name
        category {
          id
          name
        }
      }
    }
  }
''';
}
