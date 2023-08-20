import 'package:clinic_management_system/features/patients_management/data/repository/patient_crud_repository.dart';
import 'package:clinic_management_system/features/patients_management/presentation/riverpod/patient_crud_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/graphql_client_provider.dart';
import '../../../../core/strings/failures.dart';
import '../../data/models/diseases_patient.dart';
import '../../data/models/patient.dart';

final patientsCrudProvider =
    StateNotifierProvider<PatientsCrudNotifier, AddEditDeletePatientState>(
  (ref) {
    GraphQLClient client = ref.watch(graphQlClientProvider);
    return PatientsCrudNotifier(client: client);
  },
);

class PatientsCrudNotifier extends StateNotifier<AddEditDeletePatientState> {
  GraphQLClient client;
  PatientsCrudNotifier({required this.client})
      : super(AddEditDeletePatientInitial());

  late final ValueNotifier<GraphQLClient> clientNotifier =
      ValueNotifier<GraphQLClient>(client);

  //init repository to call the Functions
  final PatientsCrudRepositoryImpl respositoryImpl = PatientsCrudRepositoryImpl(
      /**************** the 'client cause error here ????'********************* */
      GraphQLClient(
    link: HttpLink('http://localhost:3000/graphql'),
    cache: GraphQLCache(),
  ));

  Future<AddEditDeletePatientState> createNewPatient(Patient patient) async {
    state = LoadingAddEditDeletePatientState();
    final response = await respositoryImpl.createNewPatient(patient);
    AddEditDeletePatientState newState = _mapFailureOrPatientToState(response);
    state = newState;
    return state;
  }

  // Future<void> createPatientDiseases(PatientDiseases patientDiseases) async {
  //   state = LoadingAddEditDeletePatientState();
  //   print("after Loading");
  //   final response =
  //       await respositoryImpl.createNewPatientDiseases(patientDiseases);
  //   print("done");
  //   state = _mapFailureOrPatientToState(either: response);
  //   print("state afterrrrrrrr");
  //   print(state);
  // }

  AddEditDeletePatientState _mapFailureOrPatientToState(
    Either<Failure, Patient> either,
  ) {
    return either.fold(
      (failure) => ErrorAddEditDeletePatientState(
          message: _mapFailureToMessage(failure)),
      (patient) => PatientAddEditDeleteSuccessState(patient: patient),
    );
  }

  // AddEditDeletePatientState _mapFailureOrToState(
  //   Either<Failure, String> either,
  // ) {
  //   return either.fold(
  //     (failure) => ErrorAddEditDeletePatientState(
  //         message: _mapFailureToMessage(failure)),
  //     (patient) => PatientAddEditDeleteSuccessState(patient: patient),
  //   );
  // }

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
