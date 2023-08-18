class ProblemQuery {
  static const getAllProblems = '''
  query Problems ('\$item_per_page: Float, \$page: Float){
    problems(
      item_per_page: \$item_per_page, 
      page: \$page
      ) {
        item_per_page: 
        page
        totalPages
        items {
            id
            name
            Problem_type {
                id
                name
            }
        }
    }
  }
  ''';

  static const getProblem = '''
  query Problem (\$id: Int!){
    problem(id: \$id) {
        id
        name
        Problem_type {
            id
            name
        }
    }
  }
  ''';
}