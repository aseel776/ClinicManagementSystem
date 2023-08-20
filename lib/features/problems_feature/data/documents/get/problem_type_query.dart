class ProblemTypeQuery {
  static const getAllProblemTypes = '''
  query ProblemType {
    problemTypes {
        id
        name
    }
  }
  ''';
}