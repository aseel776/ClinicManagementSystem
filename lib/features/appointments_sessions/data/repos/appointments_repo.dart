import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import './/core/error/failures.dart';
import '../models/page_model.dart';
import '../models/appointment_model.dart';
import '../documents/cud/appointments_mutation.dart';
import '../documents/get/appointments_query.dart';

abstract class AppointmentsRepo{
  Future<Either<Failure, AppointmentsPage>> getAllAppointments(String date);
  Future<Either<Failure, AppointmentModel>> getAppointment(int id);
  Future<Either<Failure, String>> createAppointment(AppointmentModel app);
  Future<Either<Failure, String>> updateAppointment(AppointmentModel app);
  Future<Either<Failure, String>> deleteAppointment(int id);
}

class AppointmentsRepoImp extends AppointmentsRepo{
  final GraphQLClient gqlClient;

  AppointmentsRepoImp(this.gqlClient);

  @override
  Future<Either<Failure, AppointmentsPage>> getAllAppointments(String date) async{
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(AppointmentsQuery.getAppointments),
        variables: {
          'date': date,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    if(!response.hasException && response.data != null){
      print('success from get all');
      List<dynamic> temp = response.data!['patientAppointments'];
      List<AppointmentModel> apps = temp.map((a) => AppointmentModel.fromJson(a)).toList();
      AppointmentsPage page = AppointmentsPage(date: apps[0].time, appointments: apps);
      return right(page);
    } else{
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> createAppointment(AppointmentModel app) async{
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(AppointmentsMutation.createAppointment),
        variables: {
          'createPatientAppointmentInput': app.reserveId != null
              ? {
            'date': app.time.toString(),
            'notes': app.notes?? '',
            // 'patient_id': app.patient.id
            'patient_id': 1,
            'phase': app.nextPhase?? '',
            'place': app.place?? '',
            'type': app.type,
            'reservation_id': app.reserveId,
          }
          : {
            'date': app.time.toString(),
            'notes': app.notes ?? '',
            // 'patient_id': app.patient.id
            'patient_id': 1,
            'phase': app.nextPhase ?? '',
            'place': app.place ?? '',
            'type': app.type,
          },
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if(!response.hasException && response.data != null){
      print('success from creation');
      return right('Created Successfully');
    }else{
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteAppointment(int id) async{
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(AppointmentsMutation.deleteAppointment),
        variables: {
          'id': id,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (!response.hasException && response.data != null) {
      print('success from delete');
      return right('Created Successfully');
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, AppointmentModel>> getAppointment(int id) async{
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(AppointmentsQuery.getAppointment),
        variables: {
          'id': id,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    if (!response.hasException && response.data != null) {
      print('success from get app');
      final appData = response.data!['patientAppointment'];
      return right(AppointmentModel.fromJson(appData));
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> updateAppointment(AppointmentModel app) async{
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(AppointmentsMutation.updateAppointment),
        variables: {
          'updatePatientAppointment': app.reserveId != null
              ? {
            'id': app.id,
            'date': app.time.toString(),
            'notes': app.notes ?? '',
            // 'patient_id': app.patient.id
            'patient_id': 1,
            'phase': app.nextPhase ?? '',
            'place': app.place ?? '',
            'type': app.type,
            'reservation_id': app.reserveId,
          }
              : {
            'id': app.id,
            'date': app.time.toString(),
            'notes': app.notes ?? '',
            // 'patient_id': app.patient.id
            'patient_id': 1,
            'phase': app.nextPhase ?? '',
            'place': app.place ?? '',
            'type': app.type,
          },
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (!response.hasException && response.data != null) {
      print('success from update');
      return right('Updated Successfully');
    } else {
      return left(ServerFailure());
    }
  }
}