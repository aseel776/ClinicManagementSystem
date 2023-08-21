import 'package:clinic_management_system/features/appointments_sessions/data/documents/get/patient_treatments_query.dart';
import 'package:clinic_management_system/features/appointments_sessions/data/models/patient_treatment_model.dart';
import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import './/core/error/failures.dart';

abstract class PatientTreatmentsRepo {
  Future<Either<Failure, List<PatientTreatmentModel>>> getOngoingPatientTreatments(int patientId);
  Future<Either<Failure, List<PatientTreatmentModel>>> getAllPatientTreatments(int patientId);
  Future<Either<Failure, PatientTreatmentModel>> getPatientTreatment(int treatId);
}

class PatientTreatmentsRepoImp extends PatientTreatmentsRepo {
  final GraphQLClient gqlClient;

  PatientTreatmentsRepoImp(this.gqlClient);

  @override
  Future<Either<Failure, List<PatientTreatmentModel>>> getOngoingPatientTreatments(int patientId) async {
    print(1);
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(PatientTreatmentsQuery.getOngoingPatientTreatments),
        variables: {
          'patient_id': patientId,
          'status': 'ongoing',
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    if (!response.hasException && response.data != null) {
      print('success from get ongoing');
      List<dynamic> temp = response.data!['patientTreatments'];
      List<PatientTreatmentModel> treatments = temp.map((a) => PatientTreatmentModel.fromJson(a)).toList();
      return right(treatments);
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<PatientTreatmentModel>>> getAllPatientTreatments(int patientId) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(PatientTreatmentsQuery.getAllPatientTreatments),
        variables: {
          'patient_id': patientId,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    if (!response.hasException && response.data != null) {
      print('success from get all');
      List<dynamic> temp = response.data!['patientTreatments'];
      List<PatientTreatmentModel> treatments = temp.map((a) =>
          PatientTreatmentModel.fromJson(a)).toList();
      return right(treatments);
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, PatientTreatmentModel>> getPatientTreatment(int treatId) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(PatientTreatmentsQuery.getPatientTreatment),
        variables: {
          'id': treatId,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    if (!response.hasException && response.data != null) {
      print('success from get patient treatment');
      final temp = response.data!['patientTreatment'];
      return right(PatientTreatmentModel.fromJson(temp));
    } else {
      return left(ServerFailure());
    }
  }

}