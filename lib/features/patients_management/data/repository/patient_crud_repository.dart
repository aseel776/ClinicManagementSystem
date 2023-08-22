import 'dart:io';

import 'package:clinic_management_system/features/patients_management/data/documents/create_patients.dart';
import 'package:clinic_management_system/features/patients_management/data/documents/patient_badHabits.dart';
import 'package:clinic_management_system/features/patients_management/data/documents/patient_costs.dart';
import 'package:clinic_management_system/features/patients_management/data/documents/patient_diagnosis.dart';
import 'package:clinic_management_system/features/patients_management/data/documents/patient_diseases.dart';
import 'package:clinic_management_system/features/patients_management/data/documents/patient_medicines.dart';
import 'package:clinic_management_system/features/patients_management/data/documents/patient_payments.dart';
import 'package:clinic_management_system/features/patients_management/data/models/badHabits_patient.dart';
import 'package:clinic_management_system/features/patients_management/data/models/diseases_patient.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient_cost.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient_diagnosis.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient_payments.dart';
import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../core/error/failures.dart';
import '../documents/patient_images.dart';
import '../models/medicines_intake.dart';
import '../models/patient_medical_images.dart';
import 'package:http/http.dart' as http;

abstract class PatientsCrudRespository {
  Future<Either<Failure, Patient>> createNewPatient(Patient patient);
  Future<Either<Failure, String>> createNewPatientDiseases(
      PatientDiseases patientdisease, int patientId);
  Future<Either<Failure, String>> createNewPatientBadHabits(
      PatientBadHabits patientbadHabits, int patientId);
  Future<Either<Failure, String>> createNewPatientMedicines(
      PatientMedicine patientMedicine, int patientId);

  Future<Either<Failure, String>> createNewPatientPaymentss(
      PatientPayment patientPayments, int patientId);
  Future<Either<Failure, String>> createNewPatientCosts(
      PatientCost patientCost, int patientId);
  Future<Either<Failure, String>> createPatientMedicalImage(
      PatientMedicalImage patientMedicalImage, File image);
  Future<Either<Failure, String>> deletePatientDiagnosis(int? id);
  Future<Either<Failure, String>> editPatientDiagnosis(
      PatientDiagnosis patientDiagnosis);
}

class PatientsCrudRepositoryImpl implements PatientsCrudRespository {
  final GraphQLClient gqlClient;

  PatientsCrudRepositoryImpl(this.gqlClient);
  @override
  Future<Either<Failure, Patient>> createNewPatient(Patient patient) async {
    print("tojson:" + patient.toJson().toString());
    final response = await gqlClient.mutate(MutationOptions(
      document: gql(CreatePatientsDocsGql.createPatient),
      variables: {
        'input': patient.toJson(),
      },
    ));

    if (!response.hasException && response.data != null) {
      print(response.data);
      final Map<String, dynamic> data = response.data!['createPatient'];

      Patient newPatient = Patient.fromJson(data);

      return right(newPatient);
    } else {
      print('GraphQL Error: ${response.exception}');
      return left(ServerFailure());
    }
  }

  // Future<Either<Failure, Patient>> createNewPatientBadHabits(
  //     Patient patient) async {
  //   print("tojson:" + patient.toJson().toString());
  //   final response = await gqlClient.mutate(MutationOptions(
  //     document: gql(PatientBadHabitsDocsGql.createPatientBadHabitMutation),
  //     variables: {
  //       'input': patient.toJson(),
  //     },
  //   ));

  //   if (!response.hasException && response.data != null) {
  //     print(response.data);
  //     final Map<String, dynamic> data = response.data!['createPatientDiseases'];

  //     Patient newPatient = Patient.fromJson(data);

  //     return right(newPatient);
  //   } else {
  //     print('GraphQL Error: ${response.exception}');
  //     return left(ServerFailure());
  //   }
  // }
  @override
  Future<Either<Failure, String>> createPatientMedicalImage(
      PatientMedicalImage patientMedicalImage, File image) async {
    var byteData = image.readAsBytesSync();

    final http.MultipartFile multipartFile = http.MultipartFile(
      'image',
      http.ByteStream(Stream.castFrom(image.openRead())),
      await image.length(),
      filename: 'image.jpg',
    );

    final response = await gqlClient.mutate(MutationOptions(
      document: gql(PatientImagesDocsGql.createPatientMedicalImageMutation),
      variables: {
        'image': image,
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

  Future<Either<Failure, String>> createNewPatientDiseases(
      PatientDiseases patientdisease, int patientId) async {
    print("tojson:" + patientdisease.toJson().toString());
    print(patientdisease.date);
    final response = await gqlClient.mutate(MutationOptions(
      document: gql(PatientDiseasesDocsGql.createPatientDiseaseMutation),
      variables: {
        'diseaseId': patientdisease.disease!.id,
        'notes': patientdisease.notes,
        'patientId': patientId,
        'startDate': patientdisease.date,
        'tight': patientdisease.controlled,
      },
    ));
    print(response);

    if (!response.hasException && response.data != null) {
      print(response.data);
      final Map<String, dynamic> data = response.data!['createPatientDisease'];

      return right("");
    } else {
      print('GraphQL Error: ${response.exception}');
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> createNewPatientBadHabits(
      PatientBadHabits patientbadHabits, int patientId) async {
    print("tojson:" + patientbadHabits.toJson().toString());
    print(patientbadHabits.date);
    final response = await gqlClient.mutate(MutationOptions(
      document: gql(PatientBadHabitsDocsGql.createPatientBadHabitMutation),
      variables: {
        'badHabitId': patientbadHabits.badHabit!.id,
        'notes': patientbadHabits.notes,
        'patientId': patientId,
        'startDate': patientbadHabits.date,
      },
    ));
    print(response);

    if (!response.hasException && response.data != null) {
      print(response.data);
      final Map<String, dynamic> data = response.data!['createPatientBadHabit'];

      return right("");
    } else {
      print('GraphQL Error: ${response.exception}');
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> createNewPatientMedicines(
      PatientMedicine patientMedicine, int patientId) async {
    print("tojson:" + patientMedicine.toJson().toString());
    // print(patientMedicine.date);
    final response = await gqlClient.mutate(MutationOptions(
      document: gql(PatientMedicineDocsGql.createPatientMedicineMutation),
      variables: {
        'medicine_id': patientMedicine.medicine!.id,
        'notes': patientMedicine.notes,
        'patient_id': patientId,
        'start_date': patientMedicine.date,
      },
    ));
    print(response);

    if (!response.hasException && response.data != null) {
      print(response.data);
      final Map<String, dynamic> data = response.data!['createPatientBadHabit'];

      return right("");
    } else {
      print('GraphQL Error: ${response.exception}');
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> createNewPatientPaymentss(
      PatientPayment patientPayments, int patientId) async {
    print("tojson:" + patientPayments.toJson().toString());
    final response = await gqlClient.mutate(MutationOptions(
      document: gql(PatientPaymentsDocsGql.createPaymentmutation),
      variables: {
        'amount': patientPayments.amount,
        'date': patientPayments.date,
        'patient_id': patientId,
      },
    ));
    print(response);

    if (!response.hasException && response.data != null) {
      print(response.data);
      final Map<String, dynamic> data = response.data!['createPatientPayment'];

      return right("");
    } else {
      print('GraphQL Error: ${response.exception}');
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> createNewPatientCosts(
      PatientCost patientCost, int patientId) async {
    print("tojson:" + patientCost.toJson().toString());
    final response = await gqlClient.mutate(MutationOptions(
      document: gql(PatientCostsDocsGql.createCosts),
      variables: <String, dynamic>{
        'input': {
          'amount': patientCost.amount,
          'date': patientCost.date,
          'patient_id': patientId,
          'treatment_id': patientCost.treatment,
        },
      },
    ));

    print(response);

    if (!response.hasException && response.data != null) {
      print(response.data);
      final Map<String, dynamic> data = response.data!['createPatientCost'];

      return right("");
    } else {
      print('GraphQL Error: ${response.exception}');
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> createNewPatientDiagnosis(
      PatientDiagnosis patientDiagnosis) async {
    print("tojson:" + patientDiagnosis.toJson().toString());
    final response = await gqlClient.mutate(MutationOptions(
      document: gql(PatientDiagnosisDocsGql.createPatientDiagnosisMutation),
      variables: <String, dynamic>{
        'expected_treatment': patientDiagnosis.expectedTreatment,
        'patient_id': patientDiagnosis.patientId,
        'place': patientDiagnosis.place,
        'problem_id': patientDiagnosis.problemId,
      },
    ));

    print(response);

    if (!response.hasException && response.data != null) {
      print(response.data);
      final Map<String, dynamic> data =
          response.data!['createPatientDiagnosis'];

      return right("");
    } else {
      print('GraphQL Error: ${response.exception}');
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> editPatientDiagnosis(
      PatientDiagnosis patientDiagnosis) async {
    print("tojson:" + patientDiagnosis.toJson().toString());
    final response = await gqlClient.mutate(MutationOptions(
      document: gql(PatientDiagnosisDocsGql.updatePatientDiagnosisMutation),
      variables: <String, dynamic>{
        'expected_treatment': patientDiagnosis.expectedTreatment,
        'patient_id': patientDiagnosis.patientId,
        'place': patientDiagnosis.place,
        'problem_id': patientDiagnosis.problemId,
      },
    ));

    print(response);

    if (!response.hasException && response.data != null) {
      print(response.data);
      final Map<String, dynamic> data =
          response.data!['updatePatientDiagnosis'];

      return right("");
    } else {
      print('GraphQL Error: ${response.exception}');
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deletePatientDiagnosis(int? id) async {
    final response = await gqlClient.mutate(MutationOptions(
      document: gql(PatientDiagnosisDocsGql.removePatientDiagnosisMutation),
      variables: <String, dynamic>{'id': id},
    ));

    print(response);

    if (!response.hasException && response.data != null) {
      print(response.data);
      final Map<String, dynamic> data =
          response.data!['updatePatientDiagnosis'];

      return right("");
    } else {
      print('GraphQL Error: ${response.exception}');
      return left(ServerFailure());
    }
  }
}
