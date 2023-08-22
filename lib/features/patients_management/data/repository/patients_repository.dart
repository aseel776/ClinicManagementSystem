import 'dart:io';

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
import 'package:clinic_management_system/features/patients_management/data/models/patient_costs_table.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient_payments.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient_payments_table.dart';
import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;

import '../documents/patient_diagnosis.dart';
import '../documents/patient_images.dart';
import '../models/patient.dart';
import '../models/patient_diagnosis.dart';
import '../models/patient_medical_images.dart';
import '../models/patients_table.dart';
import '../models/problem_types.dart'; // Import your Patient model

abstract class PatientsRepository {
  Future<Either<Failure, List<Patient>>> getPatients();
  Future<Either<Failure, PatientsTable>> getPaginatedPatients(
      double itemPerPage, double page);
  Future<Either<Failure, PatientsTable>> getPaginatedSearchPatients(
      double itemPerPage, double page, String search);
  Future<Either<Failure, PatientPaymentsTable>> getPatientPayments(
      double itemPerPage,
      double page,
      double patientId,
      String sort_field,
      String sort_order);
  Future<Either<Failure, PatientCostsTable>> getPatientCosts(double itemPerPage,
      double page, double patientId, String sort_field, String sort_order);
  Future<Either<Failure, List<PatientBadHabits>>> getPatientBadHabits(
    int patientId,
  );
  Future<Either<Failure, String>> createPatientBadHabits(
    PatientBadHabits patientBadHabits,
  );
  Future<Either<Failure, List<PatientDiseases>>> getPatientDiseases(
    int patientId,
  );
  Future<Either<Failure, String>> createPatientDiseases(
    PatientDiseases patientDisease,
  );

  Future<Either<Failure, List<PatientMedicine>>> getPatientMedicines(
    int patientId,
  );
  Future<Either<Failure, String>> createPatientMedicines(
    PatientMedicine patientMedicine,
  );
  Future<Either<Failure, List<PatientMedicalImage>>> getPatientMedicalImages(
    int medicalImageTypeId,
    int patientId,
  );
  Future<Either<Failure, String>> createPatientMedicalImage(
      PatientMedicalImage patientMedicalImage, File image);
  Future<Either<Failure, PatientDiagnosis>> createPatientDiagnosis(
    String expectedTreatment,
    int patientId,
    String place,
    int problemId,
  );
  Future<Either<Failure, List<PatientDiagnosis>>> getPaginatedPatientDiagnoses(
    double itemPerPage,
    double page,
    int patientId,
    int problemTypeId,
  );
  Future<List<ProblemTypes>> getProblemTypes();
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
  Future<Either<Failure, PatientsTable>> getPaginatedSearchPatients(
      double itemPerPage, double page, String search) async {
    final response = await gqlClient.query(QueryOptions(
      document: gql(PatientsTableDocsGql.patientsDataTable),
      variables: {'itemPerPage': itemPerPage, 'page': page, 'search': search},
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
  Future<Either<Failure, PatientPaymentsTable>> getPatientPayments(
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
    print("pppppppppppppppp");
    print(response);

    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data = response.data!['patientPayments'];
      final List<dynamic> items = data['items'];
      final totalPages = data['totalPages'];
      final totalAmount = data['meta']['total'];
      // print(totalPages);

      List<PatientPayment> paymentsList =
          items.map((json) => PatientPayment.fromJson(json)).toList();
      print("qqqqqqqqqqqqqqqqqqqqqqqqq");
      print(paymentsList);
      print("qqqqqqqqqqqqqqqqqqqqqqqqq");

      PatientPaymentsTable payments = PatientPaymentsTable(
          payments: paymentsList, totalAmounts: totalAmount);

      print(paymentsList.toString());
      return right(payments);
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, PatientCostsTable>> getPatientCosts(
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
    print("patieintnenasf costssss");
    print(response);

    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data = response.data!['patientCosts'];
      final List<dynamic> items = data['items'];
      final totalPages = data['totalPages'];

      final totalAmount = data['meta']['total'];

      print(totalPages);

      List<PatientCost> costsList =
          items.map((json) => PatientCost.fromJson(json)).toList();
      PatientCostsTable costs =
          PatientCostsTable(costs: costsList, totalAmounts: totalAmount);

      // print(paymentsList.toString());
      return right(costs);
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
  Future<Either<Failure, String>> createPatientDiseases(
    PatientDiseases patientDisease,
  ) async {
    final response = await gqlClient.mutate(MutationOptions(
        document: gql(PatientDiseasesDocsGql.createPatientDiseaseMutation),
        variables: {'input': patientDisease.toJson()}));
    print(response);

    if (!response.hasException && response.data != null) {
      return right("");
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> createPatientBadHabits(
    PatientBadHabits patientBadHabits,
  ) async {
    final response = await gqlClient.mutate(MutationOptions(
        document: gql(PatientBadHabitsDocsGql.createPatientBadHabitMutation),
        variables: {'input': patientBadHabits.toJson()}));
    print(response);

    if (!response.hasException && response.data != null) {
      return right("");
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> createPatientMedicines(
    PatientMedicine patientMedicine,
  ) async {
    final response = await gqlClient.mutate(MutationOptions(
        document: gql(PatientMedicineDocsGql.createPatientMedicineMutation),
        variables: {'input': patientMedicine.toJson()}));
    print(response);

    if (!response.hasException && response.data != null) {
      return right("");
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
    print("ooooooooooooooooooooooooooooooo");
    print(response);

    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data = response.data!;
      final List<dynamic> items = data['patientMedicines'];

      List<PatientMedicine> medicinesList =
          items.map((json) => PatientMedicine.fromJson(json)).toList();
      if (medicinesList.isEmpty) {
        return left(ServerFailure());
      }

      print(medicinesList.toString());
      return right(medicinesList);
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<PatientMedicalImage>>> getPatientMedicalImages(
    int medicalImageTypeId,
    int patientId,
  ) async {
    final response = await gqlClient.query(QueryOptions(
      document: gql(PatientImagesDocsGql.patientMedicalImagesQuery),
      variables: {
        'medical_image_type_id': medicalImageTypeId,
        'patient_id': patientId,
      },
    ));
    print("responseee");
    print(response);

    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data = response.data!;
      final List<dynamic> items = data['patientMedicalImages'];

      List<PatientMedicalImage> imagesList =
          items.map((json) => PatientMedicalImage.fromJson(json)).toList();

      return right(imagesList);
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> createPatientMedicalImage(
      PatientMedicalImage patientMedicalImage, File image) async {
    final http.MultipartFile multipartFile = http.MultipartFile(
      'image',
      http.ByteStream(Stream.castFrom(image.openRead())),
      await image.length(),
      filename: 'image.jpg',
    );
    final response = await gqlClient.mutate(MutationOptions(
      document: gql(PatientMedicineDocsGql.createPatientMedicineMutation),
      variables: {
        'image': multipartFile,
        'medical_image_type_id': patientMedicalImage.medicalImageTypeId,
        'patient_id': patientMedicalImage.patientId,
        'title': patientMedicalImage.title,
      },
    ));
    print(response);

    if (!response.hasException && response.data != null) {
      return right("Patient medical image created successfully");
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<PatientDiagnosis>>> getPaginatedPatientDiagnoses(
    double itemPerPage,
    double page,
    int patientId,
    int problemTypeId,
  ) async {
    final response = await gqlClient.query(QueryOptions(
      document: gql(PatientDiagnosisDocsGql.patientDiagnosesQuery),
      variables: {
        'item_per_page': itemPerPage,
        'page': page,
        'patient_id': patientId,
        'problem_type_id': problemTypeId,
      },
    ));
    print("diagnosissssssssssssssssssss");
    print(response);

    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data = response.data!['patientDiagnoses'];
      final List<dynamic> items = data['items'];

      List<PatientDiagnosis> diagnosesList =
          items.map((json) => PatientDiagnosis.fromJson(json)).toList();

      return right(diagnosesList);
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, PatientDiagnosis>> createPatientDiagnosis(
    String expectedTreatment,
    int patientId,
    String place,
    int problemId,
  ) async {
    final mutation =
        gql(PatientDiagnosisDocsGql.createPatientDiagnosisMutation);

    final response = await gqlClient.mutate(
      MutationOptions(
        document: mutation,
        variables: {
          'expected_treatment': expectedTreatment,
          'patient_id': patientId,
          'place': place,
          'problem_id': problemId,
        },
      ),
    );

    if (!response.hasException && response.data != null) {
      final Map<String, dynamic> data =
          response.data!['createPatientDiagnosis'];

      final PatientDiagnosis diagnosis = PatientDiagnosis.fromJson(data);
      return right(diagnosis);
    } else {
      return left(ServerFailure());
    }
  }

  Future<List<ProblemTypes>> getProblemTypes() async {
    final response = await gqlClient.query(QueryOptions(
      document: gql(PatientDiagnosisDocsGql.getProblemTypes),
    ));

    if (response.hasException) {
      throw Exception(
          'Error retrieving problem types: ${response.exception.toString()}');
    }

    final List<dynamic> data = response.data!['problemTypes'];

    List<ProblemTypes> problemsList =
        data.map((json) => ProblemTypes.fromJson(json)).toList();

    return problemsList;
  }
}
