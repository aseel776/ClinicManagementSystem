class MedicineMutationDocsGql {
  //this is just exmaple query
  static const addMedicine = '''
      mutation CreateMedicine(\$createMedicineInput: CreateMedicineInput!) {
        createMedicine(createMedicineInput: \$createMedicineInput) {
          category_id
          concentration
          id
          name
        }
      }
    ''';

  //    variables: {
  //   'createMedicineInput': {
  //     'category_id': categoryId,
  //     'chemical_material_id': chemicalMaterialIds,
  //     'concentration': concentration,
  //     'name': name,
  //   },
  // },

  static const editMedicine = '''
      mutation UpdateMedicine(
        \$id: Float!,
        \$updateMedicineInput: UpdateMedicineInput!
      ) {
        updateMedicine(
          id: \$id,
          updateMedicineInput: \$updateMedicineInput
        ) {
          category_id
          concentration
          id
          name
        }
      }
    ''';
  //    variables: {
  //   'id': medicineId,
  //   'updateMedicineInput': {
  //     'category_id': categoryId,
  //     'chemical_material_id': chemicalMaterialIds,
  //     'concentration': concentration,
  //     'name': name,
  //   },
  // },

  static const deleteMedicine = '''
      mutation RemoveMedicine(\$id: Int!) {
        removeMedicine(id: \$id) {
          category_id
          concentration
          id
          name
        }
      }
    ''';
}
