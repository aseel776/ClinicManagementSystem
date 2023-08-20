import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './/core/app_colors.dart';
import './types_section.dart';
import './upsert_problem.dart';
import './problems_section.dart';
import '../states/types/problem_type_state.dart';
import '../states/types/problem_type_provider.dart';

class ProblemsMainSection extends StatelessWidget {
  final double sectionWidth;
  const ProblemsMainSection({Key? key, required this.sectionWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      //row and scaffold to be removed
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenHeight * .125),
            Consumer(
              builder: (context, ref, child) {
                return Row(
                  children: [
                    Container(
                      width: sectionWidth * .6,
                      height: screenHeight * .07,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
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
                            height: screenHeight * .04,
                            child: Icon(
                              Icons.search,
                              color: AppColors.black.withOpacity(0.5),
                              size: sectionWidth * .018,
                            ),
                          ),
                          SizedBox(width: sectionWidth * .01),
                          //text field
                          Expanded(
                            child: TextField(
                              // controller: _controller.searchController,
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
                    SizedBox(width: sectionWidth * .025),
                    MaterialButton(
                      height: screenHeight * .08,
                      minWidth: sectionWidth * .175,
                      color: AppColors.lightGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () async {
                        final tempState = ref.watch(problemTypesProvider);
                        if (tempState is LoadedProblemTypesState) {
                          await showUpsertProblemPopUp(context, tempState.types);
                        } else {
                          await ref.read(problemTypesProvider.notifier).getAllTypes();
                        }
                      },
                      child: Row(
                        children: [
                          const Text(
                            'إضافة مشكلة',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: (sectionWidth * .175) * .02),
                          const Icon(
                            Icons.add,
                          )
                        ],
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    MaterialButton(
                      height: screenHeight * .08,
                      minWidth: sectionWidth * .15,
                      color: AppColors.lightGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () async {

                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'تصفية',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: (sectionWidth * .15) * .02),
                          const Icon(
                              Icons.filter_alt
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: screenHeight * .05),
            Row(
              children: [
                ProblemsSection(
                  sectionHeight: screenHeight * .675,
                  sectionWidth: sectionWidth * .6,
                ),
                SizedBox(width: sectionWidth * .025),
                ProblemTypesSection(
                  key: const ObjectKey(0),
                  sectionHeight: screenHeight * .675,
                  sectionWidth: sectionWidth * .3,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
