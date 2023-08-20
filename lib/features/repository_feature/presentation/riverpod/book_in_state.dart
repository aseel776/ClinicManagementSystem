import 'package:equatable/equatable.dart';
import '../../data/models/book_in.dart';

abstract class BookInsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookInsInitial extends BookInsState {}

class LoadingBookInsState extends BookInsState {}

class LoadedBookInsState extends BookInsState {
  final List<BookIn> bookIns;
  final int? totalPages;

  LoadedBookInsState({required this.bookIns, required this.totalPages});

  @override
  List<Object?> get props => [bookIns];
}

class ErrorBookInsState extends BookInsState {
  final String message;

  ErrorBookInsState({required this.message});

  @override
  List<Object?> get props => [message];
}

class MessageBookInsState extends BookInsState {
  final String message;

  MessageBookInsState({required this.message});

  @override
  List<Object?> get props => [message];
}
