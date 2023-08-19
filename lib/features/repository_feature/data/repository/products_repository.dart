import 'package:clinic_management_system/core/error/failures.dart';

import 'package:clinic_management_system/features/repository_feature/data/documents/products.dart';
import 'package:clinic_management_system/features/repository_feature/data/models/products_table.dart';
import 'package:clinic_management_system/features/repository_feature/data/models/stored_product.dart';
import 'package:clinic_management_system/features/repository_feature/data/models/stored_products_table.dart';

import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../documents/book_out.dart';
import '../models/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, ProductsTable>> getPaginatedProducts(
      double itemPerPage, double page);
  Future<Either<Failure, StoredProductsTable>> getPaginatedStoredProducts(
      double itemPerPage, double page);
  Future<Either<Failure, String>> addNewProduct(Product body);
  Future<Either<Failure, String>> editProduct(Product body);
  Future<Either<Failure, String>> deleteProduct(Product body);
}

class ProductRepositoryImpl implements ProductRepository {
  final GraphQLClient gqlClient;

  ProductRepositoryImpl(this.gqlClient);

  @override
  Future<Either<Failure, ProductsTable>> getPaginatedProducts(
      double itemPerPage, double page) async {
    final response = await gqlClient.query(QueryOptions(
      fetchPolicy: FetchPolicy.noCache,
      document: gql(ProductDocsGql.productsQuery),
      variables: {'itemPerPage': itemPerPage, 'page': page},
    ));
    print(response);

    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data = response.data!['products'];
      final List<dynamic> items = data['items'];
      var totalPage = data['totalPages'];

      List<Product> list = items.map((json) => Product.fromJson(json)).toList();

      ProductsTable products =
          ProductsTable(products: list, totalPages: totalPage);
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
  Future<Either<Failure, StoredProductsTable>> getPaginatedStoredProducts(
      double itemPerPage, double page) async {
    final response = await gqlClient.query(QueryOptions(
      fetchPolicy: FetchPolicy.noCache,
      document: gql(ProductDocsGql.getStoredProducts),
      variables: {'itemPerPage': itemPerPage, 'page': page},
    ));
    print("kkkkkkkkkkkkkkkkkkkkkkkkkkkk");
    print(response);

    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data = response.data!['getProducts'];
      final List<dynamic> items = data['items'];
      var totalPage = data['totalPages'];

      List<StoredProduct> list =
          items.map((json) => StoredProduct.fromJson(json)).toList();
      StoredProductsTable products =
          StoredProductsTable(products: list, totalPages: totalPage);
      if (products.products == null || products.products!.isEmpty) {
        print("lllll");
        return left(EmptyCacheFailure());
      }

      // products.totalPages = totalPage;

      return right(products);
    } else {
      print('GraphQL Error: ${response.exception}');
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> addNewProduct(Product body) async {
    final response = await gqlClient.mutate(MutationOptions(
        document: gql(ProductDocsGql.createProductMutation),
        variables: {
          'name': body.name,
        }));
    print(response);
    if (!response.hasException && response.data != null) {
      return right("");
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> editProduct(Product body) async {
    final response = await gqlClient.mutate(MutationOptions(
        document: gql(ProductDocsGql.updateProductMutation),
        variables: body.toJson()));
    if (!response.hasException && response.data != null) {
      return right("");
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteProduct(Product body) async {
    final response = await gqlClient.query(QueryOptions(
        document: gql(ProductDocsGql.deleteProductMutation),
        variables: {'id': body.id}));
    print(response);
    if (!response.hasException && response.data != null) {
      return right("");
    } else {
      return left(ServerFailure());
    }
  }
}
