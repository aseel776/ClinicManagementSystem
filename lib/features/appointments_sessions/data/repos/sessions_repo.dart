import 'package:clinic_management_system/features/appointments_sessions/data/documents/cud/sessions_mutation.dart';
import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import './/core/error/failures.dart';
import '../models/page_model.dart';
import '../models/session_model.dart';

abstract class SessionsRepo {
  // Future<Either<Failure, List<SessionModel>>> getAllSessions(int id);
  //
  // Future<Either<Failure, SessionModel>> getSession(int id);
  //
  Future<Either<Failure, String>> createSession(SessionModel session);
  //
  // Future<Either<Failure, String>> updateSession(SessionModel session);
  //
  // Future<Either<Failure, String>> deleteSession(int id);
}

class SessionsRepoImp extends SessionsRepo {
  final GraphQLClient gqlClient;

  SessionsRepoImp(this.gqlClient);

  // @override
  // Future<Either<Failure, SessionsPage>> getAllSessions(String date) async {
  //   final response = await gqlClient.query(
  //     QueryOptions(
  //       document: gql(SessionsQuery.getSessions),
  //       variables: {
  //         'date': date,
  //       },
  //       fetchPolicy: FetchPolicy.noCache,
  //     ),
  //   );
  //   if (!response.hasException && response.data != null) {
  //     print('success from get all');
  //     List<dynamic> temp = response.data!['patientSessions'];
  //     List<SessionModel> sessions =
  //     temp.map((s) => SessionModel.fromJson(s)).toList();
  //     SessionsPage page = SessionsPage(
  //       date: DateTime.tryParse(date),
  //       sessions: sessions,
  //     );
  //     return right(page);
  //   } else {
  //     return left(ServerFailure());
  //   }
  // }
  //
  @override
  Future<Either<Failure, String>> createSession(SessionModel session) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(SessionsMutation.createSession),
        variables: {
          'createPatientSessionInput': session.toJson(),
          },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    print(response);

    if (!response.hasException && response.data != null) {
      print('success from session creation');
      return right('Created Successfully');
    } else {
      return left(ServerFailure());
    }
  }
  //
  // @override
  // Future<Either<Failure, String>> deleteSession(int id) async {
  //   final response = await gqlClient.query(
  //     QueryOptions(
  //       document: gql(SessionsMutation.deleteSession),
  //       variables: {
  //         'id': id,
  //       },
  //       fetchPolicy: FetchPolicy.noCache,
  //     ),
  //   );
  //
  //   if (!response.hasException && response.data != null) {
  //     print('success from delete');
  //     return right('Deleted Successfully');
  //   } else {
  //     return left(ServerFailure());
  //   }
  // }
  //
  // @override
  // Future<Either<Failure, SessionModel>> getSession(int id) async {
  //   final response = await gqlClient.query(
  //     QueryOptions(
  //       document: gql(SessionsQuery.getSession),
  //       variables: {
  //         'id': id,
  //       },
  //       fetchPolicy: FetchPolicy.noCache,
  //     ),
  //   );
  //   if (!response.hasException && response.data != null) {
  //     print('success from get session');
  //     final sessionData = response.data!['patientSession'];
  //     return right(SessionModel.fromJson(sessionData));
  //   } else {
  //     return left(ServerFailure());
  //   }
  // }
  //
  // @override
  // Future<Either<Failure, String>> updateSession(SessionModel session) async {
  //   final response = await gqlClient.query(
  //     QueryOptions(
  //       document: gql(SessionsMutation.updateSession),
  //       variables: {
  //         'updatePatientSessionInput': session.reserveId != null
  //             ? {
  //           'id': session.id,
  //           'date': session.time.toString(),
  //           'notes': session.notes ?? '',
  //           'patient_id': session.patient!.id,
  //           'phase': session.nextPhase ?? '',
  //           'place': session.place ?? '',
  //           'type': session.type,
  //           'reservation_id': session.reserveId,
  //         }
  //             : {
  //           'id': session.id,
  //           'date': session.time.toString(),
  //           'notes': session.notes ?? '',
  //           'patient_id': session.patient!.id,
  //           'phase': session.nextPhase ?? '',
  //           'place': session.place ?? '',
  //           'type': session.type,
  //         },
  //       },
  //       fetchPolicy: FetchPolicy.noCache,
  //     ),
  //   );
  //
  //   if (!response.hasException && response.data != null) {
  //     print('success from update');
  //     return right('Updated Successfully');
  //   } else {
  //     return left(ServerFailure());
  //   }
  // }
}