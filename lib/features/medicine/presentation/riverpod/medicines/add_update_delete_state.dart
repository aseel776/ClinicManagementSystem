import 'package:equatable/equatable.dart';

abstract class AddDeleteUpdateMedicinesState extends Equatable {
  const AddDeleteUpdateMedicinesState();

  @override
  List<Object> get props => [];
}

class AddDeleteUpdateMedicinesInitial extends AddDeleteUpdateMedicinesState {}

class LoadingAddDeleteUpdateMedicinesState
    extends AddDeleteUpdateMedicinesState {}

class ErrorAddDeleteUpdateMedicinesState extends AddDeleteUpdateMedicinesState {
  final String message;

  const ErrorAddDeleteUpdateMedicinesState({required this.message});

  @override
  List<Object> get props => [message];
}

class MessageAddDeleteUpdateMedicinesState
    extends AddDeleteUpdateMedicinesState {
  final String message;

  const MessageAddDeleteUpdateMedicinesState({required this.message});

  @override
  List<Object> get props => [message];
}
