import 'package:clinic_management_system/features/diseases_badHabits/data/models/diseases.dart';

class DiseasesTable {
  List<Disease>? diseases;
  int? totalPages;

  DiseasesTable({required this.diseases, this.totalPages});
}
