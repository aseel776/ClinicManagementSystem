import 'package:clinic_management_system/core/error/failures.dart';
import 'package:clinic_management_system/features/patients_management/data/documents/patient_badHabits.dart';
import 'package:clinic_management_system/features/patients_management/data/documents/patient_costs.dart';
import 'package:clinic_management_system/features/patients_management/data/documents/patient_diseases.dart';
import 'package:clinic_management_system/features/patients_management/data/documents/patient_medicines.dart';
import 'package:clinic_management_system/features/patients_management/data/documents/patient_payments.dart';
import 'package:clinic_management_system/features/patients_management/data/documents/patients_table.dart';
import 'package:clinic_management_system/features/patients_management/data/models/badHabits_patient.dart';
import 'package:clinic_management_system/features/patients_management/data/models/diseases_patient.dart';
import 'package:clinic_management_system/features/patients_management/data/models/medicines_intake.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient_cost.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient_payments.dart';
import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../models/patient.dart';
import '../models/patients_table.dart'; // Import your Patient model

abstract class PatientsRepository {
  Future<Either<Failure, List<Patient>>> getPatients();
  Future<Either<Failure, PatientsTable>> getPaginatedPatients(
      double itemPerPage, double page);
  Future<Either<Failure, List<PatientPayment>>> getPatientPayments(
      double itemPerPage,
      double page,
      double patientId,
      String sort_field,
      String sort_order);
  Future<Either<Failure, List<PatientCost>>> getPatientCosts(double itemPerPage,
      double page, double patientId, String sort_field, String sort_order);
  Future<Either<Failure, List<PatientBadHabits>>> getPatientBadHabits(
    int patientId,
  );
  Future<Either<Failure, List<PatientDiseases>>> getPatientDiseases(
    int patientId,
  );
  Future<Either<Failure, List<PatientMedicine>>> getPatientMedicines(
    int patientId,
  );
}

class PatientsRepositoryImpl implements PatientsRepository {
  final GraphQLClient gqlClient;

  PatientsRepositoryImpl(this.gqlClient);

  @override
  Future<Either<Failure, List<Patient>>> getPatients() async {
    final response = await gqlClient.query(QueryOptions(
      document: gql(""),
      variables: {},
    ));

    if (!response.hasException && response.data != null) {
      final List<dynamic>? patientData = response.data!['data']['Patients'];
      return right(
        patientData!.map((json) => Patient.fromJson(json)).toList(),
      );
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, PatientsTable>> getPaginatedPatients(
    double itemPerPage,
    double page,
  ) async {
    final response = await gqlClient.query(QueryOptions(
      document: gql(PatientsTableDocsGql.patientsDataTable),
      variables: {'itemPerPage': itemPerPage, 'page': page},
    ));
    print(response);

    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data = response.data!['patients'];
      final List<dynamic> items = data['items'];
      final totalPages = data['totalPages'];
      print(totalPages);

      List<Patient> patientsL =
          items.map((json) => Patient.fromJson(json)).toList();
      PatientsTable patientsList =
          PatientsTable(patients: patientsL, totalPages: totalPages);
      print(patientsList.toString());
      return right(patientsList);
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<PatientPayment>>> getPatientPayments(
      double itemPerPage,
      double page,
      double patientId,
      String sort_field,
      String sort_order) async {
    final response = await gqlClient.query(QueryOptions(
      document: gql(PatientPaymentsDocsGql.getPatientPaymentsQuery),
      variables: {
        'itemPerPage': itemPerPage,
        'page': page,
        'patientId': patientId,
        'sortField': sort_field,
        'sortOrder': sort_order,
      },
    ));
    print(response);

    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data = response.data!['patientPayments'];
      final List<dynamic> items = data['items'];
      final totalPages = data['totalPages'];
      print(totalPages);

      List<PatientPayment> paymentsList =
          items.map((json) => PatientPayment.fromJson(json)).toList();

      print(paymentsList.toString());
      return right(paymentsList);
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<PatientCost>>> getPatientCosts(
      double itemPerPage,
      double page,
      double patientId,
      String sort_field,
      String sort_order) async {
    final response = await gqlClient.query(QueryOptions(
      document: gql(PatientCostsDocsGql.getPatientCostsQuery),
      variables: {
        'itemPerPage': itemPerPage,
        'page': page,
        'patientId': patientId,
        'sortField': sort_field,
        'sortOrder': sort_order,
      },
    ));
    print(response);

    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data = response.data!['patientCosts'];
      final List<dynamic> items = data['items'];
      final totalPages = data['totalPages'];
      print(totalPages);

      List<PatientCost> paymentsList =
          items.map((json) => PatientCost.fromJson(json)).toList();

      print(paymentsList.toString());
      return right(paymentsList);
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<PatientBadHabits>>> getPatientBadHabits(
    int patientId,
  ) async {
    final response = await gqlClient.query(QueryOptions(
      document: gql(PatientBadHabitsDocsGql.patientBadHabitsQuery),
      variables: {
        'patient_id': patientId,
      },
    ));
    print("responseeeeeeeeee");
    print(response);

    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data = response.data!;
      final List<dynamic> items = data['patientBadHabits'];

      List<PatientBadHabits> badHabitssList =
          items.map((json) => PatientBadHabits.fromJson(json)).toList();

      print(badHabitssList.toString());
      return right(badHabitssList);
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<PatientDiseases>>> getPatientDiseases(
    int patientId,
  ) async {
    final response = await gqlClient.query(QueryOptions(
      document: gql(PatientDiseasesDocsGql.patientDiseasesQuery),
      variables: {
        'patient_id': patientId,
      },
    ));
    print(response);

    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data = response.data!;
      final List<dynamic> items = data['patientDiseases'];

      List<PatientDiseases> badHabitssList =
          items.map((json) => PatientDiseases.fromJson(json)).toList();

      print(badHabitssList.toString());
      return right(badHabitssList);
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<PatientMedicine>>> getPatientMedicines(
    int patientId,
  ) async {
    final response = await gqlClient.query(QueryOptions(
      document: gql(PatientMedicineDocsGql.patientMedicinesQuery),
      variables: {
        'patient_id': patientId,
      },
    ));
    print(response);

    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data = response.data!;
      final List<dynamic> items = data['patientMedicines'];

      List<PatientMedicine> medicinesList =
          items.map((json) => PatientMedicine.fromJson(json)).toList();

      print(medicinesList.toString());
      return right(medicinesList);
    } else {
      return left(ServerFailure());
    }
  }
}
