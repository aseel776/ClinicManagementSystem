import 'package:clinic_management_system/core/error/failures.dart';
import 'package:clinic_management_system/features/diseases_badHabits/data/documents/diseases_crud.dart';
import 'package:clinic_management_system/features/diseases_badHabits/data/documents/get_diseases.dart';
import 'package:clinic_management_system/features/diseases_badHabits/data/models/diseases_table.dart';

import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../models/diseases.dart';

abstract class DiseaseRepository {
  Future<Either<Failure, String>> addNewDisease(Disease body);
  Future<Either<Failure, String>> editDisease(Disease body);
  Future<Either<Failure, String>> deleteDisease(Disease body);
  Future<Either<Failure, List<Disease>>> getDiseases();
  Future<Either<Failure, DiseasesTable>> getPaginatedDiseases(
      double itemPerPage, double page);
  Future<Either<Failure, DiseasesTable>> getPaginatedSearchDiseases(
      double itemPerPage, double page, String searchText);
}

class DiseaseRepositoryImpl implements DiseaseRepository {
  final GraphQLClient gqlClient;

  DiseaseRepositoryImpl(this.gqlClient);

  @override
  Future<Either<Failure, List<Disease>>> getDiseases() async {
    final response =
        await gqlClient.query(QueryOptions(document: gql(""), variables: {}));
    if (!response.hasException && response.data != null) {
      final List<dynamic>? diseaseData = response.data!['data']['Diseases'];
      return right(
        diseaseData!.map((json) => Disease.fromJson(json)).toList(),
      );
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, DiseasesTable>> getPaginatedDiseases(
      double itemPerPage, double page) async {
    final response = await gqlClient.query(QueryOptions(
      document: gql(Diseases.diseasesQuery),
      fetchPolicy: FetchPolicy.noCache,
      variables: {'itemPerPage': itemPerPage, 'page': page},
    ));

    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data = response.data!['diseases'];
      final List<dynamic> items = data['items'];
      var totalPage = data['totalPages'];

      List<Disease> list = items.map((json) => Disease.fromJson(json)).toList();
      DiseasesTable diseases = DiseasesTable(diseases: list);
      diseases.totalPages = totalPage;

      return right(diseases);
    } else {
      print('GraphQL Error: ${response.exception}');
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, DiseasesTable>> getPaginatedSearchDiseases(
      double itemPerPage, double page, String searchText) async {
    final response = await gqlClient.query(QueryOptions(
      document: gql(Diseases.diseasesSearchQuery),
      fetchPolicy: FetchPolicy.noCache,
      variables: {
        'itemPerPage': itemPerPage,
        'page': page,
        'search': searchText
      },
    ));

    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data = response.data!['diseases'];
      final List<dynamic> items = data['items'];
      var totalPage = data['totalPages'];

      List<Disease> list = items.map((json) => Disease.fromJson(json)).toList();
      DiseasesTable diseases = DiseasesTable(diseases: list);
      diseases.totalPages = totalPage;

      return right(diseases);
    } else {
      print('GraphQL Error: ${response.exception}');
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteDisease(Disease body) async {
    final response = await gqlClient.query(QueryOptions(
        document: gql(DiseasesCrudDocsGql.deleteDiseases),
        variables: {'id': body.id}));
    print(response);
    if (!response.hasException && response.data != null) {
      // Note: Replace "" with the response message
      return right("");
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> addNewDisease(Disease body) async {
    final response = await gqlClient.mutate(MutationOptions(
        document: gql(DiseasesCrudDocsGql.addDiseases),
        variables: body.toJson()));
    print(response);
    if (!response.hasException && response.data != null) {
      return right("");
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> editDisease(Disease body) async {
    List ids = [];
    if (body.antiMaterials != null) {
      ids = body.antiMaterials!.map((e) => e.id).toList();
    }
    print("idssss");
    print(ids.toString());
    final response = await gqlClient.mutate(MutationOptions(
      document: gql(DiseasesCrudDocsGql.updateDiseaseMutation),
      variables: {
        'id': body.id,
        'chemicalMaterialIds': ids,
        'name': body.name,
      },
    ));
    print(response);

    if (!response.hasException && response.data != null) {
      return right("");
    } else {
      return left(ServerFailure());
    }
  }
}
