class BadHabitsCrudDocsGql {
  static const createBadHabitMutation = r'''
  mutation CreateBadHabit($input: CreateBadHabitInput!) {
    createBadHabit(createBadHabitInput: $input) {
      id
      name
    }
  }
''';
  static const deleteBadHabitsMutation = '''
          mutation RemoveBadHabit(\$id: Int!) {
            removeBadHabit(id: \$id) {
              id
              name
            }
          }
        ''';

  static const String updateBadHabitMutation = r'''
    mutation UpdateBadHabit($id: Int!, $chemicalMaterialIds: [Int!]!, $name: String!) {
      updateBadHabit(id: $id, updateBadHabitInput: {chemical_material_id: $chemicalMaterialIds, name: $name}) {
        id
        name
      }
    }
  ''';

  // final MutationOptions options = MutationOptions(
  //   document: gql(updateBadHabitMutation),
  //   variables: {
  //     'id': 1,
  //     'chemicalMaterialIds': [9, 10],
  //     'name': 'badHabit1Updated',
  //   },
  // );
}
