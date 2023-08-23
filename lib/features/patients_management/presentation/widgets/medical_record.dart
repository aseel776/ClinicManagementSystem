// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:clinic_management_system/core/textField.dart';
import 'package:clinic_management_system/features/diseases_badHabits/data/models/badHabits.dart';
import 'package:clinic_management_system/features/medicine/data/model/medicine_model.dart';
import 'package:clinic_management_system/features/patients_management/presentation/riverpod/patients_provider.dart';
import 'package:clinic_management_system/features/patients_management/presentation/widgets/badHabit_card.dart';
import 'package:clinic_management_system/features/patients_management/presentation/widgets/radio_button.dart';
import 'package:clinic_management_system/features/patients_management/presentation/widgets/select_chip.dart';
import 'package:clinic_management_system/features/patients_management/presentation/widgets/step3_form.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

import '../../../../core/app_colors.dart';
import '../../../diseases_badHabits/data/models/diseases.dart';
import '../../../diseases_badHabits/presentation/riverpod/badHabits/badHabits_provider.dart';
import '../../../diseases_badHabits/presentation/riverpod/badHabits/badHabits_state.dart';
import '../../../diseases_badHabits/presentation/riverpod/diseases/diseases_provider.dart';
import '../../../diseases_badHabits/presentation/riverpod/diseases/diseases_state.dart';
import '../../../medicine/presentation/riverpod/medicines/medicines_provider.dart';
import '../../../medicine/presentation/riverpod/medicines/medicines_state.dart';
import '../../../medicine/presentation/widgets/primaryText.dart';
import '../../data/models/badHabits_patient.dart';
import '../../data/models/diseases_patient.dart';
import '../../data/models/medicines_intake.dart';
import '../../data/models/patient.dart';
import '../riverpod/create_patient_provider.dart';
import '../riverpod/patients_state.dart';
import 'disease_card.dart';

StateProvider quantityBadHabit =
    StateProvider((ref) => TextEditingController());

class MedicalRecord extends ConsumerStatefulWidget {
  Patient patient;
  MedicalRecord({super.key, required this.patient});

  @override
  ConsumerState<MedicalRecord> createState() => _MedicalRecordState();
}

class _MedicalRecordState extends ConsumerState<MedicalRecord> {
  Disease currentDisease = Disease(id: 0, name: "");
  BadHabit currentBadHabit = BadHabit(id: 0, name: "");
  Medicine currentMedicine = Medicine(id: 0, name: "");

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
                diseases_popup(context, ref);
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
                itemCount: widget.patient.patientDiseases!.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: (widget.patient.patientDiseases!.isNotEmpty)
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
              onTap: () {
                print("blabla");
                add_badhabits_popup(context, ref);
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
                itemCount: widget.patient.patientBadHabits.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: (widget.patient.patientBadHabits.isNotEmpty)
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
        Row(
          children: [
            DottedBorder(
              radius: const Radius.circular(15),
              padding: const EdgeInsets.all(0.4),
              borderType: BorderType.RRect,
              child: ElevatedButton(
                onPressed: () async {
                  return await medicines_popup(context);
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.grey.shade300),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ))),
                child: const PrimaryText(
                  text: "إضافة +",
                  color: AppColors.black,
                ),
              ),
            ),
            const SizedBox(width: 10),
            (widget.patient.patientMedicines.isNotEmpty)
                ? MultiSelectChip(
                    medicines: widget.patient.patientMedicines,
                  )
                : Container()
          ],
        )
        // : Container()
      ]),
    );
  }

  List<String> controlled = ["controlled", "notControlled"];

  Future<void> diseases_popup(BuildContext context, WidgetRef ref) async {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final diseases =
        await ref.watch(diseasesProvider.notifier).getPaginatedDiseases(8, 1);
    final state = ref.watch(diseasesProvider.notifier).state;
    TextEditingController diseaseName = TextEditingController();

    // final diseases =
    //     await ref.watch(diseasesProvider.notifier).getPaginatedDiseases(10, 1);
    // final state = ref.watch(diseasesProvider.notifier).state;
    // print(state);

    return showDialog(
        context: context,
        builder: (context) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Dialog(
                  backgroundColor: AppColors.lightGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SizedBox(
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: PrimaryText(
                            text: "إضافة مرض ",
                            size: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: screenWidth * 0.2,
                          child: SearchField(
                              hint: 'Search',
                              controller: diseaseName,
                              onSuggestionTap: (p0) {
                                currentDisease = p0.item as Disease;
                              },
                              searchInputDecoration: InputDecoration(
                                fillColor: Colors.transparent,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              maxSuggestionsInViewPort: 6,
                              itemHeight: 50,
                              suggestionsDecoration: SuggestionDecoration(
                                  color: AppColors.lightGreen,
                                  borderRadius: BorderRadius.circular(10),
                                  padding: EdgeInsets.all(10)),
                              marginColor: Colors.transparent,
                              suggestions: (state is LoadedDiseasesState)
                                  ? List.generate(
                                      state.diseases.length,
                                      (index) => SearchFieldListItem(
                                          state.diseases[index].name,
                                          item: state.diseases[index]))
                                  : []),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: screenWidth * 0.2,
                          child: textfield("ملاحظات",
                              ref.watch(diseaseNotes.notifier).state, "", 1),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: Container(
                            height: screenHeight * 0.075,
                            width: screenWidth * 0.2,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                    child: const Row(children: [
                                      Icon(
                                        Icons.calendar_today,
                                        color: Colors.black26,
                                      ),
                                      PrimaryText(
                                        text: "تاريخ المرض",
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ]),
                                    onTap: () async {
                                      final datePick = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime(2000),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2100));
                                      if (datePick != null &&
                                          datePick != diseaseDate) {
                                        ref.read(diseaseDate.notifier).state =
                                            datePick;

                                        ref
                                            .read(diseaseDateString.notifier)
                                            .state = DateFormat(
                                                "yyyy-MM-dd")
                                            .format(ref
                                                .watch(diseaseDate.notifier)
                                                .state!);
                                      }
                                    }),
                                const SizedBox(
                                  width: 10,
                                ),
                                ref.watch(diseaseDateString) == null
                                    ? const Text("DD/MM/YYYY")
                                    : Text("${ref.watch(diseaseDateString)}")
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 30,
                                ),
                                addRadioButton(0, 'نعم', controlled, ref,
                                    controlledSelect),
                                const SizedBox(
                                  width: 30,
                                ),
                                addRadioButton(
                                    1, 'لا', controlled, ref, controlledSelect),
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            const PrimaryText(
                              text: "مضبوط ؟",
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: screenWidth * 0.08,
                          child: ElevatedButton(
                              onPressed: () {
                                // print(currentDisease);
                                print(
                                    ref.watch(controlledSelect.notifier).state);
                                print(ref
                                    .watch(diseaseDateString.notifier)
                                    .state);

                                PatientDiseases selected1 = PatientDiseases();
                                selected1.disease = currentDisease;
                                if (ref
                                        .watch(controlledSelect.notifier)
                                        .state ==
                                    "controlled") {
                                  selected1.controlled = true;
                                } else {
                                  selected1.controlled = false;
                                }
                                selected1.notes =
                                    ref.watch(diseaseNotes.notifier).state.text;

                                selected1.date =
                                    ref.watch(diseaseDateString.notifier).state;
                                ref
                                    .watch(patientsCrudProvider.notifier)
                                    .createPatientDiseases(
                                        selected1, widget.patient.id!)
                                    .then((value) {
                                  ref
                                      .watch(patientsProvider.notifier)
                                      .getPatientDiseases(widget.patient.id!);
                                  Navigator.pop(context);
                                });

                                ref.watch(diseasesProvider.notifier);
                              },
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    AppColors.lightGreen),
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.elliptical(50, 70)))),
                              ),
                              child: const PrimaryText(
                                text: "إضافة",
                                height: 1.7,
                                color: AppColors.black,
                              )),
                        )
                      ],
                    ),
                  )),
            ));
  }

  Future<dynamic> add_badhabits_popup(
      BuildContext context, WidgetRef ref) async {
    final badHabits = await ref
        .watch(badHabitsProvider.notifier)
        .getPaginatedBadHabits(10, 1);
    final state = ref.watch(badHabitsProvider.notifier).state;
    print(state);

    return showDialog(
        context: context,
        builder: (context) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Dialog(
                backgroundColor: AppColors.lightGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: LayoutBuilder(builder: (context, constraints) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: PrimaryText(
                            text: "إضافة عادة سيئة",
                            size: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: SearchField(
                              hint: 'Search',
                              searchInputDecoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              maxSuggestionsInViewPort: 6,
                              itemHeight: 50,
                              onSuggestionTap: (p0) {
                                currentBadHabit = p0.item as BadHabit;
                              },
                              suggestionsDecoration: SuggestionDecoration(
                                  color: AppColors.lightGreen,
                                  borderRadius: BorderRadius.circular(10),
                                  padding: EdgeInsets.all(10)),
                              suggestions: (state is LoadedBadHabitsState)
                                  ? List.generate(
                                      state.badHabits.length,
                                      (index) => SearchFieldListItem(
                                          state.badHabits[index].name,
                                          item: state.badHabits[index]))
                                  : []),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.075,
                            width: MediaQuery.of(context).size.width * 0.2,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                    child: const Row(children: [
                                      Icon(
                                        Icons.calendar_today,
                                        color: Colors.black26,
                                      ),
                                      PrimaryText(
                                        text: "تاريخ العادة السيئة",
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ]),
                                    onTap: () async {
                                      final datePick = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime(2000),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2100));
                                      if (datePick != null &&
                                          datePick != badHabitDate) {
                                        ref.read(badHabitDate.notifier).state =
                                            datePick;

                                        ref
                                            .read(badHabitDateString.notifier)
                                            .state = DateFormat(
                                                "yyyy-MM-dd")
                                            .format(ref
                                                .watch(badHabitDate.notifier)
                                                .state!);

                                        print(ref.watch(badHabitDateString));
                                      }
                                    }),
                                const SizedBox(
                                  width: 10,
                                ),
                                ref.watch(badHabitDateString) == null
                                    ? const Text("DD/MM/YYYY")
                                    : Text("${ref.watch(badHabitDateString)}")
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: textfield("ملاحظات",
                              ref.watch(badHabitNotes.notifier).state, "", 1),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: textfield(
                              "الكمية (اختياري)",
                              ref.watch(quantityBadHabit.notifier).state,
                              "",
                              1),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.08,
                          child: ElevatedButton(
                              onPressed: () {
                                print(currentBadHabit);

                                print(ref
                                    .watch(badHabitDateString.notifier)
                                    .state);

                                PatientBadHabits selected1 = PatientBadHabits();
                                selected1.badHabit = currentBadHabit;
                                selected1.id = currentBadHabit.id;
                                selected1.notes = ref
                                    .watch(badHabitNotes.notifier)
                                    .state
                                    .text;
                                selected1.date = ref
                                    .watch(badHabitDateString.notifier)
                                    .state;

                                ref
                                    .watch(patientsCrudProvider.notifier)
                                    .createPatientBadHabits(
                                        selected1, widget.patient.id!)
                                    .then((value) {
                                  ref
                                      .watch(patientsProvider.notifier)
                                      .getPatientBadHabits(widget.patient.id!);
                                  Navigator.pop(context);
                                });
                              },
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    AppColors.lightGreen),
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.elliptical(50, 70)))),
                              ),
                              child: const PrimaryText(
                                text: "إضافة",
                                height: 1.7,
                                color: AppColors.black,
                              )),
                        )
                      ],
                    ),
                  );
                }),
              ),
            ));
  }

  Future<void> medicines_popup(BuildContext context) async {
    await ref.watch(medicinesProvider.notifier).getPaginatedMedicines(1000, 1);
    final state = ref.watch(medicinesProvider.notifier).state;
    print(state);
    TextEditingController medicineName = TextEditingController();
    TextEditingController notes = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Dialog(
                  backgroundColor: AppColors.lightGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: PrimaryText(
                            text: "إضافة دواء ",
                            size: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: SearchField(
                              hint: 'Search',
                              controller: medicineName,
                              onSuggestionTap: (p0) {
                                currentMedicine = p0.item as Medicine;
                              },
                              searchInputDecoration: InputDecoration(
                                fillColor: Colors.transparent,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              maxSuggestionsInViewPort: 6,
                              itemHeight: 50,
                              suggestionsDecoration: SuggestionDecoration(
                                  color: AppColors.lightGreen,
                                  borderRadius: BorderRadius.circular(10),
                                  padding: EdgeInsets.all(10)),
                              marginColor: Colors.transparent,
                              suggestions: (state is LoadedMedicinesState)
                                  ? List.generate(
                                      state.medicines.length,
                                      (index) => SearchFieldListItem(
                                          state.medicines[index].name!,
                                          item: state.medicines[index]))
                                  : []),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: MediaQuery.of(context).size.height! * 0.075,
                          width: MediaQuery.of(context).size.width * 0.2,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                  child: const Row(children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: Colors.black26,
                                    ),
                                    PrimaryText(
                                      text: "تاريخ العادة السيئة",
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ]),
                                  onTap: () async {
                                    final datePick = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime(2000),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2100));
                                    if (datePick != null &&
                                        datePick != ref.watch(medicineDate)) {
                                      ref.read(medicineDate.notifier).state =
                                          datePick;

                                      ref
                                              .read(medicineDateString.notifier)
                                              .state =
                                          DateFormat("yyyy-MM-dd").format(ref
                                              .watch(medicineDate.notifier)
                                              .state!);

                                      print(ref.watch(medicineDateString));
                                    }
                                  }),
                              const SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: textfield("ملاحظات", notes, "", 1),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.08,
                          child: ElevatedButton(
                              onPressed: () {
                                print(currentMedicine);

                                PatientMedicine selected1 = PatientMedicine();

                                selected1.medicine = currentMedicine;
                                selected1.notes = notes.text;
                                selected1.date = ref
                                    .watch(medicineDateString.notifier)
                                    .state;
                                // selected1
                                ref
                                    .watch(patientsCrudProvider.notifier)
                                    .createPatientMedicines(
                                        selected1, widget.patient.id!);
                              },
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    AppColors.lightGreen),
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.elliptical(50, 70)))),
                              ),
                              child: const PrimaryText(
                                text: "إضافة",
                                height: 1.7,
                                color: AppColors.black,
                              )),
                        )
                      ],
                    ),
                  )),
            ));
  }
}
