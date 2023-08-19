import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/graphql_client_provider.dart';
import '../../../../core/strings/failures.dart';
import '../../data/models/product.dart';
import '../../data/repository/products_repository.dart';
import 'products_crud_state.dart';

final productsCrudProvider =
    StateNotifierProvider<ProductCrudNotifier, AddDeleteUpdateProductState>(
  (ref) {
    GraphQLClient client = ref.watch(graphQlClientProvider);
    return ProductCrudNotifier(client: client);
  },
);

class ProductCrudNotifier extends StateNotifier<AddDeleteUpdateProductState> {
  GraphQLClient client;
  ProductCrudNotifier({required this.client})
      : super(AddDeleteUpdateProductInitial());

  late final ValueNotifier<GraphQLClient> clientNotifier =
      ValueNotifier<GraphQLClient>(client);

  // Initialize repository to call the functions
  final ProductRepositoryImpl repositoryImpl = ProductRepositoryImpl(
    GraphQLClient(
      link: HttpLink('http://localhost:3000/graphql'),
      cache: GraphQLCache(),
    ),
  );

  Future<AddDeleteUpdateProductState> addNewProduct(Product product) async {
    state = LoadingAddDeleteUpdateProductState();
    final response = await repositoryImpl.addNewProduct(product);
    AddDeleteUpdateProductState newState =
        _mapFailureOrProductToState(response);
    state = newState;
    return state;
  }

  Future<AddDeleteUpdateProductState> editProduct(Product product) async {
    state = LoadingAddDeleteUpdateProductState();
    final response = await repositoryImpl.editProduct(product);
    AddDeleteUpdateProductState newState =
        _mapFailureOrProductToState(response);
    state = newState;
    return state;
  }

  Future<AddDeleteUpdateProductState> deleteProduct(Product product) async {
    state = LoadingAddDeleteUpdateProductState();
    final response = await repositoryImpl.deleteProduct(product);
    AddDeleteUpdateProductState newState =
        _mapFailureOrProductToState(response);
    state = newState;
    return state;
  }

  AddDeleteUpdateProductState _mapFailureOrProductToState(
    Either<Failure, String> either,
  ) {
    return either.fold(
      (failure) => ErrorAddDeleteUpdateProductState(
          message: _mapFailureToMessage(failure)),
      (msg) => MessageAddDeleteUpdateProductState(message: msg),
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
