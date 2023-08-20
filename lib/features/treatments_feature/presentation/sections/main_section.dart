import 'package:clinic_management_system/features/treatments_feature/presentation/widgets/upsert_treatment.dart';
import 'package:flutter/material.dart';
import 'types_section.dart';
import 'treatments_section.dart';
import './/core/app_colors.dart';

class TreatmentsMainSection extends StatelessWidget {
  const TreatmentsMainSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width * 0.83;
    double screenHeight = MediaQuery.sizeOf(context).height * 0.93;

    return Scaffold(
      //row and scaffold to be removed
      body: Row(
        children: [
          //to be removed

          //return starts here
          Container(
            width: screenWidth,
            color: AppColors.lightGrey,
            // color: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * .02,
              vertical: screenHeight * .04,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //search bar
                    Container(
                      width: screenWidth * 0.7,
                      height: screenHeight * 0.06,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        // color: AppColors.lightBlue,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.01,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //search icon
                          SizedBox(
                            width: screenWidth * .02,
                            height: screenHeight * .04,
                            child: Icon(
                              Icons.search,
                              color: AppColors.black.withOpacity(0.5),
                              size: screenWidth * .018,
                            ),
                          ),
                          SizedBox(width: screenWidth * .01),
                          //text field
                          SizedBox(
                            width: screenWidth * .6,
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextField(
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
                        ],
                      ),
                    ),
                    SizedBox(width: screenWidth * .01),
                    //add treatment button
                    SizedBox(
                      height: screenHeight * .06,
                      width: screenWidth * .125,
                      child: MaterialButton(
                        color: AppColors.lightGreen,
                        // color: AppColors.black,
                        elevation: 3,
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        onPressed: () {
                          showUpsertPopUp(context);
                        },
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
                    SizedBox(width: screenWidth * .01),
                    //filter button
                    SizedBox(
                      height: screenHeight * .06,
                      width: screenWidth * .1,
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
                            Icon(
                              Icons.filter_alt,
                              color: AppColors.black,
                              // color: Colors.white,
                              size: screenWidth * .02,
                            ),
                            const Text(
                              'تصفية',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                color: AppColors.black,
                                // color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * .03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TreatmentsSection(
                      key: const ObjectKey(1),
                      sectionWidth: screenWidth * .6,
                      sectionHeight: screenHeight * .83,
                    ),
                    SizedBox(width: screenWidth * .01),
                    TreatmentTypesSection(
                      key: const ObjectKey(0),
                      sectionWidth: screenWidth * .375,
                      sectionHeight: screenHeight * .83,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
