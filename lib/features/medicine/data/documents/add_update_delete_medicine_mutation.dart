class MedicineMutationDocsGql {
  //this is just exmaple query
  static const addMedicine = '''
  mutation CreateMedicine(\$categoryId: Int!, \$concentration: Float!, \$name: String!, \$chemicalMaterialIds: [Int!]!) {
    createMedicine(
      createMedicineInput: {
        category_id: \$categoryId
        concentration: \$concentration
        name: \$name
        chemical_material_id: \$chemicalMaterialIds
      }
    ) {
      category_id
      concentration
      id
      name
      chemical_material_id
    }
  }
''';
  static const editMedicine = '''
    query getOrder(\$id: ID!) {
      order(id: \$id) {
        id
        deliveryFee
        total
        created_at
        store {
          id
          name
        }
        payment_type {
          name
        }
        order_items {
          product {
            name
          }
          quantity
          price_unit
          price
        }
      }
    }
  ''';

  static const deleteMedicine = '''
    query getOrder(\$id: ID!) {
      order(id: \$id) {
        id
        deliveryFee
        total
        created_at
        store {
          id
          name
        }
        payment_type {
          name
        }
        order_items {
          product {
            name
          }
          quantity
          price_unit
          price
        }
      }
    }
  ''';
}
