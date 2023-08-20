import 'package:clinic_management_system/features/patients_management/data/documents/create_patients.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient.dart';
import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../core/error/failures.dart';

abstract class PatientsCrudRespository {
  Future<Either<Failure, Patient>> createNewPatient(Patient patient);
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
}
