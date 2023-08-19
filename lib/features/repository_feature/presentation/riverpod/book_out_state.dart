import 'package:clinic_management_system/features/repository_feature/data/models/select_stored_product.dart';
import 'package:clinic_management_system/features/repository_feature/data/models/stored_product.dart';
import 'package:equatable/equatable.dart';

abstract class BookOutState extends Equatable {
  const BookOutState();

  @override
  List<Object?> get props => [];
}

class BookOutInitial extends BookOutState {}

class LoadingStoredProductState extends BookOutState {}

class LoadedSelectStoredProductState extends BookOutState {
  final int? totalPages;
  final List<SelectStoredProduct> storedProducts;

  LoadedSelectStoredProductState(
      {required this.storedProducts, this.totalPages});

  @override
  List<Object?> get props => [storedProducts];
}

class ErrorBookOutState extends BookOutState {
  final String message;

  ErrorBookOutState({required this.message});

  @override
  List<Object?> get props => [message];
}

class MessageBookOutState extends BookOutState {
  final String message;

  MessageBookOutState({required this.message});

  @override
  List<Object?> get props => [message];
}
