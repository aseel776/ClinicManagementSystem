import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/error/failures.dart';
import '../models/treatment_type_model.dart';
import '../documents/get/treatment_type_query.dart';
import '../documents/cud/treatment_type_mutation.dart';

abstract class TreatmentTypesRepo {

  Future<Either<Failure, String>> createTreatmentType(TreatmentTypeModel body);

  Future<Either<Failure, String>> updateTreatmentType(TreatmentTypeModel body);

  Future<Either<Failure, String>> deleteTreatmentType(int id);

  Future<Either<Failure, List<TreatmentTypeModel>>> getTreatmentTypes();

}

class TreatmentTypesRepoImp extends TreatmentTypesRepo{
  final GraphQLClient gqlClient;

  TreatmentTypesRepoImp(this.gqlClient);

  @override
  Future<Either<Failure, String>> createTreatmentType(TreatmentTypeModel body) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(TreatmentTypeMutation.createTreatmentType),
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
  Future<Either<Failure, String>> updateTreatmentType(TreatmentTypeModel body) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(TreatmentTypeMutation.updateTreatmentType),
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
  Future<Either<Failure, String>> deleteTreatmentType(int id) async {
    final response = await gqlClient.query(
      QueryOptions(
          document: gql(TreatmentTypeMutation.deleteTreatmentType),
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
  Future<Either<Failure, List<TreatmentTypeModel>>> getTreatmentTypes() async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(TreatmentTypesQuery.getTreatmentTypes),
      ),
    );
    if (!response.hasException && response.data != null) {
      final List<String>? treatmentsDate = response.data!['data']['treatment_types'];
      return right(
          treatmentsDate!.map((src) => TreatmentTypeModel.fromJson(src)).toList());
    } else {
      return left(ServerFailure());
    }
  }
}