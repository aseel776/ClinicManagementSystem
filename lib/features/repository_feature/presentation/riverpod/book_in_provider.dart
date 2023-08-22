import 'package:clinic_management_system/features/repository_feature/data/models/book_in_table.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:clinic_management_system/core/error/failures.dart';

import '../../../../core/graphql_client_provider.dart';
import '../../../../core/strings/failures.dart';
import '../../data/models/book_in.dart';
import '../../data/repository/book_in_repository.dart';

import 'book_in_state.dart';

final bookInsProvider = StateNotifierProvider<BookInsNotifier, BookInsState>(
  (ref) {
    final client = ref.watch(
        graphQlClientProvider); // Replace with your GraphQL client provider
    return BookInsNotifier(client: client);
  },
);

class BookInsNotifier extends StateNotifier<BookInsState> {
  final GraphQLClient client;

  BookInsNotifier({required this.client}) : super(BookInsInitial());
  final ProductRepositoryImpl repositoryImpl = ProductRepositoryImpl(
    GraphQLClient(
      link: HttpLink('http://localhost:3000/graphql'),
      cache: GraphQLCache(),
    ),
  );

  Future<void> getPaginatedBookIns(
      double itemPerPage, double page, int product_id) async {
    state = LoadingBookInsState();
    final response =
        await repositoryImpl.getPaginatedBookIns(itemPerPage, page, product_id);
    state = _mapFailureOrBookInsToState(response);
  }

  Future<void> createBookIn(
      String expirationDate, int price, int quantity, int productId) async {
    state = LoadingBookInsState();
    final response = await repositoryImpl.createBookIn(
        expirationDate, price, quantity, productId);
    state = _mapFailureOrMessageToState(response);
  }

  BookInsState _mapFailureOrBookInsToState(
    Either<Failure, BookInTable> either,
  ) {
    return either.fold(
      (failure) => ErrorBookInsState(message: _mapFailureToMessage(failure)),
      (bookIns) => LoadedBookInsState(
          bookIns: bookIns.bookIns, totalPages: bookIns.totalPages),
    );
  }

  BookInsState _mapFailureOrMessageToState(Either<Failure, String> either) {
    return either.fold(
      (failure) => ErrorBookInsState(message: _mapFailureToMessage(failure)),
      (message) => MessageBookInsState(message: message),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case EmptyCacheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return "Unexpected Error, Please try again later.";
    }
  }
}
