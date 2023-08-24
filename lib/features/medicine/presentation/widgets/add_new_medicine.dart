// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:clinic_management_system/core/app_colors.dart';
import 'package:clinic_management_system/core/primaryText.dart';
import 'package:clinic_management_system/features/medicine/data/model/medicine_model.dart';
import 'package:clinic_management_system/features/medicine/presentation/Pages/medicine_page.dart';
import 'package:clinic_management_system/features/medicine/presentation/riverpod/medicines/add_update_delete_provider.dart';
import 'package:clinic_management_system/features/medicine/presentation/riverpod/medicines/medicines_provider.dart';
import 'package:clinic_management_system/features/medicine/presentation/widgets/text_field.dart';
import 'package:clinic_management_system/features/medicine/presentation/widgets/type_drop_down.dart';
import 'package:clinic_management_system/features/patients_management/presentation/widgets/step1_form.dart';
import 'package:clinic_management_system/features/patients_management/presentation/widgets/textField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../active_materials_feature/data/models/active_material_model.dart';
import '../../../active_materials_feature/presentation/states/active_materials/active_materials_provider.dart';
import '../../../active_materials_feature/presentation/states/active_materials/active_materials_state.dart';
import '../../../diseases_badHabits/presentation/widgets/add_button.dart';
import '../../data/model/category.dart';
import '../riverpod/medicines/categories_provider.dart';

StateProvider medicineName =
    StateProvider<TextEditingController>((ref) => TextEditingController());
StateProvider medicineConcentration =
    StateProvider<TextEditingController>((ref) => TextEditingController());

class AddMedicineDialog {
  showDialog1(BuildContext context, WidgetRef ref, List<Category> cat,
      bool addOrEdit, int? medicineId) {
    ref.watch(categoriesProvider);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Dialog(
              backgroundColor: AppColors.lightGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                final double maxWidth = constraints.maxWidth;
                final double maxHeight = constraints.maxHeight;

                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    color: AppColors.lightGrey,
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: maxWidth * 0.45,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: maxWidth * .009,
                        left: 0,
                        right: maxWidth * .01,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //pop up header
                          Padding(
                            padding: EdgeInsets.only(
                                left: maxWidth * .001, right: maxWidth * .001),
                            child: Row(
                              textDirection: TextDirection.rtl,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: maxWidth * .001,
                                      right: maxWidth * .001),
                                  child: PrimaryText(
                                    text: addOrEdit
                                        ? "إضافة دواء جديد"
                                        : "تعديل دواء",
                                    size: maxWidth * 0.018,
                                  ),
                                ),
                                SizedBox(
                                  width: maxWidth * 0.26,
                                ),
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.close_rounded))
                              ],
                            ),
                          ),
                          //divider
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Divider(
                              color: Colors.black38,
                            ),
                          ),
                          //all the text fields
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 1.0,
                              right: 40,
                            ),
                            child: SizedBox(
                              // width: maxWidth * 0.3,
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 4.0, top: 5),
                                        child: Text(
                                          "الاسم ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: maxWidth * 0.04,
                                      ),
                                      SizedBox(
                                        width: maxWidth * 0.2,
                                        child: Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: textfield(
                                                "اسم الدواء",
                                                ref
                                                    .watch(
                                                        medicineName.notifier)
                                                    .state,
                                                "",
                                                1)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: maxHeight * 0.02,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 4.0, top: 5),
                                        child: Text(
                                          "التركيز",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: maxWidth * 0.04,
                                      ),
                                      SizedBox(
                                        width: maxWidth * 0.2,
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: textfield(
                                              "مثلاً : 10",
                                              ref
                                                  .watch(medicineConcentration
                                                      .notifier)
                                                  .state,
                                              "",
                                              1),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: maxHeight * 0.02,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 4.0, top: 5),
                                        child: Text(
                                          "الفئة ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: maxWidth * 0.044,
                                      ),
                                      SizedBox(
                                        width: maxWidth * 0.2,
                                        child: TypeDropDown(
                                          hintText: "الشكل الدوائي",
                                          items:
                                              cat.map((e) => e.name).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: maxHeight * 0.02,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 4.0, top: 5),
                                        child: Text(
                                          "المواد الفعالة  ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: maxWidth * 0,
                                      ),
                                      StatefulBuilder(
                                          builder: (context, setState) {
                                        return Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.19,
                                              child: GestureDetector(
                                                onTap: () {
                                                  antiMaterialsSelect(
                                                      context, ref);
                                                },
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.08,
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    border: Border.all(
                                                      color: Colors.grey,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 12),
                                                  child: const Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .arrow_drop_down_circle_outlined,
                                                        color: Colors.black54,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        "ادخل مواد مضادة",
                                                        style: TextStyle(
                                                          color: Colors.black54,
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
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(
                                top: 20.0,
                                right:
                                    MediaQuery.of(context).size.width * 0.13),
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    if (addOrEdit) {
                                      var catId = cat.indexWhere((element) =>
                                          element.name ==
                                          ref
                                              .watch(selectedValueProvider
                                                  .notifier)
                                              .state);
                                      if (catId != -1) {
                                        Category c = cat[catId];
                                        print("lllllllllllll");

                                        print(c.id);
                                        List<ActiveMaterialModel>?
                                            selectedMaterials = ref
                                                .watch(multiSelect.notifier)
                                                .state
                                                .cast<ActiveMaterialModel>();
                                        Medicine medicine = Medicine(
                                            concentration: int.tryParse(ref
                                                .watch(medicineConcentration
                                                    .notifier)
                                                .state
                                                .text),
                                            name: ref
                                                .watch(medicineName.notifier)
                                                .state
                                                .text,
                                            anti: selectedMaterials);
                                        await ref
                                            .watch(
                                                medicinesCrudProvider.notifier)
                                            .addMedicine(medicine, catId)
                                            .then((value) {
                                          ref
                                              .watch(
                                                  currentPageMedicines.notifier)
                                              .state = 1;
                                          ref
                                              .watch(medicinesProvider.notifier)
                                              .getPaginatedMedicines(6, 1);
                                        });
                                        Navigator.pop(context);
                                      }
                                    } else {
                                      var catId = cat.indexWhere((element) =>
                                          element.name ==
                                          ref
                                              .watch(selectedValueProvider
                                                  .notifier)
                                              .state);
                                      if (catId != -1) {
                                        Category c = cat[catId];
                                        print("lllllllllllll");

                                        print(c.id);
                                        List<ActiveMaterialModel>?
                                            selectedMaterials = ref
                                                .watch(multiSelect.notifier)
                                                .state
                                                .cast<ActiveMaterialModel>();
                                        Medicine medicine = Medicine(
                                            id: medicineId,
                                            concentration: int.tryParse(ref
                                                .watch(medicineConcentration
                                                    .notifier)
                                                .state
                                                .text),
                                            name: ref
                                                .watch(medicineName.notifier)
                                                .state
                                                .text,
                                            anti: selectedMaterials);
                                        await ref
                                            .watch(
                                                medicinesCrudProvider.notifier)
                                            .editMedicine(medicine, c.id)
                                            .then((value) {
                                          ref
                                              .watch(
                                                  currentPageMedicines.notifier)
                                              .state = 1;
                                          ref
                                              .watch(medicinesProvider.notifier)
                                              .getPaginatedMedicines(6, 1);
                                        });
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white)),
                                  child: const Text(
                                    "حفظ",
                                    style: TextStyle(color: AppColors.black),
                                  ),
                                ),
                                SizedBox(
                                  width: maxWidth * .01,
                                ),
                                TextButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white)),
                                  child: const Text(
                                    "إلغاء",
                                    style: TextStyle(color: AppColors.black),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              })),
        );
      },
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
