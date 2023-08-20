import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './/core/error/failures.dart';
import './/core/strings/failures.dart';
import './/core/graphql_client_provider.dart';
import '../../../data/repos/treatments_repo.dart';
import '../../../data/models/treatment_model.dart';
import '../../states/treatments/treatments_state.dart';
import '../../../data/models/treatments_page_model.dart';

final treatmentsProvider = StateNotifierProvider<TreatmentsNotifier, TreatmentsState>((ref){
  final client = ref.watch(graphQlClientProvider);
  return TreatmentsNotifier(client);
});

class TreatmentsNotifier extends StateNotifier<TreatmentsState> {
  GraphQLClient client;
  TreatmentsNotifier(this.client) : super(InitTreatmentsState());

  late final ValueNotifier<GraphQLClient> clientNotifier = ValueNotifier<GraphQLClient>(client);
  late final TreatmentsRepoImp repo = TreatmentsRepoImp(client);

  Future<void> getAllTreatments({int? page, int? items}) async {
    items ??= 100000;
    page ??= 1;
    state = LoadingTreatmentsState();
    final response = await repo.getTreatments(page, items);
    state = _mapFailureOrTreatmentsToState(response);
  }

  Future<void> createTreatment(TreatmentModel body) async {
    state = LoadingTreatmentsState();
    final response = await repo.createTreatment(body);
    state = _mapFailureOrSuccessToState(response);
    if(state is SuccessTreatmentsState){
      await getAllTreatments();
    }
  }

  Future<void> deleteTreatment(int treatmentId) async {
    state = LoadingTreatmentsState();
    final response = await repo.deleteTreatment(treatmentId);
    state = _mapFailureOrSuccessToState(response);
    if (state is SuccessTreatmentsState) {
      await getAllTreatments();
    }
  }

  TreatmentsState _mapFailureOrTreatmentsToState(Either<Failure, TreatmentsPageModel> either) {
    return either.fold(
      (failure) => ErrorTreatmentsState(message: _mapFailureToMessage(failure)),
      (page) => LoadedTreatmentsState(page: page),
    );
  }


  TreatmentsState _mapFailureOrSuccessToState(Either<Failure, String> either) {
    return either.fold(
      (failure) => ErrorTreatmentsState(message: _mapFailureToMessage(failure)),
      (success) => SuccessTreatmentsState(message: success),
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
