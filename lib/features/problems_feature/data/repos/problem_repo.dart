import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import './/core/error/failures.dart';
import '../models/problem_model.dart';
import '..//documents/get/problem_query.dart';
import '..//documents/cud/problem_mutation.dart';

abstract class ProblemRepo {
  Future<Either<Failure, ProblemModel>> getProblem(int id);

  Future<Either<Failure, String>> updateProblem(ProblemModel body);
}

class ProblemRepoImp extends ProblemRepo {
  final GraphQLClient gqlClient;

  ProblemRepoImp(this.gqlClient);

  @override
  Future<Either<Failure, ProblemModel>> getProblem(int id) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(ProblemQuery.getProblem),
        variables: {
          'id': id,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    if (!response.hasException && response.data != null) {
      print('success from get');
      Map<String, dynamic> problem = response.data!['problem'];
      return right(ProblemModel.fromJson(problem));
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> updateProblem(ProblemModel body) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(ProblemMutation.updateProblem),
        variables: {
          'id': body.id,
          'updateProblemInput': body.toJson(),
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    if (!response.hasException && response.data != null) {
      print('success from update');
      return right("Updated Successfully");
    } else {
      return left(ServerFailure());
    }
  }
}