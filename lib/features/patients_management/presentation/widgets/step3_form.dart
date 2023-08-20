// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:clinic_management_system/core/app_colors.dart';
import 'package:clinic_management_system/features/diseases_badHabits/data/models/badHabits.dart';
import 'package:clinic_management_system/features/diseases_badHabits/data/models/diseases.dart';
import 'package:clinic_management_system/features/diseases_badHabits/presentation/riverpod/diseases/diseases_provider.dart';
import 'package:clinic_management_system/features/diseases_badHabits/presentation/riverpod/diseases/diseases_state.dart';
import 'package:clinic_management_system/features/medicine/presentation/riverpod/medicines/medicines_state.dart';

import 'package:clinic_management_system/features/medicine/presentation/widgets/primaryText.dart';
import 'package:clinic_management_system/features/patients_management/data/models/badHabits_patient.dart';
import 'package:clinic_management_system/features/patients_management/data/models/diseases_patient.dart';
import 'package:clinic_management_system/features/patients_management/data/models/medicines_intake.dart';
import 'package:clinic_management_system/features/patients_management/presentation/widgets/disease_card.dart';

import 'package:clinic_management_system/features/patients_management/presentation/widgets/select_chip.dart';
import 'package:clinic_management_system/features/patients_management/presentation/widgets/step1_form.dart';
import 'package:clinic_management_system/features/patients_management/presentation/widgets/step2_form.dart';
import 'package:clinic_management_system/features/patients_management/presentation/widgets/textField.dart';
import 'package:dartz/dartz.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

import '../../../diseases_badHabits/presentation/riverpod/badHabits/badHabits_provider.dart';
import '../../../diseases_badHabits/presentation/riverpod/badHabits/badHabits_state.dart';
import '../../../medicine/data/model/medicine_model.dart';
import '../../../medicine/presentation/riverpod/medicines/medicines_provider.dart';
import '../../data/models/patient.dart';
import '../riverpod/create_patient_provider.dart';
import 'badHabit_card.dart';
import 'radio_button.dart';

StateProvider selectedMedicines =
    StateProvider<List<PatientMedicine>?>((ref) => []);
StateProvider badHabitDate = StateProvider<DateTime>((ref) => DateTime(2000));
StateProvider badHabitDateString = StateProvider((ref) => "");
StateProvider diseaseDate = StateProvider<DateTime>((ref) => DateTime(2000));
StateProvider diseaseDateString = StateProvider((ref) => "");
StateProvider controlledSelect = StateProvider((ref) => "");
StateProvider badHabitNotes = StateProvider((ref) => TextEditingController());
// TextEditingController notes = TextEditingController();
final medicinesProviderF = FutureProvider((ref) async {
  final response =
      await ref.watch(medicinesProvider.notifier).getPaginatedMedicines(10, 1);
  // return ref.watch(medicinesProvider.notifier).state;
});

StateProvider selectedBadHabits =
    StateProvider<List<PatientBadHabits>?>((ref) => []);

StateProvider selectedDiseases =
    StateProvider<List<PatientDiseases>?>((ref) => []);

class Step3Form extends ConsumerStatefulWidget {
  double? screenWidth;
  double? screenHeight;
  Step3Form({super.key, this.screenHeight, this.screenWidth});

  @override
  ConsumerState<Step3Form> createState() => _Step3FormState();
}

class _Step3FormState extends ConsumerState<Step3Form> {
  TextEditingController quantity = TextEditingController();
  List<String> controlled = ["controlled", "notControlled"];
  Disease currentDisease = Disease(id: 0, name: "");
  BadHabit currentBadHabit = BadHabit(id: 0, name: "");
  Medicine currentMedicine = Medicine(id: 0, name: "", concentration: 0);

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(selectedMedicines);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Stack(
        children: [
          Container(
            width: widget.screenWidth! * 0.6,
            height: widget.screenHeight! * 0.63,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, AppColors.lightGrey]),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PrimaryText(
                    text: "العادات السيئة :",
                    size: 18,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: GestureDetector(
                          onTap: () async {
                            add_badhabits_popup(context, ref);
                          },
                          child: SizedBox(
                            height: widget.screenHeight! * 0.18,
                            width: 100,
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
                      ),
                      SizedBox(
                        height: widget.screenHeight! * 0.18,
                        width: widget.screenWidth! * 0.5,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: ref.watch(selectedBadHabits).length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: BadHabitCard(
                                patientBadHabits: ref
                                    .watch(selectedBadHabits.notifier)
                                    .state[index],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const PrimaryText(
                    text: "الأمراض:",
                    size: 18,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: GestureDetector(
                          onTap: () async {
                            return diseases_popup(context, ref);
                          },
                          child: SizedBox(
                            height: widget.screenHeight! * 0.18,
                            width: 100,
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
                      ),
                      SizedBox(
                        height: widget.screenHeight! * 0.18,
                        width: widget.screenWidth! * 0.5,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: ref.watch(selectedDiseases).length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: (ref
                                          .watch(selectedDiseases.notifier)
                                          .state
                                          .length !=
                                      0)
                                  ? DiseasesPatientCard(
                                      diseasesPatient: ref
                                          .watch(selectedDiseases.notifier)
                                          .state[index],
                                    )
                                  : Container(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const PrimaryText(
                    text: "الأدوية : ",
                    size: 18,
                  ),
                  SizedBox(height: widget.screenHeight! * 0.01),
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
                              backgroundColor: MaterialStatePropertyAll(
                                  Colors.grey.shade300),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ))),
                          child: const PrimaryText(
                            text: "إضافة +",
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                          child: MultiSelectChip(
                        medicines: ref.watch(selectedMedicines.notifier).state,
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: widget.screenHeight! * 0.6,
                right: widget.screenWidth! * 0.25),
            child: ElevatedButton(
              onPressed: () {
                Patient newPatient = Patient();
                newPatient.name = ref.watch(name.notifier).state.text;
                newPatient.mainComplaint =
                    ref.watch(mainComp.notifier).state.text;
                newPatient.phone = ref.watch(phoneNumber.notifier).state.text;
                newPatient.gender = ref.watch(genderSelect.notifier).state;
                newPatient.address = ref.watch(address.notifier).state.text;
                newPatient.job = ref.watch(job.notifier).state.text;
                newPatient.maritalStatus = getMaritalStatusText(
                    ref.watch(maritalStatusProvider.notifier).state!);
                newPatient.patientBadHabits =
                    ref.watch(selectedBadHabits.notifier).state;
                newPatient.patientDiseases =
                    ref.watch(selectedDiseases.notifier).state;
                newPatient.patientMedicines =
                    ref.watch(selectedMedicines.notifier).state;
                ref
                    .watch(patientsCrudProvider.notifier)
                    .createNewPatient(newPatient);
              },
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(AppColors.lightGreen),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.elliptical(10, 70)))),
              ),
              child: const PrimaryText(
                text: "إنشاء الان",
                size: 16,
                height: 1.7,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> medicines_popup(BuildContext context) async {
    final medicinesP = await ref
        .watch(medicinesProvider.notifier)
        .getPaginatedMedicines(10, 1);
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
                    width: widget.screenWidth! * 0.4,
                    height: widget.screenHeight! * 0.4,
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
                          width: widget.screenWidth! * 0.2,
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
                        const SizedBox(
                          width: 30,
                        ),
                        SizedBox(
                          width: widget.screenWidth! * 0.2,
                          child: textfield("ملاحظات", notes, "", 1),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: widget.screenWidth! * 0.08,
                          child: ElevatedButton(
                              onPressed: () {
                                print(currentMedicine);

                                PatientMedicine selected1 = PatientMedicine();
                                selected1.medicine = currentMedicine;
                                selected1.notes = notes.text;

                                if (selected1.medicine!.name != "" &&
                                    !ref
                                        .watch(selectedMedicines.notifier)
                                        .state
                                        .any((element) =>
                                            element == selected1)) {
                                  List<PatientMedicine?> medicines = ref
                                      .watch(selectedMedicines.notifier)
                                      .state;

                                  medicines.add(selected1);
                                  ref.read(selectedMedicines.notifier).state =
                                      medicines.toList();
                                  Navigator.of(context).pop();
                                }
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

  Future<void> diseases_popup(BuildContext context, WidgetRef ref) async {
    TextEditingController diseaseName = TextEditingController();

    final diseases =
        await ref.watch(diseasesProvider.notifier).getPaginatedDiseases(10, 1);
    final state = ref.watch(diseasesProvider.notifier).state;
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
                  child: SizedBox(
                    width: widget.screenWidth! * 0.4,
                    height: widget.screenHeight! * 0.6,
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
                          width: widget.screenWidth! * 0.2,
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
                        Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: Container(
                            height: widget.screenHeight! * 0.075,
                            width: widget.screenWidth! * 0.2,
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
                          width: widget.screenWidth! * 0.08,
                          child: ElevatedButton(
                              onPressed: () {
                                print(currentDisease);
                                print(
                                    ref.watch(controlledSelect.notifier).state);
                                print(ref
                                    .watch(diseaseDateString.notifier)
                                    .state);

                                PatientDiseases selected1 = PatientDiseases();
                                selected1.disease = currentDisease;
                                selected1.date =
                                    ref.watch(diseaseDateString.notifier).state;

                                if (selected1.disease!.name != "" &&
                                    !ref
                                        .watch(selectedDiseases.notifier)
                                        .state
                                        .any((element) =>
                                            element == selected1)) {
                                  List<PatientDiseases?> diseases = ref
                                      .watch(selectedDiseases.notifier)
                                      .state;

                                  diseases.add(selected1);
                                  ref.read(selectedDiseases.notifier).state =
                                      diseases.toList();
                                  Navigator.of(context).pop();
                                }
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
                    width: widget.screenWidth! * 0.4,
                    height: widget.screenHeight! * 0.6,
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
                          width: widget.screenWidth! * 0.2,
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
                            height: widget.screenHeight! * 0.075,
                            width: widget.screenWidth! * 0.2,
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
                          width: widget.screenWidth! * 0.2,
                          child: textfield("ملاحظات",
                              ref.watch(badHabitNotes.notifier).state, "", 1),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: widget.screenWidth! * 0.2,
                          child: textfield("الكمية (اختياري)", quantity, "", 1),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: widget.screenWidth! * 0.08,
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

                                if (selected1.badHabit!.name != "" &&
                                    !ref
                                        .watch(selectedBadHabits.notifier)
                                        .state
                                        .any((element) =>
                                            element == selected1)) {
                                  List<PatientBadHabits?> badHabits = ref
                                      .watch(selectedBadHabits.notifier)
                                      .state;

                                  badHabits.add(selected1);
                                  ref.read(selectedBadHabits.notifier).state =
                                      badHabits.toList();
                                  Navigator.of(context).pop();
                                }
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
}
