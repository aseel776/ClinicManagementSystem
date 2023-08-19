import 'package:flutter/material.dart';
import './/core/app_colors.dart';
import './types_section.dart';

class ProblemsMainSection extends StatelessWidget {
  final double sectionWidth;
  const ProblemsMainSection({Key? key, required this.sectionWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      //row and scaffold to be removed
      body: Row(
        children: [
          //to be removed
          Container(
            width: screenWidth - sectionWidth,
            color: AppColors.black,
          ),
          //return starts here
          Container(
            width: sectionWidth,
            height: screenHeight,
            color: AppColors.lightGrey,
            padding: EdgeInsets.symmetric(
              horizontal: sectionWidth * .025,
              vertical: screenHeight * .025,
            ),
            child: Column(
              children: [
                SizedBox(height: screenHeight * .125),
                Row(
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
                      minWidth: sectionWidth * .2,
                      color: AppColors.lightGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () async {
                        // ActiveMaterialModel? newMaterial = await showInsertPopUp(
                        //     context);
                        // if (newMaterial != null) {
                        //   await ref.read(activeMaterialsProvider.notifier)
                        //       .createMaterial(newMaterial);
                        //   int page = ref.read(currentPageProvider);
                        //   await ref.read(activeMaterialsProvider.notifier)
                        //       .getAllMaterials(page, ref: ref);
                        // }
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
                          SizedBox(width: sectionWidth * .01),
                          const Icon(
                            Icons.add,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * .05),
                Row(
                  children: [
                    Container(
                      height: screenHeight * .675,
                      width: sectionWidth * .6,
                      alignment: Alignment.center,
                      color: AppColors.lightGreen,
                      child: Text('PROBLEMS'),
                    ),
                    SizedBox(width: sectionWidth * .05,),
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
        ],
      ),
    );
  }
}
