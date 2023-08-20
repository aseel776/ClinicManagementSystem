import 'package:clinic_management_system/core/error/failures.dart';
import 'package:clinic_management_system/features/medicine/data/documents/add_update_delete_active_materials_mutation.dart';
import 'package:clinic_management_system/features/medicine/data/documents/get_active_materials_query.dart';
import 'package:clinic_management_system/features/medicine/data/model/active_materials.dart';
import 'package:dartz/dartz.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

abstract class ActiveMaterialsRespository {
  Future<Either<Failure, String>> addNewMaterial(ActiveMaterials body);
  Future<Either<Failure, String>> editMaterial(ActiveMaterials body);
  Future<Either<Failure, String>> deleteMaterial(int orderId);
  Future<Either<Failure, List<ActiveMaterials>>> getMaterials();
}

class ActiveMaterialsRespositoryImpl implements ActiveMaterialsRespository {
  final GraphQLClient gqlClient;

  ActiveMaterialsRespositoryImpl(this.gqlClient);

  @override
  Future<Either<Failure, List<ActiveMaterials>>> getMaterials() async {
    final response = await gqlClient.query(QueryOptions(
      document: gql(ActiveMaterialDocsGql.getActiveMaterials),
    ));
  
    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data = response.data!['chemicalMaterials'];
      final List<dynamic> items = data['items'];
      final totalPag = data['totalPages'];

      List<ActiveMaterials> materials =
          items.map((json) => ActiveMaterials.fromJson(json)).toList();

      return right(materials);
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteMaterial(int orderId) async {
    final response = await gqlClient.query(QueryOptions(
        document: gql(ActiveMaterialsMutationDocsGql.deleteMaterial),
        variables: {'id': orderId}));
    if (!response.hasException && response.data != null) {
      //note: replace "" with the response message
      return right("");
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> addNewMaterial(ActiveMaterials body) async {
    final response = await gqlClient.query(QueryOptions(
        document: gql(ActiveMaterialsMutationDocsGql.addMaterial),
        variables: {'id': body.id}));
    if (!response.hasException && response.data != null) {
      //note: replace "" with the response message
      return right("");
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> editMaterial(ActiveMaterials body) async {
    final response = await gqlClient.query(QueryOptions(
        document: gql(ActiveMaterialsMutationDocsGql.editMaterial),
        variables: {'id': body.id}));
    if (!response.hasException && response.data != null) {
      //note: replace "" with the response message
      return right("");
    } else {
      return left(ServerFailure());
    }
  }
}
