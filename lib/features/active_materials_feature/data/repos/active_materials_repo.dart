import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import './/core/error/failures.dart';
import '../models/active_material_model.dart';
import '../models/materials_pagination_model.dart';
import '../documents/get/active_material_query.dart';
import '../documents/cud/active_material_mutation.dart';

abstract class ActiveMaterialsRepo {
  Future<Either<Failure, String>> createActiveMaterial(ActiveMaterialModel body);
  Future<Either<Failure, String>> deleteActiveMaterial(int id);
  Future<Either<Failure, MaterialsPaginationModel>> getActiveMaterials(int page);
}

class ActiveMaterialsRepoImp extends ActiveMaterialsRepo {
  final GraphQLClient gqlClient;

  ActiveMaterialsRepoImp(this.gqlClient);

  @override
  Future<Either<Failure, String>> createActiveMaterial(ActiveMaterialModel body) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(ActiveMaterialMutation.createActiveMaterials),
        variables: {
          'createChemicalMaterialInput': {
            'name': body.name,
            'chemical_material_id': body.antiMaterials!.map((m) => m.id).toList(),
          },
        },
      ),
    );
    if (!response.hasException && response.data != null) {
      print('success from creation');
      return right("Created Successfully.");
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteActiveMaterial(int id) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(ActiveMaterialMutation.deleteActiveMaterials),
        variables: {'id': id},
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
  Future<Either<Failure, MaterialsPaginationModel>> getActiveMaterials(int page, {int? items}) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(ActiveMaterialsQuery.getActiveMaterials),
        variables: {
          'item_per_page': items?? 15,
          'page': page,
        },
      ),
    );

    if (!response.hasException && response.data != null) {
      print('success from get active materials');
      Map<String, dynamic> data = response.data!['chemicalMaterials'];

      int page = data['page'];
      int totalPages = data['totalPages'];
      List<dynamic> temp = data['items'];
      List<ActiveMaterialModel> materials =
          temp.map((src) => ActiveMaterialModel.fromJson(src)).toList();

      final paginationModel = MaterialsPaginationModel(
        materials: materials,
        currentPage: page,
        totalPages: totalPages,
      );
      return right(paginationModel);
    } else {
      return left(ServerFailure());
    }
  }
}