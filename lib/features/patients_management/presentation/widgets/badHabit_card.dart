import 'package:clinic_management_system/features/medicine/presentation/widgets/primaryText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/badHabits_patient.dart';

class BadHabitCard extends ConsumerWidget {
  final PatientBadHabits patientBadHabits;

  BadHabitCard({required this.patientBadHabits});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.18,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 1, color: Colors.grey.shade600),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Chip(
              backgroundColor: Colors.grey.withOpacity(0.3),
              label: PrimaryText(
                  text: patientBadHabits.badHabit!.id.toString() ?? "",
                  color: Colors.white),
            ),
            const SizedBox(width: 8),
            const SizedBox(width: 8),
            Chip(
              backgroundColor: Colors.blue.withOpacity(0.3),
              label: Text(
                patientBadHabits.badHabit!.name ?? '',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 8),
            Chip(
              backgroundColor: Colors.blue.withOpacity(0.3),
              label: Text(
                patientBadHabits.notes ?? '',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
