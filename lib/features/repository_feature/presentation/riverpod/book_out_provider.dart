import 'package:clinic_management_system/features/repository_feature/data/models/book_in_table.dart';
import 'package:clinic_management_system/features/repository_feature/data/models/select_stored_product.dart';
import 'package:clinic_management_system/features/repository_feature/data/models/stored_product.dart';
import 'package:clinic_management_system/features/repository_feature/data/models/stored_products_table.dart';
import 'package:clinic_management_system/features/repository_feature/data/repository/stored_product_repository.dart';
import 'package:clinic_management_system/features/repository_feature/presentation/riverpod/book_out_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:clinic_management_system/core/error/failures.dart';

import '../../../../core/graphql_client_provider.dart';
import '../../../../core/strings/failures.dart';
import '../../data/models/book_in.dart';
import '../../data/models/book_out.dart';
import '../../data/models/select_stored_product_table.dart';
import '../../data/repository/book_in_repository.dart';

import 'book_in_state.dart';

final bookoutProvider = StateNotifierProvider<BookOutNotifier, BookOutState>(
  (ref) {
    final client = ref.watch(
        graphQlClientProvider); // Replace with your GraphQL client provider
    return BookOutNotifier(client: client);
  },
);

class BookOutNotifier extends StateNotifier<BookOutState> {
  final GraphQLClient client;

  BookOutNotifier({required this.client}) : super(BookOutInitial());
  final StoredProductRepositoryImpl repositoryImpl =
      StoredProductRepositoryImpl(
    GraphQLClient(
      link: HttpLink('http://localhost:3000/graphql'),
      cache: GraphQLCache(),
    ),
  );

  Future<void> getStoredProduct(
      double itemPerPage, double page, int productId) async {
    state = LoadingStoredProductState();
    final response =
        await repositoryImpl.getStoredProduct(itemPerPage, page, productId);
    state = _mapFailureOrBookOutToState(response);
  }

  Future<void> createBookOut(
      int productId, int quantity, List<int> storedProductIds) async {
    state = LoadingStoredProductState();
    final response = await repositoryImpl.createBookOut(
        productId, quantity, storedProductIds);
    state = _mapFailureOrMessageToState(response);
  }

  BookOutState _mapFailureOrBookOutToState(
    Either<Failure, SelectStoredProductsTable> either,
  ) {
    return either.fold(
      (failure) => ErrorBookOutState(message: _mapFailureToMessage(failure)),
      (products) => LoadedSelectStoredProductState(
          storedProducts: products.products!, totalPages: products.totalPages),
    );
  }

  BookOutState _mapFailureOrMessageToState(Either<Failure, String> either) {
    return either.fold(
      (failure) => ErrorBookOutState(message: _mapFailureToMessage(failure)),
      (message) => MessageBookOutState(message: message),
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
