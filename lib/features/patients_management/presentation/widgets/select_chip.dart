import 'dart:math';
import 'package:clinic_management_system/features/patients_management/data/models/medicines_intake.dart';
import 'package:clinic_management_system/features/patients_management/presentation/widgets/step3_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MultiSelectChip extends ConsumerWidget {
  Map<int, Color> chipColors = {};
  final int? maxSelection;
  List<PatientMedicine?> medicines;

  MultiSelectChip({this.maxSelection, required this.medicines});

  Color getRandomColor() {
    Random random = Random();
    int r = random.nextInt(256);
    int g = random.nextInt(256);
    int b = random.nextInt(256);
    return Color.fromARGB(155, r, g, b);
  }

  _buildChoiceList(WidgetRef ref) {
    final l = ref.watch(selectedMedicines);
    // List<PatientMedicine?> medicines =
    //     ref.watch(selectedMedicines.notifier).state;
    List<Widget> choices = [];

    medicines.forEach((item) {
      print("kdsklflksdflksdkf");
      print(item!.notes);
      Color chipColor = chipColors[item!.medicine!.id] ?? getRandomColor();
      chipColors[item.medicine!.id!] = chipColor;

      choices.add(GestureDetector(
        onTap: () {
          medicines
              .removeWhere((element) => element!.medicine == item.medicine);
          ref.read(selectedMedicines.notifier).state = medicines.toList();
        },
        child: Container(
          padding: const EdgeInsets.all(2.0),
          child: ChoiceChip(
            backgroundColor: chipColor.withOpacity(0.3),
            selectedColor: chipColor,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.medicine!.name!,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.clear,
                  size: 18,
                  color: Colors.white,
                ),
              ],
            ),
            selected: medicines.any((element) => element == item),
          ),
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 600,
      child: Wrap(
        clipBehavior: Clip.hardEdge,
        children: _buildChoiceList(ref),
      ),
    );
  }
}
