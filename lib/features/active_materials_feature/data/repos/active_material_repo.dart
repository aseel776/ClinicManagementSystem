import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import './/core/error/failures.dart';
import '../models/active_material_model.dart';
import '../documents/get/active_material_query.dart';
import '../documents/cud/active_material_mutation.dart';

abstract class ActiveMaterialRepo {
  Future<Either<Failure, ActiveMaterialModel>> getActiveMaterial(int id);
  Future<Either<Failure, String>> updateActiveMaterial(ActiveMaterialModel body);
}

class ActiveMaterialRepoImp extends ActiveMaterialRepo {
  final GraphQLClient gqlClient;

  ActiveMaterialRepoImp(this.gqlClient);

  @override
  Future<Either<Failure, ActiveMaterialModel>> getActiveMaterial(int id) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(ActiveMaterialsQuery.getActiveMaterial),
        variables: {'id': id},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (!response.hasException && response.data != null) {
      print('success from get material');
      Map<String, dynamic> src = response.data!['chemicalMaterial'];
      return right(ActiveMaterialModel.fromJson(src));
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> updateActiveMaterial(ActiveMaterialModel body) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(ActiveMaterialMutation.updateActiveMaterials),
        variables: {
          'id': body.id,
          'updateChemicalMaterialInput': {
            'name': body.name,
            'chemical_material_id': body.antiMaterials!.map((m) => m.id).toList(),
          },
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    if (!response.hasException && response.data != null) {
      print('success from update');
      return right("Updated Successfully.");
    } else {
      return left(ServerFailure());
    }
  }
}