import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'active_material_state.dart';
import './/core/error/failures.dart';
import './/core/strings/failures.dart';
import './/core/graphql_client_provider.dart';
import '../../../data/repos/active_material_repo.dart';
import '../../../data/models/active_material_model.dart';

final activeMaterialsProvider = StateNotifierProvider<
    ActiveMaterialNotifier,
    ActiveMaterialState>((ref) {
  final client = ref.watch(graphQlClientProvider);
  return ActiveMaterialNotifier(client);
});

class ActiveMaterialNotifier extends StateNotifier<ActiveMaterialState> {
  ActiveMaterialNotifier(this.client) : super(InitActiveMaterialState());

  GraphQLClient client;
  late final clientNotifier = ValueNotifier<GraphQLClient>(client);
  late final ActiveMaterialRepoImp repo = ActiveMaterialRepoImp(client);

  Future<ActiveMaterialState> getMaterial(int id) async{
    state = LoadingActiveMaterialState();
    final response = await repo.getActiveMaterial(id);
    ActiveMaterialState newState = _mapFailureOrMaterialToState(response);
    state = newState;
    return state;
  }

  Future<ActiveMaterialState> updateMaterial(ActiveMaterialModel body) async {
    state = LoadingActiveMaterialState();
    final response = await repo.updateActiveMaterial(body);
    ActiveMaterialState newState = await _mapFailureOrSuccessToState(response, body.id!);
    state = newState;
    return state;
  }

  ActiveMaterialState _mapFailureOrMaterialToState(
      Either<Failure, ActiveMaterialModel> either) {
    return either.fold(
          (failure) =>
          ErrorActiveMaterialState(message: _mapFailureToMessage(failure)),
          (material) => LoadedActiveMaterialState(material: material),
    );
  }

  Future<ActiveMaterialState> _mapFailureOrSuccessToState(
      Either<Failure, String> either, int id) async {
    return either.fold(
          (failure) =>
          ErrorActiveMaterialState(message: _mapFailureToMessage(failure)),
          (success) async => await getMaterial(id),
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
        return "Unexpected Error, please try again later.";
    }
  }
}
