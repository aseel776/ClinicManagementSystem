class BadHabitsDocsGql {
  static const query = '''
      query BadHabits(\$itemPerPage: Float!, \$page: Float!) {
        badHabits(item_per_page: \$itemPerPage, page: \$page) {
          items {
            id
            name
          }
          totalPages
        }
      }
    ''';
}
