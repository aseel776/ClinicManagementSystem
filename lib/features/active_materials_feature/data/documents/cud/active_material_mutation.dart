class ActiveMaterialMutation{

  static const createActiveMaterials = '''
  mutation CreateChemicalMaterial (\$input: CreateChemicalMaterialInput!){
    createChemicalMaterial(
        createChemicalMaterialInput: \$input
    ) {
        id
        name
        conflicts {
            id
            name
        }
    }
  }
  ''';

  static const updateActiveMaterials = '''
  mutation UpdateChemicalMaterial (\$id: Int!, \$input: UpdateChemicalMaterialInput!) {
    updateChemicalMaterial(
        id: \$id
        updateChemicalMaterialInput: \$input
    ) {
        id
        name
        conflicts {
            id
            name
        }
    }
  }
  ''';

  static const deleteActiveMaterials = '''
  mutation RemoveChemicalMaterial (\$id: Int!){
    removeChemicalMaterial(id: \$id) {
        id
        name
    }
  }
  ''';

}