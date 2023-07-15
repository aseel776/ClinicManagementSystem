import 'package:clinic_management_system/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'types_section.dart';
import 'treatments_section.dart';

import '../../controllers/main_section_controller.dart';

class TreatmentsMainSection extends StatelessWidget {
  final double sectionWidth;

  TreatmentsMainSection({
    Key? key,
    required this.sectionWidth
  }) : super(key: key);

  final _controller = MainSectionController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      //row and scaffold to be removed
      body: Row(
        children: [
          //return starts here
          Container(
            width: sectionWidth,
            color: AppColors.lightGrey,
            // color: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: sectionWidth * .02,
              vertical: screenHeight * .04,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //filter button
                    SizedBox(
                      height: screenHeight * .06,
                      width: sectionWidth * .1,
                      child: MaterialButton(
                        color: AppColors.lightGreen,
                        // color: AppColors.black.withOpacity(.95),
                        elevation: 3,
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'تصفية',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                color: AppColors.black,
                                // color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Icon(
                              Icons.filter_alt,
                              color: AppColors.black,
                              // color: Colors.white,
                              size: sectionWidth * .02,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: sectionWidth * .01),
                    //add treatment button
                    SizedBox(
                      height: screenHeight * .06,
                      width: sectionWidth * .125,
                      child: MaterialButton(
                        color: AppColors.lightGreen,
                        // color: AppColors.black,
                        elevation: 3,
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'إضافة معالجة',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: AppColors.black,
                            // color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: sectionWidth * .01),
                    //search bar
                    Container(
                      width: sectionWidth * 0.7,
                      height: screenHeight * 0.06,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        // color: AppColors.lightBlue,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: sectionWidth * 0.01,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          //text field
                          SizedBox(
                            width: sectionWidth * .6,
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextField(
                                controller: _controller.searchController,
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
                          ),
                          SizedBox(width: sectionWidth * .01),
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
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * .03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TreatmentTypesSection(
                      key: const ObjectKey(0),
                      sectionWidth: sectionWidth * .375,
                      sectionHeight: screenHeight * .83,
                    ),
                    SizedBox(width: sectionWidth * .01),
                    TreatmentsSection(
                      key: const ObjectKey(1),
                      sectionWidth: sectionWidth * .6,
                      sectionHeight: screenHeight * .83,
                    ),
                  ],
                )
              ],
            ),
          ),
          //to be removed
          Container(
            width: screenWidth - sectionWidth,
            color: AppColors.black,
          ),
        ],
      ),
    );
  }
}