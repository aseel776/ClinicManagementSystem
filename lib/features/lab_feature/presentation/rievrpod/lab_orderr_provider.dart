// import 'package:dartz/dartz.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';

// import '../../../../../core/error/failures.dart';
// import '../../../../../core/graphql_client_provider.dart';
// import '../../../../../core/strings/failures.dart';

// import '../../data/models/lab_order_table_model.dart'; // Replace with the actual import for Lab Order Table model
// import '../../data/repository/lab_order_repository.dart'; // Replace with the actual import for Lab Order Repository
// import 'lab_order_state.dart'; // Make sure you've created the equivalent state classes

// final labOrdersProvider =
//     StateNotifierProvider<LabOrdersNotifier, LabOrdersState>(
//   (ref) {
//     GraphQLClient client = ref.watch(graphQlClientProvider);
//     return LabOrdersNotifier(client: client);
//   },
// );

// class LabOrdersNotifier extends StateNotifier<LabOrdersState> {
//   GraphQLClient client;
//   LabOrdersNotifier({required this.client}) : super(LabOrdersInitial());

//   late final ValueNotifier<GraphQLClient> clientNotifier =
//       ValueNotifier<GraphQLClient>(client);

//   // Initialize repository to call the functions
//   final LabOrderRepositoryImpl repositoryImpl = LabOrderRepositoryImpl(
//     GraphQLClient(
//       link: HttpLink('http://localhost:3000/graphql'),
//       cache: GraphQLCache(),
//     ),
//   );

//   Future<void> getPaginatedLabOrders(double itemPerPage, double page) async {
//     state = LoadingLabOrdersState();
//     final response =
//         await repositoryImpl.getPaginatedLabOrders(itemPerPage, page);
//     state = _mapFailureOrLabOrdersToState(response);
//   }

//   Future<void> getPaginatedSearchLabOrders(
//       double itemPerPage, double page, String searchText) async {
//     state = LoadingLabOrdersState();
//     final response = await repositoryImpl.getPaginatedSearchLabOrders(
//         itemPerPage, page, searchText);
//     state = _mapFailureOrLabOrdersToState(response);
//   }

//   LabOrdersState _mapFailureOrLabOrdersToState(
//       Either<Failure, LabOrderTable> either) {
//     return either.fold(
//       (failure) => ErrorLabOrdersState(message: _mapFailureToMessage(failure)),
//       (labOrders) => LoadedLabOrdersState(
//           labOrders: labOrders.labOrders, totalPages: labOrders.totalPages),
//     );
//   }

//   String _mapFailureToMessage(Failure failure) {
//     switch (failure.runtimeType) {
//       case ServerFailure:
//         return SERVER_FAILURE_MESSAGE;
//       case EmptyCacheFailure:
//         return EMPTY_CACHE_FAILURE_MESSAGE;
//       case OfflineFailure:
//         return OFFLINE_FAILURE_MESSAGE;
//       default:
//         return "Unexpected Error, Please try again later.";
//     }
//   }
// }
