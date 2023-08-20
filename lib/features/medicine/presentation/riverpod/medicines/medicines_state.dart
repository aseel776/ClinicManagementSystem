import 'package:clinic_management_system/features/medicine/data/model/medicine_model.dart';
import 'package:equatable/equatable.dart';

abstract class MedicinesState extends Equatable {
  // const PostsState();

  @override
  List<Object> get props => [];
}

class MedicinesInitial extends MedicinesState {}

class LoadingMedicinesState extends MedicinesState {}

class LoadedMedicinesState extends MedicinesState {
  late final int? totalPages;
  late final List<Medicine> medicines;

  LoadedMedicinesState({required this.medicines, this.totalPages});

  @override
  List<Object> get props => [medicines];
}

class ErrorMedicinesState extends MedicinesState {
  late final String message;

  ErrorMedicinesState({required this.message});

  @override
  List<Object> get props => [message];
}
