import 'package:clinic_management_system/core/error/failures.dart';
import 'package:clinic_management_system/features/repository_feature/data/models/products_table.dart';
import 'package:clinic_management_system/features/repository_feature/data/models/stored_products_table.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../core/graphql_client_provider.dart';
import '../../../../../core/strings/failures.dart';

import '../../data/repository/products_repository.dart';
import 'products_state.dart';

final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>(
  (ref) {
    GraphQLClient client = ref.watch(graphQlClientProvider);
    return ProductsNotifier(client: client);
  },
);


class ProductsNotifier extends StateNotifier<ProductsState> {
  GraphQLClient client;
  ProductsNotifier({required this.client}) : super(ProductsInitial());

  late final ValueNotifier<GraphQLClient> clientNotifier =
      ValueNotifier<GraphQLClient>(client);

  // Initialize repository to call the functions
  final ProductRepositoryImpl repositoryImpl = ProductRepositoryImpl(
    GraphQLClient(
      link: HttpLink('http://localhost:3000/graphql'),
      cache: GraphQLCache(),
    ),
  );

  Future<void> getPaginatedProducts(double itemPerPage, double page) async {
    state = LoadingProductsState();
    final response =
        await repositoryImpl.getPaginatedProducts(itemPerPage, page);
    state = _mapFailureOrProductsToState(response);
  }

  Future<void> getPaginatedStoredProducts(
      double itemPerPage, double page) async {
    state = LoadingProductsState();
    final response =
        await repositoryImpl.getPaginatedStoredProducts(itemPerPage, page);
    state = _mapFailureOrProductsToState(response);
  }

  ProductsState _mapFailureOrProductsToState(Either<Failure, dynamic> either) {
    return either.fold(
      (failure) => ErrorProductsState(message: _mapFailureToMessage(failure)),
      (data) {
        if (data is ProductsTable) {
          return LoadedProductsState(
            products: data.products!,
            totalPages: data.totalPages,
          );
        } else if (data is StoredProductsTable) {
          return LoadedStoredProductsState(
            storedProducts: data.products!,
            totalPages: data.totalPages,
          );
        } else {
          throw Exception("Unsupported data type");
        }
      },
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
