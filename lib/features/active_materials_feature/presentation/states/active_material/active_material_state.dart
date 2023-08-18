import 'package:equatable/equatable.dart';
import '../../../data/models/active_material_model.dart';

abstract class ActiveMaterialState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitActiveMaterialState extends ActiveMaterialState {}

class LoadingActiveMaterialState extends ActiveMaterialState {}

class LoadedActiveMaterialState extends ActiveMaterialState {
  late final ActiveMaterialModel material;

  LoadedActiveMaterialState({required this.material});

  @override
  List<Object> get props => [material];
}

class ErrorActiveMaterialState extends ActiveMaterialState {
  late final String message;

  ErrorActiveMaterialState({required this.message});

  @override
  List<Object> get props => [message];
}

class SuccessActiveMaterialState extends ActiveMaterialState {
  late final String message;

  SuccessActiveMaterialState({required this.message});

  @override
  List<Object> get props => [message];
}