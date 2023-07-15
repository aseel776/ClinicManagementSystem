import 'package:clinic_management_system/core/app_colors.dart';
import 'package:flutter/material.dart';
import '../type_tile.dart';
import '../../../dummy_data.dart';


class TreatmentTypesSection extends StatelessWidget {
  final double sectionHeight;
  final double sectionWidth;

  const TreatmentTypesSection({Key? key, required this.sectionHeight, required this.sectionWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: sectionHeight,
        width: sectionWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          // color: AppColors.lightBlue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                top: sectionHeight * .025,
              ),
              height: sectionHeight * .1,
              child: const Text(
                'أنواع المعالجات',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.black,
                  fontSize: 24,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: sectionHeight * .75,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ...types.map((type) => TypeTile(
                            tileHeight: sectionHeight * .075,
                            tileWidth: sectionWidth * .75,
                            type: type,
                          ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  MaterialButton(
                    color: AppColors.lightGreen,
                    // color: AppColors.black,
                    height: sectionHeight * .085,
                    minWidth: sectionHeight * .2,
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(
                        color: AppColors.lightGreen,
                        // color: AppColors.black,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                    ),
                    splashColor: AppColors.lightBlue,
                    onPressed: () {},
                    child: const Text(
                      'إضافة نوع',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.black,
                        // color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
