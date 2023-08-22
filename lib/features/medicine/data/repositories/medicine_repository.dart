import 'package:clinic_management_system/core/error/failures.dart';
import 'package:clinic_management_system/features/medicine/data/model/category.dart'
    as cat;
// import 'package:clinic_management_system/features/medicine/data/model/category.dart';
import 'package:clinic_management_system/features/medicine/data/model/medicine_table.dart';

import 'package:dartz/dartz.dart';
import 'package:clinic_management_system/features/medicine/data/model/medicine_model.dart';
import 'package:flutter/foundation.dart';
import '../documents/add_update_delete_medicine_mutation.dart';
import '../documents/get_medicines_query.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class MedicineRespository {
  Future<Either<Failure, String>> addNewMedicine(Medicine body, int? catId);
  Future<Either<Failure, String>> editMedicine(Medicine body, int catId);
  Future<Either<Failure, String>> deleteMedicine(int orderId);
  Future<Either<Failure, List<Medicine>>> getMedicine();
  Future<Either<Failure, List<cat.Category>>> getCategories();

  Future<Either<Failure, MedicinesTable>> getPaginatedMedicines(
      double itemPerPage, double page);
  Future<Either<Failure, MedicinesTable>> getSearchMedicines(
      double itemPerPage, double pagetring, String search);
}

class MedicineRespositoryImpl implements MedicineRespository {
  final GraphQLClient gqlClient;

  MedicineRespositoryImpl(this.gqlClient);

  @override
  Future<Either<Failure, List<Medicine>>> getMedicine() async {
    final response = await gqlClient.query(QueryOptions(
        document: gql(MedicineDocsGql.medicinesQuery), variables: {}));
    if (!response.hasException && response.data != null) {
      final List<dynamic>? medicineData = response.data!['data']['Medicine'];
      return right(
          medicineData!.map((json) => Medicine.fromJson(json)).toList());
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<cat.Category>>> getCategories() async {
    final response = await gqlClient.query(QueryOptions(
      fetchPolicy: FetchPolicy.noCache,
      document: gql(MedicineDocsGql.categories),
    ));
    print(response);

    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data = response.data!;
      final List<dynamic> items = data['categories'];

      List<cat.Category> categories =
          items.map((e) => cat.Category.fromJson(e)).toList();

      return right(categories);
    } else {
      print('GraphQL Error: ${response.exception}');
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, MedicinesTable>> getPaginatedMedicines(
      double itemPerPage, double page) async {
    final response = await gqlClient.query(QueryOptions(
      fetchPolicy: FetchPolicy.noCache,
      document: gql(MedicineDocsGql.medicinesQuery),
      variables: {'itemPerPage': itemPerPage, 'page': page},
    ));
    print(response);

    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data = response.data!['medicines'];
      final List<dynamic> items = data['items'];
      // final List<dynamic>items
      final totalPag = data['totalPages'];

      List<Medicine> medicinesL =
          items.map((json) => Medicine.fromJson(json)).toList();
      MedicinesTable medicines =
          MedicinesTable(medicinesList: medicinesL, totalPages: totalPag);

      return right(medicines);
    } else {
      print('GraphQL Error: ${response.exception}');
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, MedicinesTable>> getSearchMedicines(
      double itemPerPage, double page, String search) async {
    final response = await gqlClient.query(QueryOptions(
      fetchPolicy: FetchPolicy.noCache,
      document: gql(MedicineDocsGql.medicinesSearchQuery),
      variables: {'itemPerPage': itemPerPage, 'page': page, 'search': search},
    ));
    print(response);

    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data = response.data!['medicines'];
      final List<dynamic> items = data['items'];
      // final List<dynamic>items
      final totalPag = data['totalPages'];

      List<Medicine> medicinesL =
          items.map((json) => Medicine.fromJson(json)).toList();
      MedicinesTable medicines =
          MedicinesTable(medicinesList: medicinesL, totalPages: totalPag);

      return right(medicines);
    } else {
      print('GraphQL Error: ${response.exception}');
      return left(ServerFailure());
    }
  }
  //  @override
  // Future<Either<Failure, MedicinesTable>> getPaginatedMedicines(
  //     double itemPerPage, double page) async {
  //   final response = await gqlClient.query(QueryOptions(
  //     document: gql(MedicineDocsGql.getMedicines),
  //     variables: {'itemPerPage': itemPerPage, 'page': page},
  //   ));
  //   print(response);

  //   if (!response.hasException && response.data != null) {
  //     final Map<String, dynamic> data = response.data!['medicines'];
  //     final List<dynamic> items = data['items'];
  //     final totalPag = data['totalPages'];

  //     List<Medicine> medicinesL =
  //         items.map((json) => Medicine.fromJson(json)).toList();
  //     MedicinesTable medicines =
  //         MedicinesTable(medicinesList: medicinesL, totalPages: totalPag);

  //     return right(medicines);
  //   } else {
  //     print('GraphQL Error: ${response.exception}');
  //     return left(ServerFailure());
  //   }
  // }

  @override
  Future<Either<Failure, String>> deleteMedicine(int id) async {
    final response = await gqlClient.mutate(MutationOptions(
      document: gql(MedicineMutationDocsGql.deleteMedicine),
      variables: {'id': id},
    ));
    print(response);

    if (!response.hasException && response.data != null) {
      return right("");
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> addNewMedicine(
      Medicine body, int? catId) async {
    final response = await gqlClient.mutate(MutationOptions(
      document: gql(MedicineMutationDocsGql.addMedicine),
      variables: {
        'createMedicineInput': {
          'category_id': catId,
          'chemical_material_id': body.anti!.map((e) => e.id).toList(),
          'concentration': body.concentration,
          'name': body.name,
        },
      },
    ));
    print(response);

    if (!response.hasException && response.data != null) {
      // Note: Replace "" with the response message
      return right("");
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> editMedicine(Medicine body, int catId) async {
    final response = await gqlClient.mutate(MutationOptions(
      document: gql(MedicineMutationDocsGql.editMedicine),
      variables: {
        'id': body.id,
        'updateMedicineInput': {
          'category_id': catId,
          'chemical_material_id': body.anti!.map((e) => e.id).toList(),
          'concentration': body.concentration,
          'name': body.name,
        },
      },
    ));
    print(response);

    if (!response.hasException && response.data != null) {
      // Note: Replace "" with the response message
      return right("");
    } else {
      return left(ServerFailure());
    }
  }
}
