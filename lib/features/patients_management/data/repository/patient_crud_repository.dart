import 'package:clinic_management_system/features/patients_management/data/documents/create_patients.dart';
import 'package:clinic_management_system/features/patients_management/data/documents/patient_badHabits.dart';
import 'package:clinic_management_system/features/patients_management/data/documents/patient_diseases.dart';
import 'package:clinic_management_system/features/patients_management/data/models/diseases_patient.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient.dart';
import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../core/error/failures.dart';

abstract class PatientsCrudRespository {
  Future<Either<Failure, Patient>> createNewPatient(Patient patient);
  Future<Either<Failure, String>> createNewPatientDiseases(
      PatientDiseases patientdisease);
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

  Future<Either<Failure, Patient>> createNewPatientBadHabits(
      Patient patient) async {
    print("tojson:" + patient.toJson().toString());
    final response = await gqlClient.mutate(MutationOptions(
      document: gql(PatientBadHabitsDocsGql.createPatientBadHabitMutation),
      variables: {
        'input': patient.toJson(),
      },
    ));

    if (!response.hasException && response.data != null) {
      print(response.data);
      final Map<String, dynamic> data = response.data!['createPatientDiseases'];

      Patient newPatient = Patient.fromJson(data);

      return right(newPatient);
    } else {
      print('GraphQL Error: ${response.exception}');
      return left(ServerFailure());
    }
  }

  Future<Either<Failure, String>> createNewPatientDiseases(
      PatientDiseases patientdisease) async {
    print("tojson:" + patientdisease.toJson().toString());
    final response = await gqlClient.mutate(MutationOptions(
      document: gql(PatientDiseasesDocsGql.createPatientDiseaseMutation),
      variables: {
        'input': patientdisease.toJson(),
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
}
