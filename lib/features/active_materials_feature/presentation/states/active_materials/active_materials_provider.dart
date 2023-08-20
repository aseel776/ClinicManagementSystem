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

  ActiveMaterialsNotifier(this.client) : super(InitActiveMaterialsState());

  GraphQLClient client;
  late final ValueNotifier<GraphQLClient> clientNotifier = ValueNotifier<GraphQLClient>(client);
  late final ActiveMaterialsRepoImp repo = ActiveMaterialsRepoImp(client);

  Future<void> getAllMaterials(int page, {int? items, WidgetRef? ref}) async {
    items ??= 15;
    state = LoadingActiveMaterialsState();
    final response = await repo.getActiveMaterials(page, items: items);
    state = _mapFailureOrMaterialsToState(response);
    if(state is LoadedActiveMaterialsState && ref != null){
      final pageModel = state.props[0] as MaterialsPaginationModel;
      ref.read(totalPagesProvider.notifier).state = pageModel.totalPages!.toInt();
    }
  }

  Future<void> createMaterial(ActiveMaterialModel body) async {
    state = LoadingActiveMaterialsState();
    final response = await repo.createActiveMaterial(body);
    state = _mapFailureOrSuccessToState(response);
  }

  Future<void> deleteMaterial(int materialId) async {
    state = LoadingActiveMaterialsState();
    final response = await repo.deleteActiveMaterial(materialId);
    state = _mapFailureOrSuccessToState(response);
  }

  ActiveMaterialsState _mapFailureOrMaterialsToState(Either<Failure, MaterialsPaginationModel> either) {
    return either.fold(
      (failure) => ErrorActiveMaterialsState(message: _mapFailureToMessage(failure)),
      (page) {
        return LoadedActiveMaterialsState(page: page);
      },
    );
  }

  ActiveMaterialsState _mapFailureOrSuccessToState (Either<Failure, String> either) {
    return either.fold(
      (failure) => ErrorActiveMaterialsState(message: _mapFailureToMessage(failure)),
      (success) => SuccessActiveMaterialsState(message: success),
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
