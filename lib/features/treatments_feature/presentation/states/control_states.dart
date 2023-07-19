import 'package:clinic_management_system/features/treatments_feature/data/models/treatment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//used to show treatment info
ValueNotifier<TreatmentModel>? selectedTreatment;

//used to manage treatments section's height
final isExpanded = ValueNotifier(true);

//used to control additional text field
final addingType = StateProvider<bool>((ref) => false);

//used to switch type tile into text field
final editingType = StateProvider.family<bool, Key?>((ref, key) => false);