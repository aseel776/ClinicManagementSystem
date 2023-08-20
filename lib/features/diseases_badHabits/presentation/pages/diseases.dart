// ignore_for_file: use_build_context_synchronously

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import '../widgets/add_button.dart';
import '../widgets/search_field.dart';
import '../widgets/tooltip_custom.dart';
import '../../data/models/diseases.dart';
import 'package:clinic_management_system/core/primaryText.dart';
import 'package:clinic_management_system/core/app_colors.dart';
import 'package:clinic_management_system/core/textField.dart';
import 'package:clinic_management_system/features/diseases_badHabits/presentation/riverpod/diseases/add_update_delete_provider.dart';
import 'package:clinic_management_system/features/diseases_badHabits/presentation/riverpod/diseases/diseases_provider.dart';
import 'package:clinic_management_system/features/diseases_badHabits/presentation/riverpod/diseases/diseases_state.dart';
import 'package:clinic_management_system/features/diseases_badHabits/presentation/widgets/delete_snack_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:clinic_management_system/features/active_materials_feature/data/models/active_material_model.dart';
import 'package:clinic_management_system/features/active_materials_feature/presentation/states/active_materials/active_materials_provider.dart';
import 'package:clinic_management_system/features/active_materials_feature/presentation/states/active_materials/active_materials_state.dart';

StateProvider totalPagesDiseases = StateProvider((ref) => 1);
StateProvider currentPageDiseases = StateProvider((ref) => 1);

class DiseaseListPage extends ConsumerStatefulWidget {
  @override
  _DiseaseListPageState createState() => _DiseaseListPageState();
}

class _DiseaseListPageState extends ConsumerState<DiseaseListPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  ScrollController? scrollController;
  final int cardsPerPage = 8;

  Widget _renderContent(BuildContext context, Disease disease) {
    ref.watch(diseasesProvider);

    return Container(
      margin: const EdgeInsets.only(
          left: 22.0, right: 22.0, top: 20.0, bottom: 0.0),
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        // flipOnTouch: false,
        side: CardSide.FRONT,
        speed: 1000,
        onFlipDone: (status) {
          print(status);
        },
        front: Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: Color(0xFF006666),
            // color: AppColors.lightGreen,

            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Divider(
                thickness: 4,
                height: 5,
                color: AppColors.black,
              ),
              const SizedBox(
                height: 70,
              ),
              Text(
                disease.id.toString(),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                disease.name,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.only(right: 160.0, bottom: 8),
                child: Tooltip(
                  message: "إضغط هنا للقلب",
                  child: Icon(Icons.refresh_outlined),
                  padding: EdgeInsets.all(15),
                  decoration: ShapeDecoration(
                    color: AppColors.black,
                    shape: ToolTipCustomShape(),
                  ),
                  textStyle:
                      TextStyle(color: Colors.white, fontSize: 10, height: 1),
                  preferBelow: false,
                  verticalOffset: 0,
                ),
              )
            ],
          ),
        ),
        back: Container(
          padding: const EdgeInsets.only(top: 10),
          decoration: const BoxDecoration(
            color: Color(0xFF006666),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Anti-Materials',
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: disease.name.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(disease.name[index]),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(DeleteSnackBar(() async {
                          await ref.watch(diseasesCrudProvider.notifier).deleteDisease(disease);
                          await ref.watch(diseasesProvider.notifier).getPaginatedDiseases(8, 1);
                          ref.watch(currentPageDiseases.notifier).state = 1;
                        }));
                      },
                      child: const PrimaryText(
                        text: "حذف",
                        color: AppColors.lightGreen,
                      ),
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(AppColors.black)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        //active materials
                        await ref.watch(activeMaterialsProvider.notifier)
                            .getAllMaterials(1, items: 10000);
                        final stateActive = ref.watch(activeMaterialsProvider.notifier).state;
                        ref.watch(multiSelect);
                        ref.watch(diseaseName.notifier).state.text = disease.name;

                        // TextEditingController notes = TextEditingController();
                        return showDialog(
                            context: context,
                            builder: (context) => BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                  child: Dialog(
                                      backgroundColor: AppColors.lightGrey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        height: MediaQuery.of(context).size.height * 0.45,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: PrimaryText(
                                                text: "تعديل مرض ",
                                                size: 18,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width * 0.2,
                                                child: textfield(
                                                  "اسم المرض",
                                                  ref.watch(diseaseName.notifier).state,
                                                  "",
                                                  1,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            StatefulBuilder(
                                                builder: (context, setState) {
                                              return Directionality(
                                                textDirection: TextDirection.rtl,
                                                child: SizedBox(
                                                    width: MediaQuery.of(context).size.width * 0.2,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        antiMaterialsSelect(
                                                            context, ref);
                                                      },
                                                      child: Container(
                                                        height: MediaQuery.of(context).size.height * 0.08,
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(15),
                                                          border: Border.all(
                                                            color: Colors.grey,
                                                            width: 1,
                                                          ),
                                                        ),
                                                        padding: const EdgeInsets.symmetric(horizontal: 12),
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
                                                                color: Colors
                                                                    .black54,
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08,
                                              child: ElevatedButton(
                                                  onPressed: () async {
                                                    List<ActiveMaterialModel>? a = ref.watch(multiSelect.notifier).state.cast<ActiveMaterialModel>();
                                                    Disease diseaseNew = Disease(
                                                        id: disease.id,
                                                        name: ref.watch(diseaseName.notifier).state.text,
                                                        antiMaterials: a);
                                                    await ref
                                                        .watch(
                                                            diseasesCrudProvider
                                                                .notifier)
                                                        .editDisease(diseaseNew)
                                                        .then((value) {
                                                      ref
                                                          .watch(
                                                              diseasesProvider
                                                                  .notifier)
                                                          .getPaginatedDiseases(
                                                              8, 1);
                                                      ref
                                                          .read(
                                                              currentPageDiseases
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
                                                  child: const PrimaryText(
                                                    text: "تعديل",
                                                    height: 1.7,
                                                    color: AppColors.black,
                                                  )),
                                            )
                                          ],
                                        ),
                                      )),
                                ));
                      },
                      child: const PrimaryText(
                        text: "تعديل",
                        color: AppColors.lightGreen,
                      ),
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(AppColors.black)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // diseases = _generateDiseases();
    _pageController = PageController(initialPage: 0);
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.watch(diseasesProvider.notifier).getPaginatedDiseases(8, 1);
      final state = ref.watch(diseasesProvider.notifier).state;
      if (state is LoadedDiseasesState) {
        ref.watch(totalPagesDiseases.notifier).state = state.totalPages;
        print("blablabal");
        print(ref.watch(totalPagesDiseases.notifier).state);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(diseasesProvider.notifier).state;
    final totalPages = ref.watch(totalPagesDiseases);
    final currentPage = ref.watch(currentPageDiseases);
    ref.watch(diseasesProvider);
    final sectionWidth = MediaQuery.of(context).size.width;
    final sectionHeight = MediaQuery.of(context).size.height;
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverAppBar(
          pinned: false,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Row(
              children: [
                SizedBox(
                  width: sectionWidth * 0.4,
                  child: SearchField(
                    sectionWidth: sectionWidth,
                    sectionHeight: sectionHeight,
                    onTextChanged: (text) {
                      ref.watch(currentPageDiseases.notifier).state = 1;
                      ref
                          .watch(diseasesProvider.notifier)
                          .getPaginatedSearchDiseases(8, 1, text);
                    },
                  ),
                ),
                SizedBox(
                  width: sectionWidth * 0.27,
                ),
                AddButton(
                  text: "إضافة مرض جديد",
                  pageName: "Diseases",
                  screenHeight: sectionHeight,
                  screenWidth: sectionWidth,
                ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          expandedHeight: 80,
        ),
        SliverFillRemaining(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0.0, right: 8, left: 8),
                child: (state is ErrorDiseasesState)
                    ? Center(
                        child: PrimaryText(
                          text: state.message,
                        ),
                      )
                    : (state is LoadingDiseasesState)
                        ? LoadingAnimationWidget.inkDrop(
                            color: AppColors.black, size: 25)
                        : (state is LoadedDiseasesState)
                            ? PageView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                controller: _pageController,
                                itemCount: state.diseases.length,
                                onPageChanged: (index) {
                                  // ref.watch(currentPageDiseases.notifier).state = index;
                                },
                                itemBuilder: (context, pageIndex) {
                                  return GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                    ),
                                    itemCount: state.diseases.length,
                                    itemBuilder: (context, index) {
                                      final disease = state.diseases[index];
                                      return _renderContent(context, disease);
                                    },
                                  );
                                },
                              )
                            : Container(),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                  onPressed: () {
                    _goToPreviousPage(currentPage);
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios_rounded),
                  onPressed: () {
                    _goToNextPage(currentPage, totalPages);
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  _goToPreviousPage(int currentPage) async {
    if (currentPage > 1) {
      await _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      await ref
          .watch(diseasesProvider.notifier)
          .getPaginatedDiseases(8, currentPage - 1);

      ref.watch(currentPageDiseases.notifier).state = currentPage - 1;
    }
  }

  _goToNextPage(int currentPage, int totalPages) async {
    if (currentPage < totalPages) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      print("next PAGE");

      await ref
          .watch(diseasesProvider.notifier)
          .getPaginatedDiseases(8, currentPage + 1);

      ref.watch(currentPageDiseases.notifier).state = currentPage + 1;
    }
  }

  void antiMaterialsSelect(BuildContext context, WidgetRef ref) async {
    await ref.watch(activeMaterialsProvider.notifier).getAllMaterials(1, items: 10000);
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
                                  ActiveMaterialModel? selected1 =
                                      materials[index] as ActiveMaterialModel?;

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
