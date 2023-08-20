import 'package:clinic_management_system/features/medicine/data/model/active_materials.dart';
import 'package:clinic_management_system/features/medicine/data/repositories/active_material_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/graphql_client_provider.dart';
import '../../../../../core/strings/failures.dart';
import 'active_materials_state.dart';

final activeMaterialsProvider =
    StateNotifierProvider<ActiveMaterialsNotifier, ActiveMaterialsState>(
  (ref) {
    GraphQLClient client = ref.watch(graphQlClientProvider);
    return ActiveMaterialsNotifier(client: client);
  },
);

class ActiveMaterialsNotifier extends StateNotifier<ActiveMaterialsState> {
  GraphQLClient client;
  ActiveMaterialsNotifier({required this.client})
      : super(ActiveMaterialsInitial());

  late final ValueNotifier<GraphQLClient> clientNotifier =
      ValueNotifier<GraphQLClient>(client);

  //init repository to call the Functions
  final ActiveMaterialsRespositoryImpl respositoryImpl =
      ActiveMaterialsRespositoryImpl(
          /**************** the 'client cause error here ????'********************* */
          GraphQLClient(
    link: HttpLink('http://localhost:3000/graphql'),
    cache: GraphQLCache(),
  ));

  Future<ActiveMaterialsState> getAllMaterials() async {
    state = LoadingActiveMaterialsState();
    final response = await respositoryImpl.getMaterials();
    ActiveMaterialsState newState =
        _mapFailureOrActiveMaterialsToState(response);
    state = newState;
    return state;
  }

  ActiveMaterialsState _mapFailureOrActiveMaterialsToState(
      Either<Failure, List<ActiveMaterials>> either) {
    return either.fold(
      (failure) =>
          ErrorActiveMaterialsState(message: _mapFailureToMessage(failure)),
      (materials) => LoadedActiveMaterialsState(
        materials: materials,
      ),
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
