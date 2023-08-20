import 'package:clinic_management_system/core/error/failures.dart';
import 'package:clinic_management_system/features/lab_feature/data/documents/lab.dart';

import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../models/lab_model.dart';
import '../models/lab_table_model.dart';

abstract class LabRepository {
  Future<Either<Failure, LabTable>> getPaginatedLabs(
      double itemPerPage, double page);
  Future<Either<Failure, LabTable>> getPaginatedSearchLabs(
      double itemPerPage, double page, String search);
  Future<Either<Failure, String>> addNewLab(Lab body);
  Future<Either<Failure, String>> editLab(Lab body);
  Future<Either<Failure, String>> deleteLab(Lab body);
}

class LabRepositoryImpl implements LabRepository {
  final GraphQLClient gqlClient;

  LabRepositoryImpl(this.gqlClient);

  @override
  Future<Either<Failure, LabTable>> getPaginatedLabs(
      double itemPerPage, double page) async {
    final response = await gqlClient.query(QueryOptions(
      fetchPolicy: FetchPolicy.noCache,
      document: gql(LabDocsGql.getLabs),
      variables: {'itemPerPage': itemPerPage, 'page': page},
    ));
    print(response);

    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data = response.data!['labs'];
      final List<dynamic> items = data['items'];
      final total = data['totalPages'];

      List<Lab> list = items.map((json) => Lab.fromJson(json)).toList();
      LabTable labsList = LabTable(labs: list, totalPages: total);

      if (labsList.labs == null || labsList.labs.isEmpty) {
        return left(ServerFailure());
      }

      return right(labsList);
    } else {
      print('GraphQL Error: ${response.exception}');
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, LabTable>> getPaginatedSearchLabs(
      double itemPerPage, double page, String search) async {
    final response = await gqlClient.query(QueryOptions(
      fetchPolicy: FetchPolicy.noCache,
      document: gql(LabDocsGql.getLabs),
      variables: {'itemPerPage': itemPerPage, 'page': page, 'search': search},
    ));
    print(response);

    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data = response.data!['labs'];
      final List<dynamic> items = data['items'];
      final total = data['totalPages'];

      List<Lab> list = items.map((json) => Lab.fromJson(json)).toList();
      LabTable labsList = LabTable(labs: list, totalPages: total);

      if (labsList.labs == null || labsList.labs.isEmpty) {
        return left(ServerFailure());
      }

      return right(labsList);
    } else {
      print('GraphQL Error: ${response.exception}');
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> addNewLab(Lab body) async {
    final response = await gqlClient.mutate(MutationOptions(
      document: gql(LabDocsGql.createLab),
      variables: {
        'address': body.address,
        'email': body.email,
        'name': body.name,
        'phone': body.phone,
      },
    ));

    if (!response.hasException && response.data != null) {
      // Note: Replace "" with the response message
      return right("");
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> editLab(Lab body) async {
    final response = await gqlClient.mutate(MutationOptions(
      document: gql(LabDocsGql.updateLab1),
      variables: {
        'id': body.id, // Replace with the actual lab ID
        // 'updateLabInput': {
          'address': body.address,
          'email': body.email,
          'name': body.name,
          'phone': body.phone,
        // },
      },
    ));
    print(response);

    if (!response.hasException && response.data != null) {
      // Note: Replace "" with the response message
      return right("");
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteLab(Lab body) async {
    final response = await gqlClient.mutate(MutationOptions(
      document: gql(LabDocsGql.deleteLab),
      variables: {"id": body.id},
    ));
    print(response);

    if (!response.hasException && response.data != null) {
      // Note: Replace "" with the response message
      return right("");
    } else {
      return left(ServerFailure());
    }
  }
}
