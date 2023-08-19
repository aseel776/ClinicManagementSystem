import 'package:clinic_management_system/features/diseases_badHabits_teeth/data/models/badHabits.dart';
import 'package:clinic_management_system/features/diseases_badHabits_teeth/data/models/diseases.dart';

class BadHabitsTable {
  List<BadHabit>? badHabits;
  int? totalPages;

  BadHabitsTable({required this.badHabits, this.totalPages});
}
