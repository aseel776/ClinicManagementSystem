import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import './/core/error/failures.dart';
import '..//documents/cud/problem_mutation.dart';
import '..//documents/get/problem_query.dart';
import '../models/problem_model.dart';
import '../models/problems_page_model.dart';

abstract class ProblemsRepo {
  Future<Either<Failure, String>> createProblem(ProblemModel body);

  Future<Either<Failure, String>> deleteProblem(int id);

  Future<Either<Failure, ProblemsPageModel>> getProblems(int page, int items);
}

class ProblemsRepoImp extends ProblemsRepo {
  final GraphQLClient gqlClient;

  ProblemsRepoImp(this.gqlClient);

  @override
  Future<Either<Failure, String>> createProblem(ProblemModel body) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(ProblemMutation.createProblem),
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
  Future<Either<Failure, String>> deleteProblem(int id) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(ProblemMutation.deleteProblem),
        variables: {'id': id},
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
  Future<Either<Failure, ProblemsPageModel>> getProblems(int page,
      int items) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(ProblemQuery.getAllProblems),
        variables: {
          'item_per_page': items,
          'page': page,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    if (!response.hasException && response.data != null) {
      print('success from getProblems');
      final List<dynamic> problemsData = response.data!['problems']['items'];
      List<ProblemModel> problems = problemsData.map((src) => ProblemModel.fromJson(src)).toList();
      int currentPage = response.data!['problems']['page'];
      int totalPages = response.data!['problems']['totalPages'];
      return right(ProblemsPageModel(totalPages: totalPages,
          currentPage: currentPage,
          problems: problems));
    } else {
      return left(ServerFailure());
    }
  }
}