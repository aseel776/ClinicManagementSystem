import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import './/core/error/failures.dart';
import '../models/treatment_model.dart';
import '..//documents/get/treatment_query.dart';
import '..//documents/cud/treatment_mutation.dart';

abstract class TreatmentRepo {
  Future<Either<Failure, TreatmentModel>> getTreatment(int id);
  Future<Either<Failure, String>> updateTreatment(TreatmentModel body);
}

class TreatmentRepoImp extends TreatmentRepo {
  final GraphQLClient gqlClient;

  TreatmentRepoImp(this.gqlClient);

  @override
  Future<Either<Failure, TreatmentModel>> getTreatment(int id) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(TreatmentsQuery.getTreatment),
        variables: {
          'id': id,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    if (!response.hasException && response.data != null) {
      print('success from get');
      Map<String, dynamic> treatment = response.data!['treatment'];
      return right(TreatmentModel.fromJson(treatment));
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> updateTreatment(TreatmentModel body) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(TreatmentMutation.updateTreatment),
        variables: {
          'id': body.id,
          'updateTreatmentInput': body.toJson(),
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