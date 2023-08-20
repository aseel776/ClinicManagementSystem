class Diseases {
  static const query = '''
                query Diseases(\$itemPerPage: Float!, \$page: Float!) {
                  diseases(item_per_page: \$itemPerPage, page: \$page) {
                    page
                    item_per_page
                    totalPages
                    items {
                      id
                      name
                    }
                  }
                }
              ''';

  static const String diseasesSearchQuery = '''
  query Diseases(\$search: String!, \$itemPerPage: Float!, \$page: Float!) {
    diseases(search: \$search, item_per_page: \$itemPerPage, page: \$page) {
      item_per_page
      page
      totalPages
      items {
        id
        name
      }
    }
  }
''';

}
