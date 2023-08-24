import 'package:equatable/equatable.dart';
import '../../../data/models/session_model.dart';

abstract class SessionsState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitSessionsState extends SessionsState {}

class LoadingSessionsState extends SessionsState {}

class LoadedSessionsState extends SessionsState {
  late final List<SessionModel> sessions;

  LoadedSessionsState({required this.sessions});

  @override
  List<Object> get props => [sessions];
}

class ErrorSessionsState extends SessionsState {
  late final String message;

  ErrorSessionsState({required this.message});

  @override
  List<Object> get props => [message];
}

class SuccessSessionsState extends SessionsState {
  late final String message;

  SuccessSessionsState({required this.message});

  @override
  List<Object> get props => [message];
}