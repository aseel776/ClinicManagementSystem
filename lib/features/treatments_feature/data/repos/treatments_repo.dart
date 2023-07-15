import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../core/error/failures.dart';
import '..//documents/cud/treatment_mutation.dart';
import '..//documents/get/treatment_query.dart';
import '../models/treatment_model.dart';

abstract class TreatmentsRepo {
  Future<Either<Failure, String>> createTreatment(TreatmentModel body);

  Future<Either<Failure, String>> updateTreatment(TreatmentModel body);

  Future<Either<Failure, String>> deleteTreatment(int id);

  Future<Either<Failure, List<TreatmentModel>>> getTreatments();
}

class TreatmentsRepoImp extends TreatmentsRepo {
  final GraphQLClient gqlClient;

  TreatmentsRepoImp(this.gqlClient);

  @override
  Future<Either<Failure, String>> createTreatment(TreatmentModel body) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(TreatmentMutation.createTreatment),
      ),
    );
    if (!response.hasException && response.data != null) {
      //note: replace "" with the response message
      return right("");
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> updateTreatment(TreatmentModel body) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(TreatmentMutation.updateTreatment),
        variables: {'id': body.id},
      ),
    );
    if (!response.hasException && response.data != null) {
      //note: replace "" with the response message
      return right("");
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteTreatment(int id) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(TreatmentMutation.deleteTreatment),
        variables: {'id': id}
      ),
    );
    if (!response.hasException && response.data != null) {
      //note: replace "" with the response message
      return right("");
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<TreatmentModel>>> getTreatments() async {
    final response = await gqlClient.query(
      QueryOptions(
          document: gql(TreatmentsQuery.getTreatments),
      ),
    );
    if (!response.hasException && response.data != null) {
      final List<String>? treatmentsDate = response.data!['data']['treatments'];
      return right(
          treatmentsDate!.map((src) => TreatmentModel.fromJson(src)).toList());
    } else {
      return left(ServerFailure());
    }
  }
}