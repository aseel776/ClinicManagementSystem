import 'package:clinic_management_system/features/medicine/data/model/category.dart';
import 'package:clinic_management_system/features/medicine/data/model/medicine_table.dart';
import 'package:clinic_management_system/features/medicine/data/repositories/medicine_repository.dart';
import 'package:clinic_management_system/features/medicine/presentation/riverpod/medicines/medicines_state.dart';
import 'package:clinic_management_system/features/medicine/data/model/medicine_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/graphql_client_provider.dart';
import '../../../../../core/strings/failures.dart';

final categoriesProvider =
    StateNotifierProvider<CategoriesNotifier, MedicinesState>(
  (ref) {
    GraphQLClient client = ref.watch(graphQlClientProvider);
    return CategoriesNotifier(client: client);
  },
);

class CategoriesNotifier extends StateNotifier<MedicinesState> {
  GraphQLClient client;
  CategoriesNotifier({required this.client}) : super(MedicinesInitial());

  late final ValueNotifier<GraphQLClient> clientNotifier =
      ValueNotifier<GraphQLClient>(client);

  //init repository to call the Functions
  final MedicineRespositoryImpl respositoryImpl = MedicineRespositoryImpl(
      /**************** the 'client cause error here ????'********************* */
      GraphQLClient(
    link: HttpLink('http://localhost:3000/graphql'),
    cache: GraphQLCache(),
  ));

  Future<void> getCategories() async {
    state = LoadingMedicinesState();
    final response = await respositoryImpl.getCategories();
    state = _mapFailureOrCategoriesToState(response);
  }

  MedicinesState _mapFailureOrCategoriesToState(
      Either<Failure, List<Category>> either) {
    return either.fold(
      (failure) => ErrorMedicinesState(message: _mapFailureToMessage(failure)),
      (cat) => LoadedCategoriesState(categories: cat),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case EmptyCacheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return "Unexpected Error , Please try again later .";
    }
  }
}
