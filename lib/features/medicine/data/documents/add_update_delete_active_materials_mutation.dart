class ActiveMaterialsMutationDocsGql {
  //this is just exmaple query
  static const addMaterial = '''
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
  static const editMaterial = '''
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

  static const deleteMaterial = '''
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
