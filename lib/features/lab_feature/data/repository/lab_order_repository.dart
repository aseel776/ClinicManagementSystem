import 'package:clinic_management_system/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../documents/lab_order.dart';
import '../models/lab_order.dart';

import '../models/lab_order_table.dart';

abstract class LabOrderRepository {
  Future<Either<Failure, LabOrderTable>> getPaginatedLabOrders(
      int? id, double itemPerPage, double page);
  Future<Either<Failure, LabOrderTable>> getPaginatedSearchLabOrders(
      double itemPerPage, double page, String search);
  Future<Either<Failure, String>> addLabOrder(
      LabOrder body, List<String> steps);
  Future<Either<Failure, String>> editLabOrder(
      LabOrder body, List<String> step);
  Future<Either<Failure, String>> deleteLabOrder(LabOrder body);
}

class LabOrderRepositoryImpl implements LabOrderRepository {
  final GraphQLClient gqlClient;

  LabOrderRepositoryImpl(this.gqlClient);

  @override
  Future<Either<Failure, LabOrderTable>> getPaginatedLabOrders(
      int? id, double itemPerPage, double page) async {
    final response = await gqlClient.query(QueryOptions(
      fetchPolicy: FetchPolicy.noCache,
      document: gql(LabOrderDocsGql.getLabOrders),
      variables: {'id': id, 'itemPerPage': itemPerPage, 'page': page},
    ));
    print(response);

    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data = response.data!['labOrders'];
      final List<dynamic> items = data['items'];
      final total = data['totalPages'];

      List<LabOrder> list =
          items.map((json) => LabOrder.fromJson(json)).toList();
      LabOrderTable labOrdersList =
          LabOrderTable(labOrders: list, totalPages: total);

      if (labOrdersList.labOrders.isEmpty) {
        return left(ServerFailure());
      }

      return right(labOrdersList);
    } else {
      print('GraphQL Error: ${response.exception}');
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, LabOrderTable>> getPaginatedSearchLabOrders(
      double itemPerPage, double page, String search) async {
    final response = await gqlClient.query(QueryOptions(
      fetchPolicy: FetchPolicy.noCache,
      document: gql(LabOrderDocsGql.getLabOrders),
      variables: {'itemPerPage': itemPerPage, 'page': page, 'search': search},
    ));

    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data = response.data!['labOrders'];
      final List<dynamic> items = data['items'];
      final total = data['totalPages'];

      List<LabOrder> list =
          items.map((json) => LabOrder.fromJson(json)).toList();
      LabOrderTable labOrdersList =
          LabOrderTable(labOrders: list, totalPages: total);

      if (labOrdersList.labOrders == null || labOrdersList.labOrders.isEmpty) {
        return left(ServerFailure());
      }

      return right(labOrdersList);
    } else {
      print('GraphQL Error: ${response.exception}');
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> addLabOrder(
      LabOrder body, List<String> steps) async {
    final response = await gqlClient.mutate(MutationOptions(
      document: gql(LabOrderDocsGql.createLabOrder),
      variables: {
        'lab_id': body.labId,
        'name': body.name,
        'steps_names': steps,
      },
    ));

    if (!response.hasException && response.data != null) {
      return right("Lab order added successfully");
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> editLabOrder(
      LabOrder body, List<String> step) async {
    print("edddiiiit");
    print(body.id.toString());
    final response = await gqlClient.mutate(MutationOptions(
      document: gql(LabOrderDocsGql.updateLabOrderMutation),
      variables: {
        'id': body.id,
        'updateLabOrderInput': {
          'lab_id': body.labId,
          'name': body.name,
          'price': body.price.toString(),
          'steps_names': step,
        },
      },
    ));
    print(response);

    if (!response.hasException && response.data != null) {
      return right("Lab order updated successfully");
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteLabOrder(LabOrder body) async {
    final response = await gqlClient.mutate(MutationOptions(
      document: gql(LabOrderDocsGql.deleteLabOrder),
      variables: {"id": body.id},
    ));

    if (!response.hasException && response.data != null) {
      return right("Lab order deleted successfully");
    } else {
      return left(ServerFailure());
    }
  }
}
