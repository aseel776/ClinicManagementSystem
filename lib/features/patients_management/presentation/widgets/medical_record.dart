import 'package:clinic_management_system/features/patients_management/presentation/riverpod/patients_provider.dart';
import 'package:clinic_management_system/features/patients_management/presentation/widgets/badHabit_card.dart';
import 'package:clinic_management_system/features/patients_management/presentation/widgets/select_chip.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/app_colors.dart';
import '../../../medicine/presentation/widgets/primaryText.dart';
import '../../data/models/patient.dart';
import '../riverpod/patients_state.dart';
import 'disease_card.dart';

class MedicalRecord extends ConsumerStatefulWidget {
  Patient patient;
  MedicalRecord({super.key, required this.patient});

  @override
  ConsumerState<MedicalRecord> createState() => _MedicalRecordState();
}

class _MedicalRecordState extends ConsumerState<MedicalRecord> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.patient.id != null) {
        await ref
            .watch(patientsProvider.notifier)
            .getPatientBadHabits(widget.patient.id!);
        await ref
            .watch(patientsProvider.notifier)
            .getPatientDiseases(widget.patient.id!);

        await ref
            .watch(patientsProvider.notifier)
            .getPatientMedicines(widget.patient.id!);

        final state = ref.watch(patientsProvider.notifier).state;
        if (state is LoadedPatientsState) {
          int patientIndex = state.patients
              .indexWhere((patient) => patient.id == widget.patient.id);
          widget.patient = state.patients[patientIndex];
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(right: 5, top: 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const PrimaryText(
          text: "الأمراض",
          size: 16,
          fontWeight: FontWeight.w500,
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () async {
                // return diseases_popup(context, ref);
              },
              child: SizedBox(
                height: screenHeight * 0.15,
                width: screenWidth * 0.06,
                child: DottedBorder(
                  radius: const Radius.circular(15),
                  padding: const EdgeInsets.all(0.4),
                  borderType: BorderType.RRect,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(15)),
                    child: const Center(
                      child: PrimaryText(
                        text: "إضافة +",
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.16,
              width: screenWidth * 0.5,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.patient.patientDiseases.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: (widget.patient.patientDiseases.isNotEmpty)
                          ? SizedBox(
                              width: screenWidth * 0.08,
                              height: screenHeight * 0.18,
                              child: DiseasesPatientCard(
                                diseasesPatient:
                                    widget.patient.patientDiseases[index],
                              ),
                            )
                          : Container());
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: screenHeight * 0.001,
        ),
        const PrimaryText(
          text: "العادات السيئة",
          size: 16,
          fontWeight: FontWeight.w500,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                // return diseases_popup(context, ref);
              },
              child: SizedBox(
                height: screenHeight * 0.15,
                width: screenWidth * 0.06,
                child: DottedBorder(
                  radius: const Radius.circular(15),
                  padding: const EdgeInsets.all(0.4),
                  borderType: BorderType.RRect,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(15)),
                    child: const Center(
                      child: PrimaryText(
                        text: "إضافة +",
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.16,
              width: screenWidth * 0.5,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.patient.patientDiseases.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: (widget.patient.patientDiseases.isNotEmpty)
                          ? SizedBox(
                              width: screenWidth * 0.08,
                              child: BadHabitCard(
                                patientBadHabits:
                                    widget.patient.patientBadHabits[index],
                              ),
                            )
                          : Container());
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: screenHeight * 0.001,
        ),
        const PrimaryText(
          text: "الأدوية",
          size: 16,
          fontWeight: FontWeight.w500,
        ),
        (widget.patient.patientMedicines.isNotEmpty)
            ? Row(
                children: [
                  MultiSelectChip(
                    medicines: widget.patient.patientMedicines,
                  )
                ],
              )
            : Container()
      ]),
    );
  }
}
