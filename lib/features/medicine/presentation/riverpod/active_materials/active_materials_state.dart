import 'package:clinic_management_system/features/medicine/data/model/active_materials.dart';

import 'package:equatable/equatable.dart';

abstract class ActiveMaterialsState extends Equatable {
  // const PostsState();

  @override
  List<Object> get props => [];
}

class ActiveMaterialsInitial extends ActiveMaterialsState {}

class LoadingActiveMaterialsState extends ActiveMaterialsState {}

class LoadedActiveMaterialsState extends ActiveMaterialsState {
  late final List<ActiveMaterials> materials;

  LoadedActiveMaterialsState({required this.materials});

  @override
  List<Object> get props => [materials];
}

class ErrorActiveMaterialsState extends ActiveMaterialsState {
  late final String message;

  ErrorActiveMaterialsState({required this.message});

  @override
  List<Object> get props => [message];
}
