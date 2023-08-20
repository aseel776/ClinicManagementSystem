import 'package:equatable/equatable.dart';

import '../../../diseases_badHabits_teeth/data/models/badHabits.dart';

class PatientBadHabits extends Equatable {
  int? id;
  String? date;
  String? notes;
  BadHabit? badHabit;

  PatientBadHabits({this.id, this.date, this.notes, this.badHabit});

  factory PatientBadHabits.fromJson(Map<String, dynamic> json) {
    final badHabitJson = json['badHabit'];

    return PatientBadHabits(
      id: json['id'],
      date: json['date'],
      notes: json['notes'],
      badHabit: badHabitJson != null ? BadHabit.fromJson(badHabitJson) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'bad_habet_id': id,
    };

    // if (date != null) {
    //   json['date'] = date;
    // }

    if (notes != null) {
      json['notes'] = notes;
    }

    // if (badHabit != null) {
    //   json['badHabit'] = badHabit?.toJson();
    // }

    return json;
  }

  @override
  List<Object?> get props => [id, date, notes, badHabit];
}
