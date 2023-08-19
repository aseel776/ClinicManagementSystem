import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import './/core/error/failures.dart';
import '../models/problem_type_model.dart';
import '../documents/get/problem_type_query.dart';
import '../documents/cud/problem_type_mutation.dart';

abstract class ProblemTypesRepo {
  Future<Either<Failure, String>> createProblemType(String name);

  Future<Either<Failure, String>> updateProblemType(ProblemTypeModel body);

  Future<Either<Failure, String>> deleteProblemType(int id);

  Future<Either<Failure, List<ProblemTypeModel>>> getProblemTypes();
}

class ProblemTypesRepoImp extends ProblemTypesRepo {
  final GraphQLClient gqlClient;

  ProblemTypesRepoImp(this.gqlClient);

  @override
  Future<Either<Failure, String>> createProblemType(
      String name) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(ProblemTypeMutation.createType),
        variables: {
          'createProblemTypeInput': {
            'name': name,
          },
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    if (!response.hasException && response.data != null) {
      print('success from creation');
      return right('Created Successfully');
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> updateProblemType(
      ProblemTypeModel body) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(ProblemTypeMutation.updateType),
        variables: {
          'id': body.id,
          'updateProblemTypeInput': {
            'name': body.name,
          },
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    if (!response.hasException && response.data != null) {
      return right("Updated Successfully.");
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteProblemType(int id) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(ProblemTypeMutation.deleteType),
        variables: {
          'id': id,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    if (!response.hasException && response.data != null) {
      print('success from delete');
      return right("Deleted Successfully.");
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ProblemTypeModel>>> getProblemTypes() async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(ProblemTypeQuery.getAllProblemTypes),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    if (!response.hasException && response.data != null) {
      final List<dynamic>? types = response.data!['problemTypes'];
      return right(types!.map((src) => ProblemTypeModel.fromJson(src)).toList());
    } else {
      return left(ServerFailure());
    }
  }
}