import 'package:clinic_management_system/features/diseases_badHabits/data/models/badHabits.dart';

class BadHabitsTable {
  List<BadHabit>? badHabits;
  int? totalPages;

  BadHabitsTable({required this.badHabits, this.totalPages});
}
