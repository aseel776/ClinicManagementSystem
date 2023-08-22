class BookInDocsGql {
  static const String bookInsQuery = '''
      query BookIns(\$itemPerPage: Float!, \$page: Float!) {
        bookIns(item_per_page: \$itemPerPage, page: \$page) {
          item_per_page
          page
          totalPages
          items {
            created_at
            id
            price
            product_id
            quantity
            total_price
            product {
              id
              name
            }
          }
        }
      }
    ''';

  // final QueryOptions options = QueryOptions(
  //   document: gql(bookInsQuery),
  //   variables: <String, dynamic>{
  //     'itemPerPage': 1000, // Replace with your dynamic variable
  //     'page': 1, // Replace with your dynamic variable
  //   },
  // );

  static const String createBookInMutation = '''
    mutation CreateBookIn(\$expirationDate: DateTime!, \$price: Int!, \$productId: Int!, \$quantity: Int!) {
      createBookIn(
        createBookInInput: {
          expiration_date: \$expirationDate
          price: \$price
          product_id: \$productId
          quantity: \$quantity
        }
      ) {
        created_at
        id
        price
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
  //   document: gql(createBookInMutation),
  //   variables: <String, dynamic>{
  //     'expirationDate': '2024-2-2', // Replace with your dynamic variable
  //     'price': 1000.0, // Replace with your dynamic variable
  //     'productId': 1, // Replace with your dynamic variable
  //     'quantity': 10, // Replace with your dynamic variable
  //   },
  // );
}
