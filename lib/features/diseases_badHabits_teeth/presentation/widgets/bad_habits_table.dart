import 'dart:ui';

import 'package:clinic_management_system/features/diseases_badHabits_teeth/presentation/pages/badHabits.dart';
import 'package:clinic_management_system/features/diseases_badHabits_teeth/presentation/riverpod/badHabits/add_update_delete_provider.dart';
import 'package:clinic_management_system/features/diseases_badHabits_teeth/presentation/riverpod/badHabits/badHabits_provider.dart';
import 'package:clinic_management_system/features/diseases_badHabits_teeth/presentation/riverpod/badHabits/badHabits_state.dart';
import 'package:clinic_management_system/features/diseases_badHabits_teeth/presentation/widgets/delete_bottom_sheet.dart';
import 'package:clinic_management_system/features/medicine/presentation/widgets/primaryText.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/app_colors.dart';

import '../../../medicine/data/model/active_materials.dart';
import '../../../medicine/presentation/riverpod/active_materials/active_materials_provider.dart';
import '../../../medicine/presentation/riverpod/active_materials/active_materials_state.dart';
import '../../../patients_management/presentation/widgets/textField.dart';
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
          iconTheme: IconThemeData(color: Colors.blue)),
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
                    DataCell(Text(row.name.toString())),
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
                                child: Icon(
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
                                                      AppColors.grey,
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
                                                                List<ActiveMaterials>?
                                                                    selectedMaterials =
                                                                    ref
                                                                        .watch(multiSelect
                                                                            .notifier)
                                                                        .state
                                                                        .cast<
                                                                            ActiveMaterials>();
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
                                                                  PrimaryText(
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
                                  child: Icon(
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

class DataSource extends DataTableSource {
  DataSource(this.context, this._rows, this.ref);

  final BuildContext context;

  late List<BadHabit> _rows;
  WidgetRef ref;

  int _selectedCount = 0;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _rows.length) return null;
    final row = _rows[index];
    return DataRow.byIndex(
      // onLongPress: () => print("aaa"),
      index: index,
      // onSelectChanged: (value) => print("asdas"),
      cells: [
        DataCell(Text(row.id.toString()), onTap: () => null),
        DataCell(Text(row.name.toString())),
        DataCell(Text(row.name.toString())),
        DataCell(Text(row.name.toString())),
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
                                    .watch(currentPageBadHabitsTable.notifier)
                                    .state
                                    .toDouble());

                        // await ref.watch()
                      }));
                    },
                    child: Icon(
                      Icons.delete,
                      color: AppColors.lightGreen,
                    ),
                  )),
              SizedBox(
                  width: 40,
                  child: TextButton(
                      onPressed: () {
                        ref.watch(badHabitsName.notifier).state.text = row.name;
                        showDialog(
                            context: context,
                            builder: (context) => BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                  child: Dialog(
                                      backgroundColor: AppColors.grey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.45,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: PrimaryText(
                                                text: "تعديل عادة سيئة",
                                                size: 18,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
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
                                            const SizedBox(height: 20),
                                            StatefulBuilder(
                                                builder: (context, setState) {
                                              return Directionality(
                                                textDirection:
                                                    TextDirection.rtl,
                                                child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.2,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        antiMaterialsSelect(
                                                            context, ref);
                                                      },
                                                      child: Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.08,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          border: Border.all(
                                                            color: Colors.grey,
                                                            width: 1,
                                                          ),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 12),
                                                        child: const Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .arrow_drop_down_circle_outlined,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                            SizedBox(width: 8),
                                                            Text(
                                                              "ادخل مواد مضادة",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
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
                                            const SizedBox(height: 20),
                                            const SizedBox(
                                              width: 30,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08,
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    List<ActiveMaterials>?
                                                        selectedMaterials = ref
                                                            .watch(multiSelect
                                                                .notifier)
                                                            .state
                                                            .cast<
                                                                ActiveMaterials>();
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
                                                        .watch(
                                                            badHabitsCrudProvider
                                                                .notifier)
                                                        .editBadHabit(
                                                            newBadHabit)
                                                        .then((value) {
                                                      ref
                                                          .watch(
                                                              badHabitsProvider
                                                                  .notifier)
                                                          .getPaginatedBadHabits(
                                                              8, 1);
                                                      ref
                                                          .read(
                                                              currentPageBadHabitsTable
                                                                  .notifier)
                                                          .state = 1;
                                                    });

                                                    Navigator.pop(context);
                                                  },
                                                  style: const ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            AppColors
                                                                .lightGreen),
                                                    shape: MaterialStatePropertyAll(
                                                        RoundedRectangleBorder(
                                                            borderRadius: BorderRadius
                                                                .all(Radius
                                                                    .elliptical(
                                                                        50,
                                                                        70)))),
                                                  ),
                                                  child: PrimaryText(
                                                    text: "إضافة",
                                                    height: 1.7,
                                                    color: AppColors.black,
                                                  )),
                                            )
                                          ],
                                        ),
                                      )),
                                ));
                      },
                      child: Icon(
                        Icons.edit,
                        color: AppColors.lightGreen,
                      )))
            ],
          ),
        )
      ],
    );
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  // Add these properties
  int _currentPage = 1; // Initialize with the first page
  int _rowsPerPage = 7; // Set your rows per page here

  void updateRows(List<BadHabit> newData, int currentPage) {
    _rows = newData;
    _currentPage = currentPage;
    notifyListeners();
  }

  void antiMaterialsSelect(BuildContext context, WidgetRef ref) async {
    await ref.watch(activeMaterialsProvider.notifier).getAllMaterials();
    final stateActive = ref.watch(activeMaterialsProvider.notifier).state;
    // material.antiMaterials ??= [];
    // List<String>? originalOne = material.antiMaterials!.toList();
    final materials;
    if (stateActive is LoadedActiveMaterialsState) {
      materials = stateActive.materials;
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
                                .state!
                                .any((element) => element == materials[index]),
                            onChanged: (value) {
                              setState(() {
                                if (value!) {
                                  ActiveMaterials selected1 =
                                      materials[index] as ActiveMaterials;

                                  if (selected1.name! != "" &&
                                      !ref
                                          .watch(multiSelect.notifier)
                                          .state!
                                          .any((element) =>
                                              element == selected1)) {
                                    print(value.toString() + "addeddd");

                                    List list =
                                        ref.watch(multiSelect.notifier).state!;

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
                                    ref.watch(multiSelect.notifier).state!.any(
                                        (element) =>
                                            element == materials[index])) {
                                  print(value.toString() + "removed");
                                  ActiveMaterials? selected1 =
                                      materials[index] as ActiveMaterials?;

                                  List list =
                                      ref.watch(multiSelect.notifier).state!;

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
