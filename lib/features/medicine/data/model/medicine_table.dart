import 'package:clinic_management_system/features/diseases_badHabits_teeth/data/models/diseases.dart';
import 'package:clinic_management_system/features/medicine/data/model/medicine_model.dart';

class MedicinesTable {
  List<Medicine>? medicinesList;
  int? totalPages;

  MedicinesTable({required this.medicinesList, this.totalPages});
}
