import 'package:clinic_management_system/core/graphql_client_provider.dart';
import 'package:clinic_management_system/features/lab_feature/data/documents/lab_order.dart';
import 'package:clinic_management_system/features/lab_feature/data/models/lab_order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final selectedDate = StateProvider((ref) => DateTime.now());

final selectedLabId = StateProvider((ref) => 1);

final servicesSelect = FutureProvider((ref) async{
  final labId = ref.watch(selectedLabId);
  final gqlClient = ref.read(graphQlClientProvider);
  final response = await gqlClient.query(
      QueryOptions(
      fetchPolicy: FetchPolicy.noCache,
      document: gql(LabOrderDocsGql.getLabOrders),
      variables: {
        'id': labId,
        'itemPerPage': 1000,
        'page': 1,
      },
  ));

  if (!response.hasException && response.data != null) {
    final Map<String, dynamic> data = response.data!['labOrders'];
    final List<dynamic> items = data['items'];

    List<LabOrder> list = items.map((json) => LabOrder.fromJson(json)).toList();

    return list;
  }
});