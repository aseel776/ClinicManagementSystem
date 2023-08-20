class ProblemTypeMutation {
  static const createType = '''
  mutation CreateProblemType (\$createProblemTypeInput: CreateProblemTypeInput!){
    createProblemType(createProblemTypeInput: \$createProblemTypeInput) {
        id
        name
    }
  }
  ''';

  static const updateType = '''
  mutation UpdateProblemType (\$id: Int!, \$updateProblemTypeInput: UpdateProblemTypeInput!){
    updateProblemType(
      id: \$id, 
      updateProblemTypeInput: \$updateProblemTypeInput
      ) {
        id
        name
    }
  }
  ''';

  static const deleteType = '''
  mutation RemoveProblemType (\$id: Int!){
    removeProblemType(id: \$id) {
        name
        id
    }
  }
  ''';
}