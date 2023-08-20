import 'package:clinic_management_system/core/error/failures.dart';
import 'package:clinic_management_system/features/diseases_badHabits/data/documents/get_badHabits.dart';

import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../documents/badhabits_crud.dart';
import '../models/badHabits.dart';
import '../models/badhabits_table.dart';

abstract class BadHabitRepository {
  Future<Either<Failure, String>> addNewBadHabit(BadHabit body);
  Future<Either<Failure, String>> editBadHabit(BadHabit body);
  Future<Either<Failure, String>> deleteBadHabit(BadHabit body);
  Future<Either<Failure, List<BadHabit>>> getBadHabits();
  Future<Either<Failure, BadHabitsTable>> getPaginatedBadHabits(
      double itemPerPage, double page);
  Future<Either<Failure, BadHabitsTable>> getPaginatedSearchBadHabits(
      double itemPerPage, double page, String search);
}

class BadHabitRepositoryImpl implements BadHabitRepository {
  final GraphQLClient gqlClient;

  BadHabitRepositoryImpl(this.gqlClient);

  @override
  Future<Either<Failure, List<BadHabit>>> getBadHabits() async {
    final response = await gqlClient.query(QueryOptions(
      document: gql(""),
      variables: {},
    ));

    if (!response.hasException && response.data != null) {
      final List<dynamic>? badHabitData = response.data!['data']['BadHabits'];
      return right(
        badHabitData!.map((json) => BadHabit.fromJson(json)).toList(),
      );
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, BadHabitsTable>> getPaginatedBadHabits(
      double itemPerPage, double page) async {
    final response = await gqlClient.query(QueryOptions(
      fetchPolicy: FetchPolicy.noCache,
      document: gql(BadHabitsDocsGql.badHabitsQuery),
      variables: {'itemPerPage': itemPerPage, 'page': page},
    ));

    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data = response.data!['badHabits'];
      final List<dynamic> items = data['items'];
      final total = data['totalPages'];

      List<BadHabit> list =
          items.map((json) => BadHabit.fromJson(json)).toList();
      BadHabitsTable badHabitsList =
          BadHabitsTable(badHabits: list, totalPages: total);
      print("sksssss");
      if (badHabitsList.badHabits == null || badHabitsList.badHabits!.isEmpty) {
        print("lllll");
        return left(ServerFailure());
      }

      print("lissst");
      print(badHabitsList.badHabits![0].name);
      return right(badHabitsList);
    } else {
      print('GraphQL Error: ${response.exception}');
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, BadHabitsTable>> getPaginatedSearchBadHabits(
      double itemPerPage, double page, String search) async {
    final response = await gqlClient.query(QueryOptions(
      fetchPolicy: FetchPolicy.noCache,
      document: gql(BadHabitsDocsGql.badHabitsSearchQuery),
      variables: {'itemPerPage': itemPerPage, 'page': page, 'search': search},
    ));

    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data = response.data!['badHabits'];
      final List<dynamic> items = data['items'];
      final total = data['totalPages'];

      List<BadHabit> list =
          items.map((json) => BadHabit.fromJson(json)).toList();
      BadHabitsTable badHabitsList =
          BadHabitsTable(badHabits: list, totalPages: total);
      print("sksssss");
      if (badHabitsList.badHabits == null || badHabitsList.badHabits!.isEmpty) {
        print("lllll");
        return left(ServerFailure());
      }

      print("lissst");
      print(badHabitsList.badHabits![0].name);
      return right(badHabitsList);
    } else {
      print('GraphQL Error: ${response.exception}');
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteBadHabit(BadHabit body) async {
    final response = await gqlClient.mutate(MutationOptions(
      document: gql(BadHabitsCrudDocsGql.deleteBadHabitsMutation),
      variables: {'id': body.id},
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
  Future<Either<Failure, String>> addNewBadHabit(BadHabit body) async {
    final response = await gqlClient.mutate(MutationOptions(
      document: gql(BadHabitsCrudDocsGql.createBadHabitMutation),
      variables: {"input": body.toJson()},
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
  Future<Either<Failure, String>> editBadHabit(BadHabit body) async {
    List ids = [];
    if (body.antiMaterials != null) {
      ids = body.antiMaterials!.map((e) => e.id).toList();
    }
    final response = await gqlClient.query(QueryOptions(
      document: gql(BadHabitsCrudDocsGql.updateBadHabitMutation),
      variables: {
        'id': body.id,
        'chemicalMaterialIds': ids,
        'name': body.name,
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
}
