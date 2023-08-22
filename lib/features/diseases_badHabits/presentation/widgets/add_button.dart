// ignore_for_file: use_build_context_synchronously
import 'dart:ui';
import 'package:clinic_management_system/features/diseases_badHabits/data/models/badHabits.dart';
import 'package:clinic_management_system/features/diseases_badHabits/data/models/diseases.dart';
import 'package:clinic_management_system/features/diseases_badHabits/presentation/pages/diseases.dart';
import 'package:clinic_management_system/features/diseases_badHabits/presentation/riverpod/badHabits/add_update_delete_provider.dart';
import 'package:clinic_management_system/features/diseases_badHabits/presentation/riverpod/badHabits/badHabits_provider.dart';
import 'package:clinic_management_system/features/diseases_badHabits/presentation/riverpod/diseases/diseases_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/app_colors.dart';
import 'package:clinic_management_system/features/active_materials_feature/data/models/active_material_model.dart';
import 'package:clinic_management_system/features/active_materials_feature/presentation/states/active_materials/active_materials_provider.dart';
import 'package:clinic_management_system/features/active_materials_feature/presentation/states/active_materials/active_materials_state.dart';
import 'package:clinic_management_system/core/primaryText.dart';
import 'package:clinic_management_system/core/textField.dart';
import '../pages/badHabits.dart';
import '../riverpod/diseases/add_update_delete_provider.dart';

final multiSelect = StateProvider.autoDispose<List>((ref) => []);
StateProvider diseaseName = StateProvider((ref) => TextEditingController());
StateProvider badHabitsName = StateProvider((ref) => TextEditingController());

class AddButton extends ConsumerWidget {
  String? text = "";
  double? screenWidth;
  double? screenHeight;
  String? pageName;
  bool? addOrEdit;

  AddButton({
    required this.text,
    required this.screenHeight,
    required this.pageName,
    this.screenWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
        onPressed: () {
          if (pageName == "BadHabits") {
            addBadHabits_popup(context, ref);
          } else if (pageName == "Diseases") {
            addDiseases_popup(context, ref);
          }
        },
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(AppColors.lightGreen),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.elliptical(50, 70)))),
            minimumSize: MaterialStatePropertyAll(Size(50, 50))),
        child: Row(
          children: [
            PrimaryText(
              text: text!,
              height: 1.7,
              color: AppColors.black,
            ),
            const Padding(
              padding: EdgeInsets.only(right: 13.0),
              child: Icon(
                Icons.add,
                color: AppColors.black,
              ),
            )
          ],
        ));
  }

  Future<void> addDiseases_popup(BuildContext context, WidgetRef ref) async {
    ref.watch(diseaseName.notifier).state.text = "";
    ref.watch(multiSelect.notifier).state = [];

    //active materials
    await ref
        .watch(activeMaterialsProvider.notifier)
        .getAllMaterials(1, items: 10000);
    final stateActive = ref.watch(activeMaterialsProvider.notifier).state;
    ref.watch(multiSelect);

    // TextEditingController notes = TextEditingController();
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
                    width: screenWidth! * 0.4,
                    height: screenHeight! * 0.45,
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
                        const SizedBox(height: 20),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: SizedBox(
                            width: screenWidth! * 0.2,
                            child: textfield("اسم المرض",
                                ref.watch(diseaseName.notifier).state, "", 1),
                          ),
                        ),
                        const SizedBox(height: 20),
                        StatefulBuilder(builder: (context, setState) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: SizedBox(
                                width: screenWidth! * 0.2,
                                child: GestureDetector(
                                  onTap: () {
                                    antiMaterialsSelect(context, ref);
                                  },
                                  child: Container(
                                    height: screenHeight! * 0.08,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_drop_down_circle_outlined,
                                          color: Colors.black54,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "ادخل مواد مضادة",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600,
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
                        SizedBox(
                          width: screenWidth! * 0.08,
                          child: ElevatedButton(
                              onPressed: () async {
                                print("adddddddddddddd");
                                print(ref
                                    .watch(multiSelect.notifier)
                                    .state
                                    .toString());
                                List<ActiveMaterialModel>? a = ref
                                    .watch(multiSelect.notifier)
                                    .state
                                    .cast<ActiveMaterialModel>();

                                Disease disease = Disease(
                                    name: ref
                                        .watch(diseaseName.notifier)
                                        .state
                                        .text,
                                    antiMaterials: a);
                                await ref
                                    .watch(diseasesCrudProvider.notifier)
                                    .addDisease(disease)
                                    .then((value) {
                                  ref
                                      .watch(diseasesProvider.notifier)
                                      .getPaginatedDiseases(8, 1);
                                  ref.read(currentPageDiseases.notifier).state =
                                      1;
                                });

                                Navigator.pop(context);
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

  Future<void> addBadHabits_popup(
    BuildContext context,
    WidgetRef ref,
  ) async {
    ref.watch(badHabitsName.notifier).state.text = "";
    ref.watch(multiSelect.notifier).state = [];
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
                    width: screenWidth! * 0.4,
                    height: screenHeight! * 0.45,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: PrimaryText(
                            text: text,
                            size: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: SizedBox(
                            width: screenWidth! * 0.2,
                            child: textfield("الاسم",
                                ref.watch(badHabitsName.notifier).state, "", 1),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(height: 20),
                        StatefulBuilder(builder: (context, setState) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: SizedBox(
                                width: screenWidth! * 0.2,
                                child: GestureDetector(
                                  onTap: () {
                                    antiMaterialsSelect(context, ref);
                                  },
                                  child: Container(
                                    height: screenHeight! * 0.08,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_drop_down_circle_outlined,
                                          color: Colors.black54,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "ادخل مواد مضادة",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600,
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
                          width: screenWidth! * 0.08,
                          child: ElevatedButton(
                              onPressed: () {
                                List<ActiveMaterialModel>? selectedMaterials =
                                    ref
                                        .watch(multiSelect.notifier)
                                        .state
                                        .cast<ActiveMaterialModel>();
                                BadHabit newBadHabit = BadHabit(
                                    name: ref
                                        .watch(badHabitsName.notifier)
                                        .state
                                        .text,
                                    antiMaterials: selectedMaterials);
                                ref
                                    .watch(badHabitsCrudProvider.notifier)
                                    .addBadHabit(newBadHabit)
                                    .then((value) {
                                  ref
                                      .watch(badHabitsProvider.notifier)
                                      .getPaginatedBadHabits(8, 1);
                                  ref
                                      .read(currentPageBadHabitsTable.notifier)
                                      .state = 1;
                                });

                                Navigator.pop(context);
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

  void antiMaterialsSelect(BuildContext context, WidgetRef ref) async {
    ref.watch(multiSelect);
    await ref
        .watch(activeMaterialsProvider.notifier)
        .getAllMaterials(1, items: 10000);
    final stateActive = ref.watch(activeMaterialsProvider.notifier).state;
    // material.antiMaterials ??= [];
    // List<String>? originalOne = material.antiMaterials!.toList();
    final materials;
    if (stateActive is LoadedActiveMaterialsState) {
      materials = stateActive.page.materials;
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
                                  ActiveMaterialModel selected1 =
                                      materials[index] as ActiveMaterialModel;

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
