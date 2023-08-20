import 'dart:ui';
import 'package:clinic_management_system/features/diseases_badHabits/presentation/pages/badHabits.dart';
import 'package:clinic_management_system/features/diseases_badHabits/presentation/riverpod/badHabits/add_update_delete_provider.dart';
import 'package:clinic_management_system/features/diseases_badHabits/presentation/riverpod/badHabits/badHabits_provider.dart';
import 'package:clinic_management_system/core/primaryText.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/app_colors.dart';
import 'package:clinic_management_system/features/active_materials_feature/data/models/active_material_model.dart';
import 'package:clinic_management_system/features/active_materials_feature/presentation/states/active_materials/active_materials_provider.dart';
import 'package:clinic_management_system/features/active_materials_feature/presentation/states/active_materials/active_materials_state.dart';
import 'package:clinic_management_system/core/textField.dart';
import '../../data/models/badHabits.dart';
import 'add_button.dart';
import 'delete_snack_bar.dart';

class BadHabitsTableWidget extends ConsumerWidget {
  List<BadHabit> badHabits;

  BadHabitsTableWidget({
    Key? key,
    required this.badHabits,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Theme(
      data: ThemeData(
          useMaterial3: false,
          textTheme: const TextTheme(bodySmall: TextStyle(color: Colors.pink)),
          iconTheme: const IconThemeData(color: Colors.blue)),
      child: DataTable(
        dataRowHeight: 54.0,
        // rowsPerPage: 8,
        showCheckboxColumn: false,

        // availableRowsPerPage: [7],
        // onPageChanged: (value) {
        //   ref
        //       .watch(badHabitsProvider.notifier)
        //       .getPaginatedBadHabits(7, value.toDouble());
        //   ref.watch(currentPageBadHabitsTable.notifier).state = value;
        //   final state = ref.watch(badHabitsProvider.notifier).state;
        //   if (state is LoadedBadHabitsState) {
        //     badHabits = state.badHabits;
        //     DataSource(context, badHabits, ref)
        //         .updateRows(state.badHabits, value);
        //   }
        // },
        columns: const [
          DataColumn(label: Text('الرقم')),
          DataColumn(label: Text('الاسم')),
          DataColumn(label: Text('المواد الفعالة')),
          DataColumn(label: Text("operations")),
        ],
        rows: badHabits
            .map((row) => DataRow(
                  cells: [
                    DataCell(Text(row.id.toString()), onTap: () => null),
                    DataCell(Text(row.name.toString())),
                    DataCell(Text(row.antiMaterials!
                        .map((e) => e.name)
                        .toList()
                        .toString())),
                    DataCell(
                      Row(
                        children: [
                          SizedBox(
                              width: 40,
                              child: TextButton(
                                onPressed: () {
                                  print(row.id);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(DeleteSnackBar(() async {
                                    await ref
                                        .watch(badHabitsCrudProvider.notifier)
                                        .deleteBadHabit(row);
                                    await ref
                                        .watch(badHabitsProvider.notifier)
                                        .getPaginatedBadHabits(
                                            10,
                                            ref
                                                .watch(currentPageBadHabitsTable
                                                    .notifier)
                                                .state
                                                .toDouble());

                                    // await ref.watch()
                                  }));
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: AppColors.lightGreen,
                                ),
                              )),
                          SizedBox(
                              width: 40,
                              child: TextButton(
                                  onPressed: () {
                                    ref
                                        .watch(badHabitsName.notifier)
                                        .state
                                        .text = row.name;
                                    showDialog(
                                        context: context,
                                        builder: (context) => BackdropFilter(
                                              filter: ImageFilter.blur(
                                                  sigmaX: 2, sigmaY: 2),
                                              child: Dialog(
                                                  backgroundColor:
                                                      AppColors.lightGrey,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.45,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: PrimaryText(
                                                            text:
                                                                "تعديل عادة سيئة",
                                                            size: 18,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        Directionality(
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          child: SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.2,
                                                            child: textfield(
                                                                "الاسم",
                                                                ref
                                                                    .watch(badHabitsName
                                                                        .notifier)
                                                                    .state,
                                                                "",
                                                                1),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        const SizedBox(
                                                            height: 20),
                                                        StatefulBuilder(builder:
                                                            (context,
                                                                setState) {
                                                          return Directionality(
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                            child: SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.2,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    // antiMaterialsSelect(
                                                                    //     context,
                                                                    //     ref);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.08,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            12),
                                                                    child:
                                                                        const Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .arrow_drop_down_circle_outlined,
                                                                          color:
                                                                              Colors.black54,
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                8),
                                                                        Text(
                                                                          "ادخل مواد مضادة",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black54,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )),
                                                          );
                                                        }),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        const SizedBox(
                                                            height: 20),
                                                        const SizedBox(
                                                          width: 30,
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                          child: ElevatedButton(
                                                              onPressed: () {
                                                                List<ActiveMaterialModel>?
                                                                    selectedMaterials =
                                                                    ref
                                                                        .watch(multiSelect
                                                                            .notifier)
                                                                        .state
                                                                        .cast<
                                                                            ActiveMaterialModel>();
                                                                BadHabit newBadHabit = BadHabit(
                                                                    id: row.id,
                                                                    name: ref
                                                                        .watch(badHabitsName
                                                                            .notifier)
                                                                        .state
                                                                        .text,
                                                                    antiMaterials:
                                                                        selectedMaterials);
                                                                ref
                                                                    .watch(badHabitsCrudProvider
                                                                        .notifier)
                                                                    .editBadHabit(
                                                                        newBadHabit)
                                                                    .then(
                                                                        (value) {
                                                                  ref
                                                                      .watch(badHabitsProvider
                                                                          .notifier)
                                                                      .getPaginatedBadHabits(
                                                                          8, 1);
                                                                  ref
                                                                      .read(currentPageBadHabitsTable
                                                                          .notifier)
                                                                      .state = 1;
                                                                });

                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              style:
                                                                  const ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStatePropertyAll(
                                                                        AppColors
                                                                            .lightGreen),
                                                                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.elliptical(
                                                                            50,
                                                                            70)))),
                                                              ),
                                                              child:
                                                                  const PrimaryText(
                                                                text: "إضافة",
                                                                height: 1.7,
                                                                color: AppColors
                                                                    .black,
                                                              )),
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                            ));
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    color: AppColors.lightGreen,
                                  )))
                        ],
                      ),
                    ),
                  ],
                ))
            .toList(),
        // source: DataSource(context, badHabits, ref),
      ),
    );
  }
}

StateProvider hovered = StateProvider((ref) => false);
