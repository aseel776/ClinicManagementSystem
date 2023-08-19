import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final graphQlClientProvider = StateProvider<GraphQLClient>((ref) {
  final GraphQLClient client = GraphQLClient(
    link: HttpLink('http://localhost:3000/graphql'),
    cache: GraphQLCache(),
  );
  return client;
});
