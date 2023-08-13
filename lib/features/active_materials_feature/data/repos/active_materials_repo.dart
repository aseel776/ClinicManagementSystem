import 'package:clinic_management_system/features/active_materials_feature/data/documents/cud/active_material_mutation.dart';
import 'package:clinic_management_system/features/active_materials_feature/data/documents/get/active_material_query.dart';
import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import './/core/error/failures.dart';
import '../models/active_material_model.dart';

abstract class ActiveMaterialsRepo {
  Future<Either<Failure, String>> createActiveMaterial(ActiveMaterialModel body);

  Future<Either<Failure, String>> updateActiveMaterial(ActiveMaterialModel body);

  Future<Either<Failure, String>> deleteActiveMaterial(int id);

  Future<Either<Failure, List<ActiveMaterialModel>>> getActiveMaterials();
}

class ActiveMaterialsRepoImp extends ActiveMaterialsRepo{
  final GraphQLClient gqlClient;

  ActiveMaterialsRepoImp(this.gqlClient);

  @override
  Future<Either<Failure, String>> createActiveMaterial(ActiveMaterialModel body) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(ActiveMaterialMutation.createActiveMaterials),
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
  Future<Either<Failure, String>> updateActiveMaterial(ActiveMaterialModel body) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(ActiveMaterialMutation.updateActiveMaterials),
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
  Future<Either<Failure, String>> deleteActiveMaterial(int id) async {
    final response = await gqlClient.query(
      QueryOptions(
          document: gql(ActiveMaterialMutation.deleteActiveMaterials),
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
  Future<Either<Failure, List<ActiveMaterialModel>>> getActiveMaterials() async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(ActiveMaterialsQuery.getActiveMaterials),
      ),
    );
    if (!response.hasException && response.data != null) {
      final List<String>? materials = response.data!['data']['active_materials'];
      return right(
          materials!.map((src) => ActiveMaterialModel.fromJson(src)).toList());
    } else {
      return left(ServerFailure());
    }
  }
}