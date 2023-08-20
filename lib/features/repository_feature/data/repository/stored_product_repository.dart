import 'package:clinic_management_system/core/error/failures.dart';
import 'package:clinic_management_system/features/repository_feature/data/documents/book_out.dart';
import 'package:clinic_management_system/features/repository_feature/data/models/select_stored_product.dart';
import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../models/book_out.dart';

import '../models/select_stored_product_table.dart';
import '../models/stored_product.dart';
import '../models/stored_products_table.dart';

abstract class StoredProductRepository {
  Future<Either<Failure, SelectStoredProductsTable>> getStoredProduct(
      double itemPerPage, double page, int id);
  Future<Either<Failure, String>> createBookOut(
      int productId, int quantity, List<int> storedProductIds);
}

class StoredProductRepositoryImpl implements StoredProductRepository {
  final GraphQLClient gqlClient;

  StoredProductRepositoryImpl(this.gqlClient);

  @override
  Future<Either<Failure, SelectStoredProductsTable>> getStoredProduct(
      double itemPerPage, double page, int id) async {
    final response = await gqlClient.query(QueryOptions(
      fetchPolicy: FetchPolicy.noCache,
      document: gql(BookOutDocsGql.storedProductsRowsQuery),
      variables: {
        'itemPerPage': itemPerPage,
        'page': page,
        'productId': id,
      },
    ));
    print(response);

    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data = response.data!['storedProducts'];
      final List<dynamic> items = data['items'];
      var totalPage = data['totalPages'];

      List<SelectStoredProduct> list =
          items.map((json) => SelectStoredProduct.fromJson(json)).toList();
      SelectStoredProductsTable products =
          SelectStoredProductsTable(products: list, totalPages: totalPage);
      if (products.products == null || products.products!.isEmpty) {
        print("lllll");
        return left(EmptyCacheFailure());
      }

      return right(products);
    } else {
      print('GraphQL Error: ${response.exception}');
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> createBookOut(
      int productId, int quantity, List<int> storedProductIds) async {
    try {
      final response = await gqlClient.mutate(MutationOptions(
        document: gql(BookOutDocsGql.createBookOutMutation),
        variables: {
          'productId': productId,
          'quantity': quantity,
          'storedProductIds': storedProductIds,
        },
      ));
      print(response);

      if (response.hasException) {
        print('GraphQL Error: ${response.exception}');
        return left(ServerFailure());
      }

      // Replace with your success message from the mutation response
      return right("Book out created successfully");
    } catch (e) {
      print('Exception: $e');
      return left(ServerFailure());
    }
  }
}
