// ignore_for_file: use_build_context_synchronously

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
                                                                    ref
                                                                        .watch(multiSelect
                                                                            .notifier)
                                                                        .state = row.antiMaterials!;
                                                                    antiMaterialsSelect(
                                                                        context,
                                                                        ref);
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

  void antiMaterialsSelect(BuildContext context, WidgetRef ref) async {
    await ref
        .watch(activeMaterialsProvider.notifier)
        .getAllMaterials(1, items: 10000);
    // ref.watch(mul)/
    final stateActive = ref.watch(activeMaterialsProvider.notifier).state;
    // material.antiMaterials ??= [];
    // List<String>? originalOne = material.antiMaterials!.toList();
    final materials;
    if (stateActive is LoadedActiveMaterialsState) {
      materials = stateActive.page.materials;
      print("materialllls");
      print(materials.toString());
    } else {
      materials = [];
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth * .25;
    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = screenHeight * .5;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                width: containerWidth,
                height: containerHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                padding: EdgeInsets.only(
                  top: containerHeight * .035,
                  bottom: containerHeight * .025,
                  left: containerWidth * .05,
                  right: containerWidth * .05,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: containerHeight * .1,
                      child: const Text(
                        'التعارضات الدوائية',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 20,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: containerHeight * .025,
                      child: Divider(
                        color: Colors.grey[400],
                      ),
                    ),
                    SizedBox(height: containerHeight * .02),
                    SizedBox(
                      height: containerHeight * .655,
                      child: ListView.builder(
                        itemCount: materials.length,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                            value: ref
                                .watch(multiSelect.notifier)
                                .state
                                .any((element) => element == materials[index]),
                            onChanged: (value) {
                              setState(() {
                                if (value!) {
                                  ActiveMaterialModel selected1 =
                                      materials[index] as ActiveMaterialModel;

                                  if (selected1.name! != "" &&
                                      !ref
                                          .watch(multiSelect.notifier)
                                          .state!
                                          .any((element) =>
                                              element == selected1)) {
                                    print(value.toString() + "addeddd");

                                    List list =
                                        ref.watch(multiSelect.notifier).state!;
                                    // print(list.toString());

                                    list.add(selected1);
                                    ref.read(multiSelect.notifier).state =
                                        list.toList();
                                    print("lengthhhh");
                                    print(list.length);
                                  }
                                  //  else if (ref
                                  //     .watch(multiSelect.notifier)
                                  //     .state
                                  //     .any((element) => element == selected1)) {
                                  //   List list =
                                  //       ref.watch(multiSelect.notifier).state;

                                  //   list.remove(selected1);
                                  //   ref.read(multiSelect.notifier).state =
                                  //       list.toList();
                                  // }
                                } else if (!value &&
                                    ref.watch(multiSelect.notifier).state.any(
                                        (element) =>
                                            element == materials[index])) {
                                  print(value.toString() + "removed");
                                  ActiveMaterialModel selected1 =
                                      materials[index] as ActiveMaterialModel;

                                  List list =
                                      ref.watch(multiSelect.notifier).state!;
                                  print("lisssssssssssst");
                                  print(list.toString());

                                  list.remove(selected1);
                                  ref.read(multiSelect.notifier).state =
                                      list.toList();
                                  print("lengthhhh");
                                  print(list.length);
                                }
                              });
                            },
                            title: Text(
                              materials[index].name!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'Cairo',
                                color: AppColors.black,
                              ),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: AppColors.black,
                            checkboxShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: containerHeight * .04),
                    SizedBox(
                      height: containerHeight * .1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            minWidth: containerWidth * .3,
                            color: Colors.white,
                            elevation: 0,
                            hoverElevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                            onPressed: () {
                              print(ref
                                  .watch(multiSelect.notifier)
                                  .state!
                                  .length);
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'تأكيد',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(width: containerWidth * .05),
                          MaterialButton(
                            minWidth: containerWidth * .3,
                            color: Colors.white,
                            elevation: 0,
                            hoverElevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                            onPressed: () {
                              // material.antiMaterials = originalOne;
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'إلغاء',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

StateProvider hovered = StateProvider((ref) => false);
