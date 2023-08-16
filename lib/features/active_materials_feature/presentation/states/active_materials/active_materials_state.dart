import 'package:equatable/equatable.dart';
import '../../../data/models/materials_pagination_model.dart';

abstract class ActiveMaterialsState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitActiveMaterialsState extends ActiveMaterialsState {}

class LoadingActiveMaterialsState extends ActiveMaterialsState {}

class LoadedActiveMaterialsState extends ActiveMaterialsState {
  late final MaterialsPaginationModel page;

  LoadedActiveMaterialsState({required this.page});

  @override
  List<Object> get props => [page];
}

class ErrorActiveMaterialsState extends ActiveMaterialsState {
  late final String message;

  ErrorActiveMaterialsState({required this.message});

  @override
  List<Object> get props => [message];
}