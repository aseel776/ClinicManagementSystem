// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:ui';

import 'package:clinic_management_system/features/patients_management/data/models/patient_diagnosis.dart';
import 'package:clinic_management_system/features/patients_management/presentation/riverpod/create_patient_provider.dart';
import 'package:clinic_management_system/features/patients_management/presentation/riverpod/patient_crud_state.dart';
import 'package:clinic_management_system/features/treatments_feature/data/models/treatment_model.dart';
import 'package:clinic_management_system/features/treatments_feature/presentation/states/treatments/treatments_provider.dart';
import 'package:clinic_management_system/features/treatments_feature/presentation/states/treatments/treatments_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:searchfield/searchfield.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/primaryText.dart';
import '../../../../core/textField.dart';

import '../../data/models/patient.dart';
import '../pages/patient_profile.dart';
import '../riverpod/patients_provider.dart';
import '../riverpod/patients_state.dart';

StateProvider selectedImage = StateProvider<File?>((ref) => null);
StateProvider totalPagesDiagnosis = StateProvider((ref) => 1);
StateProvider currentPageDiagnosis = StateProvider((ref) => 1);
StateProvider expectedTreatment =
    StateProvider((ref) => TextEditingController());
StateProvider place = StateProvider((ref) => TextEditingController());

class MedicalDiagnosisScreen extends ConsumerStatefulWidget {
  PageController pageController;
  Patient patient;
  MedicalDiagnosisScreen(
      {super.key, required this.pageController, required this.patient});

  @override
  ConsumerState<MedicalDiagnosisScreen> createState() =>
      _MedicalDiagnosisScreenState();
}

class _MedicalDiagnosisScreenState
    extends ConsumerState<MedicalDiagnosisScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.patient.id != null) {
        print("start");
        await ref.watch(patientsProvider.notifier).getPatientDiagnosis(
              1000,
              1,
              widget.patient.id!,
              ref.watch(currentPageViewDiagnosisProvider.notifier).state + 1,
            );
        print("end");

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
    final sectionWidth = MediaQuery.of(context).size.width;
    final sectionHeight = MediaQuery.of(context).size.height;
    ref.watch(currentPageDiagnosis);
    ref.watch(totalPagesDiagnosis);
    ref.watch(patientsProvider);
    ref.watch(patientsCrudProvider);

    ref.watch(selectedImage);
    ref.watch(currentPageViewDiagnosisProvider);

    return Stack(
      children: [
        Container(
            // color: Colors.pi,
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.6,
            child: pageView(
                ref.watch(currentPageViewProvider.notifier).state, ref)),
        Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.height * 0.05, bottom: 3),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .04,
            width: MediaQuery.of(context).size.width * .1,
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(AppColors.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                onPressed: () async {
                  // ref.watch(productName.notifier).state.text = "";
                  await add_edit_product_popup(context, ref, true, null);
                },
                child: const PrimaryText(text: "إضافة تشخيص ")),
          ),
        ),
      ],
    );
  }

  Widget pageView(int currentPage, WidgetRef ref) {
    final state = ref.watch(patientsProvider.notifier).state;
    ref.watch(patientsProvider);
    switch (ref.watch(currentPageViewDiagnosisProvider.notifier).state) {
      case 0:
        {
          return PageView.custom(
            scrollDirection: Axis.horizontal,
            controller: widget.pageController,
            childrenDelegate: SliverChildBuilderDelegate(
              ((context, index) {
                int patientIndex = state.patients
                    .indexWhere((patient) => patient.id == widget.patient.id);
                (state is LoadedPatientsState)
                    ? print(state.patients[patientIndex].patientDiagnosis!)
                    : print(state.patients[patientIndex]);
                return Padding(
                    padding:
                        const EdgeInsets.only(left: 25.0, top: 15, right: 10),
                    child: (state is LoadedPatientsState)
                        ? (state.patients[patientIndex].patientDiagnosis!
                                .isNotEmpty)
                            ? Container(
                                width: 600,
                                height: 400,
                                child: ListView.builder(
                                  itemCount: state.patients[patientIndex]
                                      .patientDiagnosis!.length,
                                  itemBuilder: (context, index) {
                                    final row = state.patients[patientIndex]
                                        .patientDiagnosis![index];

                                    return ListTile(
                                      title: Text(
                                          'الرقم: ${row.problemId.toString() ?? ""}'),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'المكان: ${row.place.toString() ?? ""}'),
                                          Text(
                                              'العلاج المتوقع: ${row.expectedTreatment.toString()}'),
                                        ],
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              // Delete action
                                              // Implement your delete logic here
                                            },
                                            child: const Icon(
                                              Icons.delete,
                                              color: AppColors.lightGreen,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          TextButton(
                                            onPressed: () {
                                              // Edit action
                                              // Implement your edit logic here
                                            },
                                            child: const Icon(
                                              Icons.edit,
                                              color: AppColors.lightGreen,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Container()
                        : Container());
              }),
              childCount: 1,
            ),
          );
        }
      case 1:
        {
          return PageView.custom(
            scrollDirection: Axis.horizontal,
            controller: widget.pageController,
            childrenDelegate: SliverChildBuilderDelegate(
              ((context, index) {
                int patientIndex = state.patients
                    .indexWhere((patient) => patient.id == widget.patient.id);
                return Padding(
                    padding:
                        const EdgeInsets.only(left: 25.0, top: 15, right: 10),
                    child: (state is LoadedPatientsState)
                        ? (state.patients[patientIndex].patientDiagnosis!
                                .isNotEmpty)
                            ? SizedBox(
                                width: 600,
                                height: 400,
                                child: DataTable(
                                    columnSpacing: 110,
                                    columns: const [
                                      DataColumn(label: Text('الرقم')),
                                      DataColumn(label: Text('المكان')),
                                      DataColumn(label: Text('العلاج المتوقع')),
                                      DataColumn(label: Text("العمليات"))
                                    ],
                                    rows: state.patients[patientIndex]
                                        .patientDiagnosis!
                                        .map((row) => DataRow(
                                              cells: [
                                                DataCell(
                                                    Text(row.problemId
                                                            .toString() ??
                                                        ""),
                                                    onTap: () => null),
                                                DataCell(Text(
                                                    row.place.toString() ??
                                                        "")),
                                                DataCell(Text(row
                                                    .expectedTreatment
                                                    .toString())),

                                                DataCell(
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                          width: 40,
                                                          child: TextButton(
                                                            onPressed: () {
                                                              // print(row.id);
                                                              // ScaffoldMessenger.of(context)
                                                              //     .showSnackBar(
                                                              //         DeleteSnackBar(
                                                              //             () async {
                                                              //   await ref
                                                              //       .watch(
                                                              //           medicinesCrudProvider
                                                              //               .notifier)
                                                              //       .deleteMedicine(row.id!)
                                                              //       .then((value) {
                                                              //     ref
                                                              //         .watch(medicinesProvider
                                                              //             .notifier)
                                                              //         .getPaginatedMedicines(
                                                              //             6, 1);

                                                              //     ref
                                                              //         .watch(
                                                              //             currentPageMedicines
                                                              //                 .notifier)
                                                              //         .state = 1;
                                                              //   });

                                                              //   // await ref.watch()
                                                              // }));
                                                            },
                                                            child: const Icon(
                                                              Icons.delete,
                                                              color: AppColors
                                                                  .lightGreen,
                                                            ),
                                                          )),
                                                      SizedBox(
                                                          width: 40,
                                                          child: TextButton(
                                                              onPressed: () {},
                                                              child: const Icon(
                                                                Icons.edit,
                                                                color: AppColors
                                                                    .lightGreen,
                                                              )))
                                                    ],
                                                  ),
                                                ),

                                                // DataCell(Text(row.category!
                                                //     .map((e) => e.name)
                                                //     .toList()
                                                //     .toString())),
                                              ],
                                            ))
                                        .toList()),
                              )
                            : Container()
                        : Container());
              }),
              childCount: 1,
            ),
          );
        }
      case 2:
        {
          return PageView.custom(
            scrollDirection: Axis.horizontal,
            controller: widget.pageController,
            childrenDelegate: SliverChildBuilderDelegate(
              ((context, index) {
                int patientIndex = state.patients
                    .indexWhere((patient) => patient.id == widget.patient.id);

                return Padding(
                    padding:
                        const EdgeInsets.only(left: 25.0, top: 15, right: 10),
                    child: (state is LoadedPatientsState ||
                            state is MessageAddEditDeletePatientState)
                        ? (state.patients[patientIndex].patientDiagnosis!
                                .isNotEmpty)
                            ? Container(
                                color: Colors.amber,
                                width: 200,
                                height: 400,
                                child: DataTable(
                                    columnSpacing: 110,
                                    columns: const [
                                      DataColumn(label: Text('الرقم')),
                                      DataColumn(label: Text('المكان')),
                                      DataColumn(label: Text('العلاج المتوقع')),
                                      DataColumn(label: Text("العمليات"))
                                    ],
                                    rows: state.patients[patientIndex]
                                        .patientDiagnosis!
                                        .map((row) => DataRow(
                                              cells: [
                                                DataCell(
                                                    Text(row.problemId
                                                            .toString() ??
                                                        ""),
                                                    onTap: () => null),
                                                DataCell(Text(
                                                    row.place.toString() ??
                                                        "")),
                                                DataCell(Text(row
                                                    .expectedTreatment
                                                    .toString())),

                                                DataCell(
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                          width: 40,
                                                          child: TextButton(
                                                            onPressed: () {
                                                              // print(row.id);
                                                              // ScaffoldMessenger.of(context)
                                                              //     .showSnackBar(
                                                              //         DeleteSnackBar(
                                                              //             () async {
                                                              //   await ref
                                                              //       .watch(
                                                              //           medicinesCrudProvider
                                                              //               .notifier)
                                                              //       .deleteMedicine(row.id!)
                                                              //       .then((value) {
                                                              //     ref
                                                              //         .watch(medicinesProvider
                                                              //             .notifier)
                                                              //         .getPaginatedMedicines(
                                                              //             6, 1);

                                                              //     ref
                                                              //         .watch(
                                                              //             currentPageMedicines
                                                              //                 .notifier)
                                                              //         .state = 1;
                                                              //   });

                                                              //   // await ref.watch()
                                                              // }));
                                                            },
                                                            child: const Icon(
                                                              Icons.delete,
                                                              color: AppColors
                                                                  .lightGreen,
                                                            ),
                                                          )),
                                                      SizedBox(
                                                          width: 40,
                                                          child: TextButton(
                                                              onPressed: () {},
                                                              child: const Icon(
                                                                Icons.edit,
                                                                color: AppColors
                                                                    .lightGreen,
                                                              )))
                                                    ],
                                                  ),
                                                ),

                                                // DataCell(Text(row.category!
                                                //     .map((e) => e.name)
                                                //     .toList()
                                                //     .toString())),
                                              ],
                                            ))
                                        .toList() as List<DataRow>),
                              )
                            : Container()
                        : Container());
              }),
              childCount: 1,
            ),
          );
        }
      default:
        {
          return Container(
            color: Colors.deepOrange,
          );
        }
    }
  }

  Future<dynamic> add_edit_product_popup(BuildContext context, WidgetRef ref,
      bool addOrEdit, int? productIndex) async {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final treatments =
        await ref.watch(treatmentsProvider.notifier).getAllTreatments();
    final state = ref.watch(treatmentsProvider.notifier).state;
    TreatmentModel currentTreatment = TreatmentModel();

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
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PrimaryText(
                            text: addOrEdit ? "إضافة تشخيص " : "تعديل تشخيص ",
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
                                currentTreatment = p0.item as TreatmentModel;
                              },
                              suggestionsDecoration: SuggestionDecoration(
                                  color: AppColors.lightGreen,
                                  borderRadius: BorderRadius.circular(10),
                                  padding: EdgeInsets.all(10)),
                              suggestions: (state is LoadedTreatmentsState)
                                  ? List.generate(
                                      state.page.treatments!.length,
                                      (index) => SearchFieldListItem(
                                          state.page.treatments![index].name!,
                                          item: state.page.treatments![index]))
                                  : []),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: screenWidth * 0.2,
                          child: textfield(
                              "العلاج المتوقع",
                              ref.watch(expectedTreatment.notifier).state,
                              "",
                              1),
                        ),
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        SizedBox(
                          width: screenWidth * 0.2,
                          child: textfield(" المكان  ",
                              ref.watch(place.notifier).state, "", 1),
                        ),
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        SizedBox(
                          width: screenWidth * 0.08,
                          child: ElevatedButton(
                              onPressed: () async {
                                // ref.watch(productsProvider.notifier)
                                if (addOrEdit) {
                                  PatientDiagnosis product = PatientDiagnosis(
                                      expectedTreatment: ref
                                          .watch(expectedTreatment.notifier)
                                          .state
                                          .text,
                                      place:
                                          ref.watch(place.notifier).state.text,
                                      patientId: widget.patient.id,
                                      problemId: currentTreatment.id);
                                  await ref
                                      .watch(patientsCrudProvider.notifier)
                                      .createPatientDiagnosis(product)
                                      .then((value) {
                                    print("problem type id ");
                                    ref
                                        .watch(patientsProvider.notifier)
                                        .getPatientDiagnosis(
                                            1000,
                                            1,
                                            widget.patient.id!,
                                            ref
                                                .watch(
                                                    currentPageViewDiagnosisProvider
                                                        .notifier)
                                                .state);
                                  });
                                  // ref
                                  //     .watch(currentPageDiagnosis.notifier)
                                  //     .state = 1;

                                  Navigator.pop(context);
                                } else {
                                  PatientDiagnosis diagnosis = PatientDiagnosis(
                                      expectedTreatment: ref
                                          .watch(expectedTreatment.notifier)
                                          .state
                                          .text,
                                      place:
                                          ref.watch(place.notifier).state.text,
                                      patientId: widget.patient.id,
                                      problemId: ref
                                          .watch(currentPageDiagnosis.notifier)
                                          .state);
                                  await ref
                                      .watch(patientsCrudProvider.notifier)
                                      .editPatientDiagnosis(diagnosis)
                                      .then((value) => ref
                                          .watch(patientsProvider.notifier)
                                          .getPatientDiagnosis(
                                              6,
                                              1,
                                              widget.patient.id!,
                                              ref
                                                  .watch(currentPageDiagnosis
                                                      .notifier)
                                                  .state));
                                  ref
                                      .watch(currentPageDiagnosis.notifier)
                                      .state = 1;
                                  Navigator.pop(context);
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
                              child: PrimaryText(
                                text: addOrEdit ? "إضافة" : "تعديل",
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
