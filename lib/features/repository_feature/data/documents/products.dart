class ProductDocsGql {
  static const String productsQuery = '''
      query Products(\$itemPerPage: Int!, \$page: Int!) {
        products(item_per_page: \$itemPerPage, page: \$page) {
          item_per_page
          page
          totalPages
          items {
            id
            name
          }
        }
      }
    ''';

  // final QueryOptions options = QueryOptions(
  //   document: gql(productsQuery),
  //   variables: <String, dynamic>{
  //     'itemPerPage': 1000,
  //     'page': 1,
  //   },
  // );

  static const String getStoredProducts = '''
              query GetProducts(\$itemPerPage: Float!, \$page: Float!) {
                getProducts(item_per_page: \$itemPerPage, page: \$page) {
                  item_per_page
                  page
                  totalPages
                  items {
                    name
                    product_id
                    totalQuantity
                  }
                }
              }
            ''';

  static const String createProductMutation = '''
      mutation CreateProduct(\$name: String!) {
        createProduct(createProductInput: {name: \$name}) {
          id
          name
        }
      }
    ''';

  // final MutationOptions options = MutationOptions(
  //   document: gql(createProductMutation),
  //   variables: <String, dynamic>{
  //     'name': 'product1', // Replace with your dynamic variable
  //   },
  // );

  static const String deleteProductMutation = '''
      mutation RemoveProduct(\$id: Int!) {
        removeProduct(id: \$id) {
          id
          name
        }
      }
    ''';

  static const String updateProductMutation = '''
      mutation UpdateProduct(\$id: Int!, \$name: String!) {
        updateProduct(id: \$id, updateProductInput: { name: \$name }) {
          id
          name
        }
      }
    ''';
}
