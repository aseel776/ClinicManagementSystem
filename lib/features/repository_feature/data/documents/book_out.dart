class BookOutDocsGql {
  static const String selectStoredProductQuery = '''
      query SelectStoredProduct(\$id: Int!) {
        selectStoredProduct(id: \$id) {
          total_quantity
          quantity
          product_id
          product {
            id
            name
          }
          price
          id
          expiration_date
        }
      }
    ''';

  // final QueryOptions options = QueryOptions(
  //   document: gql(selectStoredProductQuery),
  //   variables: <String, dynamic>{
  //     'id': 1, // Replace with your dynamic variable
  //   },
  // );
  static const String storedProductsRowsQuery = '''
              query StoredProducts(\$itemPerPage: Int!, \$page: Int!, \$productId: Int!) {
                storedProducts(item_per_page: \$itemPerPage, page: \$page, product_id: \$productId) {
                  item_per_page
                  page
                  totalPages
                  items {
                    expiration_date
                    id
                    price
                    product_id
                    quantity
                    total_quantity
                    product {
                      id
                      name
                    }
                  }
                }
              }
            ''';

  // variables: {
  //   'itemPerPage': 10,
  //   'page': 1,
  //   'productId': 2,
  // },

  static const String createBookOutMutation = '''
  mutation CreateBookOut(\$productId: Int!, \$quantity: Int!, \$storedProductIds: [Int!]!) {
    createBookOut(
      createBookOutInput: {
        product_id: \$productId
        quantity: \$quantity
        stored_product_id: \$storedProductIds
      }
    ) {
      created_at
      id
      product_id
      quantity
      total_price
      product {
        id
        name
      }
    }
  }
''';
  // final MutationOptions options = MutationOptions(
  //   document: gql(createBookOutMutation),
  //   variables: <String, dynamic>{
  //     'productId': 1, // Replace with your dynamic variable
  //     'quantity': 31, // Replace with your dynamic variable
  //     'storedProductIds': [3, 4], // Replace with your dynamic variable
  //   },
  // );
}
