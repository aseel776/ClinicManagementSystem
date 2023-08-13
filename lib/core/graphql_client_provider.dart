import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final graphQlClientProvider = StateProvider<GraphQLClient>((ref) {
  final GraphQLClient client = GraphQLClient(
    link: HttpLink('https://music-mates-fun.herokuapp.com/graphql'),
    cache: GraphQLCache(),
  );
  return client;
});
