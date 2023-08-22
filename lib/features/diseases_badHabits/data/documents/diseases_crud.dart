class DiseasesCrudDocsGql {
  static const addDiseases = """
  mutation CreateDisease(\$chemicalMaterialIds: [Int!], \$name: String!) {
    createDisease(
        createDiseaseInput: {chemical_material_id: \$chemicalMaterialIds, name: \$name}
    ) {
        id
        name
        diseaseChemicalMaterials {
            chemical_material_id
            disease_id
            id
            chemical_material {
                id
                name
            }
        }
    }
  }
""";
  static const deleteDiseases = '''mutation RemoveDisease(\$id: Int!) {
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
