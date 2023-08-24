import 'package:clinic_management_system/features/appointments_sessions/data/documents/get/reservation_query.dart';
import 'package:clinic_management_system/features/appointments_sessions/data/models/reservation_model.dart';
import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import './/core/error/failures.dart';
import '../models/page_model.dart';
import '../models/appointment_model.dart';
import '../documents/cud/appointments_mutation.dart';
import '../documents/get/appointments_query.dart';

abstract class AppointmentsRepo {
  Future<Either<Failure, AppointmentsPage>> getAllAppointments(String date);
  Future<Either<Failure, AppointmentModel>> getAppointment(int id);
  Future<Either<Failure, String>> createAppointment(AppointmentModel app);
  Future<Either<Failure, String>> updateAppointment(AppointmentModel app);
  Future<Either<Failure, String>> deleteAppointment(int id);
}

class AppointmentsRepoImp extends AppointmentsRepo {
  final GraphQLClient gqlClient;

  AppointmentsRepoImp(this.gqlClient);

  @override
  Future<Either<Failure, AppointmentsPage>> getAllAppointments(
      String date) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(AppointmentsQuery.getAppointments),
        variables: {
          'date': date,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    if (!response.hasException && response.data != null) {
      print('success from get all');
      List<dynamic> temp = response.data!['patientAppointments'];
      List<AppointmentModel> apps =
          temp.map((a) => AppointmentModel.fromJson(a)).toList();
      AppointmentsPage page =
          AppointmentsPage(date: DateTime.tryParse(date), appointments: apps);
      return right(page);
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> createAppointment(
      AppointmentModel app) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(AppointmentsMutation.createAppointment),
        variables: {
          'createPatientAppointmentInput': app.reserveId != null
              ? {
                  'date': app.time.toString(),
                  'notes': app.notes ?? '',
                  'patient_id': app.patient!.id,
                  'phase': app.nextPhase ?? '',
                  'place': app.place ?? '',
                  'type': app.type,
                  'reservation_id': app.reserveId,
                }
              : {
                  'date': app.time.toString(),
                  'notes': app.notes ?? '',
                  'patient_id': app.patient!.id,
                  'phase': app.nextPhase ?? '',
                  'place': app.place ?? '',
                  'type': app.type,
                },
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    print('----------------------------');
    print(response);
    if (!response.hasException && response.data != null) {
      print('success from creation');
      return right('Created Successfully');
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteAppointment(int id) async {
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
  Future<Either<Failure, AppointmentModel>> getAppointment(int id) async {
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
  Future<Either<Failure, String>> updateAppointment(
      AppointmentModel app) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(AppointmentsMutation.updateAppointment),
        variables: {
          'updatePatientAppointmentInput': app.reserveId != null
              ? {
                  'id': app.id,
                  'date': app.time.toString(),
                  'notes': app.notes ?? '',
                  'patient_id': app.patient!.id,
                  'phase': app.nextPhase ?? '',
                  'place': app.place ?? '',
                  'type': app.type,
                  'reservation_id': app.reserveId,
                }
              : {
                  'id': app.id,
                  'date': app.time.toString(),
                  'notes': app.notes ?? '',
                  'patient_id': app.patient!.id,
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

  Future<Either<Failure, List<ReservationModel>>> getAllReservations() async {
    try {
      final response = await gqlClient.query(
        QueryOptions(
          document: gql(ReservationDocsGql.getReservationQuery),
          fetchPolicy: FetchPolicy.noCache,
        ),
      );
      print("response");
      print(response);

      if (!response.hasException && response.data != null) {
        List<dynamic> temp = response.data!['patientReservations'];
        List<ReservationModel> apps =
            temp.map((a) => ReservationModel.fromJson(a)).toList();
        // ReservationModel page =
        //     ReservationModel(date: DateTime.tryParse(date), appointments: apps);
        return right(apps); // Return success response
      } else {
        return left(ServerFailure()); // Return failure response
      }
    } catch (e) {
      return left(
          ServerFailure()); // Return failure response in case of an exception
    }
  }

  @override
  Future<Either<Failure, String>> deleteReservations(int id) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(ReservationDocsGql.deleteReservations),
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
}
