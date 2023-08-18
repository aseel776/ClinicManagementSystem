import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import './/core/error/failures.dart';
import '../models/treatment_type_model.dart';
import '../documents/get/treatment_type_query.dart';
import '../documents/cud/treatment_type_mutation.dart';

abstract class TreatmentTypesRepo {

  Future<Either<Failure, TreatmentTypeModel>> createTreatmentType(TreatmentTypeModel body);

  Future<Either<Failure, String>> updateTreatmentType(TreatmentTypeModel body);

  Future<Either<Failure, String>> deleteTreatmentType(int id);

  Future<Either<Failure, List<TreatmentTypeModel>>> getTreatmentTypes();

}

class TreatmentTypesRepoImp extends TreatmentTypesRepo{
  final GraphQLClient gqlClient;

  TreatmentTypesRepoImp(this.gqlClient);

  @override
  Future<Either<Failure, TreatmentTypeModel>> createTreatmentType(TreatmentTypeModel body) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(TreatmentTypeMutation.createTreatmentType),
        variables: {
          'createTreatmentTypeInput': {
            'name': body.name,
          }
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    if (!response.hasException && response.data != null) {
      print('success from creation');
      Map<String, dynamic> src = response.data!['createTreatmentType'];
      return right(TreatmentTypeModel.fromJson(src));
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> updateTreatmentType(TreatmentTypeModel body) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(TreatmentTypeMutation.updateTreatmentType),
        variables: {
          'id': body.id,
          'updateTreatmentTypeInput' : {
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
  Future<Either<Failure, String>> deleteTreatmentType(int id) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(TreatmentTypeMutation.deleteTreatmentType),
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
  Future<Either<Failure, List<TreatmentTypeModel>>> getTreatmentTypes() async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(TreatmentTypesQuery.getTreatmentTypes),
      ),
    );
    if (!response.hasException && response.data != null) {
      final List<Map<String, dynamic>>? treatmentsDate = response.data!['data']['treatmentTypes'];
      return right(treatmentsDate!.map((src) => TreatmentTypeModel.fromJson(src)).toList());
    } else {
      return left(ServerFailure());
    }
  }
}