class ProblemMutation{
  static const createProblem = '''
  mutation CreateProblem (\$createProblemInput: CreateProblemInput!){
    createProblem(createProblemInput: \$createProblemInput) {
        id
        name
        Problem_type {
            id
            name
        }
    }
  }
  ''';

  static const updateProblem = '''
    mutation UpdateProblem (\$id: Int!, \$updateProblemInput: UpdateProblemInput!){
    updateProblem(
      id: \$id, 
      updateProblemInput: \$updateProblemInput
      ) {
        name
        problem_type_id
    }
  }
  ''';

  static const deleteProblem = '''
  mutation RemoveProblem (\$id: Int!){
    removeProblem(id: \$id) {
        name
    }
  }
  ''';
}