import 'package:equatable/equatable.dart';

import '../../data/models/product.dart';
import '../../data/models/stored_product.dart'; // Import your StoredProduct model

abstract class ProductsState extends Equatable {
  // const ProductsState();

  @override
  List<Object> get props => [];
}

class ProductsInitial extends ProductsState {}

class LoadingProductsState extends ProductsState {}

class LoadedProductsState extends ProductsState {
  late final int? totalPages;
  late final List<Product> products; // Use your Products model here

  LoadedProductsState({required this.products, this.totalPages});

  @override
  List<Object> get props => [products];
}

class LoadedStoredProductsState extends ProductsState {
  late final int? totalPages;
  late final List<StoredProduct>
      storedProducts; // Use your StoredProduct model here

  LoadedStoredProductsState({required this.storedProducts, this.totalPages});

  @override
  List<Object> get props => [storedProducts];
}

class ErrorProductsState extends ProductsState {
  late final String message;

  ErrorProductsState({required this.message});

  @override
  List<Object> get props => [message];
}
