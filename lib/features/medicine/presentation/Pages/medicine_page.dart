import 'package:clinic_management_system/core/app_colors.dart';
import 'package:clinic_management_system/core/pagination_widget.dart';
import 'package:clinic_management_system/features/diseases_badHabits/presentation/widgets/add_button.dart';
import 'package:clinic_management_system/features/medicine/presentation/riverpod/medicines/add_update_delete_provider.dart';
import 'package:clinic_management_system/features/medicine/presentation/riverpod/medicines/categories_provider.dart';
import 'package:clinic_management_system/features/medicine/presentation/riverpod/medicines/medicines_provider.dart';
import 'package:clinic_management_system/features/medicine/presentation/riverpod/medicines/medicines_state.dart';

import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../diseases_badHabits/presentation/widgets/delete_snack_bar.dart';
import '../widgets/add_new_medicine.dart';
import '../widgets/primaryText.dart';
import '../widgets/searchbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/table-data-source.dart';

final containerProvider = StateProvider.family<double?, BuildContext>(
    (ref, context) => MediaQuery.of(context).size.width * 0.4);
final tableProvider = StateProvider.family<double?, BuildContext>(
    (ref, context) => MediaQuery.of(context).size.width * 0.82);
final expandedBar = StateProvider<bool>((ref) => true);

final totalPagesMedicines = StateProvider((ref) => 1);
final currentPageMedicines = StateProvider((ref) => 1);

class MedicinePage extends ConsumerStatefulWidget {
  const MedicinePage({super.key});

  @override
  ConsumerState<MedicinePage> createState() => _MedicinePageState();
}

class _MedicinePageState extends ConsumerState<MedicinePage> {
  ScrollController? scrollController;
  ScrollController? searchController;
  TextEditingController? controller;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    searchController = ScrollController();
    controller = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.watch(medicinesProvider.notifier).getPaginatedMedicines(6, 1);
      final state = ref.watch(medicinesProvider.notifier).state;
      if (state is LoadedMedicinesState) {
        ref.watch(totalPagesMedicines.notifier).state = state.totalPages!;
      }
    });
  }

  void handleScroll(ScrollController? scrollController, WidgetRef ref) {
    if (scrollController!.offset >= 180) {
      ref.read(expandedBar.notifier).state = false;
    } else {
      ref.read(expandedBar.notifier).state = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(medicinesProvider.notifier).state;

    ref.watch(totalPagesMedicines);
    ref.watch(currentPageMedicines);
    ref.watch(medicinesProvider);

    final sectionWidth = MediaQuery.of(context).size.width;
    final sectionHeight = MediaQuery.of(context).size.height;
    return CustomScrollView(
      controller: scrollController,
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          floating: true,
          title: Visibility(
            visible: !ref.watch(expandedBar),
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Container(
                width: sectionWidth * 0.7,
                height: sectionHeight * 0.06,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: sectionWidth * 0.01,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //search icon
                    SizedBox(
                      width: sectionWidth * .02,
                      height: sectionHeight * .04,
                      child: Icon(
                        Icons.search,
                        textDirection: TextDirection.rtl,
                        color: AppColors.black.withOpacity(0.5),
                        size: sectionWidth * .018,
                      ),
                    ),
                    SizedBox(width: sectionWidth * .01),

                    //text field
                    SizedBox(
                      width: sectionWidth * .6,
                      child: TextField(
                        controller: controller,
                        scrollPadding: const EdgeInsets.all(0),
                        onChanged: (search) {
                          print("11111111111111111111111");
                          // ref
                          //     .watch(medicinesProvider.notifier)
                          //     .getSearchMedicines(6, 1, search);
                          // ref.watch(currentPageMedicines.notifier).state = 1;
                        },
                        scrollController: searchController,
                        textAlign: TextAlign.right,
                        cursorColor: AppColors.black,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          color: AppColors.black.withOpacity(.8),
                        ),
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                          hintText: 'بحث',
                          hintStyle: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 18,
                            color: AppColors.black.withOpacity(.5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          expandedHeight: sectionHeight * 0.27,
          backgroundColor: AppColors.lightGrey,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            background: Padding(
              padding: const EdgeInsets.only(top: 0.0, right: 15),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 28.0),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(30),
                              right: Radius.circular(20))),
                      width: MediaQuery.of(context).size.width * 0.37,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: PrimaryText(
                                    text: 'قسم الأدوية',
                                    size: 30,
                                    fontWeight: FontWeight.w800),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 18.0, top: 10),
                                child: Image.asset(
                                  "assets/images/medicine1.png",
                                  width: 40,
                                  height: 40,
                                ),

                                //  Icon(
                                //   Icons.grid_3x3,
                                //   color: Colors.redAccent,
                                // ),
                              )
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 18.0),
                            child: Text(
                              "-----------------------",
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.2),
                    child: SvgPicture.asset(
                      'assets/svgs/undraw_medicine.svg',

                      color: AppColors
                          .lightGreen, // Replace with your desired color
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        SliverFillRemaining(
          // hasScrollBody: false,
          child: Stack(
            children: [
              Visibility(
                visible: ref.watch(expandedBar),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  // color: Colors.red,
                  width: ref.watch(tableProvider(context)),
                  height: sectionHeight * .1,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, right: 0),
                    child: Row(
                      children: [
                        const Expanded(child: Searchbar()),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.01,
                        ),
                        // Container(
                        //     width: sectionWidth * .04,
                        //     height: sectionHeight * .07,
                        //     decoration: BoxDecoration(
                        //         color: AppColors.lightGreen,
                        //         borderRadius: BorderRadius.circular(14)),
                        //     child: IconButton(
                        //         onPressed: () {},
                        //         icon: const Icon(Icons.filter_list_alt))),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0, bottom: 3),
                          child: SizedBox(
                            height: sectionHeight * .06,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      AppColors.black),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  await ref
                                      .watch(categoriesProvider.notifier)
                                      .getCategories();
                                  final stateCat = ref
                                      .watch(categoriesProvider.notifier)
                                      .state;
                                  if (stateCat is LoadedCategoriesState) {
                                    AddMedicineDialog().showDialog1(context,
                                        ref, stateCat.categories, true, null);
                                  }
                                },
                                child:
                                    const PrimaryText(text: "إضافة دواء جديد")),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                height: sectionHeight * .7,
                width: ref.watch(tableProvider(context)),
                top: MediaQuery.of(context).size.height * 0.1,
                child: SizedBox(
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Theme(
                      data: ThemeData(
                          cardColor: Colors.transparent,
                          cardTheme: const CardTheme(
                              margin: EdgeInsets.only(bottom: 40),
                              color: AppColors.lightGreen,
                              shadowColor: Colors.yellow,
                              surfaceTintColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)))),
                          primaryColorDark: Colors.amberAccent,
                          textTheme: const TextTheme(
                              bodySmall: TextStyle(color: Colors.pink))),
                      child: (state is LoadedMedicinesState)
                          ? Column(
                              children: [
                                DataTable(
                                  columnSpacing: 110,
                                  // header: const Text(""),
                                  // actions: [
                                  //   IconButton(
                                  //       onPressed: () {},
                                  //       icon: const Icon(Icons.refresh))
                                  // ],
                                  // rowsPerPage: 5,
                                  columns: const [
                                    DataColumn(label: Text('الرقم')),
                                    DataColumn(label: Text('الاسم')),
                                    DataColumn(label: Text('التركيز')),
                                    DataColumn(label: Text('النوع')),
                                    DataColumn(label: Text('المواد الفعالة')),
                                    DataColumn(label: Text("العمليات"))
                                  ],
                                  rows: state.medicines
                                      .map((row) => DataRow(
                                            cells: [
                                              DataCell(Text(row.id.toString()),
                                                  onTap: () => null),
                                              DataCell(
                                                  Text(row.name.toString())),
                                              DataCell(Text(row.concentration
                                                  .toString())),

                                              DataCell(Text(
                                                  row.category.toString())),
                                              DataCell(Text(row.anti!
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
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    DeleteSnackBar(
                                                                        () async {
                                                              await ref
                                                                  .watch(medicinesCrudProvider
                                                                      .notifier)
                                                                  .deleteMedicine(
                                                                      row.id!)
                                                                  .then(
                                                                      (value) {
                                                                ref
                                                                    .watch(medicinesProvider
                                                                        .notifier)
                                                                    .getPaginatedMedicines(
                                                                        6, 1);

                                                                ref
                                                                    .watch(currentPageMedicines
                                                                        .notifier)
                                                                    .state = 1;
                                                              });

                                                              // await ref.watch()
                                                            }));
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
                                                            onPressed:
                                                                () async {
                                                              await ref
                                                                  .watch(categoriesProvider
                                                                      .notifier)
                                                                  .getCategories();
                                                              final stateCat = ref
                                                                  .watch(categoriesProvider
                                                                      .notifier)
                                                                  .state;
                                                              if (stateCat
                                                                  is LoadedCategoriesState) {
                                                                ref
                                                                        .watch(medicineConcentration
                                                                            .notifier)
                                                                        .state
                                                                        .text =
                                                                    row.concentration
                                                                        .toString();
                                                                ref
                                                                    .watch(medicineName
                                                                        .notifier)
                                                                    .state
                                                                    .text = row.name;

                                                                ref
                                                                    .watch(multiSelect
                                                                        .notifier)
                                                                    .state = row.anti!;

                                                                AddMedicineDialog()
                                                                    .showDialog1(
                                                                        context,
                                                                        ref,
                                                                        stateCat
                                                                            .categories,
                                                                        false,
                                                                        row.id);
                                                              }
                                                            },
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
                                      .toList(),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: sectionWidth * 0.35,
                                      top: sectionHeight * 0.01),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: PaginationWidget(
                                        totalPages: ref
                                            .watch(totalPagesMedicines.notifier)
                                            .state,
                                        currentPage: ref
                                            .watch(
                                                currentPageMedicines.notifier)
                                            .state,
                                        onPageSelected: (i) async {
                                          await ref
                                              .watch(medicinesProvider.notifier)
                                              .getPaginatedMedicines(
                                                  6, (i + 1).toDouble());
                                          ref
                                              .watch(
                                                  currentPageMedicines.notifier)
                                              .state = i + 1;
                                        }),
                                  ),
                                )
                              ],
                            )
                          : LoadingAnimationWidget.inkDrop(
                              color: AppColors.black, size: 35),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

animatedContainer(
    BuildContext context, WidgetRef ref, int index, bool closeButton) {
  final width = MediaQuery.of(context).size.width * 0.4;
  final width1 = MediaQuery.of(context).size.width * 0.64;
  final tableInitial = MediaQuery.of(context).size.width * 0.82;
  final tableWidth = MediaQuery.of(context).size.width * 0.62;
  if (!closeButton) {
    ref.read(containerProvider(context).notifier).state = width1;
    ref.read(tableProvider(context).notifier).state = tableWidth;
    print(index);
  } else if (closeButton) {
    ref.read(containerProvider(context).notifier).state = width;
    ref.read(tableProvider(context).notifier).state = tableInitial;
  }
}
