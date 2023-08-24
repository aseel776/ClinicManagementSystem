import 'dart:io';

import 'package:clinic_management_system/features/patients_management/data/models/badHabits_patient.dart';
import 'package:clinic_management_system/features/patients_management/data/models/medicines_intake.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient_cost.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient_diagnosis.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient_payments.dart';
import 'package:clinic_management_system/features/patients_management/data/repository/patient_crud_repository.dart';
import 'package:clinic_management_system/features/patients_management/presentation/riverpod/patient_crud_state.dart';
import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/graphql_client_provider.dart';
import '../../../../core/strings/failures.dart';
import '../../data/models/diseases_patient.dart';
import '../../data/models/patient.dart';
import '../../data/models/patient_medical_images.dart';

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

  Future<void> createPatientDiseases(
      PatientDiseases patientDiseases, int patientId) async {
    state = LoadingAddEditDeletePatientState();
    print("after Loading");
    final response = await respositoryImpl.createNewPatientDiseases(
        patientDiseases, patientId);
    print("done");
    state = _mapFailureOrMessageToState(response);
    print("state afterrrrrrrr");
    print(state);
  }

  Future<void> createPatientBadHabits(
      PatientBadHabits patientBadHabits, int patientId) async {
    state = LoadingAddEditDeletePatientState();
    print("after Loading");
    final response = await respositoryImpl.createNewPatientBadHabits(
        patientBadHabits, patientId);
    print("done");
    state = _mapFailureOrMessageToState(response);
    print("state afterrrrrrrr");
    print(state);
  }

  Future<void> createPatientMedicines(
      PatientMedicine patientMedicines, int patientId) async {
    state = LoadingAddEditDeletePatientState();
    print("after Loading");
    final response = await respositoryImpl.createNewPatientMedicines(
        patientMedicines, patientId);
    print("done");
    state = _mapFailureOrMessageToState(response);
    print("state afterrrrrrrr");
    print(state);
  }

  Future<void> createPatientPayments(
      PatientPayment patientPayments, int patientId) async {
    state = LoadingAddEditDeletePatientState();
    print("after Loading");
    final response = await respositoryImpl.createNewPatientPaymentss(
        patientPayments, patientId);
    print("done");
    state = _mapFailureOrMessageToState(response);
    print("state afterrrrrrrr");
    print(state);
  }

  Future<void> createPatientCosts(
      PatientCost patientCosts, int patientId) async {
    state = LoadingAddEditDeletePatientState();
    print("after Loading");
    final response =
        await respositoryImpl.createNewPatientCosts(patientCosts, patientId);
    print("done");
    state = _mapFailureOrMessageToState(response);
    print("state afterrrrrrrr");
    print(state);
  }

  Future<void> createPatientDiagnosis(PatientDiagnosis patientDiagnosis) async {
    state = LoadingAddEditDeletePatientState();
    print("after Loading");
    final response =
        await respositoryImpl.createNewPatientDiagnosis(patientDiagnosis);
    print("done");
    state = _mapFailureOrMessageToState(response);
    print("state afterrrrrrrr");
    print(state);
  }

  Future<void> editPatientDiagnosis(PatientDiagnosis patientDiagnosis) async {
    state = LoadingAddEditDeletePatientState();
    print("after Loading");
    final response =
        await respositoryImpl.editPatientDiagnosis(patientDiagnosis);
    print("done");
    state = _mapFailureOrMessageToState(response);
    print("state afterrrrrrrr");
    print(state);
  }

  Future<void> deletePatientDiagnosis(int? id) async {
    state = LoadingAddEditDeletePatientState();
    print("after Loading");
    final response = await respositoryImpl.deletePatientDiagnosis(id);
    print("done");
    state = _mapFailureOrMessageToState(response);
    print("state afterrrrrrrr");
    print(state);
  }

  Future<void> addNewImage(
      PatientMedicalImage image, FilePickerResult imageFile) async {
    state = LoadingAddEditDeletePatientState();
    final response =
        await respositoryImpl.createPatientMedicalImage(image, imageFile);
    AddEditDeletePatientState newState = _mapFailureOrMessageToState(response);
    state = newState;
    // return state;
  }

  AddEditDeletePatientState _mapFailureOrPatientToState(
    Either<Failure, Patient> either,
  ) {
    return either.fold(
      (failure) => ErrorAddEditDeletePatientState(
          message: _mapFailureToMessage(failure)),
      (patient) => PatientAddEditDeleteSuccessState(patient: patient),
    );
  }

  AddEditDeletePatientState _mapFailureOrMessageToState(
    Either<Failure, String> either,
  ) {
    return either.fold(
      (failure) => ErrorAddEditDeletePatientState(
          message: _mapFailureToMessage(failure)),
      (patient) => MessageAddEditDeletePatientState(message: patient),
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
