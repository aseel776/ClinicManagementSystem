import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../control_states.dart';
import './active_materials_state.dart';
import './/core/error/failures.dart';
import './/core/strings/failures.dart';
import './/core/graphql_client_provider.dart';
import '../../../data/repos/active_materials_repo.dart';
import '../../../data/models/active_material_model.dart';
import '../../../data/models/materials_pagination_model.dart';

final activeMaterialsProvider = StateNotifierProvider<ActiveMaterialsNotifier, ActiveMaterialsState>((ref) {
  final client = ref.watch(graphQlClientProvider);
  return ActiveMaterialsNotifier(client);
});

class ActiveMaterialsNotifier extends StateNotifier<ActiveMaterialsState> {
  GraphQLClient client;
  final _providerContainer = ProviderContainer();

  ActiveMaterialsNotifier(this.client) : super(InitActiveMaterialsState());

  late final ValueNotifier<GraphQLClient> clientNotifier = ValueNotifier<GraphQLClient>(client);

  late final ActiveMaterialsRepoImp repo = ActiveMaterialsRepoImp(client);

  Future<ActiveMaterialsState> getAllMaterials(int page, {int? items}) async {
    state = LoadingActiveMaterialsState();
    final response = await repo.getActiveMaterials(page);
    ActiveMaterialsState newState = _mapFailureOrMaterialsToState(response);
    state = newState;
    return state;
  }

  Future<ActiveMaterialsState> createMaterial(ActiveMaterialModel body) async {
    // var materials = state.props as List<ActiveMaterialModel>;
    // materials = [...materials, body];
    state = LoadingActiveMaterialsState();
    final response = await repo.createActiveMaterial(body);
    ActiveMaterialsState newState = await _mapFailureOrSuccessToState(response);
    state = newState;
    return state;
  }

  Future<ActiveMaterialsState> updateMaterial(ActiveMaterialModel body) async {
    state = LoadingActiveMaterialsState();
    final response = await repo.updateActiveMaterial(body);
    ActiveMaterialsState newState = await _mapFailureOrSuccessToState(response);
    state = newState;
    return state;
  }

  Future<ActiveMaterialsState> deleteMaterial(int materialId) async {
    state = LoadingActiveMaterialsState();
    final response = await repo.deleteActiveMaterial(materialId);
    ActiveMaterialsState newState = await _mapFailureOrSuccessToState(response);
    state = newState;
    return state;
  }

  ActiveMaterialsState _mapFailureOrMaterialsToState(Either<Failure, MaterialsPaginationModel> either) {
    return either.fold(
      (failure) => ErrorActiveMaterialsState(message: _mapFailureToMessage(failure)),
      (page) {
        _providerContainer.read(totalPagesProvider.notifier).state = page.totalPages!;
        return LoadedActiveMaterialsState(page: page);
      },
    );
  }

  Future<ActiveMaterialsState> _mapFailureOrSuccessToState (Either<Failure, String> either) async{
    final currentPage = _providerContainer.read(currentPageProvider);
    return either.fold(
      (failure) => ErrorActiveMaterialsState(message: _mapFailureToMessage(failure)),
      (success) async => await getAllMaterials(currentPage),
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
