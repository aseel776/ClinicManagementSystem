// import 'package:clinic_management_system/features/medicine/data/repositories/medicine_repository.dart';

// import 'package:clinic_management_system/features/medicine/data/model/medicine_model.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';

// import '../../../../../core/error/failures.dart';
// import '../../../../../core/graphql_client_provider.dart';
// import '../../../../../core/strings/failures.dart';
// import 'add_update_delete_state.dart';

// final activeMaterialsCrudProvider = StateNotifierProvider<
//     AddDeleteUpdateActiveMaterialsNotifier,
//     AddDeleteUpdateActiveMaterialsState>(
//   (ref) {
//     GraphQLClient client = ref.watch(graphQlClientProvider);
//     return AddDeleteUpdateActiveMaterialsNotifier(client: client);
//   },
// );

// class AddDeleteUpdateActiveMaterialsNotifier
//     extends StateNotifier<AddDeleteUpdateActiveMaterialsState> {
//   GraphQLClient client;
//   AddDeleteUpdateActiveMaterialsNotifier({required this.client})
//       : super(AddDeleteUpdateActiveMaterialsState
//             as AddDeleteUpdateActiveMaterialsState);

//   late final ValueNotifier<GraphQLClient> clientNotifier =
//       ValueNotifier<GraphQLClient>(client);

//   //init repository to call the Functions
//   final MedicineRespositoryImpl respositoryImpl = MedicineRespositoryImpl(
//       /**************** the 'client cause error here ????'********************* */
//       GraphQLClient(
//     link: HttpLink('https://music-mates-fun.herokuapp.com/graphql'),
//     cache: GraphQLCache(),
//   ));

//   Future<AddDeleteUpdateActiveMaterialsState> addMedicine(
//       Medicine medicine) async {
//     state = LoadingAddDeleteUpdateActiveMaterialsState();
//     final response = await respositoryImpl.addNewMedicine(medicine);
//     AddDeleteUpdateActiveMaterialsState newState =
//         _eitherDoneMessageOrErrorState(response);
//     state = newState;
//     return state;
//   }

//   AddDeleteUpdateActiveMaterialsState _eitherDoneMessageOrErrorState(
//       Either<Failure, String> either) {
//     return either.fold(
//       (failure) => ErrorAddDeleteUpdateActiveMaterialsState(
//         message: _mapFailureToMessage(failure),
//       ),
//       (message) => MessageAddDeleteUpdateActiveMaterialsState(message: message),
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
//         return "Unexpected Error , Please try again later .";
//     }
//   }
// }
