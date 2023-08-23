import 'package:clinic_management_system/core/pagination_widget.dart';
import 'package:clinic_management_system/features/diseases_badHabits/data/models/badHabits.dart';
import 'package:clinic_management_system/features/diseases_badHabits/presentation/riverpod/badHabits/badHabits_provider.dart';
import 'package:clinic_management_system/features/diseases_badHabits/presentation/riverpod/badHabits/badHabits_state.dart';
import 'package:clinic_management_system/features/diseases_badHabits/presentation/widgets/bad_habits_table.dart';
import 'package:clinic_management_system/core/primaryText.dart';
// import 'package:clinic_management_system/features/patients_management/presentation/pages/patients_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/app_colors.dart';
import '../widgets/add_button.dart';
import '../widgets/search_field.dart';

StateProvider totalPagesBadHabitsTable = StateProvider((ref) => 1);
StateProvider currentPageBadHabitsTable = StateProvider((ref) => 1);

class BadHabits extends ConsumerStatefulWidget {
  @override
  ConsumerState<BadHabits> createState() => _BadHabitsState();
}

class _BadHabitsState extends ConsumerState<BadHabits> {
  late List<BadHabit> badhabits;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.watch(badHabitsProvider.notifier).getPaginatedBadHabits(8, 1);
      final state = ref.watch(badHabitsProvider);
      if (state is LoadedBadHabitsState) {
        ref.watch(totalPagesBadHabitsTable.notifier).state = state.totalPages;
        print("blablabal");
        print(ref.watch(totalPagesBadHabitsTable.notifier).state);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(badHabitsProvider);
    final totalPages = ref.watch(totalPagesBadHabitsTable);
    final currentPage = ref.watch(currentPageBadHabitsTable);
    ref.watch(badHabitsProvider);
    final sectionWidth = MediaQuery.of(context).size.width;
    final sectionHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 28.0, right: 10),
            child: Row(
              children: [
                SearchField(
                  sectionWidth: sectionWidth,
                  sectionHeight: sectionHeight,
                  onTextChanged: (text) {
                    ref.watch(currentPageBadHabitsTable.notifier).state = 1;
                    ref
                        .watch(badHabitsProvider.notifier)
                        .getPaginatedSearchBadHabits(8, 1, text);
                  },
                ),
                SizedBox(
                  width: sectionWidth * 0.03,
                ),
                AddButton(
                  text: "إضافة عادة جديدة",
                  pageName: "BadHabits",
                  screenHeight: sectionHeight,
                  screenWidth: sectionWidth,
                ),
                const Spacer(),
                // Padding(
                //   padding: const EdgeInsets.only(left: 30.0),
                //   child: ElevatedButton(
                //       onPressed: () async {
                //         // await ref
                //         //     .watch(badHabitsProvider.notifier)
                //         //     .getPaginatedBadHabits(5, 1);
                //         // print(
                //         //     "blabla" + ref.watch(badHabitsProvider).toString());
                //       },
                //       style: const ButtonStyle(
                //           backgroundColor:
                //               MaterialStatePropertyAll(AppColors.lightGreen),
                //           shape: MaterialStatePropertyAll(
                //               RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.all(
                //                       Radius.elliptical(20, 40)))),
                //           minimumSize: MaterialStatePropertyAll(Size(100, 50))),
                //       child: const Row(
                //         children: [
                //           PrimaryText(
                //             text: "فلترة",
                //             color: AppColors.black,
                //           ),
                //           SizedBox(
                //             width: 8,
                //           ),
                //           Icon(
                //             Icons.arrow_back_ios_new_outlined,
                //             size: 14,
                //             color: AppColors.black,
                //           )
                //         ],
                //       )),
                // )
              ],
            ),
          ),
          SizedBox(
            width: sectionWidth,
            child: Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 10),
                child: (state is LoadedBadHabitsState)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: sectionWidth,
                              // height: sectionHeight * 0.3,
                              child: BadHabitsTableWidget(
                                  badHabits: state.badHabits)),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PaginationWidget(
                                totalPages: totalPages,
                                currentPage: currentPage,
                                onPageSelected: (i) async {
                                  print("iiiii");
                                  print(i);
                                  await ref
                                      .watch(badHabitsProvider.notifier)
                                      .getPaginatedBadHabits(
                                          7, (i + 1).toDouble());
                                  ref
                                      .watch(currentPageBadHabitsTable.notifier)
                                      .state = i + 1;
                                },
                              )
                            ],
                          ),
                        ],
                      )
                    : (state is LoadingBadHabitsState)
                        ? LoadingAnimationWidget.inkDrop(
                            color: AppColors.black, size: 20)
                        : (state is ErrorBadHabitsState)
                            ? Center(
                                child: PrimaryText(
                                  text: state.message,
                                ),
                              )
                            : Container()),
          ),
        ],
      ),
    );
  }
}
