import 'package:clinic_management_system/features/patients_management/data/models/badHabits_patient.dart';
import 'package:clinic_management_system/features/patients_management/data/models/diseases_patient.dart';
import 'package:clinic_management_system/features/patients_management/data/models/medicines_intake.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient_cost.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient_payments.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patients_table.dart';
import 'package:clinic_management_system/features/patients_management/data/repository/patient_crud_repository.dart';
import 'package:clinic_management_system/features/patients_management/presentation/riverpod/patient_crud_state.dart';
import 'package:clinic_management_system/features/patients_management/presentation/riverpod/patients_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/graphql_client_provider.dart';
import '../../../../core/strings/failures.dart';
import '../../data/models/patient.dart';
import '../../data/repository/patients_repository.dart';

final patientsProvider = StateNotifierProvider<PatientsNotifier, PatientsState>(
  (ref) {
    GraphQLClient client = ref.watch(graphQlClientProvider);
    return PatientsNotifier(client: client);
  },
);

class PatientsNotifier extends StateNotifier<PatientsState> {
  GraphQLClient client;
  PatientsNotifier({required this.client}) : super(PatientsInitial());

  late final ValueNotifier<GraphQLClient> clientNotifier =
      ValueNotifier<GraphQLClient>(client);

  //init repository to call the Functions
  final PatientsRepositoryImpl repositoryImpl = PatientsRepositoryImpl(
      /**************** the 'client cause error here ????'********************* */
      GraphQLClient(
    link: HttpLink('http://localhost:3000/graphql'),
    cache: GraphQLCache(),
  ));

  // Future<void> getAllPatients() async {
  //   state = LoadingPatientsState();
  //   final response = await repositoryImpl.getPatients();
  //   state = _mapFailureOrPatientToState(either: response);
  // }

  Future<void> getPaginatedPatients(double itemPerPage, double page) async {
    state = LoadingPatientsState();
    print("after Loading");
    final response =
        await repositoryImpl.getPaginatedPatients(itemPerPage, page);
    print("done");
    state = _mapFailureOrPatientToState(either: response);
  }

  Future<void> getPatientPayments(
    double itemPerPage,
    double page,
    double patientId,
    String sort_field,
    String sort_order,
  ) async {
    if (state is LoadedPatientsState) {
      final state1 = state;
      final totalPages;

      if (state1 is LoadedPatientsState) {
        totalPages = state1.totalPages;
      } else {
        totalPages = 0;
      }
      List<Patient> updatedPatients = [
        ...state.patients
      ]; // Make a copy of the list

      int patientIndex =
          updatedPatients.indexWhere((patient) => patient.id == patientId);
      state = LoadingPatientsState();

      if (patientIndex != -1) {
        final response = await repositoryImpl.getPatientPayments(
          itemPerPage,
          page,
          patientId,
          sort_field,
          sort_order,
        );
        List<PatientPayment> paymentsList = [];
        response.fold(
            (failure) =>
                ErrorPatientsState(message: _mapFailureToMessage(failure)),
            (payments) => paymentsList = payments);

        // Update the patientPayments for the specific patient
        updatedPatients[patientIndex].patientPayments =
            paymentsList; // Update the patient in the copied list

        // Notify the state that the data has changed
        state = LoadedPatientsState(
          patients: updatedPatients,
          totalPages: totalPages,
        );
      }
    }
  }

  Future<void> getPatientCosts(
    double itemPerPage,
    double page,
    double patientId,
    String sort_field,
    String sort_order,
  ) async {
    if (state is LoadedPatientsState) {
      final state1 = state;
      final totalPages;
      if (state1 is LoadedPatientsState) {
        totalPages = state1.totalPages;
      } else {
        totalPages = 0;
      }
      List<Patient> updatedPatients = [
        ...state.patients
      ]; // Make a copy of the list

      int patientIndex =
          updatedPatients.indexWhere((patient) => patient.id == patientId);

      if (patientIndex != -1) {
        final response = await repositoryImpl.getPatientCosts(
          itemPerPage,
          page,
          patientId,
          sort_field,
          sort_order,
        );
        List<PatientCost> costsList = [];
        response.fold(
            (failure) =>
                ErrorPatientsState(message: _mapFailureToMessage(failure)),
            (costs) => costsList = costs);

        // Update the patientPayments for the specific patient
        updatedPatients[patientIndex].patientCosts =
            costsList; // Update the patient in the copied list

        // Notify the state that the data has changed
        state = LoadingPatientsState();
        state = LoadedPatientsState(
          patients: updatedPatients,
          totalPages: totalPages,
        );
      }
    }
  }

  Future<void> getPatientBadHabits(
    int patientId,
  ) async {
    if (state is LoadedPatientsState) {
      final state1 = state;
      final totalPages;
      if (state1 is LoadedPatientsState) {
        totalPages = state1.totalPages;
      } else {
        totalPages = 0;
      }
      List<Patient> updatedPatients = [
        ...state.patients
      ]; // Make a copy of the list

      int patientIndex =
          updatedPatients.indexWhere((patient) => patient.id == patientId);

      if (patientIndex != -1) {
        final response = await repositoryImpl.getPatientBadHabits(
          patientId,
        );
        List<PatientBadHabits> badHabitsList = [];
        response.fold(
            (failure) =>
                ErrorPatientsState(message: _mapFailureToMessage(failure)),
            (badHabits) => badHabitsList = badHabits);

        // Update the patientPayments for the specific patient
        updatedPatients[patientIndex].patientBadHabits =
            badHabitsList; // Update the patient in the copied list

        // Notify the state that the data has changed
        state = LoadingPatientsState();
        state = LoadedPatientsState(
          patients: updatedPatients,
          totalPages: totalPages,
        );
      }
    }
  }

  Future<void> getPatientDiseases(
    int patientId,
  ) async {
    if (state is LoadedPatientsState) {
      final state1 = state;
      final totalPages;
      if (state1 is LoadedPatientsState) {
        totalPages = state1.totalPages;
      } else {
        totalPages = 0;
      }
      List<Patient> updatedPatients = [
        ...state.patients
      ]; // Make a copy of the list

      int patientIndex =
          updatedPatients.indexWhere((patient) => patient.id == patientId);

      if (patientIndex != -1) {
        final response = await repositoryImpl.getPatientDiseases(
          patientId,
        );
        List<PatientDiseases> diseasesList = [];
        response.fold(
            (failure) =>
                ErrorPatientsState(message: _mapFailureToMessage(failure)),
            (badHabits) => diseasesList = badHabits);

        // Update the patientPayments for the specific patient
        updatedPatients[patientIndex].patientDiseases =
            diseasesList; // Update the patient in the copied list

        // Notify the state that the data has changed
        state = LoadingPatientsState();
        state = LoadedPatientsState(
          patients: updatedPatients,
          totalPages: totalPages,
        );
      }
    }
  }

  Future<void> getPatientMedicines(
    int patientId,
  ) async {
    if (state is LoadedPatientsState) {
      final state1 = state;
      final totalPages;
      if (state1 is LoadedPatientsState) {
        totalPages = state1.totalPages;
      } else {
        totalPages = 0;
      }
      List<Patient> updatedPatients = [
        ...state.patients
      ]; // Make a copy of the list

      int patientIndex =
          updatedPatients.indexWhere((patient) => patient.id == patientId);

      if (patientIndex != -1) {
        final response = await repositoryImpl.getPatientMedicines(
          patientId,
        );
        List<PatientMedicine> medicinesList = [];
        response.fold(
            (failure) =>
                ErrorPatientsState(message: _mapFailureToMessage(failure)),
            (medicines) => medicinesList = medicines);

        // Update the patientPayments for the specific patient
        updatedPatients[patientIndex].patientMedicines =
            medicinesList; // Update the patient in the copied list

        // Notify the state that the data has changed
        state = LoadingPatientsState();
        state = LoadedPatientsState(
          patients: updatedPatients,
          totalPages: totalPages,
        );
      }
    }
  }

  PatientsState _mapFailureOrPatientToState(
      {required Either<Failure, PatientsTable> either, int? totalPages}) {
    return either.fold(
      (failure) => ErrorPatientsState(message: _mapFailureToMessage(failure)),
      (patient) => LoadedPatientsState(
          patients: patient.patients!, totalPages: patient.totalPages),
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
