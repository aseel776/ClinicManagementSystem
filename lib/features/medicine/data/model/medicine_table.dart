import 'package:clinic_management_system/features/medicine/data/model/medicine_model.dart';

class MedicinesTable {
  List<Medicine>? medicinesList;
  int? totalPages;

  MedicinesTable({required this.medicinesList, this.totalPages});
}
