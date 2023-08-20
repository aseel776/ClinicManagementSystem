class DiseasesCrudDocsGql {
  static final addDiseases = '''
  mutation CreateDisease(\$chemicalMaterialIds: [Int!], \$diseaseName: String!) {
    createDisease(
      createDiseaseInput: { chemical_material_id: \$chemicalMaterialIds, name: \$diseaseName }
    ) {
      id
      name
    }
  }
''';
  static final deleteDiseases = '''mutation RemoveDisease(\$id: Int!) {
    removeDisease(id: \$id) {
        id
        name
    }
}''';

  static const String updateDiseaseMutation = '''
    mutation UpdateDisease(\$id: Int!, \$chemicalMaterialIds: [Int!]!, \$name: String!) {
      updateDisease(id: \$id, updateDiseaseInput: {chemical_material_id: \$chemicalMaterialIds, name: \$name}) {
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
