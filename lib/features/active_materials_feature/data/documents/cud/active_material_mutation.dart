class ActiveMaterialMutation{

  static const createActiveMaterials = '''
  mutation CreateChemicalMaterial (\$createChemicalMaterialInput: CreateChemicalMaterialInput!){
    createChemicalMaterial(
        createChemicalMaterialInput: \$createChemicalMaterialInput
    ) {
        id
        name
    }
  }
  ''';

  static const updateActiveMaterials = '''
  mutation UpdateChemicalMaterial (\$id: Int!, \$updateChemicalMaterialInput: UpdateChemicalMaterialInput!) {
    updateChemicalMaterial(
        id: \$id
        updateChemicalMaterialInput: \$updateChemicalMaterialInput
    ) {
        id
        name
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