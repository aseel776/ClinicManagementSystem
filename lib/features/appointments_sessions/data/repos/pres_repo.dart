import 'package:clinic_management_system/features/appointments_sessions/data/documents/get/pres_query.dart';
import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import './/core/error/failures.dart';

abstract class PresRepo {
  Future<Either<Failure, List<String>>> getConflicts(List<int> medsIds, int patientId);
}

class PresRepoImp extends PresRepo {
  final GraphQLClient gqlClient;

  PresRepoImp(this.gqlClient);

  @override
  Future<Either<Failure, List<String>>> getConflicts(List<int> medsIds, int patientId) async {
    List<String> allConflicts = [];
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(PresQuery.getConflicts),
        variables: {
          'medicine_ids': medsIds,
          'profile_id': patientId
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    if (!response.hasException && response.data != null) {
      print('success from get conflicts');
      dynamic temp = response.data!['checkConflictsForPerscriptionMedicines'];
      bool hasConflicts = temp['bool'];
      if (hasConflicts) {
        List<dynamic> badHabitsConflicts = temp['bad_habit_medicine'];
        for (dynamic element in badHabitsConflicts) {
          List<dynamic> conflicts = element['conflict_in_chemicals'];
          allConflicts = [...allConflicts, ...conflicts];
        }
        List<dynamic> diseasesConflicts = temp['disease_medicine'];
        for (dynamic element in diseasesConflicts) {
          List<dynamic> conflicts = element['conflict_in_chemicals'];
          allConflicts = [...allConflicts, ...conflicts];
        }
        List<dynamic> medsConflicts = temp['prescription_medicines'];
          for (dynamic element in medsConflicts) {
            List<dynamic> conflicts = element['message'];
            allConflicts = [...allConflicts, ...conflicts];
          }
        List<dynamic> presConflicts = temp['prescription_patient_medicine'];
        for (dynamic list in presConflicts) {
          for (dynamic element in list) {
            List<dynamic> conflicts = element['message'];
            allConflicts = [...allConflicts, ...conflicts];
          }
        }
      }
      return right(allConflicts);
    } else {
      return left(ServerFailure());
    }
  }

}