import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/step_model.dart';
import './/core/error/failures.dart';
import '..//documents/cud/treatment_mutation.dart';
import '..//documents/get/treatment_query.dart';
import '../models/treatment_model.dart';
import '../models/treatments_page_model.dart';

abstract class TreatmentsRepo {
  Future<Either<Failure, String>> createTreatment(TreatmentModel body);
  Future<Either<Failure, String>> deleteTreatment(int id);
  Future<Either<Failure, TreatmentsPageModel>> getTreatments(int page, int items);
}

class TreatmentsRepoImp extends TreatmentsRepo {
  final GraphQLClient gqlClient;

  TreatmentsRepoImp(this.gqlClient);

  @override
  Future<Either<Failure, String>> createTreatment(TreatmentModel body) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(TreatmentMutation.createTreatment),
        variables: {
          'createTreatmentInput': _createTreatmentInput(body),
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    if (!response.hasException && response.data != null) {
      print('success from creation');
      return right('Created Successfully');
    } else {
      return left(ServerFailure());
    }
  }

  Object _createTreatmentInput(TreatmentModel body){
    Object obj = {
      'name': body.name,
      'color': body.generateStringFromColor(),
      'price': body.price,
      'treatment_type_id': body.type!.id,
      'steps' : body.steps!.map((s) => _createStepInput(s)).toList(),
    };
    return obj;
  }

  Object _createStepInput(StepModel step){
    if(step.subSteps!.isNotEmpty){
      return {
        'name': step.name,
        'subSteps': step.subSteps!.map((e) => _createSubStepInput(e)).toList(),
      };
    } else{
      return {
        'name': step.name,
      };
    }
  }

  Object _createSubStepInput(String name){
    return {
      'name': name
    };
  }

  @override
  Future<Either<Failure, String>> deleteTreatment(int id) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(TreatmentMutation.deleteTreatment),
        variables: {'id': id},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    if (!response.hasException && response.data != null) {
      print('success from delete');
      return right("Deleted Successfully.");
    } else {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, TreatmentsPageModel>> getTreatments(int page, int items) async {
    final response = await gqlClient.query(
      QueryOptions(
        document: gql(TreatmentsQuery.getTreatments),
        variables: {
          'item_per_page': items,
          'page' : page,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    if (!response.hasException && response.data != null) {
      print('success from getTreatments');
      final List<dynamic>? treatmentsData = response.data!['treatments']['items'];
      List<TreatmentModel> treatments = treatmentsData!.map((src) => TreatmentModel.fromJson(src)).toList();
      int currentPage = response.data!['treatments']['page'];
      int totalPages = response.data!['treatments']['totalPages'];
      return right(TreatmentsPageModel(totalPages: totalPages, currentPage: currentPage, treatments: treatments));
    } else {
      return left(ServerFailure());
    }
  }
}