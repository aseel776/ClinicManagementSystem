import 'package:clinic_management_system/core/error/failures.dart';
import 'package:clinic_management_system/features/repository_feature/data/models/book_in_table.dart';
import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

import '../documents/book_in.dart';
import '../models/book_in.dart';

abstract class BookInsRepository {
  Future<Either<Failure, BookInTable>> getPaginatedBookIns(
      double itemPerPage, double page, int product_id);

  Future<Either<Failure, String>> createBookIn(BookIn bookIn);
}

class ProductRepositoryImpl implements BookInsRepository {
  final GraphQLClient gqlClient;

  ProductRepositoryImpl(this.gqlClient);

  @override
  Future<Either<Failure, BookInTable>> getPaginatedBookIns(
      double itemPerPage, double page, int product_id) async {
    final response = await gqlClient.query(QueryOptions(
      fetchPolicy: FetchPolicy.noCache,
      document: gql(BookInDocsGql.bookInsQuery),
      variables: {'itemPerPage': itemPerPage, 'page': page},
    ));
    print(response);

    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data = response.data!['bookIns'];
      final List<dynamic> items = data['items'];
      var totalPage = data['totalPages'];

      List<BookIn> list = items.map((json) => BookIn.fromJson(json)).toList();
      BookInTable bookIns = BookInTable(bookIns: list, totalPages: totalPage);
      return right(bookIns);
    } else {
      print('GraphQL Error: ${response.exception}');
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> createBookIn(BookIn bookIn) async {
    final dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    if (bookIn.expirationDate != null) {
      final response = await gqlClient.mutate(MutationOptions(
          document: gql(BookInDocsGql.createBookInMutation),
          variables: {
            'expirationDate': dateFormat.format(
                bookIn.expirationDate!), // Replace with your dynamic variable
            'price': bookIn.price, // Replace with your dynamic variable
            'productId':
                bookIn.product.id, // Replace with your dynamic variable
            'quantity': bookIn.quantity,
          }));

      if (!response.hasException && response.data != null) {
        return right(""); // Return a success message or ID if applicable
      } else {
        return left(ServerFailure());
      }
    } else {
      return left(ServerFailure());
    }
  }
}